# frozen_string_literal: true

require "test_helper"

POST_1 = Post.create!(tags: %w[a b c d])
POST_2 = Post.create!(tags: %w[c d e f])
POST_3 = Post.create!

describe Litetags do
  describe ".unique_{column_name}" do
    it "returns a unique array of values" do
      assert_equal %w[a b c d e f], Post.unique_tags
    end

    it "returns an empty array" do
      assert_equal [], Post.unique_empties
    end
  end

  describe ".{column_name}_cloud" do
    it "returns a hash of values with occurrence counts" do
      assert_equal({"a" => 1, "b" => 1, "c" => 2, "d" => 2, "e" => 1, "f" => 1}, Post.tags_cloud)
    end

    it "returns an empty array" do
      assert_equal({}, Post.empties_cloud)
    end
  end

  describe ".with_{column_name}" do
    it "returns relation with appropriate entries" do
      collection = Post.with_tags
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end
  end

  describe ".without_{column_name}" do
    it "returns relation with appropriate entries" do
      collection = Post.without_tags
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end
  end

  describe ".with_any_{column_name}" do
    it "when receiving a unique argument, returns relation with appropriate entries" do
      collection = Post.with_any_tags "a"
      assert collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving a shared argument, returns relation with appropriate entries" do
      collection = Post.with_any_tags "c"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving a non-existent argument, returns relation with appropriate entries" do
      collection = Post.with_any_tags "z"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving unique arguments, returns relation with appropriate entries" do
      collection = Post.with_any_tags "a", "b"
      assert collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving shared arguments, returns relation with appropriate entries" do
      collection = Post.with_any_tags "c", "d"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving non-existent arguments, returns relation with appropriate entries" do
      collection = Post.with_any_tags "y", "z"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving split arguments, returns relation with appropriate entries" do
      collection = Post.with_any_tags "a", "f"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end
  end

  describe ".with_all_{column_name}" do
    it "when receiving a unique argument, returns relation with appropriate entries" do
      collection = Post.with_all_tags "a"
      assert collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving a shared argument, returns relation with appropriate entries" do
      collection = Post.with_all_tags "c"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving a non-existent argument, returns relation with appropriate entries" do
      collection = Post.with_all_tags "z"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving unique arguments, returns relation with appropriate entries" do
      collection = Post.with_all_tags "a", "b"
      assert collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving shared arguments, returns relation with appropriate entries" do
      collection = Post.with_all_tags "c", "d"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving non-existent arguments, returns relation with appropriate entries" do
      collection = Post.with_all_tags "y", "z"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end

    it "when receiving split arguments, returns relation with appropriate entries" do
      collection = Post.with_all_tags "a", "f"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      refute collection.include?(POST_3)
    end
  end

  describe ".without_any_{column_name}" do
    it "when receiving a unique argument, returns relation with appropriate entries" do
      collection = Post.without_any_tags "a"
      refute collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving a shared argument, returns relation with appropriate entries" do
      collection = Post.without_any_tags "c"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving a non-existent argument, returns relation with appropriate entries" do
      collection = Post.without_any_tags "z"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving unique arguments, returns relation with appropriate entries" do
      collection = Post.without_any_tags "a", "b"
      refute collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving shared arguments, returns relation with appropriate entries" do
      collection = Post.without_any_tags "c", "d"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving non-existent arguments, returns relation with appropriate entries" do
      collection = Post.without_any_tags "y", "z"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving split arguments, returns relation with appropriate entries" do
      collection = Post.without_any_tags "a", "f"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end
  end

  describe ".without_all_{column_name}" do
    it "when receiving a unique argument, returns relation with appropriate entries" do
      collection = Post.without_all_tags "a"
      refute collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving a shared argument, returns relation with appropriate entries" do
      collection = Post.without_all_tags "c"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving a non-existent argument, returns relation with appropriate entries" do
      collection = Post.without_all_tags "z"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving unique arguments, returns relation with appropriate entries" do
      collection = Post.without_all_tags "a", "b"
      refute collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving shared arguments, returns relation with appropriate entries" do
      collection = Post.without_all_tags "c", "d"
      refute collection.include?(POST_1)
      refute collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving non-existent arguments, returns relation with appropriate entries" do
      collection = Post.without_all_tags "y", "z"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end

    it "when receiving split arguments, returns relation with appropriate entries" do
      collection = Post.without_all_tags "a", "f"
      assert collection.include?(POST_1)
      assert collection.include?(POST_2)
      assert collection.include?(POST_3)
    end
  end

  describe "#has_any_{column_name}?" do
    it "when receiving a unique argument, returns appropriate boolean" do
      assert POST_1.has_any_tags?("a")
      refute POST_2.has_any_tags?("a")
      refute POST_3.has_any_tags?("a")
    end

    it "when receiving a shared argument, returns appropriate boolean" do
      assert POST_1.has_any_tags?("c")
      assert POST_2.has_any_tags?("c")
      refute POST_3.has_any_tags?("c")
    end

    it "when receiving a non-existent argument, returns appropriate boolean" do
      refute POST_1.has_any_tags?("z")
      refute POST_2.has_any_tags?("z")
      refute POST_3.has_any_tags?("z")
    end

    it "when receiving unique arguments, returns appropriate boolean" do
      assert POST_1.has_any_tags?("a", "b")
      refute POST_2.has_any_tags?("a", "b")
      refute POST_3.has_any_tags?("a", "b")
    end

    it "when receiving shared arguments, returns appropriate boolean" do
      assert POST_1.has_any_tags?("c", "d")
      assert POST_2.has_any_tags?("c", "d")
      refute POST_3.has_any_tags?("c", "d")
    end

    it "when receiving non-existent arguments, returns appropriate boolean" do
      refute POST_1.has_any_tags?("y", "z")
      refute POST_2.has_any_tags?("y", "z")
      refute POST_3.has_any_tags?("y", "z")
    end

    it "when receiving split arguments, returns appropriate boolean" do
      assert POST_1.has_any_tags?("a", "f")
      assert POST_2.has_any_tags?("a", "f")
      refute POST_3.has_any_tags?("a", "f")
    end
  end

  describe "#has_all_{column_name}?" do
    it "when receiving a unique argument, returns appropriate boolean" do
      assert POST_1.has_all_tags?("a")
      refute POST_2.has_all_tags?("a")
      refute POST_3.has_all_tags?("a")
    end

    it "when receiving a shared argument, returns appropriate boolean" do
      assert POST_1.has_all_tags?("c")
      assert POST_2.has_all_tags?("c")
      refute POST_3.has_all_tags?("c")
    end

    it "when receiving a non-existent argument, returns appropriate boolean" do
      refute POST_1.has_all_tags?("z")
      refute POST_2.has_all_tags?("z")
      refute POST_3.has_all_tags?("z")
    end

    it "when receiving unique arguments, returns appropriate boolean" do
      assert POST_1.has_all_tags?("a", "b")
      refute POST_2.has_all_tags?("a", "b")
      refute POST_3.has_all_tags?("a", "b")
    end

    it "when receiving shared arguments, returns appropriate boolean" do
      assert POST_1.has_all_tags?("c", "d")
      assert POST_2.has_all_tags?("c", "d")
      refute POST_3.has_all_tags?("c", "d")
    end

    it "when receiving non-existent arguments, returns appropriate boolean" do
      refute POST_1.has_all_tags?("y", "z")
      refute POST_2.has_all_tags?("y", "z")
      refute POST_3.has_all_tags?("y", "z")
    end

    it "when receiving split arguments, returns appropriate boolean" do
      refute POST_1.has_all_tags?("a", "f")
      refute POST_2.has_all_tags?("a", "f")
      refute POST_3.has_all_tags?("a", "f")
    end
  end
end
