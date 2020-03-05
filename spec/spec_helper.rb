require 'bundler/setup'
require 'selenium-webdriver'
require 'rspec'
require 'rspec-steps'
require 'capybara/rspec'


opts = Selenium::WebDriver::Chrome::Options.new
chrome_args = %w(--enable-logging)
chrome_args.each {|a| opts.add_argument a}

CAPABILITIES = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:loggingPrefs' => {
        browser: "ALL",
        driver: "ALL"
    }
)


RSpec.configure do |config|
  Capybara.register_driver :chrome do |app|

    Capybara::Selenium::Driver.new(app, :browser => :chrome, desired_capabilities: CAPABILITIES, options: opts)
  end

  Capybara.configure do |capybara|
    capybara.run_server = false
    capybara.default_max_wait_time = 15

    capybara.default_driver = :chrome
  end

  config.after(:suite) do
    browser_error = Capybara.page.driver.browser.manage.logs.get(:browser)
    driver_error = Capybara.page.driver.browser.manage.logs.get(:driver)

    open('logs/chrome.log', 'w') do |f|
      f << browser_error.join("\n")
    end

    open('logs/chromedriver.log', 'w') do |f|
      f << driver_error.join("\n")
    end
  end

  config.include Capybara::DSL
end