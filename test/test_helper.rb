# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pry-byebug'
require 'minitest/autorun'
require 'webrick'
require 'selenium-webdriver'
require 'webdrivers'

require 'capybara'
require 'capybara/dsl'
require 'capybara/shadowdom'

begin
  require "capybara/cuprite"

  Capybara.register_driver :cuprite do |app|
    Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
  end
rescue LoadError
end

begin
  require "capybara/apparition"
rescue LoadError
end

if ENV['BROWSERSTACK_URL']
  browserstack_url = URI(ENV['BROWSERSTACK_URL'])
  browserstack_url.user = ENV['BROWSERSTACK_USERNAME'] if ENV['BROWSERSTACK_USERNAME']
  browserstack_url.password = ENV['BROWSERSTACK_ACCESS_KEY'] if ENV['BROWSERSTACK_ACCESS_KEY']

  os, os_version, browser, browser_version = ENV.fetch('TARGET_BROWSER', 'Windows, 10, Edge, latest').split(", ")

  caps = Selenium::WebDriver::Remote::Capabilities.new(
    name: "Capybara Shadow DOM",
    server: browserstack_url.host,
    user: browserstack_url.user,
    key: browserstack_url.password,
    os: os,
    os_version: os_version,
    browser: browser,
    browser_version: browser_version,
    "browserstack.console": "errors",
    "browserstack.debug": true,
    "browserstack.networkLogs": true,
  )

  # Safari has some limitations due to their security models so we have to stick with localhost:3000.
  if browser.downcase == 'safari'
    Capybara.app_host = "http://localhost"
    Capybara.server_port = 3000
  end

  module BrowserstackPatch
    def reset!
      @browser&.navigate&.to('about:blank')
    end
  end

  Capybara::Selenium::Driver.prepend BrowserstackPatch

  Capybara.register_driver :browserstack do |app|
    Capybara::Selenium::Driver.new(app, browser: :remote, url: browserstack_url.to_s, capabilities: [caps])
  end

  Capybara.run_server = false
  Capybara.app_host = "https://yuki24.github.io/capybara-shadowdom/"
else
  Capybara.app = ->(_env) {
    [
      200,
      { 'Content-Type' => 'text/html; charset=utf-8' },
      [File.read('./test/index.html')]
    ]
  }
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

driver = ENV['JS_DRIVER']&.to_sym || case ENV['BUNDLE_GEMFILE']
                                     when /selenium_webdriver/
                                       ENV['JS_DRIVER'] || :selenium_chrome_headless
                                     when /cuprite/
                                       :cuprite
                                     when /apparition/
                                       :apparition
                                     else
                                       :selenium_chrome_headless
                                     end

Capybara.server = :webrick
Capybara.default_driver = driver
Capybara.javascript_driver = driver

class ShadowDOMTest < Minitest::Test
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
