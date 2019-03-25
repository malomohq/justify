defmodule Justify.Dataset do
  defstruct data: nil, errors: [], valid?: true

  @type error :: { String.t(), Keyword.t() }

  @type t :: %__MODULE__{
               data: map,
               errors: [{ atom, error }],
               valid?: boolean
             }

  @spec new(map) :: t
  def new(data), do: %__MODULE__{ data: data }
end
