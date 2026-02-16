defmodule MaquinaLv.Table do
  @moduledoc """
  Table component for displaying tabular data with header, body, footer, and caption.

  ## Usage

      <.table>
        <.table_caption>A list of recent invoices.</.table_caption>
        <.table_header>
          <.table_row>
            <.table_head>Invoice</.table_head>
            <.table_head>Status</.table_head>
            <.table_head>Amount</.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row>
            <.table_cell>INV001</.table_cell>
            <.table_cell>Paid</.table_cell>
            <.table_cell>$250.00</.table_cell>
          </.table_row>
        </.table_body>
        <.table_footer>
          <.table_row>
            <.table_cell>Total</.table_cell>
            <.table_cell></.table_cell>
            <.table_cell>$250.00</.table_cell>
          </.table_row>
        </.table_footer>
      </.table>

  ### Without container

      <.table container={false}>
        ...
      </.table>

  ### With variants

      <.table variant="bordered" table_variant="striped">
        ...
      </.table>
  """

  use Phoenix.Component

  @doc """
  Renders a table wrapped in an optional scrollable container div.

  When `container` is `true` (default), the table is wrapped in a `<div>` with
  `data-table-part="container"`. The container also receives `data-variant` when
  the `variant` attribute is set.

  ## Attributes

    * `container` - Whether to wrap the table in a container div (default `true`).
    * `variant` - Variant for the container (e.g., `"bordered"`).
    * `table_variant` - Variant for the table element (e.g., `"striped"`).
    * `class` - Additional CSS classes for the `<table>` element.
    * Global attributes are passed through to the `<table>` element.

  ## Slots

    * `inner_block` (required) - The table content (header, body, footer, caption).
  """
  attr(:container, :boolean, default: true)
  attr(:variant, :string, default: nil)
  attr(:table_variant, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table(map()) :: Phoenix.LiveView.Rendered.t()
  def table(assigns) do
    ~H"""
    <div :if={@container} data-table-part="container" data-variant={@variant}>
      <table data-component="table" data-variant={@table_variant} class={@class} {@rest}>
        {render_slot(@inner_block)}
      </table>
    </div>
    <table :if={!@container} data-component="table" data-variant={@table_variant} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </table>
    """
  end

  @doc """
  Renders a table header (`<thead>`).

  ## Attributes

    * `sticky` - Whether the header should be sticky (default `false`).
      Emits `data-sticky="true"` when set to `true`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The header rows.
  """
  attr(:sticky, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_header(map()) :: Phoenix.LiveView.Rendered.t()
  def table_header(assigns) do
    ~H"""
    <thead data-table-part="header" data-sticky={@sticky && "true"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </thead>
    """
  end

  @doc """
  Renders a table body (`<tbody>`).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The body rows.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_body(map()) :: Phoenix.LiveView.Rendered.t()
  def table_body(assigns) do
    ~H"""
    <tbody data-table-part="body" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  @doc """
  Renders a table row (`<tr>`).

  ## Attributes

    * `selected` - Whether the row is selected (default `false`).
      Emits `data-state="selected"` when set to `true`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The row cells.
  """
  attr(:selected, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_row(map()) :: Phoenix.LiveView.Rendered.t()
  def table_row(assigns) do
    ~H"""
    <tr data-table-part="row" data-state={@selected && "selected"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </tr>
    """
  end

  @doc """
  Renders a table head cell (`<th>`).

  ## Attributes

    * `scope` - The scope attribute for the `<th>` element (default `"col"`).
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The head cell content.
  """
  attr(:scope, :string, default: "col")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_head(map()) :: Phoenix.LiveView.Rendered.t()
  def table_head(assigns) do
    ~H"""
    <th data-table-part="head" scope={@scope} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </th>
    """
  end

  @doc """
  Renders a table data cell (`<td>`).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The cell content.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_cell(map()) :: Phoenix.LiveView.Rendered.t()
  def table_cell(assigns) do
    ~H"""
    <td data-table-part="cell" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </td>
    """
  end

  @doc """
  Renders a table footer (`<tfoot>`).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The footer rows.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_footer(map()) :: Phoenix.LiveView.Rendered.t()
  def table_footer(assigns) do
    ~H"""
    <tfoot data-table-part="footer" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  @doc """
  Renders a table caption (`<caption>`).

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - The caption content.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  @spec table_caption(map()) :: Phoenix.LiveView.Rendered.t()
  def table_caption(assigns) do
    ~H"""
    <caption data-table-part="caption" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </caption>
    """
  end
end
