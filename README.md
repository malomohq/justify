# Justify

Simple data validation for Elixir maps and structs. No schemas. Just
functions.

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
validationset = %{name: nil} |> validate_required(:name)

validationset.valid? # => false
```

### Retrieving errors

```elixir
validationset = %{name: nil} |> validate_required(:name)

validationset.errors # => [name: {"can't be blank", validation: :required}]
```

## Supported Validations

* `validate_acceptance/3`
* `validate_confirmation/3`
* `validate_exclusion/4`
* `validate_format/4`
* `validate_inclusion/4`
* `validate_length/3`
* `validate_required/3`
