defmodule MaquinaLv.ToggleGroup do
  @moduledoc """
  Toggle group component — a group of two-state buttons with single or multiple selection.

  ## Usage

      <.toggle_group type={:single} variant={:outline}>
        <.toggle_group_item value="bold" aria_label="Toggle bold">
          <strong>B</strong>
        </.toggle_group_item>
        <.toggle_group_item value="italic" aria_label="Toggle italic">
          <em>I</em>
        </.toggle_group_item>
      </.toggle_group>

  ### Convenience helper

      <.toggle_group_simple
        type={:single}
        variant={:outline}
        items={[
          %{value: "left", icon: :align_left, aria_label: "Align left"},
          %{value: "center", icon: :align_center, aria_label: "Align center"},
          %{value: "right", icon: :align_right, aria_label: "Align right"}
        ]}
        value="left"
      />
  """

  use Phoenix.Component

  import MaquinaLv.Icon

  @doc """
  Renders a toggle group container.

  ## Attributes

    * `type` - Selection mode: `:single` (default) or `:multiple`.
    * `variant` - Visual style: `:default` or `:outline`.
    * `size` - Size variant: `:default`, `:sm`, or `:lg`.
    * `value` - Initially selected value (string or list of strings for multiple).
    * `disabled` - Disables all items.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Toggle group items.
  """
  attr(:type, :atom, default: :single, values: [:single, :multiple])
  attr(:variant, :atom, default: :default, values: [:default, :outline])
  attr(:size, :atom, default: :default, values: [:default, :sm, :lg])
  attr(:value, :any, default: nil)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def toggle_group(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "toggle-group-#{System.unique_integer([:positive])}"
      end)

    selected_json =
      case assigns.value do
        nil -> "[]"
        values when is_list(values) -> encode_json_list(values)
        value -> encode_json_list([to_string(value)])
      end

    assigns = assign(assigns, :selected_json, selected_json)

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaToggleGroup"
      data-component="toggle-group"
      data-variant={@variant}
      data-size={@size}
      data-type={@type}
      data-selected={@selected_json}
      role="group"
      aria-disabled={@disabled && "true"}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a toggle group item button.

  ## Attributes

    * `value` (required) - The value this item represents.
    * `pressed` - Whether the item is pressed/selected.
    * `disabled` - Disables this item.
    * `aria_label` - Accessible label for the button.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Button content (text, icon, etc.).
  """
  attr(:value, :string, required: true)
  attr(:pressed, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:aria_label, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def toggle_group_item(assigns) do
    ~H"""
    <button
      type="button"
      data-toggle-group-part="item"
      data-value={@value}
      data-state={if @pressed, do: "on", else: "off"}
      aria-pressed={to_string(@pressed)}
      aria-label={@aria_label}
      disabled={@disabled}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Convenience component that renders a toggle group from a list of item maps.

  ## Attributes

    * `items` (required) - List of maps with keys: `value`, `label`, `icon`, `aria_label`, `disabled`.
    * `type` - Selection mode: `:single` (default) or `:multiple`.
    * `variant` - Visual style: `:default` or `:outline`.
    * `size` - Size variant: `:default`, `:sm`, or `:lg`.
    * `value` - Initially selected value(s).
    * `disabled` - Disables all items.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:items, :list, required: true)
  attr(:type, :atom, default: :single, values: [:single, :multiple])
  attr(:variant, :atom, default: :default, values: [:default, :outline])
  attr(:size, :atom, default: :default, values: [:default, :sm, :lg])
  attr(:value, :any, default: nil)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def toggle_group_simple(assigns) do
    selected_values = normalize_value(assigns.value)
    assigns = assign(assigns, :selected_values, selected_values)

    ~H"""
    <.toggle_group
      type={@type}
      variant={@variant}
      size={@size}
      value={@value}
      disabled={@disabled}
      class={@class}
      {@rest}
    >
      <.toggle_group_item
        :for={item <- @items}
        value={item.value}
        pressed={item.value in @selected_values}
        disabled={Map.get(item, :disabled, false) || @disabled}
        aria_label={Map.get(item, :aria_label)}
      >
        <%= if Map.get(item, :icon) do %>
          <.icon name={item.icon} />
        <% end %>
        <%= if Map.get(item, :label) do %>
          {item.label}
        <% end %>
      </.toggle_group_item>
    </.toggle_group>
    """
  end

  defp normalize_value(nil), do: []
  defp normalize_value(values) when is_list(values), do: Enum.map(values, &to_string/1)
  defp normalize_value(value), do: [to_string(value)]

  defp encode_json_list(values) do
    encoded = Enum.map_join(values, ",", &("\"" <> to_string(&1) <> "\""))
    "[" <> encoded <> "]"
  end
end
