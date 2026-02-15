defmodule MaquinaLv.DatePicker do
  @moduledoc """
  Date picker component with trigger button and popover calendar.

  ## Usage

      <.date_picker selected={~D[2024-03-15]} input_name="start_date" />

  ## Range Selection

      <.date_picker
        mode={:range}
        selected={~D[2024-03-10]}
        selected_end={~D[2024-03-20]}
        input_name="start_date"
        input_name_end="end_date"
      />
  """

  use Phoenix.Component

  import MaquinaLv.Calendar, only: [calendar: 1]
  import MaquinaLv.Icon, only: [icon: 1]

  @doc """
  Renders a date picker with trigger button and popover calendar.

  ## Attributes

    * `selected` - Selected date (`Date` or ISO string).
    * `selected_end` - End date for range mode.
    * `mode` - Selection mode: `:single` or `:range`. Defaults to `:single`.
    * `min_date` - Minimum selectable date.
    * `max_date` - Maximum selectable date.
    * `disabled_dates` - List of dates that cannot be selected.
    * `show_outside_days` - Show days from adjacent months. Defaults to `true`.
    * `week_starts_on` - `:sunday` or `:monday`. Defaults to `:sunday`.
    * `placeholder` - Trigger button placeholder text.
    * `input_name` - Name for hidden form input.
    * `input_name_end` - Name for hidden end date input (range mode).
    * `disabled` - Whether the picker is disabled.
    * `required` - Whether the input is required.
    * `class` - Additional CSS classes.
    * Global attributes are passed through.
  """
  attr :selected, :any, default: nil
  attr :selected_end, :any, default: nil
  attr :mode, :atom, default: :single, values: [:single, :range]
  attr :min_date, :any, default: nil
  attr :max_date, :any, default: nil
  attr :disabled_dates, :list, default: []
  attr :show_outside_days, :boolean, default: true
  attr :week_starts_on, :atom, default: :sunday, values: [:sunday, :monday]
  attr :placeholder, :string, default: nil
  attr :input_name, :string, default: nil
  attr :input_name_end, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :required, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  def date_picker(assigns) do
    selected_date = parse_date(assigns.selected)
    selected_end_date = parse_date(assigns.selected_end)

    display_value =
      cond do
        assigns.mode == :range && selected_date && selected_end_date ->
          "#{format_date_short(selected_date)} - #{format_date_short(selected_end_date)}"

        assigns.mode == :range && selected_date ->
          "#{format_date_short(selected_date)} - ..."

        selected_date ->
          format_date_long(selected_date)

        true ->
          nil
      end

    default_placeholder =
      if assigns.mode == :range, do: "Select date range", else: "Select date"

    assigns =
      assigns
      |> assign(:selected_date, selected_date)
      |> assign(:selected_end_date, selected_end_date)
      |> assign(:display_value, display_value)
      |> assign(:default_placeholder, default_placeholder)
      |> assign_new(:hook_id, fn ->
        assigns.rest[:id] || "date-picker-#{System.unique_integer([:positive])}"
      end)

    assigns = assign(assigns, :popover_id, "#{assigns.hook_id}-popover")

    ~H"""
    <div
      id={@hook_id}
      phx-hook="MaquinaDatePicker"
      data-component="date-picker"
      data-date-picker-mode={@mode}
      data-date-picker-selected={@selected_date && Date.to_iso8601(@selected_date)}
      data-date-picker-selected-end={@selected_end_date && Date.to_iso8601(@selected_end_date)}
      class={@class}
      {@rest}
    >
      <input
        :if={@input_name}
        type="hidden"
        name={@input_name}
        value={@selected_date && Date.to_iso8601(@selected_date)}
        data-date-picker-part="input"
        required={@required}
      />
      <input
        :if={@input_name_end && @mode == :range}
        type="hidden"
        name={@input_name_end}
        value={@selected_end_date && Date.to_iso8601(@selected_end_date)}
        data-date-picker-part="input-end"
      />

      <button
        type="button"
        popovertarget={@popover_id}
        data-date-picker-part="trigger"
        disabled={@disabled}
        aria-haspopup="dialog"
        aria-expanded="false"
      >
        <.icon name={:calendar} class="size-4" />
        <span data-date-picker-part="display">
          {@display_value || @placeholder || @default_placeholder}
        </span>
        <span :if={!@display_value} data-date-picker-part="placeholder-indicator" />
      </button>

      <div
        id={@popover_id}
        popover
        data-date-picker-part="popover"
        role="dialog"
        aria-modal="true"
        aria-label={if @mode == :range, do: "Date range picker", else: "Date picker"}
      >
        <.calendar
          selected={@selected_date}
          selected_end={@selected_end_date}
          mode={@mode}
          min_date={@min_date}
          max_date={@max_date}
          disabled_dates={@disabled_dates}
          show_outside_days={@show_outside_days}
          week_starts_on={@week_starts_on}
        />
      </div>
    </div>
    """
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

  defp format_date_short(date) do
    Calendar.strftime(date, "%b %-d, %Y")
  end

  defp format_date_long(date) do
    Calendar.strftime(date, "%B %-d, %Y")
  end
end
