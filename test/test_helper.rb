# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "simplecov"
SimpleCov.start do
  enable_coverage :branch
end

require "litetags"

require "minitest/autorun"

# Setup a class to allow us to track and test whether code has been performed
class Performance
  def self.reset!
    @performances = 0
  end

  def self.performed!
    @performances ||= 0
    @performances += 1
  end

  def self.processed!(item, scope: :default)
    @processed_items ||= {}
    @processed_items[scope] ||= []
    @processed_items[scope] << item
  end

  def self.processed_items(scope = :default)
    @processed_items[scope]
  end

  def self.performances
    @performances || 0
  end
end

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.json :tags, null: false, default: []
    t.check_constraint "JSON_TYPE(tags) = 'array'", name: 'post_tags_is_array'
    t.json :empties, null: false, default: []
  end
end

class Post < ActiveRecord::Base
  include Litetags
  
  tag_columns :tags, :empties
end