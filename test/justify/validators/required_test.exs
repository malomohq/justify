defmodule Justify.Validators.RequiredTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  describe "validate_required/3" do
    test "adds an error if value is `nil`" do
      data = %{}

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, :field)
    end

    test "adds an error if value is an empty string" do
      data = %{ field: "" }

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, :field)
    end

    test "adds an error if value is only whitespace and `:trim?` is `true`" do
      data = %{ field: " " }

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, :field, trim?: true)
    end

    test "adds multiple errors if a list of fields is provided" do
      field_1 = :field_1
      field_2 = :field_2

      data = %{}

      assert %Dataset{
               data: ^data,
               errors: [
                 { ^field_1, { "can't be blank", validation: :required } },
                 { ^field_2, { "can't be blank", validation: :required } }
                ],
               valid?: false
             } = Justify.validate_required(data, [field_1, field_2])
    end

    test "adds an error for field regardless of placement in list" do
      field_1 = :field_1
      field_2 = :field_2

      data = %{ field_1: "", field_2: "hi" }

      assert %Dataset{
               data: ^data,
               errors: [
                 { ^field_1, { "can't be blank", validation: :required } }
                ],
               valid?: false
             } = Justify.validate_required(data, [field_1, field_2])
    end

    test "does not add an error if value is not nil or only whitespace" do
      data = %{ field: "value" }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, :field)
    end

    test "does not add an error if value is only whitespace and `:trim?` is `false`" do
      data = %{ field: " " }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, :field, trim?: false)
    end

    test "does not add an error if value is not a string" do
      data = %{ field: 1 }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, :field)
    end

    test "uses a custom error message when provided" do
      message = "this is a message"

      data = %{}

      assert %Dataset{
               data: ^data,
               errors: [{ :field, { ^message, validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, :field, message: message)
    end
  end

  describe "validate_required!/3" do
    test "raises an error if value is `nil`" do
      assert_raise Justify.ValidationError, fn ->
        Justify.validate_required!(%{}, :field)
      end
    end

    test "raises an error if value is an empty string" do
      assert_raise Justify.ValidationError, fn ->
        Justify.validate_required!(%{ field: "" }, :field)
      end
    end

    test "raises an error if value is only whitespace and `:trim?` is `true`" do
      assert_raise Justify.ValidationError, fn ->
        Justify.validate_required!(%{ field: " " }, :field, trim?: true)
      end
    end

    test "raises a single error if a list of fields is provided" do
      assert_raise Justify.ValidationError, ":field_1 failed validation with message \"can't be blank\"", fn ->
        Justify.validate_required!(%{}, [:field_1, :field_2], trim?: true)
      end
    end

    test "raises an error for field regardless of placement in list" do
      data = %{ field_1: "hi", field_2: "" }

      assert_raise Justify.ValidationError, ":field_2 failed validation with message \"can't be blank\"", fn ->
        Justify.validate_required!(data, [:field_1, :field_2])
      end
    end

    test "does not raise an error if value is not nil or only whitespace" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required!(data, field)
    end

    test "does not raise an error if value is only whitespace and `:trim?` is `false`" do
      data = %{ field: " " }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required!(data, :field, trim?: false)
    end

    test "does not raise an error if value is not a string" do
      data = %{ field: 1 }

      assert %Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required!(data, :field)
    end

    test "uses a custom error message when provided" do
      message = "this is a message"

      data = %{ field: "" }

      error = Justify.ValidationError.message(:field, message)

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate_required!(data, :field, message: message)
      end
    end
  end
end
