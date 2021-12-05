defmodule Justify.Error do
  @moduledoc """
  Struct for capturing validation errors.
  """

  defstruct [:field, :message, :opts]

  @type t ::
          %__MODULE__{
            field: any,
            message: String.t(),
            opts: Keyword.t()
          }

  @doc """
  Returns a new error.
  """
  @spec new(any, String.t(), Keyword.t()) :: t
  def new(field, message, opts \\ []) do
    %__MODULE__{}
    |> Map.put(:field, field)
    |> Map.put(:message, message)
    |> Map.put(:opts, opts)
  end
end
