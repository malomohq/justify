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

  @doc """
  Validates the value of a given field matches it's confirmation field.

  By default, the field will be checked against a field with the same name
  but appended with `_confirmation`. It’s possible to provide a custom field by
  providing a value to the `:confirmation_field` option.

  Note that if the confirmation field is `nil` or missing, by default, an error
  will not be added. You can specify that the confirmation field is required in
  the options (see below).

  ## Options

  * `:confirmation_field` - name of the field to validate against
  * `:message` - error message, defaults to "does not match"
  * `:required?` - whether the confirmation field must contain a value
  """
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
  Validates the value of the given field is not contained within the provided
  enumerable.

  ## Options

  * `:message` - error message, defaults to "is reserved"
  """
  @spec validate_exclusion(map, atom, Enum.t(), Keyword.t()) :: Justify.Dataset.t()
  defdelegate validate_exclusion(dataset, field, enum, opts \\ []),
    to: Justify.Validators.Exclusion,
    as: :call

  @doc """
  Validates the value of the given field matches the provided format.

  ## Options

  * `:message` - error message, defaults to "has invalid format"
  """
  @spec validate_format(map, atom, Regex.t(), Keyword.t()) :: Justify.Dataset.t()
  defdelegate validate_format(dataset, field, format, opts \\ []),
    to: Justify.Validators.Format,
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
