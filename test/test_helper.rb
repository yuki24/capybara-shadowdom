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

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

driver = ENV['JS_DRIVER']&.to_sym || :selenium_chrome
Capybara.server = :webrick
Capybara.default_driver = driver
Capybara.javascript_driver = driver
Capybara.app = ->(_env) {
  [
    200,
    { 'Content-Type' => 'text/html; charset=utf-8' },
    [File.read('./test/index.html')]
  ]
}

class ShadowDOMTest < Minitest::Test
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
