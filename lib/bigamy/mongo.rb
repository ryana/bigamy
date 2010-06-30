module Bigamy

  class MongoBelongsTo < BelongsTo
    def initialize parent, name, options
      super
      me.key foreign_key
    end
  end

  class MongoHasMany < HasMany
  end

  class MongoHasOne < HasOne
  end

end
