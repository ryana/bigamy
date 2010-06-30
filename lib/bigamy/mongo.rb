module Bigamy

  class MongoBelongsTo < BelongsTo
  end

  class MongoHasMany < HasMany
    def serialize_foreign_key
      target_klass.class_eval <<-EOF
        def #{foreign_key}
          v = read_attribute(:#{foreign_key})

          v.present? ? BSON::ObjectID.from_string(v) : nil
        end
        EOF
    end
  end

  class MongoHasOne < HasOne
    def serialize_foreign_key
      target_klass.class_eval <<-EOF
        def #{foreign_key}
          v = read_attribute(:#{foreign_key})

          v.present? ? BSON::ObjectID.from_string(v) : nil
        end
        EOF
    end
  end

end
