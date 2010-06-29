require File.join(File.dirname(__FILE__), 'test_helper')

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

    teardown do
      Doc.divorce_everyone
    end

    context "that has_one_ar :user" do
      setup do
        Doc.has_one_ar :user
        @user = User.create!
      end

      should "create accessors" do
        assert Doc.new.respond_to?(:user)
        assert Doc.new.respond_to?(:user=)
      end

      should "raise on assignment if Doc is new" do
        assert_raises(Bigamy::NewRecordAssignment) { Doc.new.user = @user }
      end

      context "With a created document" do
        setup do
          @doc = Doc.create!
          @doc.user = @user
        end

        should "set @user.foreign_key on assignment" do
          assert_equal @user.doc_id, @doc.id
        end

        should "save user on assignment" do
          u = User.find(@user.id)
          assert_equal u.doc_id, @doc.id
        end

        should "retrieve user from doc" do
          d = Doc.find(@doc.id)
          assert_equal d.user, @user
        end
      end
    end

    context "that has_many_ar :user" do
      setup do
        Doc.has_many_ar :users
      end

      should "create accessors" do
        assert Doc.new.respond_to?(:users)
        assert Doc.new.respond_to?(:users=)
      end

      context "with instance and user" do
        setup do
          @doc = Doc.new
          @u1 = User.new
          @u2 = User.new
        end

        should "raise if doc is new" do
          @u1.save! && @u2.save!
          assert_raises(Bigamy::NewRecordAssignment) { @doc.users = [@u1, @u2] }
        end

        should "raise if any users are new" do
          @doc.save!
          @u1.save!
          assert_raises(Bigamy::NewRecordAssignment) { @doc.users = [@u1, @u2] }
        end

        context "with docs & users saved" do
          setup do
            @doc.save! && @u1.save! && @u2.save!
            @doc.users = [@u1, @u2]
          end

          should "assign doc_id on users" do
            assert User.find(@u1.id, @u2.id).all? {|x| x.doc_id == @doc.id}
          end

          should "retrieve targets" do
            assert_same_elements [@u1, @u2], Doc.find(@doc.id).users
          end
        end

      end
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
