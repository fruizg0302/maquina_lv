defmodule MaquinaLv.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/maquina-app/maquina_lv"

  def project do
    [
      app: :maquina_lv,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_options: [warnings_as_errors: true],
      deps: deps(),
      aliases: aliases(),
      description: description(),
      package: package(),
      source_url: @source_url,
      name: "Maquina LV",
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true,
        flags: [
          :unmatched_returns,
          :error_handling,
          :underspecs,
          :extra_return,
          :missing_return
        ]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "LiveView function components ported from maquina_components (Rails). Inspired by shadcn/ui. TailwindCSS 4.0, data-attribute CSS, JS hooks."
  end

  defp package do
    [
      maintainers: ["Fernando Ruiz Guzmán"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Ported from" => "https://github.com/maquina-app/maquina_components"
      },
      files: ~w(lib assets .formatter.exs mix.exs README.md LICENSE.md CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.0"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      precommit: [
        "compile --warnings-as-errors",
        "format",
        "credo --strict",
        "test"
      ],
      quality: [
        "compile --warnings-as-errors",
        "deps.unlock --check-unused",
        "format --check-formatted",
        "credo --strict",
        "cmd mix hex.audit",
        "dialyzer",
        "test"
      ]
    ]
  end
end
