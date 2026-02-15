defmodule MaquinaLv.Combobox do
  @moduledoc """
  Combobox component for autocomplete/search with selection.

  ## Usage

      <.combobox>
        <.combobox_trigger placeholder="Select framework..." />
        <.combobox_content>
          <.combobox_input placeholder="Search..." />
          <.combobox_list>
            <.combobox_option value="nextjs">Next.js</.combobox_option>
            <.combobox_option value="remix">Remix</.combobox_option>
          </.combobox_list>
          <.combobox_empty />
        </.combobox_content>
      </.combobox>

  ## Simple Usage

      <.combobox_simple
        options={[%{value: "nextjs", label: "Next.js"}, %{value: "remix", label: "Remix"}]}
        placeholder="Select framework..."
      />
  """

  use Phoenix.Component

  import MaquinaLv.Icon, only: [icon: 1]

  # ── combobox/1 ──────────────────────────────────────────────────────

  @doc """
  Renders the combobox root container.

  ## Attributes

    * `name` - Form field name for the hidden input.
    * `value` - Currently selected value.
    * `placeholder` - Placeholder text for trigger.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Trigger and content.
  """
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  attr :placeholder, :string, default: "Select..."
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def combobox(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "combobox-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaCombobox"
      data-component="combobox"
      data-combobox-value={@value}
      data-combobox-name={@name}
      data-combobox-placeholder={@placeholder}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── combobox_trigger/1 ──────────────────────────────────────────────

  @doc """
  Renders the combobox trigger button.

  ## Attributes

    * `for_id` - The ID of the combobox content popover.
    * `placeholder` - Placeholder text shown when no value selected.
    * `class` - Additional CSS classes.
  """
  attr :for_id, :string, required: true
  attr :placeholder, :string, default: "Select..."
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox_trigger(assigns) do
    ~H"""
    <button
      type="button"
      popovertarget={@for_id}
      popovertargetaction="toggle"
      role="combobox"
      aria-expanded="false"
      aria-haspopup="listbox"
      aria-controls={@for_id}
      data-combobox-part="trigger"
      class={@class}
      {@rest}
    >
      <span data-combobox-part="label">{@placeholder}</span>
      <.icon name={:chevron_up_down} class="size-4 shrink-0 opacity-50" />
    </button>
    """
  end

  # ── combobox_content/1 ─────────────────────────────────────────────

  @doc """
  Renders the combobox content popover.

  ## Attributes

    * `id` - Required popover ID (matches trigger's `for_id`).
    * `align` - Horizontal alignment. Defaults to `:start`.
    * `width` - Width preset. Defaults to `:default`.
    * `class` - Additional CSS classes.

  ## Slots

    * `inner_block` (required) - Input, list, empty state.
  """
  attr :id, :string, required: true
  attr :align, :atom, default: :start, values: [:start, :center, :end]
  attr :width, :atom, default: :default, values: [:default, :sm, :md, :lg, :full]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def combobox_content(assigns) do
    ~H"""
    <div
      id={@id}
      popover="auto"
      role="listbox"
      data-combobox-part="content"
      data-align={@align}
      data-width={@width}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── combobox_input/1 ───────────────────────────────────────────────

  @doc """
  Renders the search input inside the combobox.

  ## Attributes

    * `placeholder` - Input placeholder text.
    * `class` - Additional CSS classes.
  """
  attr :placeholder, :string, default: "Search..."
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox_input(assigns) do
    ~H"""
    <div data-combobox-part="input-wrapper">
      <.icon name={:search} class="size-4 shrink-0 opacity-50" />
      <input
        type="text"
        placeholder={@placeholder}
        autocomplete="off"
        autocorrect="off"
        spellcheck="false"
        data-combobox-part="input"
        class={@class}
        {@rest}
      />
    </div>
    """
  end

  # ── combobox_list/1 ────────────────────────────────────────────────

  @doc """
  Renders the scrollable options list container.

  ## Slots

    * `inner_block` (required) - Options, groups, labels.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def combobox_list(assigns) do
    ~H"""
    <div data-combobox-part="list" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── combobox_option/1 ──────────────────────────────────────────────

  @doc """
  Renders a selectable option in the combobox.

  ## Attributes

    * `value` - The option value.
    * `selected` - Whether this option is selected. Defaults to `false`.
    * `disabled` - Whether this option is disabled. Defaults to `false`.
    * `class` - Additional CSS classes.

  ## Slots

    * `inner_block` (required) - Option label content.
  """
  attr :value, :string, required: true
  attr :selected, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def combobox_option(assigns) do
    ~H"""
    <div
      role="option"
      tabindex="-1"
      data-combobox-part="option"
      data-value={@value}
      data-selected={to_string(@selected)}
      aria-selected={to_string(@selected)}
      aria-disabled={@disabled && "true"}
      class={@class}
      {@rest}
    >
      <span data-combobox-part="check" class={unless @selected, do: "invisible"}>
        <.icon name={:check} class="size-4" />
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── combobox_empty/1 ───────────────────────────────────────────────

  @doc """
  Renders the empty state shown when no options match.

  ## Attributes

    * `text` - The message to display.
  """
  attr :text, :string, default: "No results found."
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox_empty(assigns) do
    ~H"""
    <div data-combobox-part="empty" hidden class={@class} {@rest}>
      {@text}
    </div>
    """
  end

  # ── combobox_group/1 ───────────────────────────────────────────────

  @doc """
  Renders a logical group of options.

  ## Slots

    * `inner_block` (required) - Options and labels.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def combobox_group(assigns) do
    ~H"""
    <div role="group" data-combobox-part="group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # ── combobox_label/1 ───────────────────────────────────────────────

  @doc """
  Renders a label/heading within a group.

  ## Attributes

    * `text` - Label text (used if no inner block).

  ## Slots

    * `inner_block` - Custom label content.
  """
  attr :text, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def combobox_label(assigns) do
    ~H"""
    <div data-combobox-part="label" class={@class} {@rest}>
      {render_slot(@inner_block) || @text}
    </div>
    """
  end

  # ── combobox_separator/1 ───────────────────────────────────────────

  @doc """
  Renders a visual separator between groups.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox_separator(assigns) do
    ~H"""
    <div role="separator" data-combobox-part="separator" class={@class} {@rest} />
    """
  end

  # ── combobox_simple/1 ──────────────────────────────────────────────

  @doc """
  Renders a simple data-driven combobox.

  ## Attributes

    * `options` - List of maps with `:value` and `:label` keys.
    * `placeholder` - Trigger placeholder text.
    * `search_placeholder` - Search input placeholder.
    * `empty_text` - Text shown when no results match.
    * `value` - Currently selected value.
    * `name` - Form field name.
    * `class` - Additional CSS classes.
  """
  attr :options, :list, required: true
  attr :placeholder, :string, default: "Select..."
  attr :search_placeholder, :string, default: "Search..."
  attr :empty_text, :string, default: "No results found."
  attr :value, :string, default: nil
  attr :name, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox_simple(assigns) do
    assigns =
      assign_new(assigns, :hook_id, fn ->
        assigns.rest[:id] || "combobox-#{System.unique_integer([:positive])}"
      end)

    assigns = assign(assigns, :content_id, assigns.hook_id)

    ~H"""
    <.combobox name={@name} value={@value} placeholder={@placeholder} class={@class} {@rest}>
      <.combobox_trigger for_id={@content_id} placeholder={@placeholder} />
      <.combobox_content id={@content_id}>
        <.combobox_input placeholder={@search_placeholder} />
        <.combobox_list>
          <.combobox_option
            :for={opt <- @options}
            value={opt.value}
            selected={@value != nil && to_string(opt.value) == to_string(@value)}
            disabled={Map.get(opt, :disabled, false)}
          >
            {opt[:label] || opt.value}
          </.combobox_option>
        </.combobox_list>
        <.combobox_empty text={@empty_text} />
      </.combobox_content>
    </.combobox>
    """
  end
end
