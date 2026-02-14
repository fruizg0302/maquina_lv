defmodule MaquinaLv.Alert do
  @moduledoc """
  Alert component for displaying important messages with contextual variants.

  ## Usage

      <.alert>
        <.alert_title text="Heads up!" />
        <.alert_description text="You can add components to your app using the CLI." />
      </.alert>

  ### With variant and icon

      <.alert variant={:destructive} icon={:circle_alert}>
        <.alert_title text="Error" />
        <.alert_description text="Your session has expired." />
      </.alert>
  """

  use Phoenix.Component

  @doc """
  Renders an alert container.

  ## Attributes

    * `variant` - Visual variant: `:default`, `:destructive`, `:info`, `:warning`, or `:success`.
    * `icon` - Optional icon name as an atom. When set, renders the icon and adds `data-has-icon`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through (e.g., `id`, `phx-click`).

  ## Slots

    * `inner_block` (required) - The alert content.
  """
  attr :variant, :atom, default: :default, values: [:default, :destructive, :info, :warning, :success]
  attr :icon, :atom, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      role="alert"
      data-component="alert"
      data-variant={@variant}
      data-has-icon={@icon && ""}
      class={@class}
      {@rest}
    >
      <MaquinaLv.Icon.icon :if={@icon} name={@icon} />
      <div>{render_slot(@inner_block)}</div>
    </div>
    """
  end

  @doc """
  Renders the alert title.

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

  def alert_title(assigns) do
    ~H"""
    <div data-alert-part="title" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </div>
    """
  end

  @doc """
  Renders the alert description.

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

  def alert_description(assigns) do
    ~H"""
    <div data-alert-part="description" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </div>
    """
  end
end
