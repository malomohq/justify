defmodule Justify.Validators.InclusionTest do
  use ExUnit.Case, async: true

  describe "validate_inclusion/4" do
    test "adds an error if value is not contained within enum" do
      field = :field
      data = Map.new([{field, "value"}])
      enum = ["another value"]

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {"is invalid", validation: :inclusion, enum: ^enum}}],
               valid?: false
             } = Justify.validate_inclusion(data, field, enum)
    end

    test "does not add an error if the value is not contained within enum" do
      field = :field
      value = "value"
      data = Map.new([{field, value}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_inclusion(data, field, [value])
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"
      data = Map.new([{field, "value"}])
      enum = ["another value"]

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {^message, validation: :inclusion, enum: ^enum}}],
               valid?: false
             } = Justify.validate_inclusion(data, field, enum, message: message)
    end

    test "does not add an error if value is nil" do
      field = :field
      data = Map.new([{field, nil}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_inclusion(data, field, ["a value"])
    end

    test "does not add an error if value is an empty string" do
      field = :field
      data = Map.new([{field, ""}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_inclusion(data, field, ["a value"])
    end
  end
end
