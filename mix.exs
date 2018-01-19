defmodule Justify.Mixfile do
  use Mix.Project

  def project do
    [
      app: :justify,
      description: "Simple data validation for Elixir",
      version: "0.1.2",
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [ :logger ]
    ]
  end

  defp deps do
    [
      { :ex_doc, "> 0.0.0", only: [ :dev ] }
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
