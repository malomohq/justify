defmodule Justify.Dataset do
  defstruct data: %{}, errors: [], valid?: true

  @type error_t :: { String.t(), Keyword.t() }

  @type t :: %__MODULE__{
               data: map,
               errors: [{ atom, error_t }],
               valid?: boolean
             }

  @spec new(map) :: t
  def new(%Justify.Dataset{} = dataset), do: dataset
  def new(data), do: %__MODULE__{ data: data }
end
