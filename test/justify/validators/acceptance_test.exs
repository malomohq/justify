defmodule Justify.Validators.AcceptanceTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  describe "Justify.validate_acceptance/3" do
    test "adds an error if value is not `true`" do
      field = :field

      data = Map.new([{ field, false }])

      assert %Dataset{
               data: ^data,
               errors: [{ ^field, { _, validation: :acceptance } }],
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

  describe "Justify.validate_acceptance!/3" do
    test "raises an error if value is not `true`" do
      field = :field

      data = Map.new([{ field, false }])

      assert_raise Justify.ValidationError, fn ->
        Justify.validate_acceptance!(data, field)
      end
    end

    test "does not raise an error if value is `true`" do
      field = :field

      data = Map.new([{ field, true }])

      assert %Dataset{
                data: ^data,
                errors: [],
                valid?: true
              } = Justify.validate_acceptance!(data, field)
    end

    test "does not raise an error if value is `nil`" do
      field = :field

      data = Map.new([{ field, nil }])

      assert %Dataset{
                data: ^data,
                errors: [],
                valid?: true
              } = Justify.validate_acceptance!(data, field)
    end

    test "uses a custom error message when provided" do
      field = :field

      message = "this is a message"

      data = Map.new([{ field, false }])

      error = Justify.ValidationError.message(field, message)

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate_acceptance!(data, field, message: message)
      end
    end
  end
end
