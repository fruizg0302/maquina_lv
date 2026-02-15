defmodule MaquinaLv.Dropdown do
  @moduledoc """
  Simple dropdown menu container, used primarily within sidebar menu buttons.

  Uses the `MaquinaMenuButton` hook for toggle and click-outside behavior.

  ## Usage

      <.dropdown>
        <a href="/profile">Profile</a>
        <a href="/settings">Settings</a>
      </.dropdown>
  """

  use Phoenix.Component

  @doc """
  Renders a simple dropdown container.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Dropdown content (links, items).
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def dropdown(assigns) do
    ~H"""
    <div
      data-menu-button-part="content"
      role="menu"
      aria-orientation="vertical"
      tabindex="-1"
      class={["hidden", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
