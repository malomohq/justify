defmodule Justify.Validators.FormatTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  describe "Justify.validate_format/4" do
    test "adds an error if value does not match the provided format" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { _, validation: :format } }],
               valid?: false
             } = Justify.validate_format(data, :field, ~r/\d/)
    end

    test "does not add an error if value does match the provided format" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format(data, :field, ~r/value/)
    end

    test "does not add an error if value is nil" do
      data = %{ field: nil }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format(data, :field, ~r/\d/)
    end

    test "does not add an error if value is a blank string" do
      data = %{ field: "" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format(data, :field, ~r/\d/)
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value" }

      message = "this is a message"

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { ^message, validation: :format } }],
               valid?: false
             } = Justify.validate_format(data, :field, ~r/\d/, message: message)
    end
  end

  describe "Justify.validate_format!/4" do
    test "raises an error if value does not match the provided format" do
      data = %{ field: "value" }

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_format!(data, :field, ~r/\d/)
      end
    end

    test "does not raise an error if value does match the provided format" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format!(data, :field, ~r/value/)
    end

    test "does not raise an error if value is nil" do
      data = %{ field: nil }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format!(data, :field, ~r/\d/)
    end

    test "does not raise an error if value is a blank string" do
      data = %{ field: "" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format!(data, :field, ~r/\d/)
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value" }

      message = "this is a message"

      error = Justify.ValidationError.message(:field, message)

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate_format!(data, :field, ~r/\d/, message: message)
      end
    end
  end
end
