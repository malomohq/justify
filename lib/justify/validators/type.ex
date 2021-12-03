defmodule Justify.Validators.Type do
  @moduledoc false

  @available_types [
    :boolean,
    :float,
    :integer,
    :non_neg_integer,
    :pos_integer,
    :string
  ]

  @default_message "has invalid type"

  def call(dataset, field, type, opts \\ []) do
    dataset = Justify.Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    if (value == nil || value == "") do
      dataset
    else
      validate(dataset, field, type, value, opts)
    end
  end

  defp validate(dataset, field, type, value, opts) do
    if check(type, value) do
      dataset
    else
      message = Keyword.get(opts, :message, @default_message)

      Justify.add_error(dataset, field, message, validation: :type, type: type)
    end
  end

  defp check(:boolean, value) do
    is_boolean(value)
  end

  defp check(:float, value) do
    is_float(value)
  end

  defp check(:integer, value) do
    is_integer(value)
  end

  defp check(:non_neg_integer, value) do
    is_integer(value) && value >= 0
  end

  defp check(:pos_integer, value) do
    is_integer(value) && value > 0
  end

  defp check(:string, value) do
    is_binary(value)
  end

  defp check(type, _value) do
    available_types =
      @available_types
      |> Enum.map(&inspect/1)
      |> Enum.join(", ")

    raise ArgumentError,
      "unknown type #{inspect(type)} given to Justify.validate_type/4.\n\n Available types: #{available_types}"
  end
end
