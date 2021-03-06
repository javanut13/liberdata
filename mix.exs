defmodule Liberdata.Mixfile do
  use Mix.Project

  def project do
    [
      app: :liberdata,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Liberdata.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:amf, git: "https://github.com/sile/erl-amf.git", tag: "v0.1.3", override: true},
      {:rtmpmsg, git: "https://github.com/sile/erl-rtmpmsg.git", tag: "v0.2.10"},
      {:httpoison, "~> 0.12.0"},
      {:poison, "~> 3.1"},
      {:csv, "~> 1.4"},
      {:briefly, "~> 0.3"},
      {:earmark, "~> 1.2.2"}
    ]
  end
end
