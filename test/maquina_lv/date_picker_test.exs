defmodule MaquinaLv.DatePickerTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.DatePicker

  # ── date_picker/1 ──────────────────────────────────────────────────

  describe "date_picker/1" do
    test "renders root container with data-component" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ ~s(data-component="date-picker")
      assert html =~ ~s(phx-hook="MaquinaDatePicker")
    end

    test "renders trigger button" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ ~s(data-date-picker-part="trigger")
      assert html =~ ~s(aria-haspopup="dialog")
      assert html =~ ~s(aria-expanded="false")
    end

    test "renders popover with calendar" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ ~s(data-date-picker-part="popover")
      assert html =~ ~s(role="dialog")
      assert html =~ ~s(aria-modal="true")
      assert html =~ ~s(data-component="calendar")
    end

    test "renders default placeholder for single mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ "Select date"
      assert html =~ ~s(data-date-picker-part="placeholder-indicator")
    end

    test "renders default placeholder for range mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker mode={:range} />
        """)

      assert html =~ "Select date range"
    end

    test "renders custom placeholder" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker placeholder="Pick a date" />
        """)

      assert html =~ "Pick a date"
    end

    test "renders selected date display" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker selected={~D[2024-03-15]} />
        """)

      assert html =~ "March 15, 2024"
      assert html =~ ~s(data-date-picker-selected="2024-03-15")
      refute html =~ ~s(data-date-picker-part="placeholder-indicator")
    end

    test "renders selected range display" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker mode={:range} selected={~D[2024-03-10]} selected_end={~D[2024-03-20]} />
        """)

      assert html =~ "Mar 10, 2024"
      assert html =~ "Mar 20, 2024"
      assert html =~ ~s(data-date-picker-selected="2024-03-10")
      assert html =~ ~s(data-date-picker-selected-end="2024-03-20")
    end

    test "renders partial range display" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker mode={:range} selected={~D[2024-03-10]} />
        """)

      assert html =~ "Mar 10, 2024 - ..."
    end

    test "renders hidden input when input_name is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker input_name="start_date" selected={~D[2024-03-15]} />
        """)

      assert html =~ ~s(name="start_date")
      assert html =~ ~s(value="2024-03-15")
      assert html =~ ~s(type="hidden")
    end

    test "renders end date input in range mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker
          mode={:range}
          input_name="start"
          input_name_end="end"
          selected={~D[2024-03-10]}
          selected_end={~D[2024-03-20]}
        />
        """)

      assert html =~ ~s(name="start")
      assert html =~ ~s(name="end")
    end

    test "renders required attribute on hidden input" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker input_name="date" required />
        """)

      assert html =~ "required"
    end

    test "renders disabled trigger" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker disabled />
        """)

      assert html =~ "disabled"
    end

    test "renders calendar icon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ "<svg"
    end

    test "renders single mode data attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ ~s(data-date-picker-mode="single")
    end

    test "renders range mode data attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker mode={:range} />
        """)

      assert html =~ ~s(data-date-picker-mode="range")
    end

    test "passes class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker class="my-picker" />
        """)

      assert html =~ ~s(class="my-picker")
    end

    test "renders aria-label for single mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker />
        """)

      assert html =~ ~s(aria-label="Date picker")
    end

    test "renders aria-label for range mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker mode={:range} />
        """)

      assert html =~ ~s(aria-label="Date range picker")
    end

    test "renders with ISO string date" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker selected="2024-03-15" />
        """)

      assert html =~ ~s(data-date-picker-selected="2024-03-15")
      assert html =~ "March 15, 2024"
    end

    test "popover target matches trigger" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker id="my-picker" />
        """)

      assert html =~ ~s(popovertarget="my-picker-popover")
      assert html =~ ~s(id="my-picker-popover")
    end
  end
end
