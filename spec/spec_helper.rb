$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "mongoid"
require 'mongoid_schema_dump'

Mongoid.load!("spec/data/mongoid.yml", :test)
