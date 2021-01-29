# frozen_string_literal: true

require 'solidus_dev_support/rake_tasks'
rake = SolidusDevSupport::RakeTasks.new
rake.install_test_app_task
rake.install_dev_app_task
rake.install_rspec_task

task default: %w[extension:test_app extension:specs]
