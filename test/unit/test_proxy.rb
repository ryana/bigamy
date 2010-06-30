require File.join(File.dirname(__FILE__), 'test_helper')

module A
  class B
  end
end

class C
end

class DumbBelongsToProxy < Bigamy::BelongsTo
  def add_getter
  end

  def add_setter
  end
end

class DumbHasProxy < Bigamy::HasOne
  def add_getter
  end

  def add_setter
  end
end

class TestProxy < Test::Unit::TestCase

  context "A referenced association proxy" do
    setup do
      @proxy = DumbHasProxy.new(C, :user, {})
    end

    should "have proper foreign_key" do
      assert_equal :c_id, @proxy.foreign_key
    end
  end

  context "An referenced association proxy with a namespaced model parent" do
    setup do
      @proxy = DumbHasProxy.new(A::B, :user, {})
    end

    should "have proper foreign_key" do
      assert_equal :a_b_id, @proxy.foreign_key
    end
  end

  context "An referenced association proxy with a namespaced model parent and a custom foreign_key" do
    setup do
      @proxy = DumbHasProxy.new(A::B, :user, {:foreign_key => :drats})
    end

    should "have proper foreign_key" do
      assert_equal :drats, @proxy.foreign_key
    end
  end

  context "An referenced association proxy with a namespaced target" do
    setup do
      @proxy = DumbHasProxy.new(A::B, :user, {})
    end

    should "have proper foreign_key" do
      assert_equal :a_b_id, @proxy.foreign_key
    end

  end

  context "An association proxy" do
    setup do
      @proxy = DumbBelongsToProxy.new(C, :user, {})
    end

    should "have proper foreign_key" do
      assert_equal :user_id, @proxy.foreign_key
    end
  end

  context "An association proxy with a namespaced model parent" do
    setup do
      @proxy = DumbBelongsToProxy.new(A::B, :user, {})
    end

    should "have proper foreign_key" do
      assert_equal :user_id, @proxy.foreign_key
    end
  end

  context "An association proxy with a namespaced target" do
    setup do
      @proxy = DumbBelongsToProxy.new(C, :user, {:class => A::B})
    end

    should "have proper foreign_key" do
      assert_equal :user_id, @proxy.foreign_key
    end

  end

end
