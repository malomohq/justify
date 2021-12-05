defmodule Justify.Validators.RequestedTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  test "adds an error if value is `nil`" do
    field = :field

    data = %{}

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "can't be blank", validation: :required } }],
             valid?: false
           } = Justify.validate_required(data, field)
  end

  test "adds an error if value is an empty string" do
    field = :field

    data = Map.new([{ field, "" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "can't be blank", validation: :required } }],
             valid?: false
           } = Justify.validate_required(data, field)
  end

  test "adds an error if value is only whitespace and `:trim?` is `true`" do
    field = :field

    data = Map.new([{ field, " " }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "can't be blank", validation: :required } }],
             valid?: false
           } = Justify.validate_required(data, field, trim?: true)
  end

  test "adds multiple errors if a list of fields is provided" do
    field_a = :field_a
    field_b = :field_b

    data = %{}

    assert %Dataset{
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

    assert %Dataset{
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

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_required(data, field)
  end

  test "does not add an error if value is only whitespace and `:trim?` is `false`" do
    field = :field

    data = Map.new([{ field, " " }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_required(data, field, trim?: false)
  end

  test "does not add an error if value is not a string" do
    field = :field

    data = Map.new([{ field, 1 }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_required(data, field)
  end

  test "uses a custom error message when provided" do
    field = :field
    message = "message"

    data = %{}

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, validation: :required } }],
             valid?: false
           } = Justify.validate_required(data, field, message: message)
  end
end
