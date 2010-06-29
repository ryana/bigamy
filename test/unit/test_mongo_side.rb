require File.join(File.dirname(__FILE__), 'test_helper')

class Doc
  include MongoMapper::Document
end

class User < ActiveRecord::Base
end

class TestMongoSide < Test::Unit::TestCase

  should "have Bigamy" do
    assert Bigamy
  end

  should "have Bigmany::Mongo plugin" do
    assert Bigamy::Mongo
    assert Bigamy::Mongo::ClassMethods
    assert Bigamy::Mongo::InstanceMethods
    assert Bigamy::Mongo.respond_to?(:configure)
  end

  def setup
    User.delete_all
    Doc.delete_all
  end

  should "have Doc & User" do
    assert Doc
    assert User
  end

  context "Doc" do
    setup do
      Doc.plugin Bigamy::Mongo
    end

    context "that belongs_to_ar :user" do
      setup do
        Doc.belongs_to_ar :user
      end

      should "create accessors" do
        assert Doc.new.respond_to?(:user)
        assert Doc.new.respond_to?(:user=)
      end

      context "with an instance and user" do
        setup do
          @doc = Doc.new
          @user = User.new
        end

        should "raise if assigning a new User" do
          assert_raises(Bigamy::NewRecordAssignment) do
            @doc.user = @user
          end
        end

        context "with a saved user" do
          setup { @user.save! }

          should "save doc" do
            @doc.user = @user
            @doc.save!

            assert !@doc.user_id.nil?
            assert_equal @doc.user_id, @user.id
            assert_equal 1, User.count
            assert_equal 1, Doc.count
          end
        end
      end
    end
  end

end
