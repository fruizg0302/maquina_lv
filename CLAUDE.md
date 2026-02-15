# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MaquinaLv is a component library for Phoenix LiveView, ported from [maquina_components](https://github.com/maquina-app/maquina_components) (a Rails UI library built with ERB partials and Stimulus). Both projects are inspired by shadcn/ui. MaquinaLv provides reusable UI components styled with TailwindCSS 4.0 using data-attribute CSS selectors and CSS variables for theming.

## Common Commands

```bash
mix test              # Run all tests
mix test test/maquina_lv/badge_test.exs           # Run a single test file
mix test test/maquina_lv/badge_test.exs:10        # Run a specific test by line
mix format            # Format all code
mix docs              # Generate documentation
mix maquina_lv.install  # Install into a Phoenix project (--skip-theme, --skip-js)
```

## Architecture

### Component Tiers

Components fall into three patterns of increasing complexity:

1. **Simple** (Badge, Separator, Header) — Pure HEEx templates with data attributes, no JS.
2. **Composite** (Card, Alert, Form, Empty) — Parent + child functions composed via slots (e.g., `card` + `card_header` + `card_title` + `card_content` + `card_footer`).
3. **Interactive** (DropdownMenu, Calendar, Combobox, Sidebar, Toast, ToggleGroup) — Include a `phx-hook` directive and a corresponding JS hook in `assets/js/hooks/`. State managed via `data-state` attributes.

### Key Directories

- `lib/maquina_lv/` — Elixir component modules (one per component)
- `lib/maquina_lv.ex` — `use MaquinaLv` macro that imports all components
- `lib/mix/tasks/` — `mix maquina_lv.install` task
- `assets/js/hooks/` — JS hooks for interactive components
- `assets/js/maquina_lv.js` — JS hook entry point (exports all hooks)
- `assets/css/` — Per-component CSS files; `maquina_lv.css` imports them all

### Styling Convention

Components use **data-attribute CSS selectors** instead of inline Tailwind classes. Variants and sizes are set as data attributes on elements:

```elixir
<div data-component="badge" data-variant={@variant} data-size={@size}>
```

```css
[data-component="badge"][data-variant="primary"] { ... }
```

Theming uses CSS variables (`--primary`, `--secondary`, `--destructive`, `--background`, `--foreground`, etc.) following shadcn/ui conventions. Dark mode works through variable redefinition, not `dark:` prefixes.

### Component Module Pattern

Every component module follows this structure:

```elixir
defmodule MaquinaLv.ComponentName do
  use Phoenix.Component

  attr :variant, :atom, default: :default, values: [...]
  attr :size, :atom, default: :md, values: [...]
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def component_name(assigns) do
    ~H"""..."""
  end
end
```

### JS Hook Naming

Hooks are named `Maquina<ComponentName>` (e.g., `MaquinaDropdownMenu`, `MaquinaCalendar`) and exported from `assets/js/maquina_lv.js`.

### Icon System

`MaquinaLv.Icon` contains 100+ hardcoded SVG icons. Custom icon providers can be registered via `Application.get_env(:maquina_lv, :icon_provider)`.

### Test Pattern

Tests use `Phoenix.LiveViewTest.rendered_to_string/1` to render components and assert on data attributes:

```elixir
html = rendered_to_string(~H"<.badge variant={:primary}>Text</.badge>")
assert html =~ ~s(data-variant="primary")
```

All test modules use `async: true`.
