require 'mongo_mapper'

module Bigamy
  class NewRecordAssignment < StandardError; end

  module Mongo

    def self.configure(model)
    end

    module ClassMethods
      def belongs_to_ar name, options = {}, &ext
        create_association :belongs_to_ar, name, options, &ext
      end
    end

    module InstanceMethods
    end
  end
end

module ActiveRecord
  class Base
    alias new? new_record?
  end
end

module MongoMapper
  module Plugins
    module Associations
      class BelongsToAr < BelongsToProxy
        def replace(doc)
          raise Bigamy::NewRecordAssignment if doc.new?

          proxy_owner[association.foreign_key] = doc.id
          reload
        end

        def load_target
          unless loaded?
            @target = find_target
            loaded
          end

          @target
        end
      end
    end
  end
end
