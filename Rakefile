# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:rubocop)
RuboCop::RakeTask.new(:spec)

task default: %i[spec rubocop]
