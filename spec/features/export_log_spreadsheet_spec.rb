require 'spec_helper'

feature "Export Log Spreadsheet", :type => :feature do
  before do
    user = FactoryGirl.create(:user_with_application)
    login_as user, scope: :user
  end

  scenario "User exports log spreadsheet", :js => true do
    visit "/data_interactive/index"

    click_button("Export Spreadsheet")

    expect(page).to have_text("Export status: requested")
    expect(page).to have_css("#download-spreadsheet[disabled]")

    Delayed::Worker.new.work_off

    expect(page).to have_text("Export status: succeed", wait: 10)
    expect(page).to have_css("#download-spreadsheet")
    expect(page).not_to have_css("#download-spreadsheet[disabled]")
  end
end
