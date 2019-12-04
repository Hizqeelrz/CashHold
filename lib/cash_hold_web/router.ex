defmodule CashHoldWeb.Router do
  use CashHoldWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CashHoldWeb.Api do
    pipe_through :api

    post("/sign_in", SessionController, :sign_in)
    resources "/users", UserController, except: [:new, :edit]
    resources "/bank_account", BankAccountController, except: [:new, :edit]
    resources "/bank_transactions", BankTransactionController, except: [:new, :edit]
    get "/csv", BankTransactionController, :export
    post "/import", BankTransactionController, :import
  end
end
