module Bigamy

  class ARBelongsTo < BelongsTo
  end

  class ARHasOne < HasOne
    def initialize parent, name, options
      super
      target_klass.key foreign_key
    end
  end

  class ARHasMany < HasMany
    def initialize parent, name, options
      super
      target_klass.key foreign_key
    end
  end

end
