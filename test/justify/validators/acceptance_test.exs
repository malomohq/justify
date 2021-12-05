defmodule Justify.Validators.AcceptanceTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  test "adds an error if value is not `true`" do
    field = :field

    data = Map.new([{ field, false }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "must be accepted", validation: :acceptance } }],
             valid?: false
           } = Justify.validate_acceptance(data, field)
  end

  test "does not add an error if value is `true`" do
    field = :field

    data = Map.new([{ field, true }])

    assert %Dataset{
              data: ^data,
              errors: [],
              valid?: true
            } = Justify.validate_acceptance(data, field)
  end

  test "does not add an error if value is `nil`" do
    field = :field

    data = Map.new([{ field, nil }])

    assert %Dataset{
              data: ^data,
              errors: [],
              valid?: true
            } = Justify.validate_acceptance(data, field)
  end

  test "uses a custom error message when provided" do
    field = :field
    message = "message"

    data = Map.new([{ field, false }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, validation: :acceptance } }],
             valid?: false
           } = Justify.validate_acceptance(data, field, message: message)
  end
end
