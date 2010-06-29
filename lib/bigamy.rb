require 'mongo_mapper'
require 'set'

module Bigamy
  class NewRecordAssignment < StandardError; end

  module Mongo
    def self.configure(model)
      model.class_inheritable_accessor :bigamy_methods
      model.bigamy_methods = Set.new
    end

    module ClassMethods
      def divorce_everyone
        self.bigamy_methods.each {|v| undef_method(v) }
        self.bigamy_methods = Set.new
      end

      def belongs_to_ar name, options = {}, &ext
        primary_key = options.delete(:primary_key) || :id
        foreign_key = options.delete(:foreign_key) || :"#{name}_id"
        klass = options.delete(:class) || klass_from(name) 

        serialize_foreign_key(klass, foreign_key)
        add_accessors_to_bigamy_methods(name, foreign_key)
        
        define_method(name) do
          self.id.nil? ? nil : klass.first(:conditions => {primary_key => self.id})
        end

        define_method("#{name}=") do |val|
          raise NewRecordAssignment if val.new_record?
          raise TypeError unless val.is_a? klass
        
          self[foreign_key] = val.id
        end
      end

      def has_one_ar name, options = {}, &ext
        primary_key = options.delete(:primary_key) || :id
        foreign_key = options.delete(:foreign_key) || :"#{name_from(self)}_id"
        klass = options.delete(:class) || klass_from(name) 

        serialize_foreign_key(klass, foreign_key)
        add_accessors_to_bigamy_methods(name, foreign_key)

        define_method(name) do
          self.id.nil? ? nil : klass.first(:conditions => {foreign_key => self.id})
        end

        define_method("#{name}=") do |val|
          raise NewRecordAssignment.new('Child must be saved') if val.new_record?
          raise NewRecordAssignment.new('Parent must be saved') if self.new_record?
          raise TypeError unless val.is_a? klass
        
          val[foreign_key] = self.id.to_yaml
          val.save!
        end
      end

      def has_many_ar name, options = {}, &ext
        primary_key = options.delete(:primary_key) || :id
        foreign_key = options.delete(:foreign_key) || :"#{name_from(self)}_id"
        klass = options.delete(:class) || klass_from(name)

        serialize_foreign_key(klass, foreign_key)
        add_accessors_to_bigamy_methods(name, foreign_key)

        define_method(name) do
          self.id.nil? ? nil : klass.all(:conditions => {foreign_key => self.id})
        end

        define_method("#{name}=") do |val|
          raise NewRecordAssignment.new('All children must be saved') if val.select(&:new_record?).present?
          raise NewRecordAssignment.new('Parent must be saved') if self.new_record?
        
          val.each {|v| v.send "#{foreign_key}=", self.id; v.save! }
        end
      end

      def add_accessors_to_bigamy_methods name, f_key
        bigamy_methods << name
        bigamy_methods << "#{name}="
      end

      def serialize_foreign_key klass, f_key
        klass.class_eval <<-EOF
          def #{f_key}
            v = read_attribute(:#{f_key})
        
            v.present? ? YAML.load(v) : v
          end
        EOF
      end

      def name_from(klass)
        klass.to_s.underscore.singularize.gsub('/', '_')
      end

      def klass_from(name)
        name.to_s.camelcase.singularize.constantize
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
