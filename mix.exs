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
      deps: deps(),
      description: description(),
      package: package(),
      source_url: @source_url,
      name: "MaquinaLv",
      docs: docs()
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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
