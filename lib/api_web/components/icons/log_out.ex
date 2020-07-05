defmodule ReviewAppWeb.Components.Icons.LogOutIcon do
  use ReviewAppWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, :class, "")}
  end

  def render(assigns) do
    ~L"""
    <svg xmlns="http://www.w3.org/2000/svg" class="fill-current <%= assigns.class %>" viewBox="0 0 20 20">
      <path d="M19 10l-6-5v3H6v4h7v3l6-5zM3 3h8V1H3c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H3V3z"/>
    </svg>
    """
  end
end
