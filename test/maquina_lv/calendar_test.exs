defmodule MaquinaLv.CalendarTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import MaquinaLv.Calendar

  # ── calendar/1 ─────────────────────────────────────────────────────

  describe "calendar/1" do
    test "renders root container with data-component" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar />
        """)

      assert html =~ ~s(data-component="calendar")
      assert html =~ ~s(phx-hook="MaquinaCalendar")
    end

    test "renders with default single mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar />
        """)

      assert html =~ ~s(data-calendar-mode="single")
    end

    test "renders with range mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar mode={:range} />
        """)

      assert html =~ ~s(data-calendar-mode="range")
    end

    test "renders with selected date" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar selected={~D[2024-03-15]} />
        """)

      assert html =~ ~s(data-calendar-selected="2024-03-15")
      assert html =~ ~s(data-calendar-month="3")
      assert html =~ ~s(data-calendar-year="2024")
    end

    test "renders with selected range" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar mode={:range} selected={~D[2024-03-10]} selected_end={~D[2024-03-20]} />
        """)

      assert html =~ ~s(data-calendar-selected="2024-03-10")
      assert html =~ ~s(data-calendar-selected-end="2024-03-20")
    end

    test "renders weekday headers" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar month={3} year={2024} />
        """)

      assert html =~ ~s(data-calendar-part="weekdays")
      assert html =~ ~s(data-calendar-part="weekday")
      assert html =~ "Su"
      assert html =~ "Mo"
      assert html =~ "Fr"
    end

    test "renders weekday headers starting on Monday" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar month={3} year={2024} week_starts_on={:monday} />
        """)

      # First weekday should be Mo, not Su
      assert html =~ ~s(data-calendar-part="weekday")
      assert html =~ ~s(data-calendar-week-starts-on="monday")
    end

    test "renders calendar grid" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar month={3} year={2024} />
        """)

      assert html =~ ~s(data-calendar-part="grid")
      assert html =~ ~s(role="grid")
      assert html =~ ~s(data-calendar-part="week")
      assert html =~ ~s(data-calendar-part="day")
    end

    test "renders month name in header" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar month={3} year={2024} />
        """)

      assert html =~ ~s(data-calendar-part="caption")
      assert html =~ "March 2024"
    end

    test "renders navigation buttons" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar />
        """)

      assert html =~ ~s(data-calendar-part="header")
      assert html =~ ~s(aria-label="Previous month")
      assert html =~ ~s(aria-label="Next month")
    end

    test "renders hidden input when input_name is provided" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar input_name="start_date" selected={~D[2024-03-15]} />
        """)

      assert html =~ ~s(name="start_date")
      assert html =~ ~s(value="2024-03-15")
      assert html =~ ~s(type="hidden")
    end

    test "renders end date input in range mode" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar
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

    test "renders min/max date data attributes" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar min_date={~D[2024-01-01]} max_date={~D[2024-12-31]} month={3} year={2024} />
        """)

      assert html =~ ~s(data-calendar-min-date="2024-01-01")
      assert html =~ ~s(data-calendar-max-date="2024-12-31")
    end

    test "disables dates outside min/max range" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar month={3} year={2024} min_date={~D[2024-03-10]} max_date={~D[2024-03-20]} />
        """)

      # Days before min_date should be disabled
      assert html =~ "disabled"
    end

    test "renders custom cell size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar cell_size="2.5rem" month={3} year={2024} />
        """)

      assert html =~ "--cell-size: 2.5rem"
    end

    test "passes class attribute" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar class="my-cal" month={3} year={2024} />
        """)

      assert html =~ ~s(class="my-cal")
    end

    test "renders ISO date strings for selected" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar selected="2024-03-15" />
        """)

      assert html =~ ~s(data-calendar-selected="2024-03-15")
    end
  end

  # ── calendar_week/1 ────────────────────────────────────────────────

  describe "calendar_week/1" do
    test "renders day buttons with date data" do
      assigns = %{
        days: [~D[2024-03-01], ~D[2024-03-02], ~D[2024-03-03], ~D[2024-03-04],
               ~D[2024-03-05], ~D[2024-03-06], ~D[2024-03-07]]
      }

      html =
        rendered_to_string(~H"""
        <.calendar_week days={@days} display_month={3} />
        """)

      assert html =~ ~s(data-calendar-part="week")
      assert html =~ ~s(data-date="2024-03-01")
      assert html =~ ~s(data-date="2024-03-07")
      assert html =~ ">1<"
      assert html =~ ">7<"
    end

    test "marks outside days" do
      assigns = %{
        days: [~D[2024-02-28], ~D[2024-02-29], ~D[2024-03-01], ~D[2024-03-02],
               ~D[2024-03-03], ~D[2024-03-04], ~D[2024-03-05]]
      }

      html =
        rendered_to_string(~H"""
        <.calendar_week days={@days} display_month={3} />
        """)

      assert html =~ ~s(data-outside="true")
    end

    test "marks selected date" do
      assigns = %{
        days: [~D[2024-03-11], ~D[2024-03-12], ~D[2024-03-13], ~D[2024-03-14],
               ~D[2024-03-15], ~D[2024-03-16], ~D[2024-03-17]]
      }

      html =
        rendered_to_string(~H"""
        <.calendar_week days={@days} display_month={3} selected_date={~D[2024-03-15]} />
        """)

      assert html =~ ~s(data-state="selected")
      assert html =~ ~s(aria-selected="true")
    end

    test "marks range selection" do
      assigns = %{
        days: [~D[2024-03-11], ~D[2024-03-12], ~D[2024-03-13], ~D[2024-03-14],
               ~D[2024-03-15], ~D[2024-03-16], ~D[2024-03-17]]
      }

      html =
        rendered_to_string(~H"""
        <.calendar_week
          days={@days}
          display_month={3}
          mode={:range}
          selected_date={~D[2024-03-12]}
          selected_end_date={~D[2024-03-16]}
        />
        """)

      assert html =~ ~s(data-state="range-start")
      assert html =~ ~s(data-state="range-middle")
      assert html =~ ~s(data-state="range-end")
    end

    test "hides outside days when show_outside_days is false" do
      assigns = %{
        days: [~D[2024-02-28], ~D[2024-02-29], ~D[2024-03-01], ~D[2024-03-02],
               ~D[2024-03-03], ~D[2024-03-04], ~D[2024-03-05]]
      }

      html =
        rendered_to_string(~H"""
        <.calendar_week days={@days} display_month={3} show_outside_days={false} />
        """)

      refute html =~ ~s(data-date="2024-02-28")
      assert html =~ ~s(data-date="2024-03-01")
    end
  end

  # ── build_weeks/2 ──────────────────────────────────────────────────

  describe "build_weeks/2" do
    test "builds weeks for a month" do
      first = ~D[2024-03-01]
      weeks = build_weeks(first, :sunday)

      assert length(weeks) >= 5
      assert length(hd(weeks)) == 7
    end

    test "starts on Sunday by default" do
      first = ~D[2024-03-01]
      weeks = build_weeks(first, :sunday)
      first_day = hd(hd(weeks))

      # Sunday = 7 in ISO (Date.day_of_week/1)
      assert Date.day_of_week(first_day) == 7
    end

    test "starts on Monday when configured" do
      first = ~D[2024-03-01]
      weeks = build_weeks(first, :monday)
      first_day = hd(hd(weeks))

      # Monday = 1 in ISO (Date.day_of_week/1)
      assert Date.day_of_week(first_day) == 1
    end
  end

  # ── weekday_names/2 ────────────────────────────────────────────────

  describe "weekday_names/2" do
    test "returns short names starting on Sunday" do
      names = weekday_names(:sunday)
      assert hd(names) == "Su"
      assert List.last(names) == "Sa"
    end

    test "returns short names starting on Monday" do
      names = weekday_names(:monday)
      assert hd(names) == "Mo"
      assert List.last(names) == "Su"
    end

    test "returns narrow names" do
      names = weekday_names(:sunday, :narrow)
      assert hd(names) == "S"
      assert length(names) == 7
    end
  end

  # ── date_in_range?/3 ──────────────────────────────────────────────

  describe "date_in_range?/3" do
    test "returns true for date in range" do
      assert date_in_range?(~D[2024-03-15], ~D[2024-03-10], ~D[2024-03-20])
    end

    test "returns true for start date" do
      assert date_in_range?(~D[2024-03-10], ~D[2024-03-10], ~D[2024-03-20])
    end

    test "returns false for date outside range" do
      refute date_in_range?(~D[2024-03-05], ~D[2024-03-10], ~D[2024-03-20])
    end

    test "returns false when start is nil" do
      refute date_in_range?(~D[2024-03-15], nil, ~D[2024-03-20])
    end

    test "returns false when end is nil" do
      refute date_in_range?(~D[2024-03-15], ~D[2024-03-10], nil)
    end
  end
end
