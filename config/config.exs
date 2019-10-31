# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cash_hold,
  ecto_repos: [CashHold.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :cash_hold, CashHoldWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PYSQ5VjvuNWp11J+cFPKngO0k6ysMUrPa10t2y4zBdOiTNxLAwvV+SRgv/qk1GD8",
  render_errors: [view: CashHoldWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CashHold.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken, default_signer: "secret"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
