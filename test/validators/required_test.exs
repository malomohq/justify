defmodule Justify.Validators.RequiredTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  describe "validate_required/3" do
    test "adds an error if value is `nil`" do
      field = :field

      data = %{}

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {"can't be blank", validation: :required}}],
               valid?: false
             } = Justify.validate_required(data, field)
    end

    test "adds an error if value is an empty string" do
      field = :field

      data = Map.new([{field, ""}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {"can't be blank", validation: :required}}],
               valid?: false
             } = Justify.validate_required(data, field)
    end

    property "adds an error if value is only whitespace and `:trim?` is `true`" do
      check all whitespaces <- string([?\s, ?\t, ?\n, ?\v, ?\f, ?\r], min_length: 1) do
        field = :field
        data = Map.new([{field, whitespaces}])

        result = Justify.validate_required(data, field, trim?: true)

        assert %Justify.Dataset{} = result
        assert result.valid? == false
        assert result.data == data
        assert result.errors == [{field, {"can't be blank", validation: :required}}]
      end
    end

    property "adds multiple errors if a list of fields is provided" do
      check all fields <- list_of(atom(:alphanumeric), min_length: 1) do
        data = %{}

        result = Justify.validate_required(data, fields)

        assert %Justify.Dataset{} = result
        assert result.valid? == false
        assert result.data == data

        Enum.each(fields, fn field ->
          assert Keyword.get(result.errors, field) == {"can't be blank", validation: :required}
        end)
      end
    end

    test "adds an error for field regardless of placement in list" do
      field_a = :field_a
      field_b = :field_b

      data = Map.new([{field_a, ""}, {field_b, "hi"}])

      assert %Justify.Dataset{
               data: ^data,
               errors: [
                 {^field_a, {"can't be blank", validation: :required}}
               ],
               valid?: false
             } = Justify.validate_required(data, [field_a, field_b])
    end

    property "does not add an error if value is not nil or only whitespace" do
      check all str_value <- string(:printable, min_length: 1) do
        field = :field
        data = Map.new([{field, str_value}])

        result = Justify.validate_required(data, field)

        assert %Justify.Dataset{} = result
        assert result.valid? == true
        assert result.data == data
        assert result.errors == []
      end
    end

    property "does not add an error if value is only whitespace and `:trim?` is `false`" do
      check all whitespaces <- string([?\s, ?\t, ?\n, ?\v, ?\f, ?\r], min_length: 1) do
        field = :field
        data = Map.new([{field, whitespaces}])

        result = Justify.validate_required(data, field, trim?: false)

        assert %Justify.Dataset{} = result
        assert result.valid? == true
        assert result.data == data
        assert result.errors == []
      end
    end

    property "does not add an error if value is not a string" do
      check all data <- term(),
                not (is_binary(data) and String.valid?(data)) do
        field = :field
        data = Map.new([{field, data}])

        result = Justify.validate_required(data, field)

        assert %Justify.Dataset{} = result
        assert result.valid? == true
        assert result.data == data
        assert result.errors == []
      end
    end

    test "uses a custom error message when provided" do
      field = :field
      message = "message"

      data = %{}

      assert %Justify.Dataset{
               data: ^data,
               errors: [{^field, {^message, validation: :required}}],
               valid?: false
             } = Justify.validate_required(data, field, message: message)
    end
  end
end
