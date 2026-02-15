defmodule MaquinaLv.Sidebar do
  @moduledoc """
  Sidebar component with responsive behavior, cookie persistence, and keyboard shortcut.

  ## Usage

      <.sidebar_provider>
        <.sidebar>
          <.sidebar_header>
            <.sidebar_trigger />
          </.sidebar_header>
          <.sidebar_content>
            <.sidebar_group title="Navigation">
              <.sidebar_menu>
                <.sidebar_menu_item>
                  <.sidebar_menu_button title="Dashboard" url="/" icon_name={:home} active />
                </.sidebar_menu_item>
              </.sidebar_menu>
            </.sidebar_group>
          </.sidebar_content>
          <.sidebar_footer>
            Footer content
          </.sidebar_footer>
        </.sidebar>
        <.sidebar_inset>
          Main content
        </.sidebar_inset>
      </.sidebar_provider>
  """

  use Phoenix.Component

  import MaquinaLv.Icon, only: [icon: 1]

  # ── sidebar_provider/1 ─────────────────────────────────────────────

  @doc """
  Renders the sidebar provider (outermost wrapper).

  ## Attributes

    * `default_open` - Whether sidebar starts open. Defaults to `true`.
    * `variant` - Visual variant: `:inset` or `:floating`. Defaults to `:inset`.
    * `cookie_name` - Cookie name for state persistence. Defaults to `"sidebar_state"`.
    * `keyboard_shortcut` - Key for Cmd/Ctrl+key shortcut. Defaults to `"b"`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Sidebar and content.
  """
  attr(:default_open, :boolean, default: true)
  attr(:variant, :atom, default: :inset, values: [:inset, :floating])
  attr(:cookie_name, :string, default: "sidebar_state")
  attr(:keyboard_shortcut, :string, default: "b")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_provider(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "sidebar-provider"
      end)

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaSidebar"
      data-component="sidebar"
      data-variant={@variant}
      data-sidebar-default-open={to_string(@default_open)}
      data-sidebar-open={to_string(@default_open)}
      data-sidebar-cookie-name={@cookie_name}
      data-sidebar-keyboard-shortcut={@keyboard_shortcut}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── sidebar/1 ──────────────────────────────────────────────────────

  @doc """
  Renders the sidebar element.

  ## Attributes

    * `state` - Initial state: `:expanded` or `:collapsed`. Defaults to `:collapsed`.
    * `collapsible` - Collapse mode: `:offcanvas`, `:icon`, `:none`. Defaults to `:offcanvas`.
    * `variant` - Visual variant: `:inset` or `:floating`. Defaults to `:inset`.
    * `side` - Which side: `:left` or `:right`. Defaults to `:left`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Header, content, footer.
  """
  attr(:state, :atom, default: :collapsed, values: [:expanded, :collapsed])
  attr(:collapsible, :atom, default: :offcanvas, values: [:offcanvas, :icon, :none])
  attr(:variant, :atom, default: :inset, values: [:inset, :floating])
  attr(:side, :atom, default: :left, values: [:left, :right])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar(assigns) do
    assigns =
      assign_new(assigns, :sidebar_id, fn ->
        assigns.rest[:id] || "sidebar-#{assigns.side}"
      end)

    ~H"""
    <aside
      id={@sidebar_id}
      data-sidebar-part="root"
      data-state={@state}
      data-variant={@variant}
      data-collapsible={@collapsible}
      data-side={@side}
      class={["group peer sidebar-loading", @class]}
      {@rest}
    >
      <div id={"#{@sidebar_id}-gap"} data-sidebar-part="gap" />

      <div
        id={"#{@sidebar_id}-overlay"}
        data-sidebar-part="backdrop"
        data-state="hidden"
        class="hidden"
      />

      <div id={"#{@sidebar_id}-container"} data-sidebar-part="container">
        <div id={"#{@sidebar_id}-inner"} data-sidebar-part="inner">
          {render_slot(@inner_block)}
        </div>
      </div>
    </aside>
    """
  end

  # ── sidebar_header/1 ───────────────────────────────────────────────

  @doc """
  Renders the sidebar header section.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_header(assigns) do
    ~H"""
    <div data-sidebar-part="header" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── sidebar_content/1 ──────────────────────────────────────────────

  @doc """
  Renders the sidebar scrollable content area.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_content(assigns) do
    ~H"""
    <div data-sidebar-part="content" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── sidebar_footer/1 ───────────────────────────────────────────────

  @doc """
  Renders the sidebar footer section.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_footer(assigns) do
    ~H"""
    <div data-sidebar-part="footer" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── sidebar_group/1 ────────────────────────────────────────────────

  @doc """
  Renders a sidebar group with optional title.

  ## Attributes

    * `title` - Optional group title.
    * `class` - Additional CSS classes.

  ## Slots

    * `inner_block` (required) - Menu items.
  """
  attr(:title, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_group(assigns) do
    ~H"""
    <div data-sidebar-part="group" class={@class} {@rest}>
      <div :if={@title} data-sidebar-part="group-label">{@title}</div>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── sidebar_menu/1 ────────────────────────────────────────────────

  @doc """
  Renders the sidebar menu list.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_menu(assigns) do
    ~H"""
    <ul data-sidebar-part="menu" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  # ── sidebar_menu_item/1 ───────────────────────────────────────────

  @doc """
  Renders a sidebar menu item container.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_menu_item(assigns) do
    ~H"""
    <li data-sidebar-part="menu-item" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  # ── sidebar_menu_button/1 ─────────────────────────────────────────

  @doc """
  Renders a sidebar menu button (link with icon and text).

  ## Attributes

    * `title` - Button text.
    * `url` - Navigation URL.
    * `icon_name` - Icon atom name.
    * `size` - Size variant: `:default`, `:sm`, `:lg`. Defaults to `:default`.
    * `active` - Whether this item is currently active.
    * `class` - Additional CSS classes.
  """
  attr(:title, :string, required: true)
  attr(:url, :string, default: "#")
  attr(:icon_name, :atom, default: nil)
  attr(:size, :atom, default: :default, values: [:default, :sm, :lg])
  attr(:active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def sidebar_menu_button(assigns) do
    ~H"""
    <a
      href={@url}
      data-sidebar-part="menu-button"
      data-size={@size}
      data-active={to_string(@active)}
      class={@class}
      {@rest}
    >
      <.icon :if={@icon_name} name={@icon_name} class="size-4" />
      <span>{@title}</span>
    </a>
    """
  end

  # ── sidebar_menu_link/1 ───────────────────────────────────────────

  @doc """
  Renders a sidebar menu link with avatar-style layout.

  ## Attributes

    * `title` - Primary text.
    * `subtitle` - Secondary text.
    * `url` - Navigation URL.
    * `icon` - Icon atom name for avatar.
    * `text_icon` - Text to show in avatar (e.g. initials).
    * `active` - Whether this item is currently active.
    * `class` - Additional CSS classes.
  """
  attr(:title, :string, required: true)
  attr(:subtitle, :string, default: nil)
  attr(:url, :string, default: "#")
  attr(:icon, :atom, default: nil)
  attr(:text_icon, :string, default: nil)
  attr(:active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def sidebar_menu_link(assigns) do
    ~H"""
    <a
      href={@url}
      data-sidebar-part="menu-link"
      data-active={to_string(@active)}
      class={@class}
      {@rest}
    >
      <div :if={@icon || @text_icon} data-sidebar-part="menu-avatar">
        <.icon :if={@icon} name={@icon} class="size-4" />
        <span :if={@text_icon && !@icon}>{@text_icon}</span>
      </div>
      <div class="flex flex-col gap-0.5 leading-none">
        <span class="truncate font-semibold">{@title}</span>
        <span :if={@subtitle} class="truncate text-xs">{@subtitle}</span>
      </div>
    </a>
    """
  end

  # ── sidebar_trigger/1 ─────────────────────────────────────────────

  @doc """
  Renders a sidebar trigger button that toggles the sidebar.

  ## Attributes

    * `icon_name` - Icon to display. Defaults to `:left_panel`.
    * `class` - Additional CSS classes.
  """
  attr(:icon_name, :atom, default: :left_panel)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def sidebar_trigger(assigns) do
    ~H"""
    <button
      type="button"
      data-sidebar-part="trigger"
      data-sidebar-action="toggle"
      class={@class}
      {@rest}
    >
      <.icon name={@icon_name} />
      <span class="sr-only">Toggle Sidebar</span>
    </button>
    """
  end

  # ── sidebar_inset/1 ───────────────────────────────────────────────

  @doc """
  Renders the main content area adjacent to the sidebar.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def sidebar_inset(assigns) do
    ~H"""
    <main data-sidebar-part="inset" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </main>
    """
  end

  # ── sidebar_state/1 ───────────────────────────────────────────────

  @doc """
  Reads the sidebar state from a Phoenix connection's cookies.

  Returns `:expanded` if the cookie value is `"true"`, `:collapsed` otherwise.
  Defaults to `:expanded` if no cookie exists.

  ## Examples

      sidebar_state(conn)
      sidebar_state(conn, "custom_cookie")
  """
  def sidebar_state(conn, cookie_name \\ "sidebar_state") do
    case conn.cookies[cookie_name] do
      nil -> :expanded
      "true" -> :expanded
      _ -> :collapsed
    end
  end
end
