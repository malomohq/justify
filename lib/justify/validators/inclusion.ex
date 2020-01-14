defmodule Justify.Validators.Inclusion do
  @moduledoc false

  @default_message "is invalid"

  def call(dataset, field, enum, opts \\ []) do
    dataset = Justify.Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    if value == nil || value == "" || value in enum do
      dataset
    else
      Justify.add_error(dataset, field, message, validation: :inclusion, enum: enum)
    end
  end
end
