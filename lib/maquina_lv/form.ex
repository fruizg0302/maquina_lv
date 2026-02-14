defmodule MaquinaLv.Form do
  @moduledoc """
  Form wrapper components for grouping labels, inputs, descriptions, and errors.

  These complement Phoenix form helpers by providing the structural wrappers.
  Form inputs themselves work with just `data-component="input"` on the element.

  ## Usage

      <.form_group>
        <.form_label for="email" required={true}>Email</.form_label>
        <input type="email" id="email" data-component="input" />
        <.form_description text="We'll never share your email." />
        <.form_error text="is required" />
      </.form_group>

      <.form_actions align={:end}>
        <button data-component="button" data-variant="primary">Save</button>
      </.form_actions>
  """

  use Phoenix.Component

  @doc """
  Renders a form field group container.

  ## Attributes

    * `layout` - Layout direction: `:default` or `:inline`.
      Only emits `data-layout="inline"` when set to `:inline`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Group content (label, input, description, error).
  """
  attr :layout, :atom, default: :default, values: [:default, :inline]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def form_group(assigns) do
    ~H"""
    <div
      data-form-part="group"
      data-layout={@layout != :default && @layout}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a form label.

  ## Attributes

    * `for` - The ID of the input this label is for.
    * `required` - Whether the field is required. Emits `data-required` when true.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Label text content.
  """
  attr :for, :string, default: nil
  attr :required, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def form_label(assigns) do
    ~H"""
    <label
      data-component="label"
      for={@for}
      data-required={@required || nil}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Renders a form field description / help text.

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

  def form_description(assigns) do
    ~H"""
    <p data-form-part="description" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </p>
    """
  end

  @doc """
  Renders a form field error message.

  ## Attributes

    * `text` - Error text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr :text, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block

  def form_error(assigns) do
    ~H"""
    <p data-form-part="error" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </p>
    """
  end

  @doc """
  Renders a form actions container (for submit buttons, etc.).

  ## Attributes

    * `align` - Alignment: `:start` (default), `:end`, or `:between`.
      Only emits `data-align` when not `:start`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Action content (buttons).
  """
  attr :align, :atom, default: :start, values: [:start, :end, :between]
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true

  def form_actions(assigns) do
    ~H"""
    <div
      data-form-part="actions"
      data-align={@align != :start && @align}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
