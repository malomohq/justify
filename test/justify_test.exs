defmodule JustifyTest do
  use ExUnit.Case, async: true

  describe "add_error/4" do
    test "adds an error to the dataset" do
      field = :a_field
      message = "an error message"
      additional = [an_opts: "with a value"]

      dataset = Justify.add_error(%Justify.Dataset{}, field, message, additional)

      assert %Justify.Dataset{ errors: [{ ^field, { ^message, ^additional } }], valid?: false } = dataset
    end
  end

  describe "validate_acceptance/3" do
    test "adds an error if value is not `true`" do
      field = :a_field

      data = Map.new([{ field, false }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { "must be accepted", validation: :acceptance } }],
               valid?: false
             } = Justify.validate_acceptance(data, :a_field)
    end

    test "does not add an error if value is `true`" do
      field = :a_field

      data = Map.new([{ field, true }])

      assert %Justify.Dataset{
                data: ^data,
                errors: [],
                valid?: true
              } = Justify.validate_acceptance(data, :a_field)
    end

    test "uses a custom error message when provided" do
      field = :a_field
      message = "a message"

      data = Map.new([{ field, false }])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{ ^field, { ^message, validation: :acceptance } }],
               valid?: false
             } = Justify.validate_acceptance(data, :a_field, message: message)
    end
  end
end
