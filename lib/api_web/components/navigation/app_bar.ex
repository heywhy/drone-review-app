defmodule ReviewAppWeb.Components.Navigation.AppBar do
  use ReviewAppWeb, :live_component

  alias ReviewAppWeb.Components.Icons

  def mount(socket) do
    {:ok, assign(socket, :isAccountMenuOpened, false)}
  end

  def handle_event("account-menu", _args, socket) do
    state = !socket.assigns.isAccountMenuOpened
    {:noreply, assign(socket, :isAccountMenuOpened, state)}
  end

  def handle_event("close:account-menu", _args, socket) do
    {:noreply, assign(socket, :isAccountMenuOpened, false)}
  end
end
