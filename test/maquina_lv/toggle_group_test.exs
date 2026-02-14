defmodule MaquinaLv.ToggleGroupTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.ToggleGroup

  # ── toggle_group/1 ───────────────────────────────────────────────────

  describe "toggle_group/1" do
    test "renders a div with data-component='toggle-group'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group>content</.toggle_group>
        """)

      assert html =~ ~s(data-component="toggle-group")
      assert html =~ ~s(role="group")
      assert html =~ "<div"
    end

    test "sets phx-hook" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group>content</.toggle_group>
        """)

      assert html =~ ~s(phx-hook="MaquinaToggleGroup")
      assert html =~ ~s(id=")
    end

    test "renders default variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group>content</.toggle_group>
        """)

      assert html =~ ~s(data-variant="default")
    end

    test "renders outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group variant={:outline}>content</.toggle_group>
        """)

      assert html =~ ~s(data-variant="outline")
    end

    test "renders default size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group>content</.toggle_group>
        """)

      assert html =~ ~s(data-size="default")
    end

    test "renders sm size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group size={:sm}>content</.toggle_group>
        """)

      assert html =~ ~s(data-size="sm")
    end

    test "renders lg size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group size={:lg}>content</.toggle_group>
        """)

      assert html =~ ~s(data-size="lg")
    end

    test "renders single type by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group>content</.toggle_group>
        """)

      assert html =~ ~s(data-type="single")
    end

    test "renders multiple type" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group type={:multiple}>content</.toggle_group>
        """)

      assert html =~ ~s(data-type="multiple")
    end

    test "renders disabled state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group disabled={true}>content</.toggle_group>
        """)

      assert html =~ ~s(aria-disabled="true")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group class="my-class">content</.toggle_group>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── toggle_group_item/1 ──────────────────────────────────────────────

  describe "toggle_group_item/1" do
    test "renders a button with data-toggle-group-part='item'" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold">B</.toggle_group_item>
        """)

      assert html =~ ~s(data-toggle-group-part="item")
      assert html =~ ~s(type="button")
      assert html =~ "<button"
      assert html =~ "B"
    end

    test "renders data-value attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold">B</.toggle_group_item>
        """)

      assert html =~ ~s(data-value="bold")
    end

    test "renders off state by default" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold">B</.toggle_group_item>
        """)

      assert html =~ ~s(data-state="off")
      assert html =~ ~s(aria-pressed="false")
    end

    test "renders on state when pressed" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold" pressed={true}>B</.toggle_group_item>
        """)

      assert html =~ ~s(data-state="on")
      assert html =~ ~s(aria-pressed="true")
    end

    test "renders disabled state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold" disabled={true}>B</.toggle_group_item>
        """)

      assert html =~ "disabled"
    end

    test "renders aria-label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold" aria_label="Toggle bold">B</.toggle_group_item>
        """)

      assert html =~ ~s(aria-label="Toggle bold")
    end

    test "passes class attribute through" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group_item value="bold" class="my-class">B</.toggle_group_item>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── toggle_group_simple/1 ────────────────────────────────────────────

  describe "toggle_group_simple/1" do
    test "renders toggle group with items from list" do
      assigns = %{
        items: [
          %{value: "left", label: "Left", aria_label: "Align left"},
          %{value: "center", label: "Center", aria_label: "Align center"},
          %{value: "right", label: "Right", aria_label: "Align right"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.toggle_group_simple items={@items} />
        """)

      assert html =~ ~s(data-component="toggle-group")
      assert html =~ "Left"
      assert html =~ "Center"
      assert html =~ "Right"
    end

    test "marks selected value as pressed" do
      assigns = %{
        items: [
          %{value: "bold", label: "B"},
          %{value: "italic", label: "I"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.toggle_group_simple items={@items} value="bold" />
        """)

      # The bold item should be pressed
      assert html =~ ~s(data-state="on")
    end

    test "renders items with icons" do
      assigns = %{
        items: [
          %{value: "left", icon: :align_left, aria_label: "Align left"},
          %{value: "center", icon: :align_center, aria_label: "Align center"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.toggle_group_simple items={@items} />
        """)

      assert html =~ "<svg"
    end

    test "passes variant and size through" do
      assigns = %{
        items: [%{value: "a", label: "A"}]
      }

      html =
        rendered_to_string(~H"""
        <.toggle_group_simple items={@items} variant={:outline} size={:sm} />
        """)

      assert html =~ ~s(data-variant="outline")
      assert html =~ ~s(data-size="sm")
    end

    test "supports multiple selection" do
      assigns = %{
        items: [
          %{value: "bold", label: "B"},
          %{value: "italic", label: "I"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.toggle_group_simple items={@items} type={:multiple} value={["bold", "italic"]} />
        """)

      assert html =~ ~s(data-type="multiple")
    end
  end

  # ── composition ──────────────────────────────────────────────────────

  describe "composition" do
    test "renders toggle group with items" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toggle_group type={:single} variant={:outline}>
          <.toggle_group_item value="bold" aria_label="Toggle bold">
            <strong>B</strong>
          </.toggle_group_item>
          <.toggle_group_item value="italic" aria_label="Toggle italic">
            <em>I</em>
          </.toggle_group_item>
        </.toggle_group>
        """)

      assert html =~ ~s(data-component="toggle-group")
      assert html =~ ~s(data-variant="outline")
      assert html =~ ~s(data-toggle-group-part="item")
      assert html =~ ~s(data-value="bold")
      assert html =~ ~s(data-value="italic")
      assert html =~ "<strong>B</strong>"
      assert html =~ "<em>I</em>"
    end
  end
end
