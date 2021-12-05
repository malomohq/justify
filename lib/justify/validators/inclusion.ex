defmodule Justify.Validators.Inclusion do
  @moduledoc false

  alias Justify.{ Dataset }

  @default_message "is invalid"

  def call(dataset, field, enum, opts \\ []) do
    dataset = Dataset.new(dataset)

    value = Dataset.get_field(dataset, field)

    message = Keyword.get(opts, :message, @default_message)

    if value == nil || value == "" || value in enum do
      dataset
    else
      Dataset.add_error(dataset, field, message, validation: :inclusion, enum: enum)
    end
  end
end
