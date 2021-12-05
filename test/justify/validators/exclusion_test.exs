defmodule Justify.Validators.ExclusionTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  test "adds an error if value is contained within enum" do
    field = :field

    value = "value"

    data = Map.new([{ field, value }])

    enum = [value]

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "is reserved", validation: :exclusion, enum: ^enum } }],
             valid?: false
           } = Justify.validate_exclusion(data, field, enum)
  end

  test "does not add an error if the value is not contained within enum" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
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

    enum = [value]

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, validation: :exclusion, enum: ^enum } }],
             valid?: false
           } = Justify.validate_exclusion(data, field, enum, message: message)
  end

  test "does not add an error if value is `nil`" do
    field = :field

    data = Map.new([{ field, nil }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_exclusion(data, field, ["a value"])
  end
end
