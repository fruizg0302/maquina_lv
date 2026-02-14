defmodule MaquinaLv.EmptyTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Empty


  # ── empty/1 ──────────────────────────────────────────────────────────

  describe "empty/1" do
    test "renders a div with data-component='empty'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>content</.empty>
        """)

      assert html =~ ~s(data-component="empty")
      assert html =~ "<div"
    end

    test "renders default variant by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>content</.empty>
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "renders outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty variant={:outline}>content</.empty>
        """)

      assert html =~ ~s(data-variant="outline")
    end

    test "renders default size by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>content</.empty>
        """)

      assert html =~ ~s(data-size="default")
    end

    test "renders compact size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty size={:compact}>content</.empty>
        """)

      assert html =~ ~s(data-size="compact")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty class="my-class">content</.empty>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty id="my-empty">content</.empty>
        """)

      assert html =~ ~s(id="my-empty")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>
          <p>Empty content</p>
        </.empty>
        """)

      assert html =~ "<p>Empty content</p>"
    end
  end

  # ── empty_header/1 ───────────────────────────────────────────────────

  describe "empty_header/1" do
    test "renders a div with data-empty-part='header'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_header>content</.empty_header>
        """)

      assert html =~ ~s(data-empty-part="header")
      assert html =~ "<div"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_header class="my-class">content</.empty_header>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_header id="my-header">content</.empty_header>
        """)

      assert html =~ ~s(id="my-header")
    end
  end

  # ── empty_media/1 ────────────────────────────────────────────────────

  describe "empty_media/1" do
    test "renders a div with data-empty-part='media'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media>content</.empty_media>
        """)

      assert html =~ ~s(data-empty-part="media")
      assert html =~ "<div"
    end

    test "renders icon variant by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media>content</.empty_media>
        """)

      assert html =~ ~s(data-variant="icon")
    end

    test "renders avatar variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media variant={:avatar}>content</.empty_media>
        """)

      assert html =~ ~s(data-variant="avatar")
    end

    test "renders icon when icon attr is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media icon={:search} />
        """)

      assert html =~ "<svg"
    end

    test "renders inner block when no icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media>
          <img src="avatar.png" />
        </.empty_media>
        """)

      assert html =~ ~s(src="avatar.png")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media class="my-class">content</.empty_media>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── empty_title/1 ────────────────────────────────────────────────────

  describe "empty_title/1" do
    test "renders an h3 with data-empty-part='title'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_title text="No items" />
        """)

      assert html =~ ~s(data-empty-part="title")
      assert html =~ "<h3"
      assert html =~ "No items"
    end

    test "renders inner block over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_title text="ignored">
          <span>Custom title</span>
        </.empty_title>
        """)

      assert html =~ "Custom title"
      refute html =~ "ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_title text="Title" class="my-class" />
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_title text="Title" id="my-title" />
        """)

      assert html =~ ~s(id="my-title")
    end
  end

  # ── empty_description/1 ──────────────────────────────────────────────

  describe "empty_description/1" do
    test "renders a p with data-empty-part='description'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_description text="Some description" />
        """)

      assert html =~ ~s(data-empty-part="description")
      assert html =~ "<p"
      assert html =~ "Some description"
    end

    test "renders inner block over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_description text="ignored">
          <span>Custom description</span>
        </.empty_description>
        """)

      assert html =~ "Custom description"
      refute html =~ "ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_description text="Desc" class="my-class" />
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── empty_content/1 ──────────────────────────────────────────────────

  describe "empty_content/1" do
    test "renders a div with data-empty-part='content'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_content>
          <button>Action</button>
        </.empty_content>
        """)

      assert html =~ ~s(data-empty-part="content")
      assert html =~ "<div"
      assert html =~ "<button>Action</button>"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_content class="my-class">content</.empty_content>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_content id="my-content">content</.empty_content>
        """)

      assert html =~ ~s(id="my-content")
    end
  end

  # ── empty_search_state/1 ─────────────────────────────────────────────

  describe "empty_search_state/1" do
    test "renders empty state with search icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state />
        """)

      assert html =~ ~s(data-component="empty")
      assert html =~ "No results"
      assert html =~ "<svg"
    end

    test "includes query in description when provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state query="foobar" />
        """)

      assert html =~ "foobar"
      assert html =~ "No results"
    end

    test "renders generic description when no query" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state />
        """)

      assert html =~ "No results found"
    end

    test "renders reset link when reset_path is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state reset_path="/search" />
        """)

      assert html =~ ~s(href="/search")
      assert html =~ "Clear search"
    end

    test "does not render reset link when no reset_path" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state />
        """)

      refute html =~ "Clear search"
    end

    test "passes size through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_search_state size={:compact} />
        """)

      assert html =~ ~s(data-size="compact")
    end
  end

  # ── empty_list_state/1 ───────────────────────────────────────────────

  describe "empty_list_state/1" do
    test "renders empty state with resource name" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="projects" />
        """)

      assert html =~ ~s(data-component="empty")
      assert html =~ "No projects yet"
    end

    test "renders default icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="projects" />
        """)

      assert html =~ "<svg"
    end

    test "renders custom icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="users" icon={:users} />
        """)

      assert html =~ "<svg"
    end

    test "renders new link when new_path is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="projects" new_path="/projects/new" />
        """)

      assert html =~ ~s(href="/projects/new")
      assert html =~ "Create"
    end

    test "does not render new link when no new_path" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="projects" />
        """)

      refute html =~ "Create"
    end

    test "passes size through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_list_state resource_name="projects" size={:compact} />
        """)

      assert html =~ ~s(data-size="compact")
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders full empty state with all sub-components" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty variant={:outline} size={:compact}>
          <.empty_header>
            <.empty_media icon={:search} />
            <.empty_title text="No results found" />
            <.empty_description text="Try adjusting your search." />
          </.empty_header>
          <.empty_content>
            <a href="/reset">Reset</a>
          </.empty_content>
        </.empty>
        """)

      assert html =~ ~s(data-component="empty")
      assert html =~ ~s(data-variant="outline")
      assert html =~ ~s(data-size="compact")
      assert html =~ ~s(data-empty-part="header")
      assert html =~ ~s(data-empty-part="media")
      assert html =~ ~s(data-empty-part="title")
      assert html =~ ~s(data-empty-part="description")
      assert html =~ ~s(data-empty-part="content")
      assert html =~ "No results found"
      assert html =~ "Try adjusting your search."
      assert html =~ "Reset"
    end
  end
end
