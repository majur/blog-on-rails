require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/vendor/'
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Mock Webpacker pre testovacie prostredie
if defined?(Webpacker::Manifest)
  module WebpackerTestSupport
    def lookup_pack_with_chunks(name, type: nil)
      []
    end

    def lookup_pack_path(name, **options)
      "mock/path/to/#{name}"
    end
  end

  Webpacker::Manifest.prepend(WebpackerTestSupport)
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
