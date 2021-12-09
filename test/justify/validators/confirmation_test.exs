defmodule Justify.Validators.ConfirmationTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  describe "Justify.validate_confirmation/3" do
    test "adds an error if the confirmation value does not match the provided value" do
      data = %{ field: "value", field_confirmation: "confirmation value" }

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { _, validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, :field)
    end

    test "adds an error if the confirmation value is `nil` and `:required?` is `true`" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [{ :field_confirmation, { _, validation: :required } }],
               valid?: false
             } = Justify.validate_confirmation(data, :field, required?: true)
    end

    test "does not add an error if the confirmation value matches" do
      data = %{ field: "value", field_confirmation: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_confirmation(data, :field)
    end

    test "uses a different confirmation field when `:confirmation_field` is set" do
      data = %{ field: "value", another_confirmation_field: "confirmation value" }

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { _, validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, :field, confirmation_field: :another_confirmation_field)
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value", field_confirmation: "confirmation value" }

      message = "this is a message"

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { ^message, validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, :field, message: message)
    end
  end

  describe "Justify.validate_confirmation!/3" do
    test "raises an error if the confirmation value does not match the provided value" do
      data = %{ field: "value", field_confirmation: "confirmation value" }

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_confirmation!(data, :field)
      end
    end

    test "raises an error if the confirmation value is `nil` and `:required?` is `true`" do
      data = %{ field: "value" }

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_confirmation!(data, :field, required?: true)
      end
    end

    test "does not raise an error if the confirmation value matches" do
      data = %{ field: "value", field_confirmation: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_confirmation!(data, :field)
    end

    test "uses a different confirmation field when `:confirmation_field` is set" do
      data = %{ field: "value", another_confirmation_field: "confirmation value" }

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_confirmation!(data, :field, confirmation_field: :another_confirmation_field)
      end
    end

    test "uses a custom error message when provided" do
      data = %{ field: "value", field_confirmation: "confirmation value" }

      message = "this is a message"

      error = Justify.ValidationError.message(:field, message)

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate_confirmation!(data, :field, message: message)
      end
    end
  end
end
