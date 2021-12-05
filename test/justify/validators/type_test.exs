defmodule Justify.Validators.TypeTest do
  use ExUnit.Case, async: true

  alias Justify.{ Dataset }

  test "adds an error if value does not match type :boolean" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :boolean } }],
             valid?: false
           } = Justify.validate_type(data, field, :boolean)
  end

  test "adds an error if value does not match type :float" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :float } }],
             valid?: false
           } = Justify.validate_type(data, field, :float)
  end

  test "adds an error if value does not match type :integer" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :integer)
  end

  test "adds an error if value does not match type :non_neg_integer" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :non_neg_integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :non_neg_integer)
  end

  test "adds an error if value is -1 for type :non_neg_integer" do
    field = :field

    data = Map.new([{ field, -1 }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :non_neg_integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :non_neg_integer)
  end

  test "adds an error if value does not match type :pos_integer" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :pos_integer)
  end

  test "adds an error if value is 0 for type :pos_integer" do
    field = :field

    data = Map.new([{ field, 0 }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :pos_integer)
  end

  test "adds an error if value is -1 for type :pos_integer" do
    field = :field

    data = Map.new([{ field, -1 }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :pos_integer } }],
             valid?: false
           } = Justify.validate_type(data, field, :pos_integer)
  end

  test "adds an error if value does not match type :string" do
    field = :field

    data = Map.new([{ field, 0 }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { "has invalid type", validation: :type, type: :string } }],
             valid?: false
           } = Justify.validate_type(data, field, :string)
  end

  test "raises an ArgumentError if type is not recognized" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert_raise ArgumentError, fn -> Justify.validate_type(data, field, :nope) end
  end

  test "does not add an error if value matches type :boolean" do
    field = :field

    data = Map.new([{ field, true }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :boolean)
  end

  test "does not add an error if value matches type :float" do
    field = :field

    data = Map.new([{ field, 1.0 }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :float)
  end

  test "does not add an error if value matches type :integer" do
    field = :field

    data = Map.new([{ field, 1 }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :integer)
  end

  test "does not add an error if value matches type :non_neg_integer" do
    field = :field

    data = Map.new([{ field, 0 }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :non_neg_integer)
  end

  test "does not add an error if value matches type :pos_integer" do
    field = :field

    data = Map.new([{ field, 1 }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :pos_integer)
  end

  test "does not add an error if value matches type :string" do
    field = :field

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [],
             valid?: true
           } = Justify.validate_type(data, field, :string)
  end

  test "uses a custom error message when provided" do
    field = :field
    message = "message"

    data = Map.new([{ field, "value" }])

    assert %Dataset{
             data: ^data,
             errors: [{ ^field, { ^message, validation: :type, type: :boolean } }],
             valid?: false
           } = Justify.validate_type(data, field, :boolean, message: message)
  end
end
