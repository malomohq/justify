defmodule Justify.Validators.Confirmation do
  @moduledoc false

  @default_message "does not match"

  def call(dataset, field, opts \\ []) do
    dataset = Justify.Dataset.new(dataset)

    default_confirmation_field = String.to_atom("#{Atom.to_string(field)}_confirmation")

    confirmation_field = Keyword.get(opts, :confirmation_field, default_confirmation_field)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    case Map.fetch(dataset.data, confirmation_field) do
      { :ok, ^value } ->
        dataset
      { :ok, _does_not_match } ->
        Justify.add_error(dataset, field, message, validation: :confirmation)
      :error ->
        if Keyword.get(opts, :required?, false) do
          Justify.validate_required(dataset, confirmation_field)
        else
          dataset
        end
    end
  end
end
