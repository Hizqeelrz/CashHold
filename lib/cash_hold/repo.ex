defmodule CashHold.Repo do
  use Ecto.Repo,
    otp_app: :cash_hold,
    adapter: Ecto.Adapters.Postgres
end
