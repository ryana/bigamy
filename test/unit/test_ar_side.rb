require File.join(File.dirname(__FILE__), 'test_helper')

class TestArSide < Test::Unit::TestCase

  should "have Bigamy" do
    assert Bigamy
  end

  should "have Bigmany::Mongo plugin" do
    assert Bigamy::ActiveRecord
    assert Bigamy::ActiveRecord::ClassMethods
  end

  def setup
    Doc.delete_all
    User.delete_all
  end

  should "have User & Doc" do
    assert User
    assert Doc
  end

  context "User" do
    teardown do
      User.divorce_everyone
    end

    should "have divorce_everyone" do
      assert User.respond_to?(:divorce_everyone)
    end

    context "that has_one_mm :doc" do
      setup do
        User.has_one_mm :doc
        @doc = Doc.create!
      end

      should "create accessors" do
        assert User.new.respond_to?(:doc)
        assert User.new.respond_to?(:doc=)
      end

      should "raise on assignment if User is new" do
        assert_raises(Bigamy::NewRecordAssignment) { User.new.doc = @doc }
      end

      context "With a created userument" do
        setup do
          @user = User.create!
          @user.doc = @doc
        end

        should "set @doc.foreign_key on assignment" do
          assert_equal @doc.user_id, @user.id
        end

        should "save doc on assignment" do
          u = Doc.find(@doc.id)
          assert_equal u.user_id, @user.id
        end

        should "retrieve doc from user" do
          d = User.find(@user.id)
          assert_equal d.doc, @doc
        end
      end
    end

    context "that has_many_mm :doc" do
      setup do
        User.has_many_mm :docs
      end

      should "create accessors" do
        assert User.new.respond_to?(:docs)
        assert User.new.respond_to?(:docs=)
      end

      context "with instance and doc" do
        setup do
          @user = User.new
          @u1 = Doc.new
          @u2 = Doc.new
        end

        should "raise if user is new" do
          @u1.save! && @u2.save!
          assert_raises(Bigamy::NewRecordAssignment) { @user.docs = [@u1, @u2] }
        end

        should "raise if any docs are new" do
          @user.save!
          @u1.save!
          assert_raises(Bigamy::NewRecordAssignment) { @user.docs = [@u1, @u2] }
        end

        context "with users & docs saved" do
          setup do
            @user.save! && @u1.save! && @u2.save!
            @user.docs = [@u1, @u2]
          end

          should "assign user_id on docs" do
            assert Doc.find(@u1.id, @u2.id).all? {|x| x.user_id == @user.id}
          end

          should "retrieve targets" do
            assert_same_elements [@u1, @u2], User.find(@user.id).docs
          end
        end

      end
    end

    context "that belongs_to_mm :doc" do
      setup do
        User.belongs_to_mm :doc
      end

      should "create accessors" do
        assert User.new.respond_to?(:doc)
        assert User.new.respond_to?(:doc=)
      end

      context "with an instance and doc" do
        setup do
          @user = User.new
          @doc = Doc.new
        end

        should "raise if assigning a new Doc" do
          assert_raises(Bigamy::NewRecordAssignment) do
            @user.doc = @doc
          end
        end

        context "with a saved doc" do
          setup { @doc.save! }

          should "save user" do
            @user.doc = @doc
            @user.save!

            assert !@user.doc_id.nil?
            assert_equal @user.doc_id, @doc.id
            assert_equal 1, Doc.count
            assert_equal 1, User.count
          end
        end
      end
    end
  end

end
