# We don’t need this anymore for Rake because it automatically adds lib/
# to $LOAD_PATH before running the tests, but let’s leave it in so we can run
# the tests directly with Ruby
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "toy"

require "minitest/autorun"
