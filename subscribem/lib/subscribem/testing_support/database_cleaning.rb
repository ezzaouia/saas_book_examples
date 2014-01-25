require 'database_cleaner'

module Subscribem
  module TestingSupport
    module DatabaseCleaning
      def self.included(config)
        config.before(:suite) do
          DatabaseCleaner.strategy = :truncation, 
            {:pre_count => true, :reset_ids => true}
          DatabaseCleaner.clean_with(:truncation)
        end

        config.before(:each) do
          DatabaseCleaner.start
        end

        config.after(:each) do
          DatabaseCleaner.clean
        end
      end
    end
  end
end