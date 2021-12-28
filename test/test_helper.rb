# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "pry-byebug"
require "minitest/autorun"
require "webrick"
require "selenium-webdriver"
require "webdrivers"

require "capybara"
require "capybara/dsl"
require "capybara/shadowdom"
