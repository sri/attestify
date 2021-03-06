class Attestify::AssertionsTest < Attestify::Test
  def setup
    @assertions = Attestify::AssertionResults.new
    @assert = Assertable.new(@assertions)
  end

  def test_skip_without_message
    assert_raises Attestify::SkippedError do
      @assert.skip
    end
  end

  def test_skip_with_message
    exception = assert_raises Attestify::SkippedError do
      @assert.skip("A custom skip message")
    end

    assert_equal "A custom skip message", exception.message
  end

  def test_passing_assert
    @assert.assert true
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert
    @assert.assert false
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_with_custom_message
    @assert.assert false, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_empty
    @assert.assert_empty []
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_empty
    @assert.assert_empty [42]
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_empty_with_empty_not_implemented
    @assert.assert_empty Object.new
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_empty_with_custom_message
    @assert.assert_empty [42], "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_equal
    @assert.assert_equal 42, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_equal
    @assert.assert_equal 42, "Not 42"
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_equal_with_custom_message
    @assert.assert_equal 42, "Not 42", "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_in_delta_equal
    @assert.assert_in_delta 42, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_in_delta_close_to_equal
    @assert.assert_in_delta 42.0, 42.000001
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_in_delta_custom_delta
    @assert.assert_in_delta 42.0, 42.1, 0.5
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_in_delta_above
    @assert.assert_in_delta 42.0, 42.1
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_in_delta_below
    @assert.assert_in_delta 42.0, 41.9
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_in_delta_custom_delta
    @assert.assert_in_delta 42.0, 42.2, 0.1
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_in_delta_with_custom_message
    @assert.assert_in_delta 42.0, 42.1, 0.001, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_includes
    @assert.assert_includes [1, 2, 42], 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_includes_with_include_not_implemented
    @assert.assert_includes Object.new, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_includes_with_missing_element
    @assert.assert_includes [1, 2, 3], 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_includes_with_custom_message
    @assert.assert_includes [1, 2, 3], 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_instance_of
    @assert.assert_instance_of Fixnum, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_instance_of_with_parent_class
    @assert.assert_instance_of Integer, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_instance_of_with_included_module
    @assert.assert_instance_of Enumerable, []
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_instance_of_with_different_class
    @assert.assert_instance_of Float, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_instance_of_with_a_non_module
    @assert.assert_instance_of "Not a module", 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_instance_of_with_custom_message
    @assert.assert_instance_of Float, 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_kind_of_with_correct_class
    @assert.assert_kind_of Fixnum, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_kind_of_with_parent_class
    @assert.assert_kind_of Integer, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_kind_of_with_included_module
    @assert.assert_kind_of Enumerable, []
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_kind_of_with_different_class
    @assert.assert_kind_of Float, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_kind_of_with_a_non_module
    @assert.assert_kind_of "Not a module", 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_kind_of_with_custom_message
    @assert.assert_kind_of Float, 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_match
    @assert.assert_match "abc", /b/
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_match
    @assert.assert_match "abc", /z/
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_match_with_custom_message
    @assert.assert_match "abc", /z/, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_nil
    @assert.assert_nil nil
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_nil
    @assert.assert_nil "Not nil"
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_nil_with_custom_message
    @assert.assert_nil "Not nil", "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_operator
    @assert.assert_operator 4, :>=, 2
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_operator_from_false_result
    @assert.assert_operator 4, :<=, 2
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_operator_from_missing_operator
    @assert.assert_operator Object.new, :<=, Object.new
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_operator_with_custom_message
    @assert.assert_operator 4, :<=, 2, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_predicate
    @assert.assert_predicate "", :empty?
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_predicate_from_false_result
    @assert.assert_predicate "42", :empty?
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_predicate_from_missing_operator
    @assert.assert_predicate "42", :foobar
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_predicate_with_custom_message
    @assert.assert_predicate "42", :empty?, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_raises
    exception = ArgumentError.new("An example error")
    result = @assert.assert_raises(ArgumentError) { raise exception }
    assert_equal exception, result
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_raises_with_no_explicit_exception
    exception = ArgumentError.new("An example error")
    result = @assert.assert_raises { raise exception }
    assert_equal exception, result
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_assert_raises_with_multiple_possible_exceptions
    exception = ArgumentError.new("An example error")
    result = @assert.assert_raises(NoMethodError, ArgumentError) { raise exception }
    assert_equal exception, result
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_raises_with_nothing_raised
    result = @assert.assert_raises(ArgumentError) { }
    assert_equal nil, result
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_raises_with_no_explicit_exception
    exception = Exception.new("An example error")
    result = @assert.assert_raises { raise exception }
    assert_equal exception, result
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_raises_with_wrong_error_raised
    exception = NoMethodError.new("An example error")
    result = @assert.assert_raises(ArgumentError) { raise exception }
    assert_equal exception, result
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_raises_with_wrong_error_raised_with_multiple_possible_exceptions
    exception = NoMethodError.new("An example error")
    result = @assert.assert_raises(ArgumentError, KeyError) { raise exception }
    assert_equal exception, result
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_raises_with_custom_message
    @assert.assert_raises(ArgumentError, "Custom message") { raise NoMethodError, "An example error" }
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_assert_raises_with_custom_message_and_multiple_possible_exceptions
    @assert.assert_raises(ArgumentError, KeyError, "Custom message") { raise NoMethodError, "An example error" }
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_assert_raises_with_custom_message_and_nothing_raised
    @assert.assert_raises(ArgumentError, "Custom message") { }
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_respond_to
    @assert.assert_respond_to 42, :zero?
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_respond_to_with_a_method_the_object_doesnt_respond_to
    @assert.assert_respond_to 42, :foobar
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_assert_respond_to_with_a_non_string_nor_symbol
    @assert.assert_respond_to 42, 142
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_respond_to_with_custom_message
    @assert.assert_respond_to 42, :foobar, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_assert_same
    object = Object.new
    @assert.assert_same object, object
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_assert_same
    @assert.assert_same Object.new, Object.new
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_assert_same_with_custom_message
    @assert.assert_same Object.new, Object.new, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute
    @assert.refute false
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute
    @assert.refute true
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_with_custom_message
    @assert.refute true, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_empty
    @assert.refute_empty [42]
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_empty_with_empty_not_implemented
    @assert.refute_empty Object.new
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_empty
    @assert.refute_empty []
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_empty_with_custom_message
    @assert.refute_empty [], "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_equal
    @assert.refute_equal 42, "Not 42"
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_equal
    @assert.refute_equal 42, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_equal_with_custom_message
    @assert.refute_equal 42, 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_in_delta_above
    @assert.refute_in_delta 42, 43
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_in_delta_below
    @assert.refute_in_delta 42, 41
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_in_delta_custom_delta
    @assert.refute_in_delta 42.0, 42.0001, 0.00001
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_in_delta_equal
    @assert.refute_in_delta 42, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_refute_in_delta_close_to_equal
    @assert.refute_in_delta 42.0, 42.000001
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_refute_in_delta_custom_delta
    @assert.refute_in_delta 42.0, 42.1, 0.5
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_in_delta_with_custom_message
    @assert.refute_in_delta 42.0, 42.00001, 0.001, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_includes_with_include_not_implemented
    @assert.refute_includes Object.new, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_includes_with_missing_element
    @assert.refute_includes [1, 2, 3], 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_includes
    @assert.refute_includes [1, 2, 42], 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_includes_with_custom_message
    @assert.refute_includes [1, 2, 42], 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_instance_of_with_parent_class
    @assert.refute_instance_of Integer, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_instance_of_with_included_module
    @assert.refute_instance_of Enumerable, []
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_instance_of_with_different_class
    @assert.refute_instance_of Float, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_instance_of_with_a_non_module
    @assert.refute_instance_of "Not a module", 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_instance_of
    @assert.refute_instance_of Fixnum, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_instance_of_with_custom_message
    @assert.refute_instance_of Fixnum, 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_kind_of_with_different_class
    @assert.refute_kind_of Float, 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_kind_of_with_a_non_module
    @assert.refute_kind_of "Not a module", 42
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_kind_of_with_correct_class
    @assert.refute_kind_of Fixnum, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_refute_kind_of_with_parent_class
    @assert.refute_kind_of Integer, 42
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_failing_refute_kind_of_with_included_module
    @assert.refute_kind_of Enumerable, []
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_kind_of_with_custom_message
    @assert.refute_kind_of Fixnum, 42, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_match
    @assert.refute_match "abc", /z/
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_match
    @assert.refute_match "abc", /b/
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_match_with_custom_message
    @assert.refute_match "abc", /b/, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_nil
    @assert.refute_nil "Not nil"
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_nil
    @assert.refute_nil nil
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_nil_with_custom_message
    @assert.refute_nil nil, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_operator_from_false_result
    @assert.refute_operator 4, :<=, 2
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_operator_from_missing_operator
    @assert.refute_operator Object.new, :<=, Object.new
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_operator
    @assert.refute_operator 4, :>=, 2
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_operator_with_custom_message
    @assert.refute_operator 4, :>=, 2, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_predicate_from_false_result
    @assert.refute_predicate "42", :empty?
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_predicate_from_missing_operator
    @assert.refute_predicate "42", :foobar
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_predicate
    @assert.refute_predicate "", :empty?
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_predicate_with_custom_message
    @assert.refute_predicate "", :empty?, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_passing_refute_respond_to_with_a_method_the_object_doesnt_respond_to
    @assert.refute_respond_to 42, :foobar
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_respond_to_with_a_non_string_nor_symbol
    @assert.refute_respond_to 42, 142
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_failing_refute_respond_to
    @assert.refute_respond_to 42, :zero?
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_respond_to_with_custom_message
    @assert.refute_respond_to 42, :zero?, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end

  def test_failing_refute_same
    @assert.refute_same Object.new, Object.new
    assert_equal 1, @assertions.passed
    assert_equal 0, @assertions.failed
  end

  def test_passing_refute_same
    object = Object.new
    @assert.refute_same object, object
    assert_equal 0, @assertions.passed
    assert_equal 1, @assertions.failed
  end

  def test_refute_same_with_custom_message
    object = Object.new
    @assert.refute_same object, object, "Custom message"
    assert_equal "Custom message", @assertions.failure_details.first.message
  end
end
