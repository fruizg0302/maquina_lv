defmodule MaquinaLv.Toast do
  @moduledoc """
  Toast notification components for displaying temporary messages.

  ## Usage

      <.toaster position={:bottom_right}>
        <.toast variant={:success} title="Saved!" description="Your changes have been saved." />
      </.toaster>

  ### Flash messages

      <.toaster position={:bottom_right}>
        <.flash_toasts flash={@flash} />
      </.toaster>

  ### Individual sub-components

      <.toast variant={:info}>
        <.toast_title text="Update available" />
        <.toast_description text="A new version is ready to install." />
        <.toast_action label="Install" href="/update" />
      </.toast>
  """

  use Phoenix.Component

  @doc """
  Renders the toaster container (fixed positioned, manages toast stack).

  ## Attributes

    * `position` - Position on screen. One of `:bottom_right`, `:bottom_left`,
      `:top_right`, `:top_left`, `:top_center`, `:bottom_center`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Toast elements.
  """
  attr(:position, :atom,
    default: :bottom_right,
    values: [:bottom_right, :bottom_left, :top_right, :top_left, :top_center, :bottom_center]
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  def toaster(assigns) do
    position_str = assigns.position |> to_string() |> String.replace("_", "-")
    assigns = assign(assigns, :position_str, position_str)

    ~H"""
    <div
      id="toaster"
      phx-hook="MaquinaToaster"
      data-component="toaster"
      data-position={@position_str}
      role="region"
      aria-label="Notifications"
      aria-live="polite"
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an individual toast notification.

  ## Attributes

    * `variant` - Visual variant: `:default`, `:success`, `:info`, `:warning`, `:error`.
    * `title` - Toast title text.
    * `description` - Toast description text.
    * `duration` - Auto-dismiss duration in ms. `0` disables auto-dismiss. Defaults to `5000`.
    * `dismissible` - Whether to show a close button. Defaults to `true`.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Custom toast content (title, description, action sub-components).
  """
  attr(:variant, :atom,
    default: :default,
    values: [:default, :success, :info, :warning, :error]
  )

  attr(:title, :string, default: nil)
  attr(:description, :string, default: nil)
  attr(:duration, :integer, default: 5000)
  attr(:dismissible, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  def toast(assigns) do
    assigns =
      assign_new(assigns, :toast_id, fn ->
        assigns.rest[:id] || "toast-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <div
      id={@toast_id}
      phx-hook="MaquinaToast"
      data-component="toast"
      data-variant={@variant}
      data-duration={@duration}
      data-dismissible={@dismissible}
      data-state="entering"
      role="alert"
      class={@class}
      {@rest}
    >
      <div data-toast-part="content">
        <%= if @title do %>
          <.toast_title text={@title} />
        <% end %>
        <%= if @description do %>
          <.toast_description text={@description} />
        <% end %>
        {render_slot(@inner_block)}
      </div>
      <%= if @dismissible do %>
        <button
          type="button"
          data-toast-part="close"
          aria-label="Dismiss notification"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M18 6 6 18" /><path d="m6 6 12 12" />
          </svg>
        </button>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a toast title.

  ## Attributes

    * `text` - Title text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr(:text, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  def toast_title(assigns) do
    ~H"""
    <div data-toast-part="title" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </div>
    """
  end

  @doc """
  Renders a toast description.

  ## Attributes

    * `text` - Description text. Ignored if `inner_block` is provided.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.

  ## Slots

    * `inner_block` (optional) - Takes priority over `text` attribute.
  """
  attr(:text, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  slot(:inner_block)

  def toast_description(assigns) do
    ~H"""
    <div data-toast-part="description" class={@class} {@rest}>
      {if @inner_block != [], do: render_slot(@inner_block), else: @text}
    </div>
    """
  end

  @doc """
  Renders a toast action button/link.

  ## Attributes

    * `label` (required) - Action text.
    * `href` - URL. Renders as `<a>` when present, `<button>` otherwise.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr(:label, :string, required: true)
  attr(:href, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  def toast_action(assigns) do
    ~H"""
    <%= if @href do %>
      <a href={@href} data-toast-part="action" class={@class} {@rest}>
        {@label}
      </a>
    <% else %>
      <button type="button" data-toast-part="action" class={@class} {@rest}>
        {@label}
      </button>
    <% end %>
    """
  end

  @doc """
  Convenience component that renders Phoenix flash messages as toasts.

  ## Attributes

    * `flash` (required) - The Phoenix flash map.
    * `exclude` - List of flash keys to exclude.
  """
  attr(:flash, :map, required: true)
  attr(:exclude, :list, default: [])

  @flash_variants %{
    "info" => :success,
    "success" => :success,
    "error" => :error,
    "warning" => :warning
  }

  def flash_toasts(assigns) do
    toasts =
      assigns.flash
      |> Enum.reject(fn {key, _} -> key in assigns.exclude end)
      |> Enum.reject(fn {_, val} -> is_nil(val) or val == "" end)
      |> Enum.map(fn {key, message} ->
        variant = Map.get(@flash_variants, to_string(key), :default)
        %{variant: variant, title: message}
      end)

    assigns = assign(assigns, :toasts, toasts)

    ~H"""
    <%= for t <- @toasts do %>
      <.toast variant={t.variant} title={t.title} />
    <% end %>
    """
  end
end
