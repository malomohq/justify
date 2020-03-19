defmodule Justify.Validators.AcceptanceTest do
  use ExUnit.Case, async: true

  describe "validate_acceptance/3" do
    test "adds an error if value is not `true`" do
      field = :field
      data = Map.new([{field, false}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {"must be accepted", validation: :acceptance}}],
               valid?: false
             } = Justify.validate_acceptance(data, field)
    end

    test "does not add an error if value is `true`" do
      field = :field
      data = Map.new([{field, true}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_acceptance(data, field)
    end

    test "does not add an error if value is `nil`" do
      field = :field
      data = Map.new([{field, nil}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [],
               valid?: true
             } = Justify.validate_acceptance(data, field)
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"
      data = Map.new([{field, false}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {^message, validation: :acceptance}}],
               valid?: false
             } = Justify.validate_acceptance(data, field, message: message)
    end
  end
end
