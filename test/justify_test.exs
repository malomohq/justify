defmodule JustifyTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset, Error }

  describe "validate/4" do
    test "returns the provided dataset when a validator returns nil" do
      dataset = Dataset.new(%{ field: "value" })

      assert ^dataset =
               Justify.validate(dataset, :field, fn
                 (_, _, _, _) ->
                   nil
               end)
    end

    test "adds an error to a dataset when a validator returns an error" do
      dataset = Dataset.new()

      error = Error.new(:field, "message")

      expected_dataset = Justify.Dataset.add_error(dataset, error)

      assert ^expected_dataset =
                Justify.validate(dataset, :field, fn
                  (_, _, _, _) ->
                     error
                end)
    end

    test "raises an exception if a validator returns an unexpected result" do
      message =
        "validate/4 expects the provided validator to return nil or a " <>
        "Justify.Error struct, got: \"😦\""

      assert_raise Justify.BadStructError, message, fn ->
        Justify.validate(Dataset.new(), :field, fn
          (_, _, _, _) ->
            "😦"
        end)
      end
    end
  end

  describe "validate!/4" do
    test "returns the provided dataset when a validator returns nil" do
      dataset = Dataset.new(%{ field: "value" })

      assert ^dataset =
               Justify.validate!(dataset, :field, fn
                 (_, _, _, _) ->
                   nil
               end)
    end

    test "raises a validation error when a validator returns an error" do
      error = Justify.ValidationError.message(:field, "message")

      assert_raise Justify.ValidationError, error, fn ->
        Justify.validate!(Dataset.new(), :field, fn
          (_, _, _, _) ->
            Error.new(:field, "message")
        end)
      end
    end
  end

  test "raises an exception if a validator returns an unexpected result" do
    message =
      "validate/4 expects the provided validator to return nil or a " <>
      "Justify.Error struct, got: \"😦\""

    assert_raise Justify.BadStructError, message, fn ->
      Justify.validate!(Dataset.new(), :field, fn
        (_, _, _, _) ->
          "😦"
      end)
    end
  end
end
