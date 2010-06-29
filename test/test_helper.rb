require 'test/unit'
require 'mocha'
require 'ruby-debug'
require 'shoulda'
require 'factory_girl'
require 'active_record'
require 'mongo_mapper'

MongoMapper.database = 'bigamy-test'
ActiveRecord::Base.establish_connection :adapter => 'mysql', :database => 'bigamy_test', :username => 'root', :password => 'ryan'
ActiveRecord::Migration.execute 'drop table if exists users'
ActiveRecord::Migration.create_table :users do |t|
  t.string :name
  t.integer :id
  t.string :doc_id
end

class Doc
  include MongoMapper::Document
end

class User < ActiveRecord::Base
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'bigamy'
