defmodule JustifyTest do
  use ExUnit.Case, async: true

  doctest Justify

  describe "add_error/4" do
    test "adds an error to the dataset" do
      field = :field
      message = "message"
      keys = [key: "value"]

      dataset = Justify.add_error(%Justify.Dataset{}, field, message, keys)

      assert %Justify.Dataset{ errors: [{ ^field, { ^message, ^keys } }], valid?: false } = dataset
    end
  end

  describe "validate_length/3" do
    test "adds an error if value's length does not exactly match `:is`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be %{count} character(s)", count: ^count, kind: :is, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, is: count)
    end

    test "adds an error if value has a length less than `:min`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at least %{count} character(s)", count: ^count, kind: :min, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, min: count)
    end

    test "adds an error if value has a length greater than `:max`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at most %{count} character(s)", count: ^count, kind: :max, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, max: count)
    end

    test "adds an error if value's length does not exactly match `:is` when `:count` is `:codepoints`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.codepoints(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be %{count} character(s)", count: ^count, kind: :is, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, is: count)
    end

    test "adds an error if value has a length less than `:min` when `:count` is `:codepoints`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.codepoints(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at least %{count} character(s)", count: ^count, kind: :min, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, min: count)
    end

    test "adds an error if value has a length greater than `:max` when `:count` is `:codepoints`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.codepoints(value)) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at most %{count} character(s)", count: ^count, kind: :max, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, max: count)
    end

    test "adds an error if value's length does not exactly match `:is` when `:count` is `:bytes`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = byte_size(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be %{count} byte(s)", count: ^count, kind: :is, type: :binary, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, is: count)
    end

    test "adds an error if value has a length less than `:min` when `:count` is `:bytes`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = byte_size(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at least %{count} byte(s)", count: ^count, kind: :min, type: :binary, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, min: count)
    end

    test "adds an error if value has a length greater than `:max` when `:count` is `:bytes`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = byte_size(value) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should be at most %{count} byte(s)", count: ^count, kind: :max, type: :binary, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, max: count)
    end

    test "adds an error if value is a list and does not exactly match `:is`" do
      field = :field

      value = ["é"]

      data = Map.new([{ field, value }])

      count = length(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should have %{count} item(s)", count: ^count, kind: :is, type: :list, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, is: count)
    end

    test "adds an error if value is a list with fewer items than `:min`" do
      field = :field

      value = ["é"]

      data = Map.new([{ field, value }])

      count = length(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should have at least %{count} item(s)", count: ^count, kind: :min, type: :list, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, min: count)
    end

    test "adds an error if value is a list with more items than `:max`" do
      field = :field

      value = ["é"]

      data = Map.new([{ field, value }])

      count = length(value) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "should have at most %{count} item(s)", count: ^count, kind: :max, type: :list, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, max: count)
    end

    test "does not add an error if value's length matches `:is` exactly" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value))

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, is: count)
    end

    test "does not add an error if value has a length less than `:min`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, min: count)
    end

    test "does not add an error if value has a length greater than `:max`" do
      field = :field

      value = "é"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, max: count)
    end

    test "does not add an error if value is nil" do
      field = :field

      data = Map.new([{ field, nil }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, is: 1)
    end

    test "does not add an error if value is an empty string" do
      field = :field

      data = Map.new([{ field, "" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, is: 1)
    end

    test "uses a custom error message when provided" do
      field = :field

      value = "é"

      message = "message"

      data = Map.new([{ field, value }])

      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, count: ^count, kind: :is, type: :string, validation: :length } }],
               valid?: false
             } = Justify.validate_length(data, field, is: count, message: message)
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

    test "adds an error for field regardless of placement in list" do
      field_a = :field_a
      field_b = :field_b

      data = Map.new([{ field_a, "" }, { field_b, "hi" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 { ^field_a, { "can't be blank", validation: :required } }
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

    test "does not add an error if value is not a string" do
      field = :field

      data = Map.new([{ field, 1 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_required(data, field)
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

  describe "validate_type/4" do
    test "adds an error if value does not match type :boolean" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :boolean } }],
               valid?: false
             } = Justify.validate_type(data, field, :boolean)
    end

    test "adds an error if value does not match type :float" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :float } }],
               valid?: false
             } = Justify.validate_type(data, field, :float)
    end

    test "adds an error if value does not match type :integer" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :integer)
    end

    test "adds an error if value does not match type :non_neg_integer" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :non_neg_integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :non_neg_integer)
    end

    test "adds an error if value is -1 for type :non_neg_integer" do
      field = :field

      data = Map.new([{ field, -1 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :non_neg_integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :non_neg_integer)
    end

    test "adds an error if value does not match type :pos_integer" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :pos_integer)
    end

    test "adds an error if value is 0 for type :pos_integer" do
      field = :field

      data = Map.new([{ field, 0 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :pos_integer)
    end

    test "adds an error if value is -1 for type :pos_integer" do
      field = :field

      data = Map.new([{ field, -1 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
               valid?: false
             } = Justify.validate_type(data, field, :pos_integer)
    end

    test "adds an error if value does not match type :string" do
      field = :field

      data = Map.new([{ field, 0 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "has invalid type", validation: :type, type: :string } }],
               valid?: false
             } = Justify.validate_type(data, field, :string)
    end

    test "raises an ArgumentError if type is not recognized" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert_raise ArgumentError, fn -> Justify.validate_type(data, field, :nope) end
    end

    test "does not add an error if value matches type :boolean" do
      field = :field

      data = Map.new([{ field, true }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :boolean)
    end

    test "does not add an error if value matches type :float" do
      field = :field

      data = Map.new([{ field, 1.0 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :float)
    end

    test "does not add an error if value matches type :integer" do
      field = :field

      data = Map.new([{ field, 1 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :integer)
    end

    test "does not add an error if value matches type :non_neg_integer" do
      field = :field

      data = Map.new([{ field, 0 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :non_neg_integer)
    end

    test "does not add an error if value matches type :pos_integer" do
      field = :field

      data = Map.new([{ field, 1 }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :pos_integer)
    end

    test "does not add an error if value matches type :string" do
      field = :field

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_type(data, field, :string)
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"

      data = Map.new([{ field, "value" }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :type, type: :boolean } }],
               valid?: false
             } = Justify.validate_type(data, field, :boolean, message: message)
    end
  end
end
