# Justify

Justify is a data validation library for Elixir.

The primary philosophy behind Justify is that it should be easy to validate
data without schemas or types. All of Justify's validation functions will
happily accept a plain ol' map.

```elixir
iex> %{email: "madebyanthony"}
...> |> Justify.validate_required(:email)
...> |> Justify.validate_format(:email, ~r/\S+@\S+/)
%Justify.Dataset{errors: [email: {"has invalid format", validation: :format}], valid?: false}
```

Pretty simple. Not much more to it than that.

## Supported Validations

* [`validate_acceptance/3`](https://hexdocs.pm/justify/Justify.html#validate_acceptance/3)
* [`validate_confirmation/3`](https://hexdocs.pm/justify/Justify.html#validate_confirmation/3)
* [`validate_embed/3`](https://hexdocs.pm/justify/Justify.html#validate_embed/3)
* [`validate_exclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_exclusion/4)
* [`validate_format/4`](https://hexdocs.pm/justify/Justify.html#validate_format/4)
* [`validate_inclusion/4`](https://hexdocs.pm/justify/Justify.html#validate_inclusion/4)
* [`validate_length/3`](https://hexdocs.pm/justify/Justify.html#validate_length/3)
* [`validate_required/3`](https://hexdocs.pm/justify/Justify.html#validate_required/3)
