defmodule ReviewAppWeb.HomeLive do
  use ReviewAppWeb, :live_view

  alias ReviewAppWeb.Components.Navigation.AppBar

  def mount(_params, assigns, socket) do
    socket = socket |> assign(:auth, Map.get(assigns, "current_user", nil))

    {:ok, socket}
  end
end
