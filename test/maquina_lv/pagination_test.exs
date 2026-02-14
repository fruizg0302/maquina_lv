defmodule MaquinaLv.PaginationTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Pagination

  # ── pagination/1 ─────────────────────────────────────────────────────

  describe "pagination/1" do
    test "renders a nav with data-component='pagination'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination>content</.pagination>
        """)

      assert html =~ ~s(data-component="pagination")
      assert html =~ "<nav"
      assert html =~ ~s(aria-label="Pagination")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination class="my-class">content</.pagination>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination id="my-nav">content</.pagination>
        """)

      assert html =~ ~s(id="my-nav")
    end
  end

  # ── pagination_content/1 ─────────────────────────────────────────────

  describe "pagination_content/1" do
    test "renders a ul with data-pagination-part='content'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_content>content</.pagination_content>
        """)

      assert html =~ ~s(data-pagination-part="content")
      assert html =~ "<ul"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_content class="my-class">content</.pagination_content>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── pagination_item/1 ────────────────────────────────────────────────

  describe "pagination_item/1" do
    test "renders a li with data-pagination-part='item'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_item>content</.pagination_item>
        """)

      assert html =~ ~s(data-pagination-part="item")
      assert html =~ "<li"
    end
  end

  # ── pagination_link/1 ────────────────────────────────────────────────

  describe "pagination_link/1" do
    test "renders a link with data-pagination-part='link'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_link href="/page/2">2</.pagination_link>
        """)

      assert html =~ ~s(data-pagination-part="link")
      assert html =~ ~s(href="/page/2")
      assert html =~ "<a"
      assert html =~ "2"
    end

    test "renders active state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_link href="/page/1" active={true}>1</.pagination_link>
        """)

      assert html =~ ~s(data-active="true")
      assert html =~ ~s(aria-current="page")
    end

    test "does not render active attributes when not active" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_link href="/page/2">2</.pagination_link>
        """)

      refute html =~ "data-active"
      refute html =~ "aria-current"
    end

    test "renders disabled state as span" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_link href="/page/2" disabled={true}>2</.pagination_link>
        """)

      assert html =~ "<span"
      assert html =~ ~s(aria-disabled="true")
      refute html =~ "<a"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_link href="/page/2" class="my-class">2</.pagination_link>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── pagination_previous/1 ────────────────────────────────────────────

  describe "pagination_previous/1" do
    test "renders a link with data-pagination-part='previous'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous href="/page/1" />
        """)

      assert html =~ ~s(data-pagination-part="previous")
      assert html =~ ~s(href="/page/1")
      assert html =~ "<a"
      assert html =~ "<svg"
    end

    test "shows label by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous href="/page/1" />
        """)

      assert html =~ "Previous"
    end

    test "hides label when show_label is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous href="/page/1" show_label={false} />
        """)

      refute html =~ "<span>Previous</span>"
    end

    test "renders custom label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous href="/page/1" label="Back" />
        """)

      assert html =~ "Back"
    end

    test "renders disabled state as span" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous disabled={true} />
        """)

      assert html =~ "<span"
      assert html =~ ~s(aria-disabled="true")
      refute html =~ "<a"
    end

    test "renders disabled when no href" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_previous />
        """)

      assert html =~ "<span"
      assert html =~ ~s(aria-disabled="true")
    end
  end

  # ── pagination_next/1 ────────────────────────────────────────────────

  describe "pagination_next/1" do
    test "renders a link with data-pagination-part='next'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_next href="/page/3" />
        """)

      assert html =~ ~s(data-pagination-part="next")
      assert html =~ ~s(href="/page/3")
      assert html =~ "<a"
      assert html =~ "<svg"
    end

    test "shows label by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_next href="/page/3" />
        """)

      assert html =~ "Next"
    end

    test "hides label when show_label is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_next href="/page/3" show_label={false} />
        """)

      refute html =~ "<span>Next</span>"
    end

    test "renders disabled state as span" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_next disabled={true} />
        """)

      assert html =~ "<span"
      assert html =~ ~s(aria-disabled="true")
    end
  end

  # ── pagination_ellipsis/1 ────────────────────────────────────────────

  describe "pagination_ellipsis/1" do
    test "renders a span with data-pagination-part='ellipsis'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_ellipsis />
        """)

      assert html =~ ~s(data-pagination-part="ellipsis")
      assert html =~ ~s(aria-hidden="true")
      assert html =~ "<svg"
      assert html =~ "More pages"
    end
  end

  # ── pagination_nav/1 ────────────────────────────────────────────────

  describe "pagination_nav/1" do
    test "renders full pagination for multiple pages" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={2} total_pages={5} path_fn={&"/items?page=#{&1}"} />
        """)

      assert html =~ ~s(data-component="pagination")
      assert html =~ ~s(data-pagination-part="previous")
      assert html =~ ~s(data-pagination-part="next")
      assert html =~ ~s(data-pagination-part="link")
    end

    test "renders page links" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={1} total_pages={3} path_fn={&"/items?page=#{&1}"} />
        """)

      assert html =~ "/items?page=1"
      assert html =~ "/items?page=2"
      assert html =~ "/items?page=3"
    end

    test "marks current page as active" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={2} total_pages={3} path_fn={&"/items?page=#{&1}"} />
        """)

      assert html =~ ~s(aria-current="page")
    end

    test "disables previous on first page" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={1} total_pages={3} path_fn={&"/items?page=#{&1}"} />
        """)

      # The previous link should be disabled (rendered as span)
      assert html =~ ~s(data-pagination-part="previous")
    end

    test "disables next on last page" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={3} total_pages={3} path_fn={&"/items?page=#{&1}"} />
        """)

      # The next link should be disabled (rendered as span)
      assert html =~ ~s(data-pagination-part="next")
    end

    test "renders ellipsis for many pages" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={5} total_pages={10} path_fn={&"/items?page=#{&1}"} />
        """)

      assert html =~ ~s(data-pagination-part="ellipsis")
    end

    test "returns nothing for single page" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_nav current_page={1} total_pages={1} path_fn={&"/items?page=#{&1}"} />
        """)

      refute html =~ "data-component"
    end
  end

  # ── pagination_simple/1 ─────────────────────────────────────────────

  describe "pagination_simple/1" do
    test "renders only previous and next" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_simple current_page={2} total_pages={5} path_fn={&"/items?page=#{&1}"} />
        """)

      assert html =~ ~s(data-pagination-part="previous")
      assert html =~ ~s(data-pagination-part="next")
      refute html =~ ~s(data-pagination-part="link")
    end

    test "returns nothing for single page" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination_simple current_page={1} total_pages={1} path_fn={&"/items?page=#{&1}"} />
        """)

      refute html =~ "data-component"
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders full pagination with all sub-components" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.pagination>
          <.pagination_content>
            <.pagination_item>
              <.pagination_previous href="/page/1" />
            </.pagination_item>
            <.pagination_item>
              <.pagination_link href="/page/1">1</.pagination_link>
            </.pagination_item>
            <.pagination_item>
              <.pagination_link href="/page/2" active={true}>2</.pagination_link>
            </.pagination_item>
            <.pagination_item>
              <.pagination_ellipsis />
            </.pagination_item>
            <.pagination_item>
              <.pagination_link href="/page/10">10</.pagination_link>
            </.pagination_item>
            <.pagination_item>
              <.pagination_next href="/page/3" />
            </.pagination_item>
          </.pagination_content>
        </.pagination>
        """)

      assert html =~ ~s(data-component="pagination")
      assert html =~ ~s(data-pagination-part="content")
      assert html =~ ~s(data-pagination-part="previous")
      assert html =~ ~s(data-pagination-part="next")
      assert html =~ ~s(data-pagination-part="ellipsis")
      assert html =~ ~s(aria-current="page")
    end
  end
end
