defmodule Justify.MixProject do
  use Mix.Project

  def project do
    [
      app: :justify,
      description: "Validate unstructured data with Elixir",
      version: "2.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :dialyxir, "~> 1.1.0", only: :dev, runtime: false },
      { :ex_doc,   ">= 0.0.0",    only: :dev, runtime: false }
    ]
  end

  defp package do
    %{
      maintainers: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/malomohq/justify"
      }
    }
  end
end
