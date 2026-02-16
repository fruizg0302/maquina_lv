defmodule MaquinaLv.Separator do
  @moduledoc """
  Separator component for visually dividing content.

  ## Usage

      <.separator />

  ### Vertical orientation

      <.separator orientation={:vertical} />
  """

  use Phoenix.Component

  @doc """
  Renders a separator element.

  ## Attributes

    * `orientation` - Orientation: `:horizontal` (default) or `:vertical`.
      Always emitted as `data-orientation`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through (e.g., `id`, `phx-click`).
  """
  attr(:orientation, :atom, default: :horizontal, values: [:horizontal, :vertical])
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec separator(map()) :: Phoenix.LiveView.Rendered.t()
  def separator(assigns) do
    ~H"""
    <div role="separator" data-orientation={@orientation} class={@class} {@rest}></div>
    """
  end
end
