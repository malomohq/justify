defmodule Justify.Validators.ExclusionTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  describe "Justify.validate_exclusion/4" do
    test "adds an error if value is contained within enum" do
      data = %{ field: "value" }

      enum = ["value"]

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { _, validation: :exclusion, enum: ^enum } }],
               valid?: false
             } = Justify.validate_exclusion(data, :field, enum)
    end

    test "does not add an error if the value is not contained within enum" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_exclusion(data, :field, ["another value"])
    end

    test "does not add an error if value is `nil`" do
      data = %{ field: nil }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_exclusion(data, :field, ["a value"])
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value" }

      message = "message"

      enum = ["value"]

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { ^message, validation: :exclusion, enum: ^enum } }],
               valid?: false
             } = Justify.validate_exclusion(data, :field, enum, message: message)
    end
  end

  describe "Justify.validate_exclusion!/4" do
    test "raises an error if value is contained within enum" do
      data = %{ field: "value" }

      enum = ["value"]

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_exclusion!(data, :field, enum)
      end
    end

    test "does not raise an error if the value is not contained within enum" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_exclusion!(data, :field, ["another value"])
    end

    test "does not raise an error if value is `nil`" do
      data = %{ field: nil }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_exclusion!(data, :field, ["a value"])
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value" }

      message = "this is a message"

      enum = ["value"]

      error = Justify.ValidationError.message(:field, message)

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate_exclusion!(data, :field, enum, message: message)
      end
    end
  end
end
