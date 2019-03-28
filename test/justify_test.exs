defmodule JustifyTest do
  use ExUnit.Case, async: true

  describe "add_error/4" do
    test "adds an error to the dataset" do
      field = :field
      message = "message"
      keys = [key: "value"]

      dataset = Justify.add_error(%Justify.Dataset{}, field, message, keys)

      assert %Justify.Dataset{ errors: [{ ^field, { ^message, ^keys } }], valid?: false } = dataset
    end
  end

  describe "validate_acceptance/3" do
    test "adds an error if value is not `true`" do
      field = :field

      data = Map.new([{ field, false }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "must be accepted", validation: :acceptance } }],
               valid?: false
             } = Justify.validate_acceptance(data, field)
    end

    test "does not add an error if value is `true`" do
      field = :field

      data = Map.new([{ field, true }])

      assert %Justify.Dataset{
                data: ^data,
                errors: [],
                valid?: true
              } = Justify.validate_acceptance(data, field)
    end

    test "does not add an error if value is `nil`" do
      field = :field

      data = Map.new([{ field, nil }])

      assert %Justify.Dataset{
                data: ^data,
                errors: [],
                valid?: true
              } = Justify.validate_acceptance(data, field)
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"

      data = Map.new([{ field, false }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :acceptance } }],
               valid?: false
             } = Justify.validate_acceptance(data, field, message: message)
    end
  end

  describe "validate_confirmation/3" do
    test "adds an error if the confirmation value does not match the provided value" do
      field = :field

      confirmation_field = :field_confirmation

      data = Map.new([{ field, "value" }, { confirmation_field, "confirmation_value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "does not match", validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, field)
    end

    test "adds an error if the confirmation value is `nil` and `:required?` is `true`" do
      field = :field

      confirmation_field = :field_confirmation

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^confirmation_field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_confirmation(data, field, required?: true)
    end

    test "does not add an error if the confirmation value matches" do
      field = :field

      confirmation_field = :field_confirmation

      value = "value"

      data = Map.new([{ field, value }, { confirmation_field, value }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_confirmation(data, field)
    end

    test "uses a different confirmation field when `:confirmation_field` is set" do
      field = :field

      confirmation_field = :another_confirmation_field

      data = Map.new([{ field, "value" }, { confirmation_field, "confirmation value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "does not match", validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, field, confirmation_field: confirmation_field)
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"

      confirmation_field = :field_confirmation

      data = Map.new([{ field, "value" }, { confirmation_field, "confirmation_value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :confirmation } }],
               valid?: false
             } = Justify.validate_confirmation(data, field, message: message)
    end
  end

  describe "validate_embed/3" do
    test "adds an error if an embedded map is invalid" do
      field = :field

      embed_field = :embed_field
      message = "message"
      keys = [validation: :custom]

      data = Map.new([{ field, Map.new([{ embed_field, false }]) }])

      fun = fn(_value) -> Justify.add_error(%Justify.Dataset{}, embed_field, message, keys) end

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, [{ ^embed_field, { ^message, ^keys } }] }],
               valid?: false
             } = Justify.validate_embed(data, field, fun)
    end

    test "adds an error if an embedded list is invalid" do
      field = :field

      embed_field = :embed_field
      message = "message"
      keys = [validation: :custom]

      embed_data = Map.new([{ embed_field, false }])

      data = Map.new([{ field, [embed_data, embed_data] }])

      fun = fn(_value) -> Justify.add_error(%Justify.Dataset{}, embed_field, message, keys) end

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, [[{ ^embed_field, { ^message, ^keys } }], [{ ^embed_field, { ^message, ^keys } }]] }],
               valid?: false
             } = Justify.validate_embed(data, field, fun)
    end

    test "does not add an error if value is `nil`" do
      field = :field

      embed_field = :embed_field
      message = "message"
      keys = [validation: :custom]

      data = Map.new([{ field, nil }])

      fun = fn(_value) -> Justify.add_error(%Justify.Dataset{}, embed_field, message, keys) end

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_embed(data, field, fun)
    end
  end

  describe "validate_exclusion/4" do
    test "adds an error if value is contained within enum" do
      field = :field

      value = "value"

      data = Map.new([{ field, value }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "is reserved", validation: :exclusion } }],
               valid?: false
             } = Justify.validate_exclusion(data, field, [value])
    end

    test "does not add an error if the value is not contained within enum" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_exclusion(data, field, ["another value"])
    end

    test "uses a custom error message when provided" do
      field = :field

      value = "value"

      message = "message"

      data = Map.new([{ field, value }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :exclusion } }],
               valid?: false
             } = Justify.validate_exclusion(data, field, [value], message: message)
    end
  end

  describe "validate_format/4" do
    test "adds an error if value does not match the provided format" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid format", validation: :format } }],
               valid?: false
             } = Justify.validate_format(data, field, ~r/\d/)
    end

    test "does not add an error if value does match the provided format" do
      field = :field

      value = "value"

      data = Map.new([{ field, value }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_format(data, field, ~r/#{value}/)
    end

    test "uses a custom error message when provided" do
      field = :field

      message = "message"

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :format } }],
               valid?: false
             } = Justify.validate_format(data, field, ~r/\d/, message: message)
    end
  end

  describe "validate_inclusion/4" do
    test "adds an error if value is not contained within enum" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "is invalid", validation: :inclusion } }],
               valid?: false
             } = Justify.validate_inclusion(data, field, ["another value"])
    end

    test "does not add an error if the value is not contained within enum" do
      field = :field

      value = "value"

      data = Map.new([{ field, value }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_inclusion(data, field, [value])
    end

    test "uses a custom error message when provided" do
      field = :field

      message = "message"

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :inclusion } }],
               valid?: false
             } = Justify.validate_inclusion(data, field, ["another value"], message: message)
    end
  end

  describe "validate_required/3" do
    test "adds an error if value is `nil`" do
      field = :field

      data = %{}

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, field)
    end

    test "adds an error if value is an empty string" do
      field = :field

      data = Map.new([{ field, "" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, field)
    end

    test "adds an error if value is only whitespace and `:trim?` is `true`" do
      field = :field

      data = Map.new([{ field, " " }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "can't be blank", validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, field, trim?: true)
    end

    test "adds multiple errors if a list of fields is provided" do
      field_a = :field_a
      field_b = :field_b

      data = %{}

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 { ^field_a, { "can't be blank", validation: :required } },
                 { ^field_b, { "can't be blank", validation: :required } }
                ],
               valid?: false
             } = Justify.validate_required(data, [field_a, field_b])
    end

    test "does not add an error if value is not nil or only whitespace" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, field)
    end

    test "does not add an error if value is only whitespace and `:trim?` is `false`" do
      field = :field

      data = Map.new([{ field, " " }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, field, trim?: false)
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"

      data = %{}

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :required } }],
               valid?: false
             } = Justify.validate_required(data, field, message: message)
    end
  end
end
