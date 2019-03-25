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
end
