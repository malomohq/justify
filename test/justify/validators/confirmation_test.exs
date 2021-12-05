defmodule Justify.Validators.ConfirmationTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  test "adds an error if the confirmation value does not match the provided value" do
    field = :field

    confirmation_field = :field_confirmation

    data = Map.new([{ field, "value" }, { confirmation_field, "confirmation_value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "does not match", validation: :confirmation } }],
             valid?: false
           } = Justify.validate_confirmation(data, field)
  end

  test "adds an error if the confirmation value is `nil` and `:required?` is `true`" do
    field = :field

    confirmation_field = :field_confirmation

    data = Map.new([{ field, "value" }])

    assert %Dataset{
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

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_confirmation(data, field)
  end

  test "uses a different confirmation field when `:confirmation_field` is set" do
    field = :field

    confirmation_field = :another_confirmation_field

    data = Map.new([{ field, "value" }, { confirmation_field, "confirmation value" }])

    assert %Dataset{
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

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, validation: :confirmation } }],
             valid?: false
           } = Justify.validate_confirmation(data, field, message: message)
  end
end
