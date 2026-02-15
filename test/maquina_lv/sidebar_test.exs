defmodule MaquinaLv.SidebarTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Sidebar

  # ── sidebar_provider/1 ─────────────────────────────────────────────

  describe "sidebar_provider/1" do
    test "renders root container with data-component" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_provider>
          <span>content</span>
        </.sidebar_provider>
        """)

      assert html =~ ~s(data-component="sidebar")
      assert html =~ ~s(phx-hook="MaquinaSidebar")
      assert html =~ "content"
    end

    test "renders with default values" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_provider>
          <span>content</span>
        </.sidebar_provider>
        """)

      assert html =~ ~s(data-sidebar-default-open="true")
      assert html =~ ~s(data-sidebar-open="true")
      assert html =~ ~s(data-sidebar-cookie-name="sidebar_state")
      assert html =~ ~s(data-sidebar-keyboard-shortcut="b")
      assert html =~ ~s(data-variant="inset")
    end

    test "renders with custom values" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_provider
          default_open={false}
          variant={:floating}
          cookie_name="my_sidebar"
          keyboard_shortcut="s"
        >
          <span>content</span>
        </.sidebar_provider>
        """)

      assert html =~ ~s(data-sidebar-default-open="false")
      assert html =~ ~s(data-variant="floating")
      assert html =~ ~s(data-sidebar-cookie-name="my_sidebar")
      assert html =~ ~s(data-sidebar-keyboard-shortcut="s")
    end
  end

  # ── sidebar/1 ──────────────────────────────────────────────────────

  describe "sidebar/1" do
    test "renders sidebar with default attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar>
          <span>sidebar content</span>
        </.sidebar>
        """)

      assert html =~ ~s(data-sidebar-part="root")
      assert html =~ ~s(data-state="collapsed")
      assert html =~ ~s(data-collapsible="offcanvas")
      assert html =~ ~s(data-variant="inset")
      assert html =~ ~s(data-side="left")
    end

    test "renders sidebar structural elements" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar>
          <span>content</span>
        </.sidebar>
        """)

      assert html =~ ~s(data-sidebar-part="gap")
      assert html =~ ~s(data-sidebar-part="backdrop")
      assert html =~ ~s(data-sidebar-part="container")
      assert html =~ ~s(data-sidebar-part="inner")
    end

    test "renders with expanded state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar state={:expanded}>
          <span>content</span>
        </.sidebar>
        """)

      assert html =~ ~s(data-state="expanded")
    end

    test "renders with icon collapsible" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar collapsible={:icon}>
          <span>content</span>
        </.sidebar>
        """)

      assert html =~ ~s(data-collapsible="icon")
    end

    test "renders on right side" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar side={:right}>
          <span>content</span>
        </.sidebar>
        """)

      assert html =~ ~s(data-side="right")
    end

    test "includes sidebar-loading class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar>
          <span>content</span>
        </.sidebar>
        """)

      assert html =~ "sidebar-loading"
    end
  end

  # ── sidebar_header/1 ───────────────────────────────────────────────

  describe "sidebar_header/1" do
    test "renders header section" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_header>
          Header content
        </.sidebar_header>
        """)

      assert html =~ ~s(data-sidebar-part="header")
      assert html =~ "Header content"
    end
  end

  # ── sidebar_content/1 ──────────────────────────────────────────────

  describe "sidebar_content/1" do
    test "renders content section" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_content>
          Main content
        </.sidebar_content>
        """)

      assert html =~ ~s(data-sidebar-part="content")
      assert html =~ "Main content"
    end
  end

  # ── sidebar_footer/1 ───────────────────────────────────────────────

  describe "sidebar_footer/1" do
    test "renders footer section" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_footer>
          Footer content
        </.sidebar_footer>
        """)

      assert html =~ ~s(data-sidebar-part="footer")
      assert html =~ "Footer content"
    end
  end

  # ── sidebar_group/1 ────────────────────────────────────────────────

  describe "sidebar_group/1" do
    test "renders group with title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_group title="Navigation">
          <span>items</span>
        </.sidebar_group>
        """)

      assert html =~ ~s(data-sidebar-part="group")
      assert html =~ ~s(data-sidebar-part="group-label")
      assert html =~ "Navigation"
    end

    test "renders group without title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_group>
          <span>items</span>
        </.sidebar_group>
        """)

      assert html =~ ~s(data-sidebar-part="group")
      refute html =~ ~s(data-sidebar-part="group-label")
    end
  end

  # ── sidebar_menu/1 ────────────────────────────────────────────────

  describe "sidebar_menu/1" do
    test "renders menu list" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu>
          <li>item</li>
        </.sidebar_menu>
        """)

      assert html =~ ~s(data-sidebar-part="menu")
      assert html =~ "<ul"
    end
  end

  # ── sidebar_menu_item/1 ───────────────────────────────────────────

  describe "sidebar_menu_item/1" do
    test "renders menu item" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_item>
          <span>content</span>
        </.sidebar_menu_item>
        """)

      assert html =~ ~s(data-sidebar-part="menu-item")
      assert html =~ "<li"
    end
  end

  # ── sidebar_menu_button/1 ─────────────────────────────────────────

  describe "sidebar_menu_button/1" do
    test "renders menu button with title and url" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_button title="Dashboard" url="/" />
        """)

      assert html =~ ~s(data-sidebar-part="menu-button")
      assert html =~ ~s(href="/")
      assert html =~ "Dashboard"
    end

    test "renders with icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_button title="Home" url="/" icon_name={:home} />
        """)

      assert html =~ "<svg"
      assert html =~ "Home"
    end

    test "renders with active state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_button title="Dashboard" url="/" active />
        """)

      assert html =~ ~s(data-active="true")
    end

    test "renders with size variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_button title="Item" url="/" size={:lg} />
        """)

      assert html =~ ~s(data-size="lg")
    end
  end

  # ── sidebar_menu_link/1 ───────────────────────────────────────────

  describe "sidebar_menu_link/1" do
    test "renders menu link with title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_link title="Admin" url="/admin" />
        """)

      assert html =~ ~s(data-sidebar-part="menu-link")
      assert html =~ ~s(href="/admin")
      assert html =~ "Admin"
    end

    test "renders with subtitle" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_link title="Admin" subtitle="admin@example.com" url="/admin" />
        """)

      assert html =~ "Admin"
      assert html =~ "admin@example.com"
    end

    test "renders with text icon (avatar)" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_link title="Admin" text_icon="A" url="/admin" />
        """)

      assert html =~ ~s(data-sidebar-part="menu-avatar")
      assert html =~ ">A</span>"
    end

    test "renders with active state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_menu_link title="Admin" url="/admin" active />
        """)

      assert html =~ ~s(data-active="true")
    end
  end

  # ── sidebar_trigger/1 ─────────────────────────────────────────────

  describe "sidebar_trigger/1" do
    test "renders trigger button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_trigger />
        """)

      assert html =~ ~s(data-sidebar-part="trigger")
      assert html =~ ~s(data-sidebar-action="toggle")
      assert html =~ "Toggle Sidebar"
      assert html =~ "<svg"
    end
  end

  # ── sidebar_inset/1 ───────────────────────────────────────────────

  describe "sidebar_inset/1" do
    test "renders inset main content area" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_inset>
          Main content
        </.sidebar_inset>
        """)

      assert html =~ ~s(data-sidebar-part="inset")
      assert html =~ "<main"
      assert html =~ "Main content"
    end
  end

  # ── composition ────────────────────────────────────────────────────

  describe "composition" do
    test "renders full sidebar layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.sidebar_provider>
          <.sidebar state={:expanded}>
            <.sidebar_header>
              <.sidebar_trigger />
            </.sidebar_header>
            <.sidebar_content>
              <.sidebar_group title="Menu">
                <.sidebar_menu>
                  <.sidebar_menu_item>
                    <.sidebar_menu_button title="Dashboard" url="/" icon_name={:home} active />
                  </.sidebar_menu_item>
                  <.sidebar_menu_item>
                    <.sidebar_menu_button title="Settings" url="/settings" icon_name={:settings} />
                  </.sidebar_menu_item>
                </.sidebar_menu>
              </.sidebar_group>
            </.sidebar_content>
            <.sidebar_footer>
              <.sidebar_menu_link title="Admin" subtitle="admin@test.com" text_icon="A" url="/admin" />
            </.sidebar_footer>
          </.sidebar>
          <.sidebar_inset>
            <p>Main content here</p>
          </.sidebar_inset>
        </.sidebar_provider>
        """)

      assert html =~ ~s(data-component="sidebar")
      assert html =~ ~s(data-sidebar-part="root")
      assert html =~ ~s(data-sidebar-part="header")
      assert html =~ ~s(data-sidebar-part="content")
      assert html =~ ~s(data-sidebar-part="footer")
      assert html =~ ~s(data-sidebar-part="menu")
      assert html =~ ~s(data-sidebar-part="inset")
      assert html =~ "Dashboard"
      assert html =~ "Settings"
      assert html =~ "Main content here"
    end
  end
end
