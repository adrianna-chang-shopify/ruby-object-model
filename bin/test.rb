Dir["test/**/*_test.rb"].each { |file| require_relative "../#{file}" }
