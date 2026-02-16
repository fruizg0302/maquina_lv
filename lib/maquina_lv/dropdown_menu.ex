defmodule MaquinaLv.DropdownMenu do
  @moduledoc """
  Dropdown menu component for displaying actions triggered by a button.

  ## Usage

      <.dropdown_menu>
        <.dropdown_menu_trigger>
          Options
        </.dropdown_menu_trigger>
        <.dropdown_menu_content>
          <.dropdown_menu_label text="Actions" />
          <.dropdown_menu_item href="/profile">Profile</.dropdown_menu_item>
          <.dropdown_menu_separator />
          <.dropdown_menu_item href="/delete" variant={:destructive}>Delete</.dropdown_menu_item>
        </.dropdown_menu_content>
      </.dropdown_menu>
  """

  use Phoenix.Component

  @doc """
  Renders the dropdown menu root container.

  ## Attributes

    * `auto_close` - Close menu when an item is clicked. Defaults to `false`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Trigger and content.
  """
  attr(:auto_close, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec dropdown_menu(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "dropdown-menu-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaDropdownMenu"
      data-component="dropdown-menu"
      data-auto-close={@auto_close && "true"}
      data-state="closed"
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the dropdown menu trigger button.

  ## Attributes

    * `variant` - Button variant: `:outline` (default), `:ghost`, etc.
    * `size` - Button size: `:default`, `:sm`, `:icon`.
    * `as_child` - When true, renders only inner content without wrapping button.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Trigger content.
  """
  attr(:variant, :atom, default: :outline)
  attr(:size, :atom, default: :default)
  attr(:as_child, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec dropdown_menu_trigger(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_trigger(assigns) do
    ~H"""
    <%= if @as_child do %>
      {render_slot(@inner_block)}
    <% else %>
      <button
        type="button"
        data-component="button"
        data-variant={@variant}
        data-size={@size}
        data-dropdown-menu-part="trigger"
        aria-haspopup="menu"
        aria-expanded="false"
        class={@class}
        {@rest}
      >
        {render_slot(@inner_block)}
      </button>
    <% end %>
    """
  end

  @doc """
  Renders the dropdown menu content container.

  ## Attributes

    * `align` - Horizontal alignment: `:start` (default), `:center`, `:end`.
    * `side` - Side to open: `:bottom` (default), `:top`, `:left`, `:right`.
    * `width` - Width preset: `:default`, `:sm`, `:md`, `:lg`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Menu items, labels, separators, groups.
  """
  attr(:align, :atom, default: :start, values: [:start, :center, :end])
  attr(:side, :atom, default: :bottom, values: [:bottom, :top, :left, :right])
  attr(:width, :atom, default: :default, values: [:default, :sm, :md, :lg])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec dropdown_menu_content(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_content(assigns) do
    ~H"""
    <div
      data-dropdown-menu-part="content"
      data-align={@align}
      data-side={@side}
      data-width={@width}
      data-state="closed"
      role="menu"
      aria-orientation="vertical"
      tabindex="-1"
      hidden
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu item.

  ## Attributes

    * `href` - URL for the item. Renders as `<a>` when present, `<button>` otherwise.
    * `method` - HTTP method (for links).
    * `variant` - Visual variant: `:default` or `:destructive`.
    * `disabled` - Disables the item.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Item content.
  """
  attr(:href, :string, default: nil)
  attr(:method, :string, default: nil)
  attr(:variant, :atom, default: :default, values: [:default, :destructive])
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec dropdown_menu_item(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_item(assigns) do
    ~H"""
    <%= if @href do %>
      <a
        href={@href}
        data-dropdown-menu-part="item"
        data-variant={@variant != :default && @variant}
        data-method={@method}
        role="menuitem"
        tabindex="-1"
        aria-disabled={@disabled && "true"}
        class={@class}
        {@rest}
      >
        {render_slot(@inner_block)}
      </a>
    <% else %>
      <button
        type="button"
        data-dropdown-menu-part="item"
        data-variant={@variant != :default && @variant}
        role="menuitem"
        tabindex="-1"
        disabled={@disabled}
        class={@class}
        {@rest}
      >
        {render_slot(@inner_block)}
      </button>
    <% end %>
    """
  end

  @doc """
  Renders a dropdown menu label/heading.

  ## Attributes

    * `text` - Label text. Ignored if `inner_block` is provided.
    * `inset` - Whether to indent to align with items that have icons.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr(:text, :string, default: nil)
  attr(:inset, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  @spec dropdown_menu_label(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_label(assigns) do
    ~H"""
    <div
      data-dropdown-menu-part="label"
      data-inset={@inset && "true"}
      class={@class}
      {@rest}
    >
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu separator.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec dropdown_menu_separator(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_separator(assigns) do
    ~H"""
    <div
      data-dropdown-menu-part="separator"
      role="separator"
      aria-orientation="horizontal"
      class={@class}
      {@rest}
    />
    """
  end

  @doc """
  Renders a dropdown menu group.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Group items.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec dropdown_menu_group(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_group(assigns) do
    ~H"""
    <div data-dropdown-menu-part="group" role="group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a keyboard shortcut hint inside a menu item.

  ## Attributes

    * `text` - Shortcut text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr(:text, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  @spec dropdown_menu_shortcut(map()) :: Phoenix.LiveView.Rendered.t()
  def dropdown_menu_shortcut(assigns) do
    ~H"""
    <span data-dropdown-menu-part="shortcut" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </span>
    """
  end
end
