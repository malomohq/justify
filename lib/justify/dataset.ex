defmodule Justify.Dataset do
  defstruct data: %{}, errors: [], valid?: true

  @type error_t :: { String.t(), Keyword.t() }

  @type t :: %__MODULE__{
               data: keyword | map,
               errors: [{ atom, error_t }],
               valid?: boolean
             }

  @doc """
  Gets the value for a field.
  """
  @spec get_field(t, any, any) :: any
  def get_field(dataset, field, default \\ nil) do
    data = dataset.data

    cond do
      Keyword.keyword?(data) ->
        Keyword.get(data, field, default)
      is_map(data) ->
        Map.get(data, field, default)
    end
  end

  @doc """
  Returns a new dataset.
  """
  @spec new :: t
  def new, do: %__MODULE__{}

  @doc """
  Returns a dataset from a map, keyword list or dataset.

  If a dataset is provided it will be returned as-is.
  """
  @spec new(keyword | map | t) :: t
  def new(%Justify.Dataset{} = dataset) do
    dataset
  end

  def new(data) do
    if Keyword.keyword?(data) || is_map(data) do
      %__MODULE__{ data: data }
    else
      raise ArgumentError, "Justify.Dataset.new/1 expects a keyword list or a map, got: #{inspect(data)}"
    end
  end
end
