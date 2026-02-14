defmodule MaquinaLv.Empty do
  @moduledoc """
  Empty state component for displaying placeholder content when no data exists.

  ## Usage

      <.empty variant={:outline}>
        <.empty_header>
          <.empty_media icon={:search} />
          <.empty_title text="No results found" />
          <.empty_description text="Try adjusting your search." />
        </.empty_header>
        <.empty_content>
          <a href="/reset">Reset</a>
        </.empty_content>
      </.empty>

  ### Convenience helpers

      <.empty_search_state query="foobar" reset_path="/search" />

      <.empty_list_state resource_name="projects" new_path="/projects/new" />
  """

  use Phoenix.Component

  import MaquinaLv.Icon

  @doc """
  Renders an empty state container.

  ## Attributes

    * `variant` - Visual style: `:default` or `:outline`.
    * `size` - Size variant: `:default` or `:compact`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The empty state content.
  """
  attr :variant, :atom, default: :default, values: [:default, :outline]
  attr :size, :atom, default: :default, values: [:default, :compact]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def empty(assigns) do
    ~H"""
    <div
      data-component="empty"
      data-variant={@variant}
      data-size={@size}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the empty state header section.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Header content (media, title, description).
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def empty_header(assigns) do
    ~H"""
    <div data-empty-part="header" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the empty state media section (icon or avatar).

  ## Attributes

    * `icon` - Icon name atom. Renders an icon when provided.
    * `variant` - Media variant: `:icon` (default) or `:avatar`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Custom media content (e.g., an image).
  """
  attr :icon, :atom, default: nil
  attr :variant, :atom, default: :icon, values: [:icon, :avatar]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def empty_media(assigns) do
    ~H"""
    <div data-empty-part="media" data-variant={@variant} class={@class} {@rest}>
      <%= if @icon do %>
        <.icon name={@icon} />
      <% else %>
        {render_slot(@inner_block)}
      <% end %>
    </div>
    """
  end

  @doc """
  Renders the empty state title.

  ## Attributes

    * `text` - Title text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr :text, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def empty_title(assigns) do
    ~H"""
    <h3 data-empty-part="title" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </h3>
    """
  end

  @doc """
  Renders the empty state description.

  ## Attributes

    * `text` - Description text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr :text, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def empty_description(assigns) do
    ~H"""
    <p data-empty-part="description" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </p>
    """
  end

  @doc """
  Renders the empty state content/actions section.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Action content (buttons, links).
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def empty_content(assigns) do
    ~H"""
    <div data-empty-part="content" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Convenience component for search empty states.

  ## Attributes

    * `query` - The search query to display in the description.
    * `reset_path` - Path for the "Clear search" link.
    * `size` - Size variant: `:default` or `:compact`.
  """
  attr :query, :string, default: nil
  attr :reset_path, :string, default: nil
  attr :size, :atom, default: :default, values: [:default, :compact]

  def empty_search_state(assigns) do
    description =
      if assigns.query do
        "No results found for \"#{assigns.query}\". Try a different search term."
      else
        "No results found. Try adjusting your search."
      end

    assigns = assign(assigns, :description, description)

    ~H"""
    <.empty size={@size}>
      <.empty_header>
        <.empty_media icon={:search} />
        <.empty_title text="No results" />
        <.empty_description text={@description} />
      </.empty_header>
      <%= if @reset_path do %>
        <.empty_content>
          <a href={@reset_path} data-component="button" data-variant="outline" data-size="sm">
            Clear search
          </a>
        </.empty_content>
      <% end %>
    </.empty>
    """
  end

  @doc """
  Convenience component for list/table empty states.

  ## Attributes

    * `resource_name` - Name of the resource (e.g., "projects").
    * `new_path` - Path to create a new resource.
    * `icon` - Icon name atom. Defaults to `:folder_open`.
    * `size` - Size variant: `:default` or `:compact`.
  """
  attr :resource_name, :string, required: true
  attr :new_path, :string, default: nil
  attr :icon, :atom, default: :folder
  attr :size, :atom, default: :default, values: [:default, :compact]

  def empty_list_state(assigns) do
    assigns =
      assign(assigns,
        title: "No #{assigns.resource_name} yet",
        description: "Get started by creating a new #{assigns.resource_name} entry."
      )

    ~H"""
    <.empty size={@size}>
      <.empty_header>
        <.empty_media icon={@icon} />
        <.empty_title text={@title} />
        <.empty_description text={@description} />
      </.empty_header>
      <%= if @new_path do %>
        <.empty_content>
          <a href={@new_path} data-component="button" data-variant="primary">
            Create
          </a>
        </.empty_content>
      <% end %>
    </.empty>
    """
  end
end
