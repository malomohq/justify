defmodule Justify.Validators.Format do
  @moduledoc false

  alias Justify.{ Error }

  @default_message "has invalid format"

  def call(dataset, field, format, opts \\ []) do
    Justify.validate(dataset, field, opts ++ [format: format], &validator/4)
  end

  def call!(dataset, field, format, opts \\ []) do
    Justify.validate!(dataset, field, opts ++ [format: format], &validator/4)
  end

  def validator(field, value, opts, _dataset) do
    format = Keyword.fetch!(opts, :format)

    unless skip?(value, format) do
      Error.new(field, opts[:message] || @default_message, validation: :format)
    end
  end

  defp skip?(nil, _format) do
    true
  end

  defp skip?("", _format) do
    true
  end

  defp skip?(value, _format) when not is_binary(value) do
    true
  end

  defp skip?(value, format) do
    value =~ format
  end
end
