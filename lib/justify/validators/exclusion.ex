defmodule Justify.Validators.Exclusion do
  @moduledoc false

  alias Justify.{ Error }

  @default_message "is reserved"

  def call(dataset, field, enum, opts \\ []) do
    Justify.validate(dataset, field, opts ++ [enum: enum], &validator/4)
  end

  def call!(dataset, field, enum, opts \\ []) do
    Justify.validate!(dataset, field, opts ++ [enum: enum], &validator/4)
  end

  def validator(field, value, opts, _dataset) do
    enum = Keyword.fetch!(opts, :enum)

    message = opts[:message] || @default_message

    if value in enum do
      Error.new(field, message, validation: :exclusion, enum: enum)
    end
  end
end
