defmodule Justify.Validators.Embed do
  @moduledoc false

  def call(dataset, field, validator) do
    dataset = Justify.Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    case validate(value, validator) do
      [] ->
        dataset
      errors ->
        Justify.put_error(dataset, field, errors)
    end
  end

  #
  # private
  #

  defp validate(nil, _validator) do
    []
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
    value
    |> validator.()
    |> Map.get(:errors, [])
  end
end
