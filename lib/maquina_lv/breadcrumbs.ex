defmodule MaquinaLv.Breadcrumbs do
  @moduledoc """
  Breadcrumbs navigation component with optional responsive collapsing.

  ## Usage

      <.breadcrumbs>
        <.breadcrumbs_list>
          <.breadcrumbs_item>
            <.breadcrumbs_link href="/">Home</.breadcrumbs_link>
          </.breadcrumbs_item>
          <.breadcrumbs_separator />
          <.breadcrumbs_item>
            <.breadcrumbs_link href="/projects">Projects</.breadcrumbs_link>
          </.breadcrumbs_item>
          <.breadcrumbs_separator />
          <.breadcrumbs_item>
            <.breadcrumbs_page>Current</.breadcrumbs_page>
          </.breadcrumbs_item>
        </.breadcrumbs_list>
      </.breadcrumbs>

  ### Responsive (auto-collapses middle items)

      <.breadcrumbs responsive={true}>
        ...
      </.breadcrumbs>
  """

  use Phoenix.Component

  import MaquinaLv.Icon

  @doc """
  Renders the breadcrumbs nav wrapper.

  ## Attributes

    * `responsive` - Enables responsive collapsing via JS hook. Defaults to `false`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Breadcrumbs content.
  """
  attr(:responsive, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec breadcrumbs(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs(assigns) do
    assigns =
      if assigns.responsive && !assigns.rest[:id] do
        assign(assigns, :hook_id, "breadcrumbs-#{System.unique_integer([:positive])}")
      else
        assign(assigns, :hook_id, assigns.rest[:id])
      end

    ~H"""
    <nav
      data-component="breadcrumbs"
      aria-label="Breadcrumb"
      id={@responsive && @hook_id}
      phx-hook={@responsive && "MaquinaBreadcrumb"}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </nav>
    """
  end

  @doc """
  Renders the breadcrumbs ordered list.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - List items.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec breadcrumbs_list(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_list(assigns) do
    ~H"""
    <ol data-breadcrumb-part="list" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </ol>
    """
  end

  @doc """
  Renders a breadcrumb item (list item wrapper).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Item content (link or page).
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec breadcrumbs_item(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_item(assigns) do
    ~H"""
    <li data-breadcrumb-part="item" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  @doc """
  Renders a breadcrumb link.

  ## Attributes

    * `href` (required) - Link URL.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Link text.
  """
  attr(:href, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec breadcrumbs_link(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_link(assigns) do
    ~H"""
    <a href={@href} data-breadcrumb-part="link" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </a>
    """
  end

  @doc """
  Renders the current page (non-interactive).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Page text.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec breadcrumbs_page(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_page(assigns) do
    ~H"""
    <span
      data-breadcrumb-part="page"
      role="link"
      aria-current="page"
      aria-disabled="true"
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a breadcrumb separator.

  ## Attributes

    * `icon` - Icon to use. Defaults to `:chevron_right`. Use `:custom` for custom content.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Custom separator content (only used when `icon` is `:custom`).
  """
  attr(:icon, :atom, default: :chevron_right)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  @spec breadcrumbs_separator(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_separator(assigns) do
    ~H"""
    <li data-breadcrumb-part="separator" role="presentation" aria-hidden="true" class={@class} {@rest}>
      <%= if @icon == :custom do %>
        {render_slot(@inner_block)}
      <% else %>
        <.icon name={@icon} />
      <% end %>
    </li>
    """
  end

  @doc """
  Renders a breadcrumb ellipsis indicator.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec breadcrumbs_ellipsis(map()) :: Phoenix.LiveView.Rendered.t()
  def breadcrumbs_ellipsis(assigns) do
    ~H"""
    <span data-breadcrumb-part="ellipsis" role="presentation" class={@class} {@rest}>
      <.icon name={:ellipsis} />
      <span class="sr-only">More</span>
    </span>
    """
  end
end
