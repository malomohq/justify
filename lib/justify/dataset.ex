defmodule Justify.Dataset do
  @moduledoc """
  Datasets track validations on unstructured data.
  """

  alias Justify.{ Error }

  defstruct data: %{}, errors: [], valid?: true

  @type error_t :: { String.t(), keyword }

  @type t :: %__MODULE__{
               data: keyword | map,
               errors: [{ atom, error_t }],
               valid?: boolean
             }

  @doc """
  Adds an error to the dataset from a `Justify.Error` struct.
  """
  @spec add_error(t, Error.t()) :: t
  def add_error(dataset, error) do
    add_error(dataset, error.field, error.message, error.opts)
  end

  @doc """
  Adds a list of `Justify.Error` structs to the dataset.
  """
  @spec add_errors(t, [Error.t()]) :: t
  def add_errors(dataset, errors) do
    Enum.reduce(errors, dataset, fn
      (%Error{} = error, acc) ->
        add_error(acc, error)
      (result, _acc) ->
        message = "expected a Justify.Error struct, got: #{inspect(result)}"

        raise Justify.BadStructError, message
    end)
  end

  @doc """
  Adds an error to the dataset.

  An optional keyword list can be used to provide additional contextual
  information about the error.
  """
  @spec add_error(t, Justify.field_t(), String.t(), keyword) :: t
  def add_error(dataset, field, message, keys \\ []) do
    Justify.put_error(dataset, field, { message, keys })
  end


  @doc """
  Fetches the value for a field.

  If a dataset contains the given field then its value is returned in the shape
  `{:ok, value}`. If the dataset doesn't contain the field `:error` is returned.
  """
  @spec fetch_field(t, Justify.field_t()) :: { :ok, Justify.value_t() } | :error
  def fetch_field(dataset, field) do
    data = dataset.data

    cond do
      Keyword.keyword?(data) ->
        Keyword.fetch(data, field)
      is_map(data) ->
        Map.fetch(data, field)
    end
  end

  @doc """
  Gets the value for a field.
  """
  @spec get_field(t, Justify.field_t(), Justify.value_t()) :: any
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
  @spec new(Justify.data_t()) :: t
  def new(%__MODULE__{} = dataset) do
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
