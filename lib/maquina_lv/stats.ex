defmodule MaquinaLv.Stats do
  @moduledoc """
  Stats components for displaying metric cards in a grid layout.

  ## Usage

      <.stats_grid cards={[
        %{title: "Total Users", value: "1,234", icon: :users},
        %{title: "Revenue", value: "$5,000", subtitle: "+12%", icon: :check}
      ]} />

  ### Individual card

      <.stats_card title="Messages" value="42" icon={:check} subtitle="+5%" />

  ### With action

      <.stats_grid cards={@cards}>
        <:action>
          <a href="/dashboard">View All</a>
        </:action>
      </.stats_grid>
  """

  use Phoenix.Component

  import MaquinaLv.Icon

  @doc """
  Renders a single stats card.

  ## Attributes

    * `title` (required) - Card title/label.
    * `value` (required) - Main value/metric to display.
    * `icon` - Icon name atom.
    * `icon_class` - CSS classes for the icon container.
    * `subtitle` - Subtitle text below the value.
    * `value_class` - CSS classes for the value text.
    * `container_class` - Additional CSS classes for the card container.
    * Global attributes are passed through.
  """
  attr(:title, :string, required: true)
  attr(:value, :string, required: true)
  attr(:icon, :atom, default: nil)
  attr(:icon_class, :string, default: nil)
  attr(:subtitle, :string, default: nil)
  attr(:value_class, :string, default: nil)
  attr(:container_class, :string, default: nil)
  attr(:rest, :global)

  @spec stats_card(map()) :: Phoenix.LiveView.Rendered.t()
  def stats_card(assigns) do
    ~H"""
    <div
      class={[
        "bg-card p-4 rounded-lg shadow-sm border border-border",
        @container_class
      ]}
      {@rest}
    >
      <div class="flex items-center justify-between">
        <div>
          <p class="text-sm text-muted-foreground">{@title}</p>
          <p class={["text-2xl font-bold", @value_class || "text-foreground"]}>
            {@value}
          </p>
          <%= if @subtitle do %>
            <p data-stats-part="subtitle" class="text-xs text-muted-foreground mt-1">
              {@subtitle}
            </p>
          <% end %>
        </div>
        <%= if @icon do %>
          <div data-stats-part="icon" class={@icon_class || "text-muted-foreground"}>
            <.icon name={@icon} class="w-8 h-8" />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a grid of stats cards.

  ## Attributes

    * `cards` (required) - List of card maps. Each map supports: `title`, `value`,
      `icon`, `icon_class`, `subtitle`, `value_class`, `container_class`.
    * `columns` - Number of grid columns (default: 3).
    * `container_class` - Additional CSS classes for the grid container.
    * `action_position` - Position of the action slot: `"start"` or `"end"` (default).
    * Global attributes are passed through.

  ## Slots

    * `action` (optional) - Action content rendered next to the grid.
  """
  attr(:cards, :list, required: true)
  attr(:columns, :integer, default: 3)
  attr(:container_class, :string, default: nil)
  attr(:action_position, :string, default: "end", values: ["start", "end"])
  attr(:rest, :global)

  slot(:action)

  @spec stats_grid(map()) :: Phoenix.LiveView.Rendered.t()
  def stats_grid(assigns) do
    ~H"""
    <div
      class={[
        if(@action != [], do: "flex flex-col lg:flex-row lg:items-center gap-4")
      ]}
      {@rest}
    >
      <%= if @action != [] && @action_position == "start" do %>
        <div class="flex justify-center lg:justify-start">
          {render_slot(@action)}
        </div>
      <% end %>

      <div
        data-component="stats-grid"
        data-columns={@columns}
        class={[
          "grid gap-4 grid-cols-1",
          @container_class,
          if(@action != [], do: "flex-1")
        ]}
      >
        <.stats_card
          :for={card <- @cards}
          title={card.title}
          value={card.value}
          icon={Map.get(card, :icon)}
          icon_class={Map.get(card, :icon_class)}
          subtitle={Map.get(card, :subtitle)}
          value_class={Map.get(card, :value_class)}
          container_class={Map.get(card, :container_class)}
        />
      </div>

      <%= if @action != [] && @action_position == "end" do %>
        <div class="flex justify-center lg:justify-end">
          {render_slot(@action)}
        </div>
      <% end %>
    </div>
    """
  end
end
