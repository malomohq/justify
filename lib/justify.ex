defmodule Justify do
  @moduledoc """
  Justify makes it easy to validate unstructured data.

  Inspired heavily by [Ecto.Changeset][1], Justify allows you to pipe a plain map
  into a series of validation functions using a simple and familiar API. No
  schemas or casting required.

  [1]: https://hexdocs.pm/ecto/Ecto.Changeset.html

  ### Example

  ```elixir
  dataset =
    %{email: "madebyanthony"}
    |> Justify.validate_required(:email)
    |> Justify.validate_format(:email, ~r/\S+@\S+/)

  dataset.errors #=> [email: {"has invalid format", validation: :format}]
  dataset.valid? #=> false
  ```

  Each validation function will return a `Justify.Dataset` struct which can be
  passed into the next function. If a validation error is encountered the dataset
  will be marked as invalid and an error will be added to the struct.

  ## Custom Validations

  You can provide your own custom validations using the
  `Justify.Dataset.add_error/4` function.

  ### Example

  ```elixir
  defmodule MyValidator do
    def validate_color(data, field, color) do
      dataset = Justify.Dataset.new(data)

      value = Justify.Dataset.get_field(dataset, :field)

      if value == color do
        dataset
      else
        Justify.Dataset.add_error(dataset, field, "wrong color", validation: :color)
      end
    end
  end
  ```

  Your custom validation can be used as part of a validation pipeline.

  ### Example

  ```elixir
  dataset =
    %{color: "brown"}
    |> Justify.validation_required(:color)
    |> MyValidator.validate_color(:color, "green")

  dataset.errors #=> [color: {"wrong color", validation: :color}]
  dataset.valid? #=> false
  ```

  ## Supported Validations

  * [`validate_acceptance/3`](https://hexdocs.pm/justify/Justify.html#validate_acceptance/3)
  * [`validate_confirmation/3`](https://hexdocs.pm/justify/Justify.html#validate_confirmation/3)
  * [`validate_embed/3`](https://hexdocs.pm/justify/Justify.html#validate_embed/3)
  * [`validate_exclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_exclusion/4)
  * [`validate_format/4`](https://hexdocs.pm/justify/Justify.html#validate_format/4)
  * [`validate_inclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_inclusion/4)
  * [`validate_length/3`](https://hexdocs.pm/justify/Justify.html#validate_length/3)
  * [`validate_required/3`](https://hexdocs.pm/justify/Justify.html#validate_required/3)
  * [`validate_type/4`](https://hexdocs.pm/justify/Justify.html#validate_type/4)
  """

  alias Justify.{ Error, Dataset }

  require Justify.Error

  @type data_t ::
          keyword | map | Dataset.t()

  @type field_t ::
          atom | String.t() | [field_t]

  @type type_t ::
          :boolean
          | :float
          | :integer
          | :non_neg_integer
          | :pos_integer
          | :string

  @type validator_t ::
          (
            field_t,
            value_t,
            keyword,
            Dataset.t() -> nil | Error.t() | [Error.t()]
          )

  @type value_t ::
          any

  @doc """
  Validate the given field using a custom validator.

  The provided validator function is expected to return `nil` if the validation
  was successful or a `Justify.Error` struct if the validation failed.

  ## Example

      dataset =
        Justify.validate(%{name: "Voldermort"}, :name, fn
          (field, value, opts, _dataset) ->
            if value == "Voldermort" do
              Justify.Error.new(field, "is forbidden", validation: :name)
            end
        end)

      dataset.errors #=> [name: {"is forbidden", validation: :name}]
      dataset.valid? #=> false

  A validator can expect to receive only one field. If a list of fields is
  provided the validator will be called for each individual field.
  """
  @spec validate(data_t, field_t, keyword, validator_t) :: Dataset.t()
  def validate(data, field, opts \\ [], validator)

  def validate(data, fields, opts, validator) when is_list(fields) do
    dataset = Dataset.new(data)

    Enum.reduce(fields, dataset, fn
      (field, acc) ->
        validate(acc, field, opts, validator)
    end)
  end

  def validate(data, field, opts, validator) do
    dataset = Dataset.new(data)

    value = Dataset.get_field(dataset, field)

    case validator.(field, value, opts, dataset) do
      nil ->
        dataset
      %Dataset{} = result ->
        result
      %Error{} = error ->
        Dataset.add_error(dataset, error)
      result ->
        message =
          "validate/4 expects the provided validator to return nil or " <>
          "a Justify.Error struct, got: #{inspect(result)}"

        raise Justify.BadStructError, message
    end
  end

  @doc """
  Similar to `validate/4` but raises `Justify.ValidationError` if the provided
  validator returns a `Justify.Error` struct.

  ## Options
  * `:raise` - a function to raise an exception other than
    `Justify.ValidationError`. A `Justify.Error` struct is passed as the only
    argument.
  """
  @spec validate!(data_t, field_t, keyword, validator_t) :: Dataset.t()
  def validate!(data, field, opts \\ [], validator)

  def validate!(data, fields, opts, validator) when is_list(fields) do
    dataset = Dataset.new(data)

    Enum.reduce(fields, dataset, fn
      (field, acc) ->
        validate!(acc, field, opts, validator)
    end)
  end

  def validate!(data, field, opts, validator) do
    dataset = Dataset.new(data)

    value = Dataset.get_field(dataset, field)

    case validator.(field, value, opts, dataset) do
      nil ->
        dataset
      %Dataset{} = result ->
        result
      %Error{} = error ->
        Error.raise!(error)
      result ->
        message =
          "validate/4 expects the provided validator to return nil or " <>
          "a Justify.Error struct, got: #{inspect(result)}"

        raise Justify.BadStructError, message
    end
  end

  @doc """
  Validates the given field has a value of `true`.

  ## Options

  * `:message` - error message, defaults to "must be accepted"
  """
  @spec validate_acceptance(data_t, field_t, keyword) :: Dataset.t()
  defdelegate validate_acceptance(data, field, opts \\ []),
    to: Justify.Validators.Acceptance,
    as: :call

    @doc """
    Similar to `validate_acceptance/3` but raises `Justify.ValidationError` if
    validation fails.
    """
  @spec validate_acceptance!(data_t, field_t, keyword) :: Dataset.t() | no_return
  defdelegate validate_acceptance!(data, field, opts \\ []),
    to: Justify.Validators.Acceptance,
    as: :call!

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
  @spec validate_confirmation(data_t, field_t, keyword) :: Dataset.t()
  defdelegate validate_confirmation(data, field, opts \\ []),
    to: Justify.Validators.Confirmation,
    as: :call

  @doc """
  Similar to `validate_confirmation/3` but raises `Justify.ValidationError` if
  validation fails.
  """
  defdelegate validate_confirmation!(data, field, opts \\ []),
    to: Justify.Validators.Confirmation,
    as: :call!

  @doc """
  Applies a validator function to a field containing an embedded value.

  An embedded value can be either a map or a list of maps.

  ## Example

      validator = fn(metadata) -> Justify.validate_required(metadata, :key) end

      data = %{metadata: [%{value: "a value"}]}

      validate_embed(data, :metadata, validator)
      #> %Justify.Dataset{errors: [metadata: [[key: {"can't be blank", validation: :required}]]], valid?: false}
  """
  @spec validate_embed(data_t, field_t, fun) :: Dataset.t()
  defdelegate validate_embed(data, field, validator),
    to: Justify.Validators.Embed,
    as: :call

  @doc """
  Validates the value for the given field is not contained within the provided
  enumerable.

  ## Options

  * `:message` - error message, defaults to "is reserved"
  """
  @spec validate_exclusion(data_t, field_t, Enum.t(), keyword) :: Dataset.t()
  defdelegate validate_exclusion(data, field, enum, opts \\ []),
    to: Justify.Validators.Exclusion,
    as: :call

  @doc """
  Similar to `validate_exclusion/4` but raises `Justify.ValidationError` if
  validation fails.
  """
  @spec validate_exclusion!(data_t, field_t, Enum.t(), keyword) :: Dataset.t()
  defdelegate validate_exclusion!(data, field, enum, opts \\ []),
    to: Justify.Validators.Exclusion,
    as: :call!

  @doc """
  Validates the value of the given field matches the provided format.

  ## Options

  * `:message` - error message, defaults to "has invalid format"
  """
  @spec validate_format(data_t, field_t, Regex.t(), keyword) :: Dataset.t()
  defdelegate validate_format(data, field, format, opts \\ []),
    to: Justify.Validators.Format,
    as: :call

  @doc """
  Similar to `validate_format/4` but raises `Justify.ValidationError` if
  validation fails.
  """
  @spec validate_format!(data_t, field_t, Regex.t(), keyword) :: Dataset.t()
  defdelegate validate_format!(data, field, format, opts \\ []),
    to: Justify.Validators.Format,
    as: :call!

  @doc """
  Validates the value for the given field is contained within the provided
  enumerable.

  ## Options

  * `:message` - error message, defaults to "is invalid"
  """
  @spec validate_inclusion(data_t, field_t, Enum.t(), keyword) :: Dataset.t()
  defdelegate validate_inclusion(data, field, enum, opts \\ []),
    to: Justify.Validators.Inclusion,
    as: :call

  @doc """
  Validates the length of a string or list.

  ## Options

  * `:count` - how to calculate the length of a string. Must be one of
               `:codepoints`, `:graphemes` or `:bytes`. Defaults to
               `:graphemes`.
  * `:is` - the exact length match
  * `:min` - match a length greater than or equal to
  * `:max` - match a length less than or equal to
  * `:message` - error message, defaults to one of the following variants:
    * for strings
      * “should be %{count} character(s)”
      * “should be at least %{count} character(s)”
      * “should be at most %{count} character(s)”
    * for binary
      * “should be %{count} byte(s)”
      * “should be at least %{count} byte(s)”
      * “should be at most %{count} byte(s)”
    * for lists
      * “should have %{count} item(s)”
      * “should have at least %{count} item(s)”
      * “should have at most %{count} item(s)”
  """
  @spec validate_length(data_t, field_t, keyword) :: Dataset.t()
  defdelegate validate_length(data, field, opts),
    to: Justify.Validators.Length,
    as: :call

  @doc """
  Validates that one or more fields has a value.

  ## Options

  * `:message` - error message, defaults to "must be accepted"
  * `:trim?` - remove whitespace before validating, defaults to `true`
  """
  @spec validate_required(data_t, atom | [atom], keyword) :: Dataset.t()
  defdelegate validate_required(data, fields, opts \\ []),
    to: Justify.Validators.Required,
    as: :call

  @doc """
  Similar to `validate_required/3` but raises `Justify.ValidationError` if
  validation fails.
  """
  @spec validate_required!(data_t, atom | [atom], keyword) :: Dataset.t()
  defdelegate validate_required!(data, fields, opts \\ []),
    to: Justify.Validators.Required,
    as: :call!

  @doc """
  Validates that the value of a field is a specific type.

  Supported types:

  * `:boolean`
  * `:float`
  * `:integer`
  * `:non_neg_integer`
  * `:pos_integer`
  * `:string`

  ## Options

  * `:message` - error message, defaults to "has invalid type"
  """
  @spec validate_type(data_t, field_t, type_t, keyword) :: Dataset.t()
  defdelegate validate_type(data, field, type, opts \\ []),
    to: Justify.Validators.Type,
    as: :call

  @doc false
  def put_error(dataset, field, error) do
    errors =
      dataset
      |> Map.get(:errors)
      |> Enum.concat([{ field, error }])

    %{ dataset | errors: errors, valid?: false }
  end
end
