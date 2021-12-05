defmodule Justify.BadStructError do
  @moduledoc """
  Raised at runtime when a function is expected to return a `Justify.Dataset`
  struct but does not.
  """

  defexception [:message]
end

defmodule Justify.ValidationError do
  @moduledoc """
  Raised at runtime when a validation error occurs.
  """

  defexception [:message]

  @spec message(any, String.t()) :: String.t()
  def message(field, message) do
    "#{inspect(field)} failed validation with message #{inspect(message)}"
  end

  @impl true
  def exception(opts) do
    error = Keyword.fetch!(opts, :error)

    %__MODULE__{ message: message(error.field, error.message) }
  end
end
