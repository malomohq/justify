defmodule Justify.Validators.Required do
  @moduledoc false

  alias Justify.{ Error }

  require Justify.Error

  @default_message "can't be blank"

  def call(dataset, fields, opts \\ []) do
    Justify.validate(dataset, fields, opts, &validator/4)
  end

  def call!(dataset, fields, opts \\ []) do
    Justify.validate!(dataset, fields, opts, &validator/4)
  end

  def validator(field, value, opts, _dataset) do
    value = maybe_trim_value(value, Keyword.get(opts, :trim?, true))

    if value in [nil, ""] do
      Error.new(field, opts[:message] || @default_message, validation: :required)
    end
  end

  defp maybe_trim_value(nil, _does_not_matter) do
    nil
  end

  defp maybe_trim_value(value, true) when is_binary(value) do
    String.trim(value)
  end

  defp maybe_trim_value(value, _do_not_trim) do
    value
  end
end
