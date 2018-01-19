defmodule Justify.JustifyTest do
  use ExUnit.Case, async: true

  import Justify

  alias Justify.{ Dataset }

  describe "add_error/4" do
    test "add error to dataset" do
      dataset = dataset(%{}) |> add_error(:foo, "bar")
      assert dataset.errors == [{ :foo, { "bar", [] } }]
      refute dataset.valid?
    end

    test "add error with additional details to dataset" do
      dataset = dataset(%{}) |> add_error(:foo, "bar", additional: "information")
      assert dataset.errors == [{ :foo, { "bar", [additional: "information"] } }]
      refute dataset.valid?
    end
  end

  describe "validate_acceptance/3" do
    test "add acceptance error when no value exists" do
      dataset = dataset(%{}) |> validate_acceptance(:foo)
      assert dataset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute dataset.valid?
    end

    test "add acceptance error when value is `false`" do
      dataset = dataset(%{ foo: false }) |> validate_acceptance(:foo)
      assert dataset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute dataset.valid?
    end

    test "add acceptance error when value is not `true`" do
      dataset = dataset(%{ foo: "bar" }) |> validate_acceptance(:foo)
      assert dataset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute dataset.valid?
    end

    test "validates when value is `true`" do
      dataset = dataset(%{ foo: true }) |> validate_acceptance(:foo)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_confirmation/3" do
    test "add confirmation error when value and confirmation value do not match" do
      dataset = dataset(%{ foo: "bar", foo_confirmation: "baz" }) |> validate_confirmation(:foo)
      assert dataset.errors == [{ :foo, { "does not match", validation: :confirmation } }]
      refute dataset.valid?
    end

    test "add confirmation error when confirmation value does not exist and `:required` is `true`" do
      dataset = dataset(%{ foo: "bar" }) |> validate_confirmation(:foo, required: true)
      assert dataset.errors == [{ :foo, { "does not match", validation: :confirmation } }]
      refute dataset.valid?
    end

    test "validate when value and confirmation value match" do
      dataset = dataset(%{ foo: "bar", foo_confirmation: "bar" }) |> validate_confirmation(:foo)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value and confirmation value on alternative field match" do
      dataset = dataset(%{ foo: "bar", foo_cnfrm: "bar" }) |> validate_confirmation(:foo, confirmation_field: :foo_cnfrm)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_exclusion/4" do
    test "add exclusion error when value is included in exclusion list" do
      dataset = dataset(%{ foo: "bar" }) |> validate_exclusion(:foo, ~w(bar))
      assert dataset.errors == [{ :foo, { "is reserved", validation: :exclusion } }]
      refute dataset.valid?
    end

    test "validate when value is not included in exclusion list" do
      dataset = dataset(%{ foo: "bar" }) |> validate_exclusion(:foo, ~w(baz))
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_format/4" do
    test "add format error when no value exists" do
      dataset = dataset(%{}) |> validate_format(:foo, ~r/bar/)
      assert dataset.errors == [{ :foo, { "has invalid format", validation: :format } }]
      refute dataset.valid?
    end

    test "add format error when value does not match the format" do
      dataset = dataset(%{ foo: "baz" }) |> validate_format(:foo, ~r/bar/)
      assert dataset.errors == [{ :foo, { "has invalid format", validation: :format } }]
      refute dataset.valid?
    end

    test "validate when value does match the format" do
      dataset = dataset(%{ foo: "bar" }) |> validate_format(:foo, ~r/bar/)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_inclusion/4" do
    test "add inclusion error when value does not exist" do
      dataset = dataset(%{}) |> validate_inclusion(:foo, ~w(bar))
      assert dataset.errors == [{ :foo, { "is invalid", validation: :inclusion } }]
      refute dataset.valid?
    end

    test "add inclusion error when value is not in inclusion list" do
      dataset = dataset(%{ foo: "baz" }) |> validate_inclusion(:foo, ~w(bar))
      assert dataset.errors == [{ :foo, { "is invalid", validation: :inclusion } }]
      refute dataset.valid?
    end

    test "validate when value is in inclusion list" do
      dataset = dataset(%{ foo: "bar" }) |> validate_inclusion(:foo, ~w(bar))
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_length/3 with string" do
    test "add length error when value length must match required length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, is: 1)
      assert dataset.errors == [{ :foo, { "should be %{count} character(s)", count: 1, kind: :is, validation: :length } }]
      refute dataset.valid?
    end

    test "add length error when value length is over the maximum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, max: 1)
      assert dataset.errors == [{ :foo, { "should be at most %{count} character(s)", count: 1, kind: :max, validation: :length } }]
      refute dataset.valid?
    end

    test "add length error when value length is less than the minimum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, min: 4)
      assert dataset.errors == [{ :foo, { "should be at least %{count} character(s)", count: 4, kind: :min, validation: :length } }]
      refute dataset.valid?
    end

    test "add length error when value is an empty list" do
      dataset = dataset(%{ foo: [] }) |> validate_length(:foo, is: 1)
      assert dataset.errors == [{ :foo, { "should have %{count} item(s)", count: 1, kind: :is, validation: :length } }]
      refute dataset.valid?
    end

    test "validate when value is `nil`" do
      dataset = dataset(%{ foo: nil }) |> validate_length(:foo, is: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value is empty string" do
      dataset = dataset(%{ foo: "" }) |> validate_length(:foo, is: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length matches required length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, is: 3)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length is under the maximum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, max: 4)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length equals the maximum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, max: 3)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length is above the minimum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, min: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length equals the minimum length" do
      dataset = dataset(%{ foo: "bar" }) |> validate_length(:foo, min: 3)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_length/3 with list" do
    test "add length error when value length must match required length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, is: 2)
      assert dataset.errors == [{ :foo, { "should have %{count} item(s)", count: 2, kind: :is, validation: :length } }]
      refute dataset.valid?
    end

    test "add length error when value length is over the maximum length" do
      dataset = dataset(%{ foo: ["bar", "bar"] }) |> validate_length(:foo, max: 1)
      assert dataset.errors == [{ :foo, { "should have at most %{count} item(s)", count: 1, kind: :max, validation: :length } }]
      refute dataset.valid?
    end

    test "add length error when value length is less than the minimum length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, min: 2)
      assert dataset.errors == [{ :foo, { "should have at least %{count} item(s)", count: 2, kind: :min, validation: :length } }]
      refute dataset.valid?
    end

    test "validate when value length matches required length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, is: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length is under the maximum length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, max: 2)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length equals the maximum length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, max: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length is above the minimum length" do
      dataset = dataset(%{ foo: ["bar", "bar"] }) |> validate_length(:foo, min: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end

    test "validate when value length equals the minimum length" do
      dataset = dataset(%{ foo: ["bar"] }) |> validate_length(:foo, min: 1)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  describe "validate_required/3" do
    test "add required error when value does not exist" do
      dataset = dataset(%{}) |> validate_required(:foo)
      assert dataset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute dataset.valid?
    end

    test "add required error when value is `nil`" do
      dataset = dataset(%{ foo: nil }) |> validate_required(:foo)
      assert dataset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute dataset.valid?
    end

    test "add required error when value is an empty string" do
      dataset = dataset(%{ foo: "" }) |> validate_required(:foo)
      assert dataset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute dataset.valid?
    end

    test "add required error when value contains only whitespace" do
      dataset = dataset(%{ foo: " " }) |> validate_required(:foo)
      assert dataset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute dataset.valid?
    end

    test "validate when value contains a value" do
      dataset = dataset(%{ foo: "bar" }) |> validate_required(:foo)
      assert dataset.errors == []
      assert dataset.valid?
    end
  end

  #
  # private
  #

  defp dataset(data) do
    %Dataset{ data: data }
  end
end
