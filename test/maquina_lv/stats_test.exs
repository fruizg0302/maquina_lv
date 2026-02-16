defmodule MaquinaLv.StatsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Stats

  # ── stats_card/1 ─────────────────────────────────────────────────────

  describe "stats_card/1" do
    test "renders a card with title and value" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Total Users" value="1,234" />
        """)

      assert html =~ "Total Users"
      assert html =~ "1,234"
      assert html =~ "<div"
    end

    test "renders subtitle when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Revenue" value="$5,000" subtitle="+12% from last month" />
        """)

      assert html =~ "+12% from last month"
    end

    test "does not render subtitle when not provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Revenue" value="$5,000" />
        """)

      refute html =~ "data-stats-part=\"subtitle\""
    end

    test "renders icon when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Messages" value="42" icon={:check} />
        """)

      assert html =~ "<svg"
    end

    test "does not render icon container when no icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Messages" value="42" />
        """)

      refute html =~ "data-stats-part=\"icon\""
    end

    test "passes value_class through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Sales" value="99" value_class="text-green-500" />
        """)

      assert html =~ "text-green-500"
    end

    test "passes icon_class through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Sales" value="99" icon={:check} icon_class="text-blue-500" />
        """)

      assert html =~ "text-blue-500"
    end

    test "passes container_class through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Sales" value="99" container_class="my-custom" />
        """)

      assert html =~ "my-custom"
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.stats_card title="Sales" value="99" id="my-card" />
        """)

      assert html =~ ~s(id="my-card")
    end
  end

  # ── stats_grid/1 ─────────────────────────────────────────────────────

  describe "stats_grid/1" do
    test "renders a grid container" do
      assigns = %{
        cards: [
          %{title: "Users", value: "100"},
          %{title: "Revenue", value: "$500"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} />
        """)

      assert html =~ "Users"
      assert html =~ "100"
      assert html =~ "Revenue"
      assert html =~ "$500"
    end

    test "renders correct number of columns" do
      assigns = %{
        cards: [
          %{title: "A", value: "1"},
          %{title: "B", value: "2"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} columns={4} />
        """)

      assert html =~ ~s(data-columns="4")
    end

    test "defaults to 3 columns" do
      assigns = %{
        cards: [%{title: "A", value: "1"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} />
        """)

      assert html =~ ~s(data-columns="3")
    end

    test "passes container_class through" do
      assigns = %{
        cards: [%{title: "A", value: "1"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} container_class="my-grid" />
        """)

      assert html =~ "my-grid"
    end

    test "renders cards with icons" do
      assigns = %{
        cards: [
          %{title: "A", value: "1", icon: :check},
          %{title: "B", value: "2", icon: :search}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} />
        """)

      assert html =~ "<svg"
    end

    test "renders cards with subtitle" do
      assigns = %{
        cards: [%{title: "Users", value: "100", subtitle: "+5%"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} />
        """)

      assert html =~ "+5%"
    end

    test "renders action slot at end by default" do
      assigns = %{
        cards: [%{title: "A", value: "1"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards}>
          <:action>
            <button>View All</button>
          </:action>
        </.stats_grid>
        """)

      assert html =~ "View All"
    end

    test "renders action slot at start" do
      assigns = %{
        cards: [%{title: "A", value: "1"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} action_position="start">
          <:action>
            <button>View All</button>
          </:action>
        </.stats_grid>
        """)

      assert html =~ "View All"
    end

    test "passes global attributes through" do
      assigns = %{
        cards: [%{title: "A", value: "1"}]
      }

      html =
        rendered_to_string(~H"""
        <.stats_grid cards={@cards} id="my-grid" />
        """)

      assert html =~ ~s(id="my-grid")
    end
  end
end
