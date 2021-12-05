defmodule Justify.DatasetTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset, Error }

  test "add_error/2" do
    data = %{}

    field = :field

    message = "message"

    keys = [key: "value"]

    error = Error.new(:field, "message", key: "value")

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, ^keys } }],
             valid?: false
           } = Dataset.add_error(Dataset.new(data), error)
  end

  test "add_error/4" do
    data = %{}

    field = :field

    message = "message"

    keys = [key: "value"]

    dataset = Dataset.add_error(Dataset.new(), field, message, keys)

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, ^keys } }],
             valid?: false
           } = dataset
  end

  describe "get_field/3" do
    test "retrieves value from a map" do
      field = :field

      value = "value"

      data = Map.new([{ field, value }])

      dataset = Dataset.new(data)

      assert Dataset.get_field(dataset, field) == value
    end

    test "retrieves value from a keyword list" do
      field = :field

      value = "value"

      data = Keyword.new([{ field, value }])

      dataset = Dataset.new(data)

      assert Dataset.get_field(dataset, field) == value
    end

    test "returns a default value if provided and the field is not present" do
      default = "default"

      dataset = Dataset.new()

      assert Dataset.get_field(dataset, :field, default) == default
    end
  end

  test "new/0" do
    assert Dataset.new() == %Dataset{}
  end

  test "new/1" do
    keyword = [field: "value"]
    map = %{ field: "value" }

    assert %Dataset{ data: ^keyword } = Dataset.new(keyword)
    assert %Dataset{ data: ^map } = Dataset.new(map)
    assert_raise ArgumentError, fn -> Dataset.new("😦") end
  end
end
