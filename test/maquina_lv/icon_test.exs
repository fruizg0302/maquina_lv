defmodule MaquinaLv.IconTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Icon

  # ── icon/1 basic rendering ────────────────────────────────────────

  describe "icon/1 basic rendering" do
    test "renders an <svg> tag for name: :check" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} />
        """)

      assert html =~ "<svg"
    end

    test "contains the check path" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} />
        """)

      assert html =~ ~s(M20 6 9 17l-5-5)
    end

    test "renders nothing for nonexistent icon name" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:nonexistent} />
        """)

      refute html =~ "<svg"
    end
  end

  # ── icon/1 class attribute ────────────────────────────────────────

  describe "icon/1 class attribute" do
    test "adds class to the svg element" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} class="text-green-500" />
        """)

      assert html =~ "<svg"
      assert html =~ "text-green-500"
    end

    test "preserves existing empty class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} />
        """)

      assert html =~ ~s(class="")
    end
  end

  # ── icon/1 stroke_width attribute ─────────────────────────────────

  describe "icon/1 stroke_width attribute" do
    test "replaces stroke-width in the svg" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} stroke_width="1.5" />
        """)

      assert html =~ ~s(stroke-width="1.5")
      refute html =~ ~s(stroke-width="2")
    end

    test "keeps default stroke-width when not specified" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check} />
        """)

      assert html =~ ~s(stroke-width="2")
    end
  end

  # ── icon/1 specific icons ─────────────────────────────────────────

  describe "icon/1 specific icons" do
    test "renders :home icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:home} />
        """)

      assert html =~ "<svg"
      assert html =~ "M3 10a2 2 0 0 1 .709-1.528"
    end

    test "renders :trash icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:trash} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(M3 6h18)
    end

    test "renders :search icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:search} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(cx="11" cy="11" r="8")
    end

    test "renders :dollar icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:dollar} />
        """)

      assert html =~ "<svg"
      assert html =~ "M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"
    end

    test "renders :users icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:users} />
        """)

      assert html =~ "<svg"
      assert html =~ "M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"
    end

    test "renders :settings icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:settings} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(cx="12" cy="12" r="3")
    end

    test "renders :calendar icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:calendar} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(M8 2v4)
    end

    test "renders :info icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:info} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(M12 16v-4)
    end

    test "renders :triangle_alert icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:triangle_alert} />
        """)

      assert html =~ "<svg"
      assert html =~ "m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"
    end

    test "renders :check_circle icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:check_circle} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(m9 12 2 2 4-4)
    end
  end

  # ── icon/1 all icon names render ──────────────────────────────────

  describe "icon/1 all icon names render" do
    @all_icons [
      :dollar,
      :users,
      :credit_card,
      :activity,
      :trend_up,
      :trend_down,
      :clock,
      :money,
      :line_chart,
      :piggy_bank,
      :arrow_left,
      :select_chevron,
      :check,
      :circle_alert,
      :logout,
      :chevron_up_down,
      :chevron_right,
      :chevron_left,
      :left_panel,
      :ellipsis,
      :calendar,
      :info,
      :triangle_alert,
      :check_circle,
      :arrow_right,
      :slash,
      :inbox,
      :folder,
      :search,
      :upload,
      :user,
      :log_out,
      :more_horizontal,
      :settings,
      :mail,
      :download,
      :trash,
      :pencil,
      :home,
      :layout_dashboard,
      :align_left,
      :align_center,
      :align_right,
      :bold,
      :italic,
      :underline,
      :list,
      :grid
    ]

    for icon_name <- @all_icons do
      test "renders :#{icon_name} icon" do
        name = unquote(icon_name)
        assigns = %{name: name}

        html =
          rendered_to_string(~H"""
          <.icon name={@name} />
          """)

        assert html =~ "<svg",
               "Expected :#{name} to render an <svg> tag, got: #{inspect(html)}"
      end
    end
  end

  # ── icon/1 icon_provider fallback ─────────────────────────────────

  describe "icon/1 icon_provider fallback" do
    test "calls icon_provider module when icon is not found and provider is set" do
      defmodule TestIconProvider do
        def icon_svg(:custom_icon) do
          ~s(<svg xmlns="http://www.w3.org/2000/svg" class=""><path d="M0 0"/></svg>)
        end

        def icon_svg(_), do: nil
      end

      Application.put_env(:maquina_lv, :icon_provider, TestIconProvider)

      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:custom_icon} />
        """)

      assert html =~ "<svg"
      assert html =~ ~s(M0 0)

      Application.delete_env(:maquina_lv, :icon_provider)
    end

    test "renders nothing when provider returns nil" do
      defmodule NilIconProvider do
        def icon_svg(_), do: nil
      end

      Application.put_env(:maquina_lv, :icon_provider, NilIconProvider)

      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.icon name={:totally_unknown} />
        """)

      refute html =~ "<svg"

      Application.delete_env(:maquina_lv, :icon_provider)
    end
  end
end
