# MaquinaLv

[![Hex.pm](https://img.shields.io/hexpm/v/maquina_lv.svg)](https://hex.pm/packages/maquina_lv)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

LiveView function components ported from [maquina_components](https://github.com/maquina-app/maquina_components) (a Rails UI library inspired by [shadcn/ui](https://ui.shadcn.com)). TailwindCSS 4.0, data-attribute CSS, JS hooks.

## Installation

Add `maquina_lv` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:maquina_lv, "~> 0.1.0"}
  ]
end
```

Then run the install task:

```bash
mix deps.get
mix maquina_lv.install
```

This will:

1. Add the MaquinaLv CSS import and `@source` directive to your `assets/css/app.css`
2. Append theme variables (shadcn/ui convention) to your CSS
3. Add JS hooks import to your `assets/js/app.js`

Use `--skip-theme` or `--skip-js` to skip individual steps.

## Setup

**1. Import components** — add `use MaquinaLv` to your component helpers:

```elixir
defmodule MyAppWeb do
  defp html_helpers do
    quote do
      use MaquinaLv
      # ...
    end
  end
end
```

**2. Register JS hooks** — spread `MaquinaHooks` into your LiveSocket:

```javascript
import { MaquinaHooks } from "maquina_lv"

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...MaquinaHooks },
  // ...
})
```

**3. Customize theme** — edit the CSS variables in `assets/css/app.css` to match your design. Dark mode works through variable redefinition, not `dark:` prefixes.

## Usage

### Badge (simple component)

```heex
<.badge>Default</.badge>
<.badge variant={:success}>Published</.badge>
<.badge variant={:destructive} size={:sm}>Error</.badge>
```

### Card (composite component)

```heex
<.card>
  <.card_header>
    <.card_title text="Notifications" />
    <.card_description text="You have 3 unread messages." />
  </.card_header>
  <.card_content>
    <p>Card body content goes here.</p>
  </.card_content>
  <.card_footer>
    <button>Mark all as read</button>
  </.card_footer>
</.card>
```

### DropdownMenu (interactive component)

```heex
<.dropdown_menu>
  <.dropdown_menu_trigger>
    Options
  </.dropdown_menu_trigger>
  <.dropdown_menu_content>
    <.dropdown_menu_label text="Actions" />
    <.dropdown_menu_item href="/profile">Profile</.dropdown_menu_item>
    <.dropdown_menu_separator />
    <.dropdown_menu_item href="/delete" variant={:destructive}>Delete</.dropdown_menu_item>
  </.dropdown_menu_content>
</.dropdown_menu>
```

### Toast (flash integration)

```heex
<.toaster position={:bottom_right}>
  <.flash_toasts flash={@flash} />
</.toaster>
```

Or create toasts directly:

```heex
<.toaster position={:bottom_right}>
  <.toast variant={:success} title="Saved!" description="Your changes have been saved." />
</.toaster>
```

## Components

| Component | Type | Description |
|-----------|------|-------------|
| Alert | Composite | Contextual feedback messages |
| Badge | Simple | Short status text or labels |
| Breadcrumbs | Composite | Navigation breadcrumb trail |
| Calendar | Interactive | Date picker calendar |
| Card | Composite | Grouped content with header/body/footer |
| Combobox | Interactive | Searchable select input |
| DatePicker | Interactive | Date input with calendar popup |
| Dropdown | Simple | Basic dropdown |
| DropdownMenu | Interactive | Action menu triggered by a button |
| Empty | Composite | Empty state placeholder |
| Form | Composite | Form fields and validation |
| Header | Simple | Page/section header |
| Icon | Simple | 100+ built-in SVG icons |
| MenuButton | Simple | Button styled for menus |
| Pagination | Composite | Page navigation controls |
| Separator | Simple | Visual divider |
| Sidebar | Interactive | Collapsible sidebar navigation |
| Stats | Composite | Statistic display cards |
| Table | Composite | Data table |
| Toast | Interactive | Temporary notification messages |
| ToggleGroup | Interactive | Grouped toggle buttons |

## Styling

Components use **data-attribute CSS selectors** instead of inline Tailwind classes. Variants and sizes are set as data attributes:

```heex
<.badge variant={:secondary} size={:lg}>Label</.badge>
```

This renders as:

```html
<span data-component="badge" data-variant="secondary" data-size="lg">Label</span>
```

Theme colors are CSS variables (`--primary`, `--secondary`, `--destructive`, `--background`, `--foreground`, etc.) following shadcn/ui conventions. Override them in your `assets/css/app.css` to customize the look.

## License

MIT
