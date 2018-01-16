defmodule Justify.ValidationsetTest do
  use ExUnit.Case, async: true

  import Justify.Validationset

  alias Justify.{ Validationset }

  describe "add_error/4" do
    test "add error to validationset" do
      validationset = validationset(%{}) |> add_error(:foo, "bar")
      assert validationset.errors == [{ :foo, { "bar", [] } }]
      refute validationset.valid?
    end

    test "add error with additional details to validationset" do
      validationset = validationset(%{}) |> add_error(:foo, "bar", additional: "information")
      assert validationset.errors == [{ :foo, { "bar", [additional: "information"] } }]
      refute validationset.valid?
    end
  end

  describe "validate_acceptance/3" do
    test "add acceptance error when no value exists" do
      validationset = validationset(%{}) |> validate_acceptance(:foo)
      assert validationset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute validationset.valid?
    end

    test "add acceptance error when value is `false`" do
      validationset = validationset(%{ foo: false }) |> validate_acceptance(:foo)
      assert validationset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute validationset.valid?
    end

    test "add acceptance error when value is not `true`" do
      validationset = validationset(%{ foo: "bar" }) |> validate_acceptance(:foo)
      assert validationset.errors == [{ :foo, { "must be accepted", [validation: :acceptance] } }]
      refute validationset.valid?
    end

    test "validates when value is `true`" do
      validationset = validationset(%{ foo: true }) |> validate_acceptance(:foo)
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  describe "validate_confirmation/3" do
    test "add confirmation error when value and confirmation value do not match" do
      validationset = validationset(%{ foo: "bar", foo_confirmation: "baz" }) |> validate_confirmation(:foo)
      assert validationset.errors == [{ :foo, { "does not match", validation: :confirmation } }]
      refute validationset.valid?
    end

    test "add confirmation error when confirmation value does not exist and `:required` is `true`" do
      validationset = validationset(%{ foo: "bar" }) |> validate_confirmation(:foo, required: true)
      assert validationset.errors == [{ :foo, { "does not match", validation: :confirmation } }]
      refute validationset.valid?
    end

    test "validate when value and confirmation value match" do
      validationset = validationset(%{ foo: "bar", foo_confirmation: "bar" }) |> validate_confirmation(:foo)
      assert validationset.errors == []
      assert validationset.valid?
    end

    test "validate when value and confirmation value on alternative field match" do
      validationset = validationset(%{ foo: "bar", foo_cnfrm: "bar" }) |> validate_confirmation(:foo, confirmation_field: :foo_cnfrm)
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  describe "validate_exclusion/4" do
    test "add exclusion error when value is included in exclusion list" do
      validationset = validationset(%{ foo: "bar" }) |> validate_exclusion(:foo, ~w(bar))
      assert validationset.errors == [{ :foo, { "is reserved", validation: :exclusion } }]
      refute validationset.valid?
    end

    test "validate when value is not included in exclusion list" do
      validationset = validationset(%{ foo: "bar" }) |> validate_exclusion(:foo, ~w(baz))
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  describe "validate_format/4" do
    test "add format error when no value exists" do
      validationset = validationset(%{}) |> validate_format(:foo, ~r/bar/)
      assert validationset.errors == [{ :foo, { "has invalid format", validation: :format } }]
      refute validationset.valid?
    end

    test "add format error when value does not match the format" do
      validationset = validationset(%{ foo: "baz" }) |> validate_format(:foo, ~r/bar/)
      assert validationset.errors == [{ :foo, { "has invalid format", validation: :format } }]
      refute validationset.valid?
    end

    test "validate when value does match the format" do
      validationset = validationset(%{ foo: "bar" }) |> validate_format(:foo, ~r/bar/)
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  describe "validate_inclusion/4" do
    test "add inclusion error when value does not exist" do
      validationset = validationset(%{}) |> validate_inclusion(:foo, ~w(bar))
      assert validationset.errors == [{ :foo, { "is invalid", validation: :inclusion } }]
      refute validationset.valid?
    end

    test "add inclusion error when value is not in inclusion list" do
      validationset = validationset(%{ foo: "baz" }) |> validate_inclusion(:foo, ~w(bar))
      assert validationset.errors == [{ :foo, { "is invalid", validation: :inclusion } }]
      refute validationset.valid?
    end

    test "validate when value is in inclusion list" do
      validationset = validationset(%{ foo: "bar" }) |> validate_inclusion(:foo, ~w(bar))
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  describe "validate_required/3" do
    test "add required error when value does not exist" do
      validationset = validationset(%{}) |> validate_required(:foo)
      assert validationset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute validationset.valid?
    end

    test "add required error when value is `nil`" do
      validationset = validationset(%{ foo: nil }) |> validate_required(:foo)
      assert validationset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute validationset.valid?
    end

    test "add required error when value is an empty string" do
      validationset = validationset(%{ foo: "" }) |> validate_required(:foo)
      assert validationset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute validationset.valid?
    end

    test "add required error when value contains only whitespace" do
      validationset = validationset(%{ foo: " " }) |> validate_required(:foo)
      assert validationset.errors == [{ :foo, { "can't be blank", validation: :required } }]
      refute validationset.valid?
    end

    test "validate when value contains a value" do
      validationset = validationset(%{ foo: "bar" }) |> validate_required(:foo)
      assert validationset.errors == []
      assert validationset.valid?
    end
  end

  #
  # private
  #

  defp validationset(data) do
    %Validationset{ data: data }
  end
end
