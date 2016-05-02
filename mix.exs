defmodule VoiceController.Mixfile do
  use Mix.Project

  @target "rpi2"

  def project do
    [app: :voice_controller,
     version: "0.0.1",
     elixir: "~> 1.2",
     archives: [nerves_bootstrap: "~> 0.1"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     target: @target,
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     config_path: "config/#{@target}/config.exs",
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :nerves, :movi, :poison],
    mod: {VoiceController, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:nerves, github: "nerves-project/nerves", branch: "mix"},
      {:poison, "~> 2.1"},
      {:httpoison, "~> 0.8.3"},
      {:movi, github: "NationalAssociationOfRealtors/movi"},
    ]
  end

  def system("rpi2") do
    [{:nerves_system_rpi2, github: "nerves-project/nerves_system_rpi2"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end
