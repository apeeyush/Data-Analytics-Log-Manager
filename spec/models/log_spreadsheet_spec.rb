require 'spec_helper'

describe LogSpreadsheet, :type => :model do

  describe "max number of spreadsheet instances is limited" do
    it "old spreadsheets are removed once new one is created" do
      count = LogSpreadsheet::SPREADSHEET_COUNT_LIMIT + 10
      count.times do
        FactoryGirl.create(:log_spreadsheet)
        expect(LogSpreadsheet.count).to be <= LogSpreadsheet::SPREADSHEET_COUNT_LIMIT
      end
      expect(LogSpreadsheet.count).to eql(LogSpreadsheet::SPREADSHEET_COUNT_LIMIT)
    end
  end

  describe "spreadsheet generation" do
    let(:user) { user = FactoryGirl.create(:user_with_application) }
    let(:app) { user.applications.first }
    let(:query) do
      '{
         "filter": [
           {
             "key": "activity",
             "list": [
               "myActivity"
             ],
             "remove": false,
             "filter_type": "string"
           },
           {
             "key": "groupname",
             "list": [
               "group1"
             ],
             "remove": false,
             "filter_type": "string"
           }
         ]
       }'
    end
    let(:spreadsheet) { FactoryGirl.create(:log_spreadsheet, query: query, user: user, all_columns: false) }

    before do
      FactoryGirl.create(:log, application: app.name, event: "event_1")
      FactoryGirl.create(:log, application: app.name, event: "event_2", extras: {extra_param_1: 1, groupname: "group1"}, parameters: {custom_param_1: 1})
      FactoryGirl.create(:log, application: app.name, event: "event_3", extras: {extra_param_2: 2, groupname: "group1"}, parameters: {custom_param_2: 2})
      FactoryGirl.create(:log, application: app.name, event: "event_4", extras: {extra_param_3: 3, groupname: "group2"}, parameters: {custom_param_3: 3})
      FactoryGirl.create(:log, application: app.name, event: "event_5", extras: {extra_param_4: 4, groupname: "group3"}, parameters: {custom_param_4: 4})
      # These logs should not be included in report, as application or activity isn't matching.
      FactoryGirl.create(:log, application: app.name, activity: "wrongActivity", extras: {extra_param_3: 3})
      FactoryGirl.create_list(:log, 3, application: "anotherApplication")
    end

    it "generates spreadsheet which matches log data and query" do
      spreadsheet.generate

      csv = CSV.new StringIO.new(spreadsheet.file_chunk), :headers => true

      logs_matching_query = Log.where(application: app.name).where(activity: "myActivity").where("extras -> :key IN ( :list )", :key => "groupname", :list => ["group1"]).order(id: :asc)
      expect(csv.count).to eql(logs_matching_query.count)

      expect(csv.headers).to eql(logs_matching_query.keys_list)
      expect(csv.headers).to_not include("extra_param_3", "custom_param_3", "extra_param_4", "custom_param_4")

      csv.rewind()
      for idx in 0...logs_matching_query.count
        row = csv.shift
        log = logs_matching_query[idx]
        csv.headers.count.times do |header_idx|
          header = csv.headers[header_idx]
          if LogSpreadsheet::TIME_COLS.include?(header)
            # Accept small difference in time value. Without range comparison, tests seem to fail randomly.
            # Maybe some precision is lost when date is converted to Excel format.
            expect(row[header_idx].to_i).to be_within(1).of(log[header].to_i)
          else
            expect(row[header_idx]).to eql(log.value(header))
          end
        end
      end
    end

    describe "spreadsheet generation with all columns" do
      let(:spreadsheet) { FactoryGirl.create(:log_spreadsheet, query: query, user: user, all_columns: true) }

      it "generates spreadsheet which matches log data and query" do
        spreadsheet.generate

        csv = CSV.new StringIO.new(spreadsheet.file_chunk), :headers => true

        logs_matching_query = Log.where(application: app.name).where(activity: "myActivity").where("extras -> :key IN ( :list )", :key => "groupname", :list => ["group1"]).order(id: :asc)
        expect(csv.count).to eql(logs_matching_query.count)

        expect(csv.headers).to eql(logs_matching_query.keys_list Log::ALL_COLUMNS)
        expect(csv.headers).to include("extra_param_3", "custom_param_3", "extra_param_4", "custom_param_4")

        csv.rewind()
        for idx in 0...logs_matching_query.count
          row = csv.shift
          log = logs_matching_query[idx]
          csv.headers.count.times do |header_idx|
            header = csv.headers[header_idx]
            if LogSpreadsheet::TIME_COLS.include?(header)
              # Accept small difference in time value. Without range comparison, tests seem to fail randomly.
              # Maybe some precision is lost when date is converted to Excel format.
              expect(row[header_idx].to_i).to be_within(1).of(log[header].to_i)
            else
              expect(row[header_idx]).to eql(log.value(header))
            end
          end
        end
      end
    end
  end

end
