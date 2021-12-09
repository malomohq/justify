defmodule Justify.Validators.Confirmation do
  @moduledoc false

  alias Justify.{ Dataset, Error, Validators }

  @default_message "does not match"

  def call(dataset, field, opts \\ []) do
    Justify.validate(dataset, field, opts, &validator/4)
  end

  def call!(dataset, field, opts \\ []) do
    Justify.validate!(dataset, field, opts, &validator/4)
  end

  def validator(field, value, opts, dataset) do
    default_confirmation_field = String.to_atom("#{Atom.to_string(field)}_confirmation")

    confirmation_field = Keyword.get(opts, :confirmation_field, default_confirmation_field)

    case Dataset.fetch_field(dataset, confirmation_field) do
      { :ok, ^value } ->
        nil
      { :ok, _does_not_match } ->
        Error.new(field, opts[:message] || @default_message, validation: :confirmation)
      :error ->
        if Keyword.get(opts, :required?, false) do
          confirmation_value = Dataset.get_field(dataset, confirmation_field)

          Validators.Required.validator(confirmation_field, confirmation_value, [], dataset)
        else
          nil
        end
    end
  end
end
