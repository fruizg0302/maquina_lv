defmodule MaquinaLv.Card do
  @moduledoc """
  Card component for grouping related content with header, body, and footer.

  ## Usage

      <.card>
        <.card_header>
          <.card_title text="Title" />
          <.card_description text="Description" />
        </.card_header>
        <.card_content>
          <p>Body content</p>
        </.card_content>
        <.card_footer>
          <button>Action</button>
        </.card_footer>
      </.card>

  ### With row layout header and action

      <.card>
        <.card_header layout={:row}>
          <div>
            <.card_title text="Dashboard" />
            <.card_description text="Overview" />
          </div>
          <.card_action>
            <button>Settings</button>
          </.card_action>
        </.card_header>
      </.card>
  """

  use Phoenix.Component

  @doc """
  Renders a card container.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through (e.g., `id`, `phx-click`).

  ## Slots

    * `inner_block` (required) - The card content.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div data-component="card" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the card header section.

  ## Attributes

    * `layout` - Layout direction: `:column` (default) or `:row`.
      Only emits `data-layout="row"` when set to `:row`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Header content (title, description, action).
  """
  attr :layout, :atom, default: :column, values: [:column, :row]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def card_header(assigns) do
    ~H"""
    <div
      data-card-part="header"
      data-layout={@layout != :column && @layout}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the card title.

  ## Attributes

    * `text` - Title text. Ignored if `inner_block` is provided.
    * `size` - Size variant: `:default` or `:sm`.
      Only emits `data-size="sm"` when set to `:sm`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr :text, :string, default: nil
  attr :size, :atom, default: :default, values: [:default, :sm]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def card_title(assigns) do
    ~H"""
    <h3
      data-card-part="title"
      data-size={@size != :default && @size}
      class={@class}
      {@rest}
    >
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </h3>
    """
  end

  @doc """
  Renders the card description.

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

  def card_description(assigns) do
    ~H"""
    <p data-card-part="description" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </p>
    """
  end

  @doc """
  Renders the card content section.

  ## Attributes

    * `spacing` - Spacing variant: `:default` or `:full`.
      Only emits `data-spacing="full"` when set to `:full`.
      Use `:full` when there is no header above the content.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The main body content.
  """
  attr :spacing, :atom, default: :default, values: [:default, :full]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def card_content(assigns) do
    ~H"""
    <div
      data-card-part="content"
      data-spacing={@spacing != :default && @spacing}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the card footer section.

  ## Attributes

    * `align` - Alignment: `:start` (default), `:between`, `:end`, or `:center`.
      Only emits `data-align` when not `:start`.
    * `spacing` - Spacing variant: `:default` or `:full`.
      Only emits `data-spacing="full"` when set to `:full`.
      Use `:full` when there is no content above the footer.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Footer content (buttons, links, etc.).
  """
  attr :align, :atom, default: :start, values: [:start, :between, :end, :center]
  attr :spacing, :atom, default: :default, values: [:default, :full]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def card_footer(assigns) do
    ~H"""
    <div
      data-card-part="footer"
      data-align={@align != :start && @align}
      data-spacing={@spacing != :default && @spacing}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card action container, typically used inside a row-layout header.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Action content (buttons, icons, etc.).
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def card_action(assigns) do
    ~H"""
    <div data-card-part="action" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
