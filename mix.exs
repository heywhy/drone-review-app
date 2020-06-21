defmodule ReviewAppDeployer.MixProject do
  use Mix.Project

  def project do
    [
      app: :review_app_deployer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript do
    [
      path: "./bin/deployer",
      main_module: ReviewAppDeployer.CLI
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:optimus, "~> 0.1.0"}
    ]
  end
end
