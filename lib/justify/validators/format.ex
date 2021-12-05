defmodule Justify.Validators.Format do
  @moduledoc false

  alias Justify.{ Dataset }

  @default_message "has invalid format"

  def call(dataset, field, format, opts \\ []) do
    dataset = Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    if value == nil || value == "" || value =~ format do
      dataset
    else
      Dataset.add_error(dataset, field, message, validation: :format)
    end
  end
end
