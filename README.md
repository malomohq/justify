# Justify

Provides a simple solution for validating maps and structs. No schemas. Just
functions.

## Inspired By

* [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-validations-and-constraints)

## Installation

```elixir
def deps do
  [
    {:justify, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
%Justify.Validationset{ data: %{ name: "Anthony Smith" } }
|> Justify.Validationset.validate_required()
```
