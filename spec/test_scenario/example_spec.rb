require 'spec_helper'

feature 'Capybara example' do
  scenario 'Test example' do
    visit 'https://trueautomation.io/'

    find(:xpath, "//a[.//span[text()='Login']]").click
    find(:css, 'div.sign-up-container > a').click
    fill_in 'email', with: 'your@mail.com'

    sleep 3
  end
end
