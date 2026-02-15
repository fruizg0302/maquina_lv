defmodule Mix.Tasks.MaquinaLv.Install do
  @shortdoc "Installs MaquinaLv into your Phoenix project"

  @moduledoc """
  Installs MaquinaLv into your Phoenix project.

      $ mix maquina_lv.install

  This will:

    1. Add the MaquinaLv CSS import and `@source` directive to your `assets/css/app.css`
    2. Append theme variables (shadcn/ui convention) to your CSS
    3. Add JS hooks import to your `assets/js/app.js`

  ## Options

    * `--skip-theme` - Skip adding theme variables
    * `--skip-js` - Skip adding JS hooks import
  """

  use Mix.Task

  @css_import ~s|@import "../../deps/maquina_lv/assets/css/maquina_lv.css";|
  @css_source ~s|@source "../../deps/maquina_lv/lib";|
  @js_import ~s|import { MaquinaHooks } from "maquina_lv"|

  @impl Mix.Task
  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args, switches: [skip_theme: :boolean, skip_js: :boolean])

    add_css_import()

    unless opts[:skip_theme], do: add_theme_variables()
    unless opts[:skip_js], do: add_js_hooks()

    print_instructions()
  end

  defp add_css_import do
    css_path = "assets/css/app.css"

    cond do
      not File.exists?(css_path) ->
        Mix.shell().info([:yellow, "* skip ", :reset, "#{css_path} not found"])

      File.read!(css_path) |> String.contains?(@css_import) ->
        Mix.shell().info([:cyan, "* skip ", :reset, "CSS import already present"])

      true ->
        content = File.read!(css_path)

        updated =
          String.replace(
            content,
            ~r/@import\s+["']tailwindcss["'];?\n/,
            "\\0\n#{@css_import}\n#{@css_source}\n",
            global: false
          )

        updated =
          if updated == content do
            "#{@css_import}\n#{@css_source}\n\n#{content}"
          else
            updated
          end

        File.write!(css_path, updated)
        Mix.shell().info([:green, "* injecting ", :reset, "CSS import into #{css_path}"])
    end
  end

  defp add_theme_variables do
    css_path = "assets/css/app.css"

    cond do
      not File.exists?(css_path) ->
        :skip

      File.read!(css_path) |> String.contains?("--color-primary:") ->
        Mix.shell().info([:cyan, "* skip ", :reset, "theme variables already present"])

      true ->
        content = File.read!(css_path)
        theme_content = theme_template()
        File.write!(css_path, content <> "\n" <> theme_content)
        Mix.shell().info([:green, "* appending ", :reset, "theme variables to #{css_path}"])
    end
  end

  defp add_js_hooks do
    js_path = "assets/js/app.js"

    cond do
      not File.exists?(js_path) ->
        Mix.shell().info([:yellow, "* skip ", :reset, "#{js_path} not found"])

      File.read!(js_path) |> String.contains?(@js_import) ->
        Mix.shell().info([:cyan, "* skip ", :reset, "JS hooks import already present"])

      true ->
        content = File.read!(js_path)
        updated = @js_import <> "\n" <> content
        File.write!(js_path, updated)

        Mix.shell().info([:green, "* injecting ", :reset, "JS hooks import into #{js_path}"])
        Mix.shell().info("")

        Mix.shell().info("""
        Add MaquinaHooks to your LiveSocket:

            let liveSocket = new LiveSocket("/live", Socket, {
              hooks: { ...MaquinaHooks },
              // ...
            })
        """)
    end
  end

  defp print_instructions do
    Mix.shell().info("")
    Mix.shell().info("MaquinaLv installed successfully!")
    Mix.shell().info("")
    Mix.shell().info("Next steps:")
    Mix.shell().info("")
    Mix.shell().info("  1. Add `use MaquinaLv` to your component helpers:")
    Mix.shell().info("")

    Mix.shell().info("""
        defmodule MyAppWeb do
          defp html_helpers do
            quote do
              use MaquinaLv
              # ...
            end
          end
        end
    """)

    Mix.shell().info("  2. Customize theme variables in assets/css/app.css")
    Mix.shell().info("")
    Mix.shell().info("  3. Start using components in your templates:")
    Mix.shell().info("")
    Mix.shell().info("     <.card>")
    Mix.shell().info("       <.card_header>")
    Mix.shell().info("         <.card_title text=\"Hello\" />")
    Mix.shell().info("       </.card_header>")
    Mix.shell().info("     </.card>")
    Mix.shell().info("")
  end

  defp theme_template do
    template_path = Path.join(:code.priv_dir(:maquina_lv), "templates/theme.css")

    if File.exists?(template_path) do
      File.read!(template_path)
    else
      # Fallback for development: read from source
      source_path = Path.join([__DIR__, "templates", "theme.css"])
      File.read!(source_path)
    end
  end
end
