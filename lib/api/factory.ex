defmodule ReviewApp.Factory do
  alias ReviewApp.Repo
  alias ReviewApp.Models.User

  defp build(:user), do: %User{}

  def make(model, attributes \\ []) do
    model |> build() |> struct!(attributes)
  end

  def create!(model, attributes \\ []) do
    model |> make(attributes) |> Repo.insert!()
  end
end
