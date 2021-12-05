defmodule Justify.Validators.Acceptance do
  @moduledoc false

  alias Justify.{ Dataset }

  @default_message "must be accepted"

  def call(dataset, field, opts \\ []) do
    dataset = Dataset.new(dataset)

    value = Map.get(dataset.data, field)

    message = Keyword.get(opts, :message, @default_message)

    case value do
      _valid when value in [true, nil] ->
        dataset
      _otherwise ->
        Dataset.add_error(dataset, field, message, validation: :acceptance)
    end
  end
end
