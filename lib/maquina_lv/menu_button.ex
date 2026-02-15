defmodule MaquinaLv.MenuButton do
  @moduledoc """
  Menu button component for sidebar-style menus with toggle and click-outside behavior.

  ## Usage

      <.menu_button title="My Account" subtitle="admin@example.com" submenu={true}>
        <div data-menu-button-part="content" class="hidden">
          <a href="/profile">Profile</a>
          <a href="/logout">Sign out</a>
        </div>
      </.menu_button>
  """

  use Phoenix.Component

  import MaquinaLv.Icon

  @doc """
  Renders a menu button with optional submenu content.

  ## Attributes

    * `title` (required) - Button title text.
    * `subtitle` - Optional subtitle text.
    * `icon` - Image URL for the icon.
    * `text_icon` - Text content for a text-based icon.
    * `icon_classes` - CSS classes for the icon container.
    * `submenu` - Whether to show a chevron indicating a submenu. Defaults to `false`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Submenu content.
  """
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :icon, :string, default: nil
  attr :text_icon, :string, default: nil
  attr :icon_classes, :string, default: nil
  attr :submenu, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def menu_button(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "menu-button-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <ul class="flex w-full min-w-0 flex-col gap-1">
      <li
        id={@hook_id}
        phx-hook="MaquinaMenuButton"
        class={["group/menu-item relative", @class]}
        {@rest}
      >
        <button
          type="button"
          data-state="closed"
          data-menu-button-part="button"
          class="peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left outline-none transition-colors hover:bg-sidebar-accent hover:text-sidebar-accent-foreground h-12 text-sm [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0"
        >
          <%= if @icon do %>
            <img src={@icon} alt="" class={@icon_classes} />
          <% end %>
          <%= if @text_icon do %>
            <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
              <span class={@icon_classes}>{@text_icon}</span>
            </div>
          <% end %>
          <div class="grid flex-1 text-left text-sm leading-tight">
            <span class="truncate font-semibold">{@title}</span>
            <%= if @subtitle do %>
              <span class="truncate text-xs">{@subtitle}</span>
            <% end %>
          </div>
          <%= if @submenu do %>
            <.icon name={:chevron_up_down} class="ml-auto" />
          <% end %>
        </button>
        {render_slot(@inner_block)}
      </li>
    </ul>
    """
  end
end
