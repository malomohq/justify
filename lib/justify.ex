defmodule Justify do
  @spec add_error(Justify.Dataset.t(), atom, String.t(), Keyword.t()) :: Justify.Dataset.t()
  def add_error(dataset, field, message, keys \\ []) do
    errors =
      dataset
      |> Map.get(:errors)
      |> Enum.concat([{ field, { message, keys } }])

    %{ dataset | errors: errors, valid?: false }
  end
end
