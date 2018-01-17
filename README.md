# Justify

Simple data validation for Elixir. No schemas. Just functions.

## Inspired By

* [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-validations-and-constraints)
* [Vex](https://github.com/CargoSense/vex)

## Installation

```elixir
def deps do
  [
    {:justify, "~> 0.1.0"}
  ]
end
```

## Usage

### Checking for validity

```elixir
dataset = %{name: nil} |> validate_required(:name)

dataset.valid? # => false
```

### Retrieving errors

```elixir
dataset = %{name: nil} |> validate_required(:name)

dataset.errors # => [name: {"can't be blank", validation: :required}]
```

## Supported Validations

* `validate_acceptance/3`
* `validate_confirmation/3`
* `validate_exclusion/4`
* `validate_format/4`
* `validate_inclusion/4`
* `validate_length/3`
* `validate_required/3`
