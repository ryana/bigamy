require File.join(File.dirname(__FILE__), 'test_helper')

module A
  class B
  end
end

class C
end

class TestProxy < Test::Unit::TestCase


  def self.should_have_options name, options
    should "have correct options for #{name}" do
      assert_equal options[:primary_key], @proxy.primary_key
      assert_equal options[:foreign_key], @proxy.foreign_key
      assert_equal options[:target_klass], @proxy.target_klass
      assert_equal options[:root_klass], @proxy.root_klass
    end
  end


  context "A referenced association proxy" do
    setup do
      @proxy = Bigamy::HasOne.new(C, :user, {})
    end

    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :c_id,
                                    :target_klass => User,
                                    :root_klass => C
  end

  context "An referenced association proxy with a namespaced model parent" do
    setup do
      @proxy = Bigamy::HasOne.new(A::B, :user, {})
    end

    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :a_b_id,
                                    :target_klass => User,
                                    :root_klass => A::B
 

  end

  context "An referenced association proxy with a namespaced model parent and a custom foreign_key" do
    setup do
      @proxy = Bigamy::HasOne.new(A::B, :user, {:foreign_key => :drats})
    end
    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :drats,
                                    :target_klass => User,
                                    :root_klass => A::B
 
  end

  context "An referenced association proxy with a namespaced target" do
    setup do
      @proxy = Bigamy::HasOne.new(C, :user, {:class => A::B})
    end
  
    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :c_id,
                                    :target_klass => A::B,
                                    :root_klass => C
  end

  context "An association proxy" do
    setup do
      @proxy = Bigamy::BelongsTo.new(C, :user, {})
    end
  
    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :user_id,
                                    :target_klass => User,
                                    :root_klass => C
 
  end

  context "An association proxy with a namespaced model parent" do
    setup do
      @proxy = Bigamy::BelongsTo.new(A::B, :user, {})
    end
  
    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :user_id,
                                    :target_klass => User,
                                    :root_klass => A::B
 
  end

  context "An association proxy with a namespaced target" do
    setup do
      @proxy = Bigamy::BelongsTo.new(C, :user, {:class => A::B})
    end

    should_have_options 'standard', :primary_key => :id,
                                    :foreign_key => :user_id,
                                    :target_klass => A::B,
                                    :root_klass => C
 
  end

end
