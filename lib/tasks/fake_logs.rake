namespace :fake_logs do
  desc "Generates fake logs entries"
  task generate: :environment do
    count = ENV["COUNT"].to_i
    set_uuid = SecureRandom.uuid
    count.times do |i|
      Log.create!(username: "fake user", application: "fake app", activity: "fake activity", event: "fake event",
                 time: Time.now, parameters: {set_uuid: set_uuid}, extras: {index: i})
    end
  end
end
