defmodule MaquinaLv.MenuButtonTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.MenuButton

  # ── menu_button/1 ────────────────────────────────────────────────────

  describe "menu_button/1" do
    test "renders a button with title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="My Account" />
        """)

      assert html =~ "My Account"
      assert html =~ "<button"
      assert html =~ ~s(data-state="closed")
      assert html =~ ~s(data-menu-button-part="button")
    end

    test "renders phx-hook" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" />
        """)

      assert html =~ ~s(phx-hook="MaquinaMenuButton")
      assert html =~ ~s(id=")
    end

    test "renders subtitle when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" subtitle="admin@example.com" />
        """)

      assert html =~ "admin@example.com"
    end

    test "does not render subtitle when not provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" />
        """)

      refute html =~ "truncate text-xs"
    end

    test "renders text_icon when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" text_icon="AB" />
        """)

      assert html =~ "AB"
      assert html =~ "bg-sidebar-primary"
    end

    test "renders chevron when submenu is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" submenu={true} />
        """)

      assert html =~ "<svg"
    end

    test "does not render chevron when submenu is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" />
        """)

      refute html =~ "ml-auto"
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" submenu={true}>
          <div data-menu-button-part="content">
            <a href="/profile">Profile</a>
          </div>
        </.menu_button>
        """)

      assert html =~ ~s(href="/profile")
      assert html =~ "Profile"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menu_button title="Account" class="my-class" />
        """)

      assert html =~ "my-class"
    end
  end
end
