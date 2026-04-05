# elixir-phoenix-metamodel

A [Phoenix](https://phoenixframework.org/) web application integrated with [MetaDsl](https://github.com/diasbruno/metamodel) for meta-model driven development.

## Requirements

- [Nix](https://nixos.org/) (for reproducible development environment)
- PostgreSQL

## Development Setup

### With Nix

```sh
nix develop
mix setup
```

### Without Nix

- Elixir ~> 1.18
- Erlang/OTP 27
- Node.js (for asset compilation)

```sh
mix setup
```

## Running

```sh
mix phx.server
```

Visit [`localhost:4000`](http://localhost:4000) from your browser.

## About MetaDsl

[MetaDsl](https://github.com/diasbruno/metamodel) is a DSL for defining generator-agnostic meta-types and deriving new types from existing ones.

Define a schema:

```elixir
defmodule MyApp.Schema do
  use MetaDsl

  meta_type :user do
    property :id,    :uuid,   required: true
    property :name,  :string, required: true
    property :email, :string, required: true
  end

  subtype :create_user, from: :user, except: [:id]
  subtype :public_user, from: :user, only:   [:id, :name]
end
```

## License

This project is released into the public domain under the [Unlicense](https://unlicense.org).