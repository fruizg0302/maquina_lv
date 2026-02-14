defmodule MaquinaLv.FormTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Form

  # ── form_group/1 ─────────────────────────────────────────────────────

  describe "form_group/1" do
    test "renders a div with data-form-part='group'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group>content</.form_group>
        """)

      assert html =~ ~s(data-form-part="group")
      assert html =~ "<div"
    end

    test "does not render data-layout for default layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group>content</.form_group>
        """)

      refute html =~ "data-layout"
    end

    test "renders inline layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group layout={:inline}>content</.form_group>
        """)

      assert html =~ ~s(data-layout="inline")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group class="my-class">content</.form_group>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group id="my-group">content</.form_group>
        """)

      assert html =~ ~s(id="my-group")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group>
          <label>Name</label>
          <input type="text" />
        </.form_group>
        """)

      assert html =~ "<label>Name</label>"
      assert html =~ "<input"
    end
  end

  # ── form_label/1 ─────────────────────────────────────────────────────

  describe "form_label/1" do
    test "renders a label with data-component='label'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label>Name</.form_label>
        """)

      assert html =~ ~s(data-component="label")
      assert html =~ "<label"
    end

    test "renders for attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label for="name-input">Name</.form_label>
        """)

      assert html =~ ~s(for="name-input")
    end

    test "does not render data-required by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label>Name</.form_label>
        """)

      refute html =~ "data-required"
    end

    test "renders data-required when required is true" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label required={true}>Name</.form_label>
        """)

      assert html =~ "data-required"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label class="my-class">Name</.form_label>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label id="my-label">Name</.form_label>
        """)

      assert html =~ ~s(id="my-label")
    end

    test "renders inner block content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_label>
          <span>Email</span>
        </.form_label>
        """)

      assert html =~ "<span>Email</span>"
    end
  end

  # ── form_description/1 ───────────────────────────────────────────────

  describe "form_description/1" do
    test "renders a p with data-form-part='description'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_description>Help text</.form_description>
        """)

      assert html =~ ~s(data-form-part="description")
      assert html =~ "<p"
      assert html =~ "Help text"
    end

    test "renders text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_description text="Enter your name" />
        """)

      assert html =~ "Enter your name"
    end

    test "renders inner block over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_description text="ignored">
          <span>Custom help</span>
        </.form_description>
        """)

      assert html =~ "Custom help"
      refute html =~ "ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_description class="my-class">text</.form_description>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_description id="my-desc">text</.form_description>
        """)

      assert html =~ ~s(id="my-desc")
    end
  end

  # ── form_error/1 ─────────────────────────────────────────────────────

  describe "form_error/1" do
    test "renders a p with data-form-part='error'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_error>can't be blank</.form_error>
        """)

      assert html =~ ~s(data-form-part="error")
      assert html =~ "<p"
      assert html =~ "can't be blank"
    end

    test "renders text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_error text="is required" />
        """)

      assert html =~ "is required"
    end

    test "renders inner block over text attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_error text="ignored">
          <span>Custom error</span>
        </.form_error>
        """)

      assert html =~ "Custom error"
      refute html =~ "ignored"
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_error class="my-class">error</.form_error>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_error id="my-error">error</.form_error>
        """)

      assert html =~ ~s(id="my-error")
    end
  end

  # ── form_actions/1 ───────────────────────────────────────────────────

  describe "form_actions/1" do
    test "renders a div with data-form-part='actions'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions>
          <button>Submit</button>
        </.form_actions>
        """)

      assert html =~ ~s(data-form-part="actions")
      assert html =~ "<div"
      assert html =~ "<button>Submit</button>"
    end

    test "does not render data-align for default align" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions>content</.form_actions>
        """)

      refute html =~ "data-align"
    end

    test "renders end alignment" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions align={:end}>content</.form_actions>
        """)

      assert html =~ ~s(data-align="end")
    end

    test "renders between alignment" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions align={:between}>content</.form_actions>
        """)

      assert html =~ ~s(data-align="between")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions class="my-class">content</.form_actions>
        """)

      assert html =~ ~s(class="my-class")
    end

    test "passes global attributes through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_actions id="my-actions">content</.form_actions>
        """)

      assert html =~ ~s(id="my-actions")
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders full form group with all sub-components" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.form_group>
          <.form_label for="email" required={true}>Email</.form_label>
          <input type="email" id="email" data-component="input" />
          <.form_description text="We'll never share your email." />
          <.form_error text="is required" />
        </.form_group>
        """)

      assert html =~ ~s(data-form-part="group")
      assert html =~ ~s(data-component="label")
      assert html =~ ~s(data-form-part="description")
      assert html =~ ~s(data-form-part="error")
      assert html =~ "Email"
      assert html =~ "We&#39;ll never share your email."
      assert html =~ "is required"
    end
  end
end
