defmodule MaquinaLv.HeaderTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Header

  # ── header/1 ──────────────────────────────────────────────────────────

  describe "header/1" do
    test "renders a header element with data-component='header'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header>content</.header>
        """)

      assert html =~ ~s(data-component="header")
      assert html =~ "<header"
    end

    test "contains an inner div with data-header-part='inner'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header>content</.header>
        """)

      assert html =~ ~s(data-header-part="inner")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header class="my-header">content</.header>
        """)

      assert html =~ ~s(class="my-header")
    end

    test "renders empty class attribute when class is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header>content</.header>
        """)

      # Phoenix renders class="" for nil class values; this is harmless
      assert html =~ ~s(class="")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header id="my-header">content</.header>
        """)

      assert html =~ ~s(id="my-header")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header>
          <h1>Page Title</h1>
        </.header>
        """)

      assert html =~ "<h1>Page Title</h1>"
      assert html =~ ~s(data-component="header")
    end

    test "inner block content is wrapped in the inner div" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.header>
          <span>Wrapped</span>
        </.header>
        """)

      assert html =~ ~s(data-header-part="inner")
      assert html =~ "<span>Wrapped</span>"
    end
  end
end
