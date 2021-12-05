defmodule Justify.Validators.Embed do
  @moduledoc false

  alias Justify.{ Dataset }

  def call(dataset, field, validator) do
    dataset = Dataset.new(dataset)

    value = Dataset.get_field(dataset, field)

    case validate(value, validator) do
      [] ->
        dataset
      errors ->
        Justify.put_error(dataset, field, errors)
    end
  end

  defp validate(nil, _validator) do
    []
  end

  defp validate([{ _k, _v } | _t] = value, validator) do
    do_validator(value, validator)
  end

  defp validate([h | t], validator) do
    case validate(h, validator) do
      [] ->
        []
      error ->
        [error]
    end ++ validate(t, validator)
  end

  defp validate([], _validator) do
    []
  end

  defp validate(value, validator) do
    do_validator(value, validator)
  end

  defp do_validator(value, validator) do
    value
    |> validator.()
    |> Map.get(:errors, [])
  end
end
