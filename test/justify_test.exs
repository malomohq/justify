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
