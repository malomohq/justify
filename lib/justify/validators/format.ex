defmodule Justify.Validators.Format do
  @moduledoc false

  @default_message "has invalid format"

  def call(dataset, field, format, opts \\ []) do
    dataset = Justify.Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    if value == nil || value == "" || value =~ format do
      dataset
    else
      Justify.add_error(dataset, field, message, validation: :format)
    end
  end
end
