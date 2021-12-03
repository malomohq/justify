# Justify

Justify provides the ability to easily validate unstructured data.

Inspired heavily by [Ecto.Changeset][1], Justify allows you to pipe a plain map
into a series of validation functions using a simple and familiar API. No
schemas or casting required.

[1]: https://hexdocs.pm/ecto/Ecto.Changeset.html

### Example

```elixir
dataset =
  %{email: "madebyanthony"}
  |> Justify.validate_required(:email)
  |> Justify.validate_format(:email, ~r/\S+@\S+/)

dataset.errors #=> [email: {"has invalid format", validation: :format}]
dataset.valid? #=> false
```

Each validation function will return a `Justify.Dataset` struct which can be
passed into the next function. If a validation error is encountered the dataset
will be marked as invalid and an error will be added to the struct.

## Custom Validations

You can provide your own custom validations using the `Justify.add_error/4`
function.

### Example

```elixir
defmodule MyValidator do
  def validate_color(data, field, color) do
    dataset = Justify.Dataset.new(data)

    value = Map.get(dataset.data, :field)

    if value == color do
      dataset
    else
      Justify.add_error(dataset, field, "wrong color", validation: :color)
    end
  end
end
```

You can use your custom validation as part of a validation pipeline.

### Example

```elixir
dataset =
  %{color: "brown"}
  |> Justify.validation_required(:color)
  |> MyValidator.validate_color(:color, "green")

dataset.errors #=> [color: {"wrong color", validation: :color}]
dataset.valid? #=> false
```

## Supported Validations

* [`validate_acceptance/3`](https://hexdocs.pm/justify/Justify.html#validate_acceptance/3)
* [`validate_confirmation/3`](https://hexdocs.pm/justify/Justify.html#validate_confirmation/3)
* [`validate_embed/3`](https://hexdocs.pm/justify/Justify.html#validate_embed/3)
* [`validate_exclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_exclusion/4)
* [`validate_format/4`](https://hexdocs.pm/justify/Justify.html#validate_format/4)
* [`validate_inclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_inclusion/4)
* [`validate_length/3`](https://hexdocs.pm/justify/Justify.html#validate_length/3)
* [`validate_required/3`](https://hexdocs.pm/justify/Justify.html#validate_required/3)
* [`validate_type/4`](https://hexdocs.pm/justify/Justify.html#validate_type/4)
