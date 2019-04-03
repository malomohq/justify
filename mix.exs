defmodule Justify.MixProject do
  use Mix.Project

  def project do
    [
      app: :justify,
      description: "Data validation for Elixir",
      version: "1.0.1",
      elixir: "~> 1.3",
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
      { :dialyxir, "~> 1.0.0-rc", only: :dev, runtime: false },
      { :ex_doc,   ">= 0.0.0",    only: :dev, runtime: false }
    ]
  end

  defp package do
    %{
      maintainers: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/sticksnleaves/justify"
      }
    }
  end
end
