# frozen_string_literal: true

require 'bundler/setup'
require 'memoized_on_frozen/as_memoized'

ROOT = File.expand_path('..', __dir__)
Dir[File.join(ROOT, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
