defmodule CashHoldWeb.UserView do
  use CashHoldWeb, :view
  alias CashHoldWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      password: user.password,
      avatar: user.avatar,
      is_deleted: user.is_deleted}
  end
end
