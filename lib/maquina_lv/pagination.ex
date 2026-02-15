defmodule MaquinaLv.Pagination do
  @moduledoc """
  Pagination components for navigating multi-page content.

  ## Usage

      <.pagination>
        <.pagination_content>
          <.pagination_item><.pagination_previous href="/page/1" /></.pagination_item>
          <.pagination_item><.pagination_link href="/page/1" active={true}>1</.pagination_link></.pagination_item>
          <.pagination_item><.pagination_link href="/page/2">2</.pagination_link></.pagination_item>
          <.pagination_item><.pagination_ellipsis /></.pagination_item>
          <.pagination_item><.pagination_next href="/page/3" /></.pagination_item>
        </.pagination_content>
      </.pagination>

  ### Convenience helpers

      <.pagination_nav current_page={2} total_pages={10} path_fn={&"/items?page=\#{&1}"} />

      <.pagination_simple current_page={2} total_pages={10} path_fn={&"/items?page=\#{&1}"} />
  """

  use Phoenix.Component

  @doc """
  Renders the pagination nav wrapper.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Pagination content.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def pagination(assigns) do
    ~H"""
    <nav data-component="pagination" aria-label="Pagination" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </nav>
    """
  end

  @doc """
  Renders the pagination content list.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Pagination items.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def pagination_content(assigns) do
    ~H"""
    <ul data-pagination-part="content" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  @doc """
  Renders a pagination list item wrapper.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Item content (link, previous, next, or ellipsis).
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def pagination_item(assigns) do
    ~H"""
    <li data-pagination-part="item" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  @doc """
  Renders a pagination page link.

  ## Attributes

    * `href` (required) - Link URL.
    * `active` - Whether this is the current page.
    * `disabled` - Renders as a non-interactive span.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (required) - Link content (page number).
  """
  attr(:href, :string, required: true)
  attr(:active, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block, required: true)

  def pagination_link(assigns) do
    ~H"""
    <%= if @disabled do %>
      <span
        data-pagination-part="link"
        aria-disabled="true"
        class={@class}
        {@rest}
      >
        {render_slot(@inner_block)}
      </span>
    <% else %>
      <a
        href={@href}
        data-pagination-part="link"
        data-active={@active && "true"}
        aria-current={@active && "page"}
        class={@class}
        {@rest}
      >
        {render_slot(@inner_block)}
      </a>
    <% end %>
    """
  end

  @doc """
  Renders the "Previous" pagination button.

  ## Attributes

    * `href` - Link URL. When nil, renders as disabled.
    * `label` - Custom label text. Defaults to "Previous".
    * `show_label` - Whether to show the text label. Defaults to `true`.
    * `disabled` - Forces disabled state.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:href, :string, default: nil)
  attr(:label, :string, default: "Previous")
  attr(:show_label, :boolean, default: true)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pagination_previous(assigns) do
    assigns = assign(assigns, :is_disabled, assigns.disabled || is_nil(assigns.href))

    ~H"""
    <%= if @is_disabled do %>
      <span
        data-pagination-part="previous"
        aria-disabled="true"
        class={@class}
        {@rest}
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="m15 18-6-6 6-6" />
        </svg>
        <%= if @show_label do %>
          <span>{@label}</span>
        <% end %>
      </span>
    <% else %>
      <a
        href={@href}
        data-pagination-part="previous"
        aria-label={@label}
        class={@class}
        {@rest}
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="m15 18-6-6 6-6" />
        </svg>
        <%= if @show_label do %>
          <span>{@label}</span>
        <% end %>
      </a>
    <% end %>
    """
  end

  @doc """
  Renders the "Next" pagination button.

  ## Attributes

    * `href` - Link URL. When nil, renders as disabled.
    * `label` - Custom label text. Defaults to "Next".
    * `show_label` - Whether to show the text label. Defaults to `true`.
    * `disabled` - Forces disabled state.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:href, :string, default: nil)
  attr(:label, :string, default: "Next")
  attr(:show_label, :boolean, default: true)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pagination_next(assigns) do
    assigns = assign(assigns, :is_disabled, assigns.disabled || is_nil(assigns.href))

    ~H"""
    <%= if @is_disabled do %>
      <span
        data-pagination-part="next"
        aria-disabled="true"
        class={@class}
        {@rest}
      >
        <%= if @show_label do %>
          <span>{@label}</span>
        <% end %>
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="m9 18 6-6-6-6" />
        </svg>
      </span>
    <% else %>
      <a
        href={@href}
        data-pagination-part="next"
        aria-label={@label}
        class={@class}
        {@rest}
      >
        <%= if @show_label do %>
          <span>{@label}</span>
        <% end %>
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="m9 18 6-6-6-6" />
        </svg>
      </a>
    <% end %>
    """
  end

  @doc """
  Renders a pagination ellipsis indicator.

  ## Attributes

    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pagination_ellipsis(assigns) do
    ~H"""
    <span data-pagination-part="ellipsis" aria-hidden="true" class={@class} {@rest}>
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <circle cx="12" cy="12" r="1" /><circle cx="19" cy="12" r="1" /><circle cx="5" cy="12" r="1" />
      </svg>
      <span class="sr-only">More pages</span>
    </span>
    """
  end

  @doc """
  Convenience component that renders full pagination with page numbers.

  ## Attributes

    * `current_page` (required) - The current page number.
    * `total_pages` (required) - The total number of pages.
    * `path_fn` (required) - A function that takes a page number and returns a URL.
    * `show_labels` - Whether to show Previous/Next text labels. Defaults to `true`.
    * `class` - Additional CSS classes for the nav.
    * Global attributes are passed through.
  """
  attr(:current_page, :integer, required: true)
  attr(:total_pages, :integer, required: true)
  attr(:path_fn, :any, required: true)
  attr(:show_labels, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pagination_nav(assigns) do
    if assigns.total_pages <= 1 do
      ~H""
    else
      assigns = assign(assigns, :series, page_series(assigns.current_page, assigns.total_pages))

      ~H"""
      <.pagination class={@class} {@rest}>
        <.pagination_content>
          <.pagination_item>
            <%= if @current_page > 1 do %>
              <.pagination_previous href={@path_fn.(@current_page - 1)} show_label={@show_labels} />
            <% else %>
              <.pagination_previous disabled={true} show_label={@show_labels} />
            <% end %>
          </.pagination_item>

          <%= for item <- @series do %>
            <.pagination_item>
              <%= case item do %>
                <% :ellipsis -> %>
                  <.pagination_ellipsis />
                <% page -> %>
                  <.pagination_link href={@path_fn.(page)} active={page == @current_page}>
                    {page}
                  </.pagination_link>
              <% end %>
            </.pagination_item>
          <% end %>

          <.pagination_item>
            <%= if @current_page < @total_pages do %>
              <.pagination_next href={@path_fn.(@current_page + 1)} show_label={@show_labels} />
            <% else %>
              <.pagination_next disabled={true} show_label={@show_labels} />
            <% end %>
          </.pagination_item>
        </.pagination_content>
      </.pagination>
      """
    end
  end

  @doc """
  Convenience component that renders simple previous/next pagination (no page numbers).

  ## Attributes

    * `current_page` (required) - The current page number.
    * `total_pages` (required) - The total number of pages.
    * `path_fn` (required) - A function that takes a page number and returns a URL.
    * `class` - Additional CSS classes for the nav.
    * Global attributes are passed through.
  """
  attr(:current_page, :integer, required: true)
  attr(:total_pages, :integer, required: true)
  attr(:path_fn, :any, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def pagination_simple(assigns) do
    if assigns.total_pages <= 1 do
      ~H""
    else
      ~H"""
      <.pagination class={@class} {@rest}>
        <.pagination_content>
          <.pagination_item>
            <%= if @current_page > 1 do %>
              <.pagination_previous href={@path_fn.(@current_page - 1)} />
            <% else %>
              <.pagination_previous disabled={true} />
            <% end %>
          </.pagination_item>
          <.pagination_item>
            <%= if @current_page < @total_pages do %>
              <.pagination_next href={@path_fn.(@current_page + 1)} />
            <% else %>
              <.pagination_next disabled={true} />
            <% end %>
          </.pagination_item>
        </.pagination_content>
      </.pagination>
      """
    end
  end

  # Generates a page series similar to Pagy's series method.
  # Returns a list of page numbers and :ellipsis atoms.
  defp page_series(_current, total) when total <= 7 do
    Enum.to_list(1..total)
  end

  defp page_series(current, total) do
    cond do
      current <= 3 ->
        Enum.to_list(1..4) ++ [:ellipsis, total]

      current >= total - 2 ->
        [1, :ellipsis] ++ Enum.to_list((total - 3)..total)

      true ->
        [1, :ellipsis, current - 1, current, current + 1, :ellipsis, total]
    end
  end
end
