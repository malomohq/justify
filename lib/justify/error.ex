defmodule Justify.Error do
  @moduledoc """
  Struct for capturing validation errors.
  """

  defstruct [:field, :message, :opts]

  @type raise_opts_t ::
          [raise: (t -> no_return)]

  @type t ::
          %__MODULE__{
            field: any,
            message: String.t(),
            opts: Keyword.t()
          }

  @doc """
  Returns a new error.
  """
  @spec new(any, String.t(), Keyword.t()) :: t
  def new(field, message, opts \\ []) do
    %__MODULE__{}
    |> Map.put(:field, field)
    |> Map.put(:message, message)
    |> Map.put(:opts, opts)
  end

  @doc """
  Raises a `Justify.ValidationError` exception based on the provided error.

  To raise an exception other than `Justify.ValidationError` you can provide
  a function to the `:raise` option that will become responsible for raising the
  exception.

  ## Example raising a `Justify.ValidationError` exception

      error = Justify.Error.new(:email, "must be valid")

      Justify.Error.raise!(error)

  ## Example raising a custom exception

      error = Justify.Error.new(:email, "must be valid")

      Justify.Error.raise!(error, raise: fn
        (error) ->
          raise ArgumentError, "expected \#{inspect(error.field)} to be a valid email address"
      end)
  """
  @spec raise!(t, raise_opts_t) :: no_return
  defmacro raise!(error, opts \\ []) do
    quote do
      raise_fn = Keyword.get(unquote(opts), :raise)

      if raise_fn do
        raise_fn.(unquote(error))
      else
        raise Justify.ValidationError, error: unquote(error)
      end
    end
  end
end
