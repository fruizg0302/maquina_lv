defmodule MaquinaLv.SeparatorTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Separator

  # ── separator/1 ──────────────────────────────────────────────────────

  describe "separator/1" do
    test "renders a div with role='separator'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator />
        """)

      assert html =~ ~s(role="separator")
      assert html =~ "<div"
    end

    test "emits data-orientation='horizontal' by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator />
        """)

      assert html =~ ~s(data-orientation="horizontal")
    end

    test "emits data-orientation='horizontal' when explicitly set" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator orientation={:horizontal} />
        """)

      assert html =~ ~s(data-orientation="horizontal")
    end

    test "emits data-orientation='vertical' when orientation is :vertical" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator orientation={:vertical} />
        """)

      assert html =~ ~s(data-orientation="vertical")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator class="my-separator" />
        """)

      assert html =~ ~s(class="my-separator")
    end

    test "renders empty class attribute when class is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator />
        """)

      # Phoenix renders class="" for nil class values; this is harmless
      assert html =~ ~s(class="")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator id="my-sep" />
        """)

      assert html =~ ~s(id="my-sep")
    end

    test "does not render any inner content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.separator />
        """)

      assert html =~ ~r{<div[^>]*></div>}
    end
  end
end
