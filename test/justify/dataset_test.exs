defmodule Justify.DatasetTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset, Error }

  test "add_error/2" do
    data = %{}

    field = :field

    message = "message"

    keys = [key: "value"]

    error = Error.new(field, message, keys)

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, ^keys } }],
             valid?: false
           } = Dataset.add_error(Dataset.new(data), error)
  end

  describe "add_errors/2" do
    test "adds a list of Justify.Error structs to a dataset" do
      data = %{}

      error_1 = Error.new(:field_1, "message 1")
      error_2 = Error.new(:field_2, "message 2")

      errors = [error_1, error_2]

      expected_error_1 = { error_1.field, { error_1.message, error_1.opts } }
      expected_error_2 = { error_2.field, { error_2.message, error_2.opts } }

      assert %Dataset{
               data: ^data,
               errors: [^expected_error_1, ^expected_error_2],
               valid?: false
             } = Dataset.add_errors(Dataset.new(data), errors)
    end

    test "raises an exception if the provided list contains something other than a Justify.Error struct" do
      message = "expected a Justify.Error struct, got: nil"
      
      assert_raise Justify.BadStructError, message, fn -> Dataset.add_errors(%{}, [nil]) end
    end
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
