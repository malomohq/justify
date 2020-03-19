defmodule Justify.Validators.LengthTest do
  use ExUnit.Case, async: true

  describe "validate_length/3" do
    test "adds an error if value's length does not exactly match `:is`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be %{count} character(s)",
                   count: ^count, kind: :is, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, is: count)
    end

    test "adds an error if value has a length less than `:min`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at least %{count} character(s)",
                   count: ^count, kind: :min, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, min: count)
    end

    test "adds an error if value has a length greater than `:max`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.graphemes(value)) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at most %{count} character(s)",
                   count: ^count, kind: :max, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, max: count)
    end

    test "adds an error if value's length does not exactly match `:is` when `:count` is `:codepoints`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.codepoints(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be %{count} character(s)",
                   count: ^count, kind: :is, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, is: count)
    end

    test "adds an error if value has a length less than `:min` when `:count` is `:codepoints`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.codepoints(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at least %{count} character(s)",
                   count: ^count, kind: :min, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, min: count)
    end

    test "adds an error if value has a length greater than `:max` when `:count` is `:codepoints`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = length(String.codepoints(value)) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at most %{count} character(s)",
                   count: ^count, kind: :max, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :codepoints, max: count)
    end

    test "adds an error if value's length does not exactly match `:is` when `:count` is `:bytes`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = byte_size(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be %{count} byte(s)",
                   count: ^count, kind: :is, type: :binary, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, is: count)
    end

    test "adds an error if value has a length less than `:min` when `:count` is `:bytes`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = byte_size(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at least %{count} byte(s)",
                   count: ^count, kind: :min, type: :binary, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, min: count)
    end

    test "adds an error if value has a length greater than `:max` when `:count` is `:bytes`" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
      count = byte_size(value) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should be at most %{count} byte(s)",
                   count: ^count, kind: :max, type: :binary, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, count: :bytes, max: count)
    end

    test "adds an error if value is a list and does not exactly match `:is`" do
      field = :field
      value = ["é"]
      data = Map.new([{field, value}])
      count = length(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should have %{count} item(s)",
                   count: ^count, kind: :is, type: :list, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, is: count)
    end

    test "adds an error if value is a list with fewer items than `:min`" do
      field = :field
      value = ["é"]
      data = Map.new([{field, value}])
      count = length(value) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should have at least %{count} item(s)",
                   count: ^count, kind: :min, type: :list, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, min: count)
    end

    test "adds an error if value is a list with more items than `:max`" do
      field = :field
      value = ["é"]
      data = Map.new([{field, value}])
      count = length(value) - 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {"should have at most %{count} item(s)",
                   count: ^count, kind: :max, type: :list, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, max: count)
    end

    test "does not add an error if value's length matches `:is` exactly" do
      field = :field
      value = "é"
      data = Map.new([{field, value}])
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
      data = Map.new([{field, value}])
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
      data = Map.new([{field, value}])
      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, max: count)
    end

    test "does not add an error if value is nil" do
      field = :field
      data = Map.new([{field, nil}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_length(data, field, is: 1)
    end

    test "does not add an error if value is an empty string" do
      field = :field
      data = Map.new([{field, ""}])

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
      data = Map.new([{field, value}])
      count = length(String.graphemes(value)) + 1

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field,
                  {^message, count: ^count, kind: :is, type: :string, validation: :length}}
               ],
               valid?: false
             } = Justify.validate_length(data, field, is: count, message: message)
    end
  end
end
