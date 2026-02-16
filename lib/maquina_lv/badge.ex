defmodule MaquinaLv.Badge do
  @moduledoc """
  Badge component for displaying short status text or labels.

  ## Usage

      <.badge>Default</.badge>

  ### Variants

      <.badge variant={:secondary}>Secondary</.badge>
      <.badge variant={:destructive}>Error</.badge>
      <.badge variant={:outline}>Outline</.badge>
      <.badge variant={:success}>Success</.badge>
      <.badge variant={:warning}>Warning</.badge>

  ### Sizes

      <.badge size={:sm}>Small</.badge>
      <.badge size={:lg}>Large</.badge>
  """

  use Phoenix.Component

  @doc """
  Renders a badge.

  ## Attributes

    * `variant` - Visual variant: `:default`, `:secondary`, `:destructive`,
      `:outline`, `:success`, or `:warning`. Defaults to `:default`.
    * `size` - Size variant: `:sm`, `:md`, or `:lg`. Defaults to `:md`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through (e.g., `id`, `phx-click`).

  ## Slots

    * `inner_block` (required) - The badge content.
  """
  attr(:variant, :atom,
    default: :default,
    values: [:default, :secondary, :destructive, :outline, :success, :warning]
  )

  attr(:size, :atom, default: :md, values: [:sm, :md, :lg])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec badge(map()) :: Phoenix.LiveView.Rendered.t()
  def badge(assigns) do
    ~H"""
    <span
      data-component="badge"
      data-variant={@variant}
      data-size={@size}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
