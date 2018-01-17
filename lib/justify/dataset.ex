defmodule Justify.Dataset do
  @moduledoc """
  """

  defstruct [ data: nil, errors: [], valid?: true ]

  @type error :: { String.t(), Keyword.t() }

  @type t :: %__MODULE__{
    data: map,
    errors: [{ atom, error }],
    valid?: boolean
  }

  def new(data), do: %__MODULE__{ data: data }
end
