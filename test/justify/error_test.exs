defmodule Justify.ErrorTest do
  use ExUnit.Case, async: true

  alias Justify.{ Error }

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
end
