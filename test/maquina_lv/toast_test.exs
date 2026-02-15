defmodule MaquinaLv.ToastTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Toast

  # ── toaster/1 ────────────────────────────────────────────────────────

  describe "toaster/1" do
    test "renders a div with data-component='toaster'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster />
        """)

      assert html =~ ~s(data-component="toaster")
      assert html =~ ~s(id="toaster")
      assert html =~ ~s(phx-hook="MaquinaToaster")
      assert html =~ ~s(role="region")
      assert html =~ ~s(aria-label="Notifications")
    end

    test "renders default position" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster />
        """)

      assert html =~ ~s(data-position="bottom-right")
    end

    test "renders custom position" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster position={:top_center} />
        """)

      assert html =~ ~s(data-position="top-center")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster>
          <div>Toast here</div>
        </.toaster>
        """)

      assert html =~ "Toast here"
    end
  end

  # ── toast/1 ──────────────────────────────────────────────────────────

  describe "toast/1" do
    test "renders a div with data-component='toast'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" />
        """)

      assert html =~ ~s(data-component="toast")
      assert html =~ ~s(role="alert")
      assert html =~ ~s(phx-hook="MaquinaToast")
      assert html =~ ~s(data-state="entering")
    end

    test "renders default variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" />
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "renders success variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast variant={:success} title="Saved!" />
        """)

      assert html =~ ~s(data-variant="success")
    end

    test "renders error variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast variant={:error} title="Failed" />
        """)

      assert html =~ ~s(data-variant="error")
    end

    test "renders title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Important" />
        """)

      assert html =~ "Important"
      assert html =~ ~s(data-toast-part="title")
    end

    test "renders description" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Note" description="Some details" />
        """)

      assert html =~ "Some details"
      assert html =~ ~s(data-toast-part="description")
    end

    test "renders close button by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" />
        """)

      assert html =~ ~s(data-toast-part="close")
      assert html =~ ~s(aria-label="Dismiss notification")
    end

    test "does not render close button when dismissible is false" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" dismissible={false} />
        """)

      refute html =~ ~s(data-toast-part="close")
    end

    test "renders duration data attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" duration={10000} />
        """)

      assert html =~ ~s(data-duration="10000")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast title="Hello" class="my-class" />
        """)

      assert html =~ ~s(class="my-class")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast>
          <.toast_title text="Custom" />
          <.toast_description text="Desc" />
        </.toast>
        """)

      assert html =~ "Custom"
      assert html =~ "Desc"
    end
  end

  # ── toast_title/1 ────────────────────────────────────────────────────

  describe "toast_title/1" do
    test "renders a div with data-toast-part='title'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_title text="Title" />
        """)

      assert html =~ ~s(data-toast-part="title")
      assert html =~ "Title"
    end

    test "renders inner block over text" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_title text="ignored">Custom</.toast_title>
        """)

      assert html =~ "Custom"
      refute html =~ "ignored"
    end
  end

  # ── toast_description/1 ──────────────────────────────────────────────

  describe "toast_description/1" do
    test "renders a div with data-toast-part='description'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_description text="Details" />
        """)

      assert html =~ ~s(data-toast-part="description")
      assert html =~ "Details"
    end
  end

  # ── toast_action/1 ───────────────────────────────────────────────────

  describe "toast_action/1" do
    test "renders a button by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_action label="Retry" />
        """)

      assert html =~ ~s(data-toast-part="action")
      assert html =~ "<button"
      assert html =~ "Retry"
    end

    test "renders a link when href is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_action label="View" href="/details" />
        """)

      assert html =~ "<a"
      assert html =~ ~s(href="/details")
      assert html =~ "View"
    end
  end

  # ── flash_toasts/1 ──────────────────────────────────────────────────

  describe "flash_toasts/1" do
    test "renders toasts from flash" do
      assigns = %{flash: %{"info" => "Saved!", "error" => "Failed"}}

      html =
        rendered_to_string(~H"""
        <.flash_toasts flash={@flash} />
        """)

      assert html =~ "Saved!"
      assert html =~ "Failed"
      assert html =~ ~s(data-variant="success")
      assert html =~ ~s(data-variant="error")
    end

    test "renders nothing for empty flash" do
      assigns = %{flash: %{}}

      html =
        rendered_to_string(~H"""
        <.flash_toasts flash={@flash} />
        """)

      refute html =~ "data-component"
    end

    test "excludes specified flash keys" do
      assigns = %{flash: %{"info" => "Saved!", "error" => "Failed"}}

      html =
        rendered_to_string(~H"""
        <.flash_toasts flash={@flash} exclude={["error"]} />
        """)

      assert html =~ "Saved!"
      refute html =~ "Failed"
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders toaster with toasts" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster position={:top_right}>
          <.toast variant={:success} title="Profile updated" description="Your changes have been saved.">
            <.toast_action label="Undo" href="/undo" />
          </.toast>
        </.toaster>
        """)

      assert html =~ ~s(data-component="toaster")
      assert html =~ ~s(data-position="top-right")
      assert html =~ ~s(data-component="toast")
      assert html =~ ~s(data-variant="success")
      assert html =~ "Profile updated"
      assert html =~ "Your changes have been saved."
      assert html =~ ~s(data-toast-part="action")
      assert html =~ "Undo"
    end
  end
end
