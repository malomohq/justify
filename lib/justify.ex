defmodule Justify do
  @doc """
  Validates the given field has a value of `true`.

  ## Options

  * `:message` - error message, defaults to "must be accepted"
  """
  @spec validate_acceptance(map, atom, Keyword.t()) :: Justify.Dataset.t()
  defdelegate validate_acceptance(dataset, field, opts \\ []),
    to: Justify.Validators.Acceptance,
    as: :call

  @spec validate_confirmation(map, atom, Keyword.t()) :: Justify.Dataset.t()
  defdelegate validate_confirmation(dataset, field, opts \\ []),
    to: Justify.Validators.Confirmation,
    as: :call

  @doc """
  Applies a validator function to a field containing an embedded value.

  An embedded value can be either a map or a list of maps.

  ## Example

      validator = fn(metadata) -> Justify.validate_required(metadata, :key) end

      data = %{metadata: [%{value: "a value"}]}

      validate_embed(data, :metadata, validator)
      #> %Justify.Dataset{errors: [metadata: [[key: {"can't be blank", validation: :required}]]], valid?: false}
  """
  @spec validate_embed(map, atom, fun()) :: Justify.Dataset.t()
  defdelegate validate_embed(dataset, field, validator),
    to: Justify.Validators.Embed,
    as: :call

  @doc """
  Validates that one or more fields has a value.

  ## Options

  * `:message` - error message, defaults to "must be accepted"
  * ':trim?' - remove whitespace before validating, defaults to `true`
  """
  @spec validate_required(map, atom | [atom], Keyword.t()) :: Justify.Dataset.t()
  defdelegate validate_required(dataset, fields, opts \\ []),
    to: Justify.Validators.Required,
    as: :call

  @doc """
  Adds an error to the dataset.

  An optional keyword list can be used to provide additional contextual
  information about the error.
  """
  @spec add_error(Justify.Dataset.t(), atom, String.t(), Keyword.t()) :: Justify.Dataset.t()
  def add_error(dataset, field, message, keys \\ []) do
    put_error(dataset, field, { message, keys })
  end

  @doc false
  def put_error(dataset, field, error) do
    errors =
      dataset
      |> Map.get(:errors)
      |> Enum.concat([{ field, error }])

    %{ dataset | errors: errors, valid?: false }
  end
end
