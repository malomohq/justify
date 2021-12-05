defmodule Justify.Validators.Exclusion do
  @moduledoc false

  alias Justify.{ Dataset }

  @default_message "is reserved"

  def call(dataset, field, enum, opts \\ []) do
    dataset = Dataset.new(dataset)

    value = Dataset.get_field(dataset, field)

    message = Keyword.get(opts, :message, @default_message)

    if value in enum do
      Dataset.add_error(dataset, field, message, validation: :exclusion, enum: enum)
    else
      dataset
    end
  end
end
