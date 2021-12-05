defmodule Justify.ErrorTest do
  use ExUnit.Case, async: true

  alias Justify.{ Error }

  require Justify.Error

  test "new/3" do
    field = :field

    message = "message"

    opts = [validation: :validation]

    assert %Error{
             field: ^field,
             message: ^message,
             opts: ^opts
           } = Justify.Error.new(field, message, opts)
  end

  describe "raise/2" do
    test "raises a Justify.ValidationError by default" do
      field = :field

      message = "message"

      error = Justify.Error.new(field, message)

      assert_raise Justify.ValidationError, fn ->
        Justify.Error.raise!(error)
      end
    end

    test "raise a custom exception when provided" do
      field = :field

      message = "message"

      error = Justify.Error.new(field, message)

      raise_fn = fn
        (^error) ->
          raise "my custom error"
      end

      assert_raise RuntimeError, "my custom error", fn ->
        Justify.Error.raise!(error, raise: raise_fn)
      end
    end
  end
end
