# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'support/factory_girl'
require 'support/redis_test'
require 'support/puma'

INVALID_VCR = 'invalid_yandex_vcr.txt'
VALID_VCR = 'valid_yandex_vcr.txt'
RELEVANT_DESCRIPTION = 'Description of relevant post.'
RELEVANT_TIMESTAMP = 1_505_432_811
RELEVANT_TITLE = 'This post is relevant'
REQUIRED_KEYS = %w[ts title descr].freeze

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end
Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
