defmodule MaquinaLv.BreadcrumbsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Breadcrumbs

  # ── breadcrumbs/1 ────────────────────────────────────────────────────

  describe "breadcrumbs/1" do
    test "renders a nav with data-component='breadcrumbs'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs>content</.breadcrumbs>
        """)

      assert html =~ ~s(data-component="breadcrumbs")
      assert html =~ "<nav"
      assert html =~ ~s(aria-label="Breadcrumb")
    end

    test "adds phx-hook when responsive is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs responsive={true}>content</.breadcrumbs>
        """)

      assert html =~ ~s(phx-hook="MaquinaBreadcrumb")
      assert html =~ ~s(id=")
    end

    test "does not add phx-hook when responsive is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs>content</.breadcrumbs>
        """)

      refute html =~ "phx-hook"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs class="my-class">content</.breadcrumbs>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs id="my-nav">content</.breadcrumbs>
        """)

      assert html =~ ~s(id="my-nav")
    end
  end

  # ── breadcrumbs_list/1 ───────────────────────────────────────────────

  describe "breadcrumbs_list/1" do
    test "renders an ol with data-breadcrumb-part='list'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_list>content</.breadcrumbs_list>
        """)

      assert html =~ ~s(data-breadcrumb-part="list")
      assert html =~ "<ol"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_list class="my-class">content</.breadcrumbs_list>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── breadcrumbs_item/1 ───────────────────────────────────────────────

  describe "breadcrumbs_item/1" do
    test "renders a li with data-breadcrumb-part='item'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_item>content</.breadcrumbs_item>
        """)

      assert html =~ ~s(data-breadcrumb-part="item")
      assert html =~ "<li"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_item class="my-class">content</.breadcrumbs_item>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── breadcrumbs_link/1 ───────────────────────────────────────────────

  describe "breadcrumbs_link/1" do
    test "renders a link with data-breadcrumb-part='link'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_link href="/home">Home</.breadcrumbs_link>
        """)

      assert html =~ ~s(data-breadcrumb-part="link")
      assert html =~ ~s(href="/home")
      assert html =~ "<a"
      assert html =~ "Home"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_link href="/home" class="my-class">Home</.breadcrumbs_link>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── breadcrumbs_page/1 ──────────────────────────────────────────────

  describe "breadcrumbs_page/1" do
    test "renders a span with data-breadcrumb-part='page'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_page>Current</.breadcrumbs_page>
        """)

      assert html =~ ~s(data-breadcrumb-part="page")
      assert html =~ "<span"
      assert html =~ ~s(aria-current="page")
      assert html =~ "Current"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_page class="my-class">Current</.breadcrumbs_page>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── breadcrumbs_separator/1 ──────────────────────────────────────────

  describe "breadcrumbs_separator/1" do
    test "renders a li with data-breadcrumb-part='separator'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_separator />
        """)

      assert html =~ ~s(data-breadcrumb-part="separator")
      assert html =~ "<li"
      assert html =~ ~s(role="presentation")
      assert html =~ ~s(aria-hidden="true")
    end

    test "renders default chevron_right icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_separator />
        """)

      assert html =~ "<svg"
    end

    test "renders custom content when icon is :custom" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_separator icon={:custom}>/</.breadcrumbs_separator>
        """)

      assert html =~ "/"
    end
  end

  # ── breadcrumbs_ellipsis/1 ──────────────────────────────────────────

  describe "breadcrumbs_ellipsis/1" do
    test "renders a span with data-breadcrumb-part='ellipsis'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs_ellipsis />
        """)

      assert html =~ ~s(data-breadcrumb-part="ellipsis")
      assert html =~ ~s(role="presentation")
      assert html =~ "<svg"
      assert html =~ "More"
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders full breadcrumbs with all sub-components" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.breadcrumbs>
          <.breadcrumbs_list>
            <.breadcrumbs_item>
              <.breadcrumbs_link href="/">Home</.breadcrumbs_link>
            </.breadcrumbs_item>
            <.breadcrumbs_separator />
            <.breadcrumbs_item>
              <.breadcrumbs_link href="/projects">Projects</.breadcrumbs_link>
            </.breadcrumbs_item>
            <.breadcrumbs_separator />
            <.breadcrumbs_item>
              <.breadcrumbs_page>Current Project</.breadcrumbs_page>
            </.breadcrumbs_item>
          </.breadcrumbs_list>
        </.breadcrumbs>
        """)

      assert html =~ ~s(data-component="breadcrumbs")
      assert html =~ ~s(data-breadcrumb-part="list")
      assert html =~ ~s(data-breadcrumb-part="item")
      assert html =~ ~s(data-breadcrumb-part="link")
      assert html =~ ~s(data-breadcrumb-part="separator")
      assert html =~ ~s(data-breadcrumb-part="page")
      assert html =~ "Home"
      assert html =~ "Projects"
      assert html =~ "Current Project"
    end
  end
end
