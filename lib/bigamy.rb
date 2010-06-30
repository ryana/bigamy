require 'mongo_mapper'
require 'set'

require 'bigamy/proxy'
require 'bigamy/mongo'
require 'bigamy/ar'

module Bigamy
  class NewRecordAssignment < StandardError; end

  def self.setup *args
    args.each do |klass|
      case
      when klass.ancestors.include?(::ActiveRecord::Base)
        Bigamy::ActiveRecord.configure klass
      when (klass.included_modules & [::MongoMapper::Document, ::MongoMapper::EmbeddedDocument]).present?
        klass.plugin Bigamy::Mongo
      else
        raise "NO #{klass}"
      end
    end
  end

  module Base
    def self.configure(model)
      model.class_inheritable_accessor :bigamy_associations
      model.bigamy_associations = {}
    end
  end

  module Mongo

    def self.configure(model)
      ::Bigamy::Base.configure(model)
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
      def set_value c, val
        write_key c, val
      end
   
      def read_val c
        read_key c
      end

      def export_id_val i
        i.to_s
      end

      def import_id_val i
        i
      end
    end
  end

  module ActiveRecord
    def self.configure(model)
      ::Bigamy::Base.configure(model)

      model.extend ClassMethods
      model.send :include, InstanceMethods
    end

    module ClassMethods
      def divorce_everyone
        self.bigamy_associations.each {|k,v| v.divorce_everyone }
      end

      def belongs_to_ar name, options = {}, &ext
        bigamy_associations[name] = ARBelongsTo.new(self, name, options)
      end

      def has_one_ar name, options = {}, &ext
        bigamy_associations[name] = ARHasOne.new(self, name, options)
      end

      def has_many_ar name, options = {}, &ext
        bigamy_associations[name] = ARHasMany.new(self, name, options)
      end
    end

    module InstanceMethods
      def set_value c, val
        self[c] = val
      end
    
      def read_val c
        read_attribute c
      end

      def export_id_val i
        i
      end

      def import_id_val i
        BSON::ObjectID.from_string(i)
      end
    end
  end

end
