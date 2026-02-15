defmodule MaquinaLv do
  @moduledoc """
  LiveView function components inspired by shadcn/ui.

  ## Usage

  Add `use MaquinaLv` to your Phoenix component module to import all components:

      defmodule MyAppWeb do
        def html_helpers do
          quote do
            use MaquinaLv
            # ...
          end
        end
      end

  Then use dot-syntax in your templates:

      <.card>
        <.card_header>
          <.card_title text="Hello" />
        </.card_header>
      </.card>
  """

  defmacro __using__(_opts) do
    quote do
      import MaquinaLv.Alert
      import MaquinaLv.Badge
      import MaquinaLv.Breadcrumbs
      import MaquinaLv.Card
      import MaquinaLv.DropdownMenu
      import MaquinaLv.Empty
      import MaquinaLv.Form
      import MaquinaLv.Header
      import MaquinaLv.Icon
      import MaquinaLv.MenuButton
      import MaquinaLv.Pagination
      import MaquinaLv.Separator
      import MaquinaLv.Stats
      import MaquinaLv.Table
      import MaquinaLv.Toast
      import MaquinaLv.ToggleGroup
    end
  end
end
