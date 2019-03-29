defmodule Justify.Validators.Exclusion do
  @moduledoc false

  @default_message "is reserved"

  def call(dataset, field, enum, opts \\ []) do
    dataset = Justify.Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    if value in enum do
      Justify.add_error(dataset, field, message, validation: :exclusion)
    else
      dataset
    end
  end
end
