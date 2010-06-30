require 'mongo_mapper'
require 'set'

require 'bigamy/proxy'
require 'bigamy/mongo'

module Bigamy
  class NewRecordAssignment < StandardError; end

  module Mongo
    def self.configure(model)
      model.class_inheritable_accessor :bigamy_associations
      model.bigamy_associations = {}
    end

    module ClassMethods
      def divorce_everyone
        self.bigamy_associations.each {|k,v| v.divorce_everyone }
      end

      def belongs_to_ar name, options = {}, &ext
        bigamy_associations[name] = MongoBelongsTo.new(self, name, options)
      end

      def has_one_ar name, options = {}, &ext
        bigamy_associations[name] = MongoHasOne.new(self, name, options)
      end

      def has_many_ar name, options = {}, &ext
        bigamy_associations[name] = MongoHasMany.new(self, name, options)
      end
    end

    module InstanceMethods
    end
  end

  module ActiveRecord
    ClassMethods = ::Bigamy::Mongo::ClassMethods

    def self.corrupt klass
      User.extend ClassMethods
      ::Bigamy::Mongo.configure User
    end
  end
end
