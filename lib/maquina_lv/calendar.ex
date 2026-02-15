defmodule MaquinaLv.Calendar do
  @moduledoc """
  Calendar component for date selection.

  Supports single date and date range selection modes.

  ## Usage

      <.calendar selected={~D[2024-03-15]} />

  ## Range Selection

      <.calendar mode={:range} selected={~D[2024-03-10]} selected_end={~D[2024-03-20]} />
  """

  use Phoenix.Component

  import MaquinaLv.Icon, only: [icon: 1]

  @weekday_names_short ~w(Su Mo Tu We Th Fr Sa)
  @weekday_names_narrow ~w(S M T W T F S)

  # ── calendar/1 ─────────────────────────────────────────────────────

  @doc """
  Renders a calendar with date selection.

  ## Attributes

    * `selected` - Selected date (`Date` or ISO string).
    * `selected_end` - End date for range mode.
    * `month` - Display month (1-12). Defaults to selected date's month or current.
    * `year` - Display year. Defaults to selected date's year or current.
    * `mode` - Selection mode: `:single` or `:range`. Defaults to `:single`.
    * `min_date` - Minimum selectable date.
    * `max_date` - Maximum selectable date.
    * `disabled_dates` - List of dates that cannot be selected.
    * `show_outside_days` - Show days from adjacent months. Defaults to `true`.
    * `week_starts_on` - `:sunday` or `:monday`. Defaults to `:sunday`.
    * `cell_size` - Custom CSS cell size (e.g. "2.5rem").
    * `input_name` - Name for hidden form input.
    * `input_name_end` - Name for hidden end date input (range mode).
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr :selected, :any, default: nil
  attr :selected_end, :any, default: nil
  attr :month, :integer, default: nil
  attr :year, :integer, default: nil
  attr :mode, :atom, default: :single, values: [:single, :range]
  attr :min_date, :any, default: nil
  attr :max_date, :any, default: nil
  attr :disabled_dates, :list, default: []
  attr :show_outside_days, :boolean, default: true
  attr :week_starts_on, :atom, default: :sunday, values: [:sunday, :monday]
  attr :cell_size, :string, default: nil
  attr :input_name, :string, default: nil
  attr :input_name_end, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def calendar(assigns) do
    selected_date = parse_date(assigns.selected)
    selected_end_date = parse_date(assigns.selected_end)
    min_date_parsed = parse_date(assigns.min_date)
    max_date_parsed = parse_date(assigns.max_date)

    today = Date.utc_today()
    display_date = selected_date || today
    display_month = assigns.month || display_date.month
    display_year = assigns.year || display_date.year

    first_of_month = Date.new!(display_year, display_month, 1)
    weeks = build_weeks(first_of_month, assigns.week_starts_on)
    weekday_names = weekday_names(assigns.week_starts_on)
    month_name = Calendar.strftime(first_of_month, "%B %Y")

    style_attr = if assigns.cell_size, do: "--cell-size: #{assigns.cell_size};", else: nil

    assigns =
      assigns
      |> assign(:selected_date, selected_date)
      |> assign(:selected_end_date, selected_end_date)
      |> assign(:min_date_parsed, min_date_parsed)
      |> assign(:max_date_parsed, max_date_parsed)
      |> assign(:display_month, display_month)
      |> assign(:display_year, display_year)
      |> assign(:weeks, weeks)
      |> assign(:weekday_names, weekday_names)
      |> assign(:month_name, month_name)
      |> assign(:style_attr, style_attr)
      |> assign_new(:hook_id, fn ->
        assigns.rest[:id] || "calendar-#{System.unique_integer([:positive])}"
      end)

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaCalendar"
      data-component="calendar"
      data-calendar-mode={@mode}
      data-calendar-month={@display_month}
      data-calendar-year={@display_year}
      data-calendar-selected={@selected_date && Date.to_iso8601(@selected_date)}
      data-calendar-selected-end={@selected_end_date && Date.to_iso8601(@selected_end_date)}
      data-calendar-min-date={@min_date_parsed && Date.to_iso8601(@min_date_parsed)}
      data-calendar-max-date={@max_date_parsed && Date.to_iso8601(@max_date_parsed)}
      data-calendar-week-starts-on={@week_starts_on}
      class={@class}
      style={@style_attr}
      {@rest}
    >
      <input
        :if={@input_name}
        type="hidden"
        name={@input_name}
        value={@selected_date && Date.to_iso8601(@selected_date)}
        data-calendar-part="input"
      />
      <input
        :if={@input_name_end && @mode == :range}
        type="hidden"
        name={@input_name_end}
        value={@selected_end_date && Date.to_iso8601(@selected_end_date)}
        data-calendar-part="input-end"
      />

      <.calendar_header month_name={@month_name} />

      <div data-calendar-part="weekdays">
        <div :for={name <- @weekday_names} data-calendar-part="weekday">{name}</div>
      </div>

      <div data-calendar-part="grid" role="grid" aria-label="Calendar">
        <.calendar_week
          :for={week_days <- @weeks}
          days={week_days}
          display_month={@display_month}
          selected_date={@selected_date}
          selected_end_date={@selected_end_date}
          mode={@mode}
          min_date={@min_date_parsed}
          max_date={@max_date_parsed}
          disabled_dates={@disabled_dates}
          show_outside_days={@show_outside_days}
        />
      </div>
    </div>
    """
  end

  # ── calendar_header/1 ──────────────────────────────────────────────

  @doc """
  Renders the calendar header with month navigation.

  ## Attributes

    * `month_name` - Formatted month and year string.
    * `class` - Additional CSS classes.
  """
  attr :month_name, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  def calendar_header(assigns) do
    ~H"""
    <div data-calendar-part="header" class={@class} {@rest}>
      <button type="button" data-calendar-action="prev" aria-label="Previous month">
        <.icon name={:chevron_left} class="size-4" />
      </button>
      <div data-calendar-part="caption">{@month_name}</div>
      <button type="button" data-calendar-action="next" aria-label="Next month">
        <.icon name={:chevron_right} class="size-4" />
      </button>
    </div>
    """
  end

  # ── calendar_week/1 ────────────────────────────────────────────────

  @doc """
  Renders a single week row of the calendar.
  """
  attr :days, :list, required: true
  attr :display_month, :integer, required: true
  attr :selected_date, :any, default: nil
  attr :selected_end_date, :any, default: nil
  attr :mode, :atom, default: :single
  attr :min_date, :any, default: nil
  attr :max_date, :any, default: nil
  attr :disabled_dates, :list, default: []
  attr :show_outside_days, :boolean, default: true

  def calendar_week(assigns) do
    today = Date.utc_today()

    day_data =
      assigns.days
      |> Enum.map(fn day ->
        is_outside = day.month != assigns.display_month
        is_today = Date.compare(day, today) == :eq
        is_selected = assigns.selected_date && Date.compare(day, assigns.selected_date) == :eq

        is_range_end =
          assigns.selected_end_date && Date.compare(day, assigns.selected_end_date) == :eq

        is_range_middle =
          assigns.selected_date && assigns.selected_end_date &&
            Date.compare(day, assigns.selected_date) == :gt &&
            Date.compare(day, assigns.selected_end_date) == :lt

        is_disabled =
          (assigns.min_date && Date.compare(day, assigns.min_date) == :lt) ||
            (assigns.max_date && Date.compare(day, assigns.max_date) == :gt) ||
            day in assigns.disabled_dates

        day_state =
          cond do
            is_selected && assigns.mode == :range && assigns.selected_end_date -> "range-start"
            is_range_end -> "range-end"
            is_range_middle -> "range-middle"
            is_selected -> "selected"
            true -> nil
          end

        show = !is_outside || assigns.show_outside_days

        %{
          date: day,
          date_str: Date.to_iso8601(day),
          day_num: day.day,
          is_outside: is_outside,
          is_today: is_today,
          is_disabled: is_disabled,
          day_state: day_state,
          show: show,
          tabindex: if(is_today, do: "0", else: "-1"),
          aria_selected: day_state in ["selected", "range-start", "range-end"]
        }
      end)

    assigns = assign(assigns, :day_data, day_data)

    ~H"""
    <div data-calendar-part="week" role="row">
      <button
        :for={day <- @day_data}
        :if={day.show}
        type="button"
        data-calendar-part="day"
        data-date={day.date_str}
        data-state={day.day_state}
        data-outside={day.is_outside && "true"}
        data-today={day.is_today && "true"}
        disabled={day.is_disabled}
        tabindex={day.tabindex}
        aria-selected={day.aria_selected && "true"}
        aria-current={day.is_today && "date"}
      >{day.day_num}</button>
    </div>
    """
  end

  # ── Helper Functions ───────────────────────────────────────────────

  @doc """
  Generates the weeks grid for a given month.
  """
  def build_weeks(first_of_month, week_starts_on) do
    last_of_month = Date.end_of_month(first_of_month)

    # Convert to 0=Sunday..6=Saturday (like Ruby's wday)
    wday = rem(Date.day_of_week(first_of_month), 7)
    week_start = if week_starts_on == :monday, do: 1, else: 0
    days_before = rem(wday - week_start + 7, 7)
    calendar_start = Date.add(first_of_month, -days_before)

    total_days = days_before + last_of_month.day
    weeks_needed = min(ceil(total_days / 7), 6)
    calendar_end = Date.add(calendar_start, weeks_needed * 7 - 1)

    Date.range(calendar_start, calendar_end)
    |> Enum.chunk_every(7)
  end

  @doc """
  Returns weekday name abbreviations.
  """
  def weekday_names(week_starts_on, format \\ :short) do
    names =
      case format do
        :narrow -> @weekday_names_narrow
        _ -> @weekday_names_short
      end

    if week_starts_on == :monday do
      tl(names) ++ [hd(names)]
    else
      names
    end
  end

  @doc """
  Checks if a date falls within a range.
  """
  def date_in_range?(date, start_date, end_date) do
    start_date && end_date &&
      Date.compare(date, start_date) in [:eq, :gt] &&
      Date.compare(date, end_date) in [:eq, :lt]
  end

  defp parse_date(nil), do: nil
  defp parse_date(%Date{} = d), do: d

  defp parse_date(str) when is_binary(str) do
    case Date.from_iso8601(str) do
      {:ok, d} -> d
      _ -> nil
    end
  end

  defp parse_date(_), do: nil
end
