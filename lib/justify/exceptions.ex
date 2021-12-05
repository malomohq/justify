defmodule Justify.NoDatasetError do
  @moduledoc """
  Raised when a function is expected to return a `Justify.Dataset` struct but
  does not.
  """
  
  defexception [:message]
end
