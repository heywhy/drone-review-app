[
  import_deps: [:ecto, :phoenix],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test,mix}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
