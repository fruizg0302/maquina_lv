defmodule MaquinaLv.Header do
  @moduledoc """
  Header component for page or section headers.

  ## Usage

      <.header>
        Page Title
      </.header>
  """

  use Phoenix.Component

  @doc """
  Renders a header element with an inner content wrapper.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through (e.g., `id`, `phx-click`).

  ## Slots

    * `inner_block` (required) - The header content.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def header(assigns) do
    ~H"""
    <header data-component="header" class={@class} {@rest}>
      <div data-header-part="inner">{render_slot(@inner_block)}</div>
    </header>
    """
  end
end
