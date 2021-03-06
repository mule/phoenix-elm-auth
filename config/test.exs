use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenixAuthKata, PhoenixAuthKata.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenixAuthKata, PhoenixAuthKata.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "password",
  database: "phoenixauthkata_test",
  hostname: "192.168.99.100",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox
