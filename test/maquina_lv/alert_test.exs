defmodule MaquinaLv.AlertTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Alert

  # ── alert/1 ──────────────────────────────────────────────────────────

  describe "alert/1" do
    test "renders a div with data-component='alert' and role='alert'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>content</.alert>
        """)

      assert html =~ ~s(data-component="alert")
      assert html =~ ~s(role="alert")
      assert html =~ "<div"
    end

    test "renders default variant by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>content</.alert>
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "renders destructive variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert variant={:destructive}>content</.alert>
        """)

      assert html =~ ~s(data-variant="destructive")
    end

    test "renders info variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert variant={:info}>content</.alert>
        """)

      assert html =~ ~s(data-variant="info")
    end

    test "renders warning variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert variant={:warning}>content</.alert>
        """)

      assert html =~ ~s(data-variant="warning")
    end

    test "renders success variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert variant={:success}>content</.alert>
        """)

      assert html =~ ~s(data-variant="success")
    end

    test "does not emit data-has-icon when icon is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>content</.alert>
        """)

      refute html =~ "data-has-icon"
    end

    test "emits data-has-icon when icon is set" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert icon={:info}>content</.alert>
        """)

      assert html =~ ~s(data-has-icon)
    end

    test "renders icon when icon is set" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert icon={:info}>content</.alert>
        """)

      assert html =~ "<svg"
    end

    test "does not render icon when icon is nil" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>content</.alert>
        """)

      refute html =~ "<svg"
    end

    test "wraps inner block content in a div" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert>
          <p>Alert content</p>
        </.alert>
        """)

      assert html =~ "<p>Alert content</p>"
      # The outer div is the alert, and inner content should be wrapped in another div
      assert html =~ ~s(data-component="alert")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert class="my-class">content</.alert>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert id="my-alert">content</.alert>
        """)

      assert html =~ ~s(id="my-alert")
    end
  end

  # ── alert_title/1 ────────────────────────────────────────────────────

  describe "alert_title/1" do
    test "renders a div with data-alert-part='title'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_title text="Title" />
        """)

      assert html =~ ~s(data-alert-part="title")
      assert html =~ "<div"
    end

    test "renders text attribute as content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_title text="Hello" />
        """)

      assert html =~ "Hello"
    end

    test "inner block takes priority over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_title text="Ignored">
          <span>Block wins</span>
        </.alert_title>
        """)

      assert html =~ "Block wins"
      refute html =~ "Ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_title text="T" class="bold" />
        """)

      assert html =~ ~s(class="bold")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_title text="T" id="ttl" />
        """)

      assert html =~ ~s(id="ttl")
    end
  end

  # ── alert_description/1 ─────────────────────────────────────────────

  describe "alert_description/1" do
    test "renders a div with data-alert-part='description'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_description text="Desc" />
        """)

      assert html =~ ~s(data-alert-part="description")
      assert html =~ "<div"
    end

    test "renders text attribute as content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_description text="Some desc" />
        """)

      assert html =~ "Some desc"
    end

    test "inner block takes priority over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_description text="Ignored">
          <em>Block wins</em>
        </.alert_description>
        """)

      assert html =~ "Block wins"
      refute html =~ "Ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_description class="muted" />
        """)

      assert html =~ ~s(class="muted")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert_description id="dsc" />
        """)

      assert html =~ ~s(id="dsc")
    end
  end

  # ── Full composition ────────────────────────────────────────────────

  describe "full alert composition" do
    test "all sub-components compose together correctly" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.alert variant={:destructive} icon={:circle_alert}>
          <.alert_title text="Error" />
          <.alert_description text="Your session has expired." />
        </.alert>
        """)

      assert html =~ ~s(data-component="alert")
      assert html =~ ~s(data-variant="destructive")
      assert html =~ ~s(data-has-icon)
      assert html =~ "<svg"
      assert html =~ ~s(data-alert-part="title")
      assert html =~ "Error"
      assert html =~ ~s(data-alert-part="description")
      assert html =~ "Your session has expired."
    end
  end
end
