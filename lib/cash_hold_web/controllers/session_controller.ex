defmodule CashHoldWeb.SessionController do
  use CashHoldWeb, :controller
  alias CashHold.Auth
  alias CashHold.Accounts

  def sign_in(conn, %{"email" => email, "password" => password}) do
    email = String.downcase(email)
    case Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn, user} ->
        token = conn.assigns.jwt_token
        
        conn
        |> put_status(200)
        |> render("sign_in.json", token: token, user: user)

      {:error, _reason, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: "The username or password you have entered is invalid."})
    end
  end


  # def forgot_password(conn, %{"email" => email}) do
  #   case Accounts.get_user_by_email(email) do
  #     nil ->
  #       conn
  #       |> put_status(200)
  #       |> json(%{
  #         msg: "User not found"
  #       })
  #     user ->
  #       token = Accounts.six_digit_token()
  #       send_forgot_password_notification(user, token)
  #       send_sms(user, token)
        
  #       conn
  #       |> put_status(200)
  #       |> json(%{
  #         msg: "Token has been sent to your phone and/or email"
  #       })
  #   end
  # end
end