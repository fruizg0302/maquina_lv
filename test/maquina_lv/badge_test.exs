defmodule MaquinaLv.BadgeTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Badge

  # ── badge/1 ──────────────────────────────────────────────────────────

  describe "badge/1" do
    test "renders a span with data-component='badge'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Status</.badge>
        """)

      assert html =~ "<span"
      assert html =~ ~s(data-component="badge")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Active</.badge>
        """)

      assert html =~ "Active"
    end

    # ── variant ──────────────────────────────────────────────────────

    test "emits data-variant='default' by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Status</.badge>
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "emits data-variant='default' when variant is explicitly :default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:default}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "emits data-variant='secondary' when variant is :secondary" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:secondary}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="secondary")
    end

    test "emits data-variant='destructive' when variant is :destructive" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:destructive}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="destructive")
    end

    test "emits data-variant='outline' when variant is :outline" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:outline}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="outline")
    end

    test "emits data-variant='success' when variant is :success" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:success}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="success")
    end

    test "emits data-variant='warning' when variant is :warning" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:warning}>Status</.badge>
        """)

      assert html =~ ~s(data-variant="warning")
    end

    # ── size ─────────────────────────────────────────────────────────

    test "emits data-size='md' by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Status</.badge>
        """)

      assert html =~ ~s(data-size="md")
    end

    test "emits data-size='md' when size is explicitly :md" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge size={:md}>Status</.badge>
        """)

      assert html =~ ~s(data-size="md")
    end

    test "emits data-size='sm' when size is :sm" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge size={:sm}>Status</.badge>
        """)

      assert html =~ ~s(data-size="sm")
    end

    test "emits data-size='lg' when size is :lg" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge size={:lg}>Status</.badge>
        """)

      assert html =~ ~s(data-size="lg")
    end

    # ── class ────────────────────────────────────────────────────────

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge class="my-class">Status</.badge>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "renders empty class attribute when class is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge>Status</.badge>
        """)

      # Phoenix renders class="" for nil class values; this is harmless
      assert html =~ ~s(class="")
    end

    # ── global attributes ────────────────────────────────────────────

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge id="my-badge">Status</.badge>
        """)

      assert html =~ ~s(id="my-badge")
    end

    # ── combined attributes ──────────────────────────────────────────

    test "renders with all attributes combined" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.badge variant={:success} size={:sm} class="extra" id="badge-1">
          Active
        </.badge>
        """)

      assert html =~ "<span"
      assert html =~ ~s(data-component="badge")
      assert html =~ ~s(data-variant="success")
      assert html =~ ~s(data-size="sm")
      assert html =~ ~s(class="extra")
      assert html =~ ~s(id="badge-1")
      assert html =~ "Active"
    end
  end
end
