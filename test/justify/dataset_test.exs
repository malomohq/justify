defmodule Justify.DatasetTest do
  use ExUnit.Case, async: true

  test "add_error/4" do
    field = :field
    message = "message"
    keys = [key: "value"]

    dataset = Justify.Dataset.add_error(Justify.Dataset.new(), field, message, keys)

    assert %Justify.Dataset{ errors: [{ ^field, { ^message, ^keys } }], valid?: false } = dataset
  end

  describe "get_field/3" do
    test "retrieves value from a map" do
      field = :field

      value = "value"

      data = Map.new([{ field, value }])

      dataset = Justify.Dataset.new(data)

      assert Justify.Dataset.get_field(dataset, field) == value
    end

    test "retrieves value from a keyword list" do
      field = :field

      value = "value"

      data = Keyword.new([{ field, value }])

      dataset = Justify.Dataset.new(data)

      assert Justify.Dataset.get_field(dataset, field) == value
    end

    test "returns a default value if provided and the field is not present" do
      default = "default"

      dataset = Justify.Dataset.new()

      assert Justify.Dataset.get_field(dataset, :field, default) == default
    end
  end

  test "new/0" do
    assert Justify.Dataset.new() == %Justify.Dataset{}
  end

  test "new/1" do
    keyword = [field: "value"]
    map = %{ field: "value" }

    assert %Justify.Dataset{ data: ^keyword } = Justify.Dataset.new(keyword)
    assert %Justify.Dataset{ data: ^map } = Justify.Dataset.new(map)
    assert_raise ArgumentError, fn -> Justify.Dataset.new("😦") end
  end
end
