defmodule Justify.Validators.Acceptance do
  @moduledoc false

  alias Justify.{ Error }

  @default_message "must be accepted"

  def call(data, field, opts \\ []) do
    Justify.validate(data, field, opts, &validator/4)
  end

  def call!(data, field, opts \\ []) do
    Justify.validate!(data, field, opts, &validator/4)
  end

  defp validator(field, value, opts, _dataset) do
    if value not in [true, nil] do
      Error.new(field, opts[:message] || @default_message, validation: :acceptance)
    end
  end
end
