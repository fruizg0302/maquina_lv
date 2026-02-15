defmodule MaquinaLv.DropdownMenuTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.DropdownMenu

  # ── dropdown_menu/1 ──────────────────────────────────────────────────

  describe "dropdown_menu/1" do
    test "renders a div with data-component='dropdown-menu'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu>content</.dropdown_menu>
        """)

      assert html =~ ~s(data-component="dropdown-menu")
      assert html =~ ~s(data-state="closed")
      assert html =~ ~s(phx-hook="MaquinaDropdownMenu")
      assert html =~ ~s(id=")
    end

    test "renders auto_close attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu auto_close={true}>content</.dropdown_menu>
        """)

      assert html =~ ~s(data-auto-close="true")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu class="my-class">content</.dropdown_menu>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── dropdown_menu_trigger/1 ──────────────────────────────────────────

  describe "dropdown_menu_trigger/1" do
    test "renders a button with trigger part" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_trigger>Options</.dropdown_menu_trigger>
        """)

      assert html =~ ~s(data-dropdown-menu-part="trigger")
      assert html =~ ~s(aria-haspopup="menu")
      assert html =~ ~s(aria-expanded="false")
      assert html =~ "<button"
      assert html =~ "Options"
    end

    test "renders with default variant and size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_trigger>Options</.dropdown_menu_trigger>
        """)

      assert html =~ ~s(data-variant="outline")
      assert html =~ ~s(data-size="default")
    end

    test "renders with custom variant and size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_trigger variant={:ghost} size={:icon}>
          ...
        </.dropdown_menu_trigger>
        """)

      assert html =~ ~s(data-variant="ghost")
      assert html =~ ~s(data-size="icon")
    end

    test "renders only inner content when as_child is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_trigger as_child={true}>
          <span>Custom trigger</span>
        </.dropdown_menu_trigger>
        """)

      assert html =~ "Custom trigger"
      refute html =~ ~s(data-dropdown-menu-part="trigger")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_trigger class="my-class">Options</.dropdown_menu_trigger>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── dropdown_menu_content/1 ──────────────────────────────────────────

  describe "dropdown_menu_content/1" do
    test "renders a div with content part" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_content>items</.dropdown_menu_content>
        """)

      assert html =~ ~s(data-dropdown-menu-part="content")
      assert html =~ ~s(role="menu")
      assert html =~ ~s(tabindex="-1")
      assert html =~ "hidden"
      assert html =~ ~s(data-state="closed")
    end

    test "renders default alignment and side" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_content>items</.dropdown_menu_content>
        """)

      assert html =~ ~s(data-align="start")
      assert html =~ ~s(data-side="bottom")
    end

    test "renders custom alignment and side" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_content align={:end} side={:top} width={:md}>items</.dropdown_menu_content>
        """)

      assert html =~ ~s(data-align="end")
      assert html =~ ~s(data-side="top")
      assert html =~ ~s(data-width="md")
    end
  end

  # ── dropdown_menu_item/1 ─────────────────────────────────────────────

  describe "dropdown_menu_item/1" do
    test "renders a button by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item>Edit</.dropdown_menu_item>
        """)

      assert html =~ ~s(data-dropdown-menu-part="item")
      assert html =~ ~s(role="menuitem")
      assert html =~ "<button"
      assert html =~ "Edit"
    end

    test "renders a link when href is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item href="/edit">Edit</.dropdown_menu_item>
        """)

      assert html =~ "<a"
      assert html =~ ~s(href="/edit")
      assert html =~ ~s(role="menuitem")
    end

    test "renders destructive variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item variant={:destructive}>Delete</.dropdown_menu_item>
        """)

      assert html =~ ~s(data-variant="destructive")
    end

    test "does not render data-variant for default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item>Edit</.dropdown_menu_item>
        """)

      refute html =~ "data-variant"
    end

    test "renders disabled state on button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item disabled={true}>Edit</.dropdown_menu_item>
        """)

      assert html =~ "disabled"
    end

    test "renders disabled state on link" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item href="/edit" disabled={true}>Edit</.dropdown_menu_item>
        """)

      assert html =~ ~s(aria-disabled="true")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_item class="my-class">Edit</.dropdown_menu_item>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── dropdown_menu_label/1 ────────────────────────────────────────────

  describe "dropdown_menu_label/1" do
    test "renders a div with label part" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_label text="Actions" />
        """)

      assert html =~ ~s(data-dropdown-menu-part="label")
      assert html =~ "Actions"
    end

    test "renders inner block over text" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_label text="ignored">Custom</.dropdown_menu_label>
        """)

      assert html =~ "Custom"
      refute html =~ "ignored"
    end

    test "renders inset" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_label text="Title" inset={true} />
        """)

      assert html =~ ~s(data-inset="true")
    end
  end

  # ── dropdown_menu_separator/1 ────────────────────────────────────────

  describe "dropdown_menu_separator/1" do
    test "renders a separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_separator />
        """)

      assert html =~ ~s(data-dropdown-menu-part="separator")
      assert html =~ ~s(role="separator")
    end
  end

  # ── dropdown_menu_group/1 ────────────────────────────────────────────

  describe "dropdown_menu_group/1" do
    test "renders a group container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_group>items</.dropdown_menu_group>
        """)

      assert html =~ ~s(data-dropdown-menu-part="group")
      assert html =~ ~s(role="group")
    end
  end

  # ── dropdown_menu_shortcut/1 ─────────────────────────────────────────

  describe "dropdown_menu_shortcut/1" do
    test "renders a shortcut span" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu_shortcut text="⌘K" />
        """)

      assert html =~ ~s(data-dropdown-menu-part="shortcut")
      assert html =~ "⌘K"
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders full dropdown menu" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.dropdown_menu>
          <.dropdown_menu_trigger>Options</.dropdown_menu_trigger>
          <.dropdown_menu_content align={:end}>
            <.dropdown_menu_label text="Actions" />
            <.dropdown_menu_group>
              <.dropdown_menu_item href="/edit">
                Edit <.dropdown_menu_shortcut text="⌘E" />
              </.dropdown_menu_item>
            </.dropdown_menu_group>
            <.dropdown_menu_separator />
            <.dropdown_menu_item variant={:destructive}>Delete</.dropdown_menu_item>
          </.dropdown_menu_content>
        </.dropdown_menu>
        """)

      assert html =~ ~s(data-component="dropdown-menu")
      assert html =~ ~s(data-dropdown-menu-part="trigger")
      assert html =~ ~s(data-dropdown-menu-part="content")
      assert html =~ ~s(data-dropdown-menu-part="label")
      assert html =~ ~s(data-dropdown-menu-part="group")
      assert html =~ ~s(data-dropdown-menu-part="item")
      assert html =~ ~s(data-dropdown-menu-part="separator")
      assert html =~ ~s(data-dropdown-menu-part="shortcut")
      assert html =~ "Options"
      assert html =~ "Edit"
      assert html =~ "Delete"
    end
  end
end
