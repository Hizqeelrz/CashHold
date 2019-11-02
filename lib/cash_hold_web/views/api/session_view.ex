defmodule CashHoldWeb.Api.SessionView do
  use CashHoldWeb, :view
  alias CashHoldWeb.Api.{
                    SessionView,
                    UserView
                    }

  def render("sign_in.json", %{token: token, user: user}) do
    %{
      token: token,
      user: render_one(user, UserView, "user.json", as: :user)
    }
  end
end
