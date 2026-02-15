defmodule MaquinaLv.ComboboxTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Combobox

  # ── combobox/1 ──────────────────────────────────────────────────────

  describe "combobox/1" do
    test "renders root container with data-component" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox>
          <span>content</span>
        </.combobox>
        """)

      assert html =~ ~s(data-component="combobox")
      assert html =~ ~s(phx-hook="MaquinaCombobox")
      assert html =~ "content"
    end

    test "renders with name and value" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox name="framework" value="nextjs">
          <span>content</span>
        </.combobox>
        """)

      assert html =~ ~s(data-combobox-name="framework")
      assert html =~ ~s(data-combobox-value="nextjs")
    end

    test "renders with placeholder" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox placeholder="Choose...">
          <span>content</span>
        </.combobox>
        """)

      assert html =~ ~s(data-combobox-placeholder="Choose...")
    end

    test "passes class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox class="my-class">
          <span>content</span>
        </.combobox>
        """)

      assert html =~ ~s(class="my-class")
    end
  end

  # ── combobox_trigger/1 ─────────────────────────────────────────────

  describe "combobox_trigger/1" do
    test "renders trigger button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_trigger for_id="combo-1" />
        """)

      assert html =~ ~s(data-combobox-part="trigger")
      assert html =~ ~s(popovertarget="combo-1")
      assert html =~ ~s(role="combobox")
      assert html =~ ~s(aria-expanded="false")
      assert html =~ ~s(aria-haspopup="listbox")
      assert html =~ ~s(aria-controls="combo-1")
    end

    test "renders placeholder text" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_trigger for_id="combo-1" placeholder="Pick one..." />
        """)

      assert html =~ "Pick one..."
      assert html =~ ~s(data-combobox-part="label")
    end

    test "renders chevrons icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_trigger for_id="combo-1" />
        """)

      assert html =~ "<svg"
    end
  end

  # ── combobox_content/1 ─────────────────────────────────────────────

  describe "combobox_content/1" do
    test "renders content popover" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_content id="combo-1">
          <span>content</span>
        </.combobox_content>
        """)

      assert html =~ ~s(id="combo-1")
      assert html =~ ~s(popover="auto")
      assert html =~ ~s(role="listbox")
      assert html =~ ~s(data-combobox-part="content")
    end

    test "renders with alignment and width" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_content id="combo-1" align={:end} width={:lg}>
          <span>content</span>
        </.combobox_content>
        """)

      assert html =~ ~s(data-align="end")
      assert html =~ ~s(data-width="lg")
    end
  end

  # ── combobox_input/1 ───────────────────────────────────────────────

  describe "combobox_input/1" do
    test "renders search input" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_input />
        """)

      assert html =~ ~s(data-combobox-part="input-wrapper")
      assert html =~ ~s(data-combobox-part="input")
      assert html =~ ~s(type="text")
      assert html =~ ~s(autocomplete="off")
      assert html =~ ~s(placeholder="Search...")
    end

    test "renders custom placeholder" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_input placeholder="Type to filter..." />
        """)

      assert html =~ ~s(placeholder="Type to filter...")
    end

    test "renders search icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_input />
        """)

      assert html =~ "<svg"
    end
  end

  # ── combobox_list/1 ────────────────────────────────────────────────

  describe "combobox_list/1" do
    test "renders list container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_list>
          <span>options</span>
        </.combobox_list>
        """)

      assert html =~ ~s(data-combobox-part="list")
      assert html =~ "options"
    end
  end

  # ── combobox_option/1 ──────────────────────────────────────────────

  describe "combobox_option/1" do
    test "renders option with value" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_option value="react">React</.combobox_option>
        """)

      assert html =~ ~s(data-combobox-part="option")
      assert html =~ ~s(role="option")
      assert html =~ ~s(data-value="react")
      assert html =~ "React"
    end

    test "renders selected option" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_option value="react" selected>React</.combobox_option>
        """)

      assert html =~ ~s(data-selected="true")
      assert html =~ ~s(aria-selected="true")
      refute html =~ "invisible"
    end

    test "renders unselected option with invisible check" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_option value="react">React</.combobox_option>
        """)

      assert html =~ ~s(data-selected="false")
      assert html =~ ~s(aria-selected="false")
      assert html =~ "invisible"
    end

    test "renders disabled option" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_option value="react" disabled>React</.combobox_option>
        """)

      assert html =~ ~s(aria-disabled="true")
    end

    test "renders check icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_option value="react">React</.combobox_option>
        """)

      assert html =~ ~s(data-combobox-part="check")
    end
  end

  # ── combobox_empty/1 ───────────────────────────────────────────────

  describe "combobox_empty/1" do
    test "renders empty state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_empty />
        """)

      assert html =~ ~s(data-combobox-part="empty")
      assert html =~ "No results found."
      assert html =~ "hidden"
    end

    test "renders custom text" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_empty text="Nothing here" />
        """)

      assert html =~ "Nothing here"
    end
  end

  # ── combobox_group/1 ───────────────────────────────────────────────

  describe "combobox_group/1" do
    test "renders group container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_group>
          <span>items</span>
        </.combobox_group>
        """)

      assert html =~ ~s(data-combobox-part="group")
      assert html =~ ~s(role="group")
      assert html =~ "items"
    end
  end

  # ── combobox_label/1 ───────────────────────────────────────────────

  describe "combobox_label/1" do
    test "renders label with text" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_label text="Frontend" />
        """)

      assert html =~ ~s(data-combobox-part="label")
      assert html =~ "Frontend"
    end

    test "renders label with inner block" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_label text="ignored">Custom Label</.combobox_label>
        """)

      assert html =~ "Custom Label"
      refute html =~ "ignored"
    end
  end

  # ── combobox_separator/1 ───────────────────────────────────────────

  describe "combobox_separator/1" do
    test "renders separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox_separator />
        """)

      assert html =~ ~s(data-combobox-part="separator")
      assert html =~ ~s(role="separator")
    end
  end

  # ── combobox_simple/1 ──────────────────────────────────────────────

  describe "combobox_simple/1" do
    test "renders a complete combobox from options" do
      assigns = %{
        options: [
          %{value: "nextjs", label: "Next.js"},
          %{value: "remix", label: "Remix"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.combobox_simple options={@options} />
        """)

      assert html =~ ~s(data-component="combobox")
      assert html =~ ~s(data-combobox-part="trigger")
      assert html =~ ~s(data-combobox-part="content")
      assert html =~ ~s(data-combobox-part="input")
      assert html =~ ~s(data-combobox-part="list")
      assert html =~ ~s(data-value="nextjs")
      assert html =~ ~s(data-value="remix")
      assert html =~ "Next.js"
      assert html =~ "Remix"
      assert html =~ ~s(data-combobox-part="empty")
    end

    test "renders with selected value" do
      assigns = %{
        options: [
          %{value: "nextjs", label: "Next.js"},
          %{value: "remix", label: "Remix"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.combobox_simple options={@options} value="nextjs" />
        """)

      assert html =~ ~s(data-combobox-value="nextjs")
    end

    test "renders with custom placeholders" do
      assigns = %{
        options: [%{value: "a", label: "A"}]
      }

      html =
        rendered_to_string(~H"""
        <.combobox_simple
          options={@options}
          placeholder="Choose..."
          search_placeholder="Filter..."
          empty_text="Nothing found"
        />
        """)

      assert html =~ "Choose..."
      assert html =~ ~s(placeholder="Filter...")
      assert html =~ "Nothing found"
    end
  end

  # ── composition ────────────────────────────────────────────────────

  describe "composition" do
    test "renders full combobox with groups" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.combobox placeholder="Select...">
          <.combobox_trigger for_id="my-combo" placeholder="Select..." />
          <.combobox_content id="my-combo">
            <.combobox_input />
            <.combobox_list>
              <.combobox_group>
                <.combobox_label text="Frontend" />
                <.combobox_option value="react">React</.combobox_option>
                <.combobox_option value="vue">Vue</.combobox_option>
              </.combobox_group>
              <.combobox_separator />
              <.combobox_group>
                <.combobox_label text="Backend" />
                <.combobox_option value="rails">Rails</.combobox_option>
              </.combobox_group>
            </.combobox_list>
            <.combobox_empty />
          </.combobox_content>
        </.combobox>
        """)

      assert html =~ ~s(data-component="combobox")
      assert html =~ ~s(data-combobox-part="trigger")
      assert html =~ ~s(data-combobox-part="content")
      assert html =~ ~s(data-combobox-part="group")
      assert html =~ ~s(data-combobox-part="separator")
      assert html =~ "Frontend"
      assert html =~ "Backend"
      assert html =~ "React"
      assert html =~ "Vue"
      assert html =~ "Rails"
    end
  end
end
