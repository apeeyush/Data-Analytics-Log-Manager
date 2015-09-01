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
           }
         ]
       }'
    end
    let(:spreadsheet) { FactoryGirl.create(:log_spreadsheet, query: query, user: user) }

    before do
      FactoryGirl.create(:log, application: app.name, event: "event_1")
      FactoryGirl.create(:log, application: app.name, event: "event_2", extras: {extra_param_1: 1}, parameters: {custom_param_1: 1})
      FactoryGirl.create(:log, application: app.name, event: "event_3", extras: {extra_param_2: 2}, parameters: {custom_param_2: 2})
      # These logs should not be included in report, as application or activity isn't matching.
      FactoryGirl.create(:log, application: app.name, activity: "wrongActivity", extras: {extra_param_3: 3})
      FactoryGirl.create_list(:log, 3, application: "anotherApplication")
    end

    it "generates spreadsheet which matches log data and query" do
      spreadsheet.generate

      data = StringIO.new(spreadsheet.file)
      book = Spreadsheet.open(data)
      sheet = book.worksheet(0)

      logs_matching_query = Log.where(application: app.name).where(activity: "myActivity").order(id: :asc)
      expect(sheet.rows.count).to eql(logs_matching_query.count + 1)

      headers = sheet.row(0).to_a
      expect(headers).to eql(logs_matching_query.keys_list)

      for idx in 1..logs_matching_query.count
        row = sheet.row(idx)
        log = logs_matching_query[idx - 1]
        headers.count.times do |header_idx|
          header = headers[header_idx]
          if LogSpreadsheet::TIME_COLS.include?(header)
            # Accept small difference in time value. Without range comparison, tests seem to fail randomly.
            # Maybe some precision is lost when date is converted to Excel format.
            expect(row[header_idx].to_i).to be_within(1).of(log[header].to_i)
          else
            val = log.value(header)
            val = nil if val === ''
            expect(row[header_idx]).to eql(val)
          end
        end
      end
    end
  end
end
