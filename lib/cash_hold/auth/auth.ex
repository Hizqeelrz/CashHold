defmodule CashHold.Auth do
  import Plug.Conn

  alias CashHold.Repo
  alias CashHold.Accounts
  alias CashHold.Accounts.User
  import Joken
  import Phoenix.Controller, only: [json: 2]

  def init(_opts) do
  end

  def call(conn, _opts) do
    jwt_token = fetch_token(conn)

    claims = verified_token(conn, jwt_token)
    user_id = claims["user_id"]
    user = user_id && Repo.get(User, user_id)
    jwt_token = my_token(conn, user)

    conn
    |> put_resp_header("authorization", jwt_token)
    |> assign(:current_user, user)
    |> assign(:jwt_token, jwt_token)
  end

  defp fetch_token(conn) do
    token =
      conn
      |> get_req_header("authorization")
      |> List.first()

    is_nil?(conn, token)
  end

  defp is_nil?(conn, token) do
    case token do
      nil ->
        conn
        |> json(%{error: "invalid token"})
        |> halt()
      token ->
        token
    end
  end

  defp my_token(conn, user) do
    claims = %{user_id: user.id} 
                    |> CashHold.Token.generate_and_sign()
    
    case claims do
      {:ok, jwt_token, _} -> jwt_token
      _ -> 
        conn
        |> json(%{error: "invalid token"})
        |> halt()
    end
  end

  defp verified_token(conn, token_string) when is_binary(token_string) do
    claims = token_string
                    |> CashHold.Token.verify_and_validate
    
    case claims do
      {:ok, claims} -> claims
      _ -> 
        conn
        |> json(%{error: "invalid token"})
        |> halt()
    end
  end
  
  def login(conn, user) do
    jwt_token = my_token(conn, user)

    conn = conn
      |> put_resp_header("authorization", jwt_token)
      |> assign(:current_user, user)
      |> assign(:jwt_token, jwt_token)

    {conn, user}
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Argon2.verify_pass(given_pass, user.password_hash) ->
        {conn, user} = login(conn, user)
        {:ok, conn, user}
        
      user ->
        {:error, :unauthorized, conn}
        
      true ->
        {:error, :not_found, conn}
    end
  end

  # def login_by_email_and_pass(conn, email, given_pass) do
  #   user = Accounts.get_user_by_email(email)

  #   cond do
  #     user && Argon2.verify_pass(given_pass, user.password_hash) ->
  #       now = NaiveDateTime.utc_now()
  #       locked_at = user.locked_at || ~N[1970-01-01 00:00:01]
  #       diff = NaiveDateTime.diff(now, locked_at)
  #       if diff < 3600 do
  #         Accounts.lock_user(user, %{bad_attempts: 0}) 
  #         {:error, :locked, conn}
  #       else
  #         Accounts.lock_user(user, %{bad_attempts: 0}) 
  #         {conn, user} = login(conn, user)
  #         {:ok, conn, user}
  #       end

  #     user ->
  #       now = NaiveDateTime.utc_now()
  #       last_attempt_at = user.last_attempt_at || ~N[1970-01-01 00:00:01]
  #       diff = NaiveDateTime.diff(now, last_attempt_at)
        
  #       if (diff < 600) && (user.bad_attempts >= 3) do
  #         Accounts.lock_user(user, %{bad_attempts: user.bad_attempts + 1, locked_at: NaiveDateTime.utc_now()}) 
  #         {:error, :locked, conn}
  #       else
  #         Accounts.lock_user(user, %{bad_attempts: user.bad_attempts + 1, last_attempt_at: NaiveDateTime.utc_now()}) 
  #         {:error, :unauthorized, conn}
  #       end
  #     true ->
  #       {:error, :not_found, conn}
  #   end
  # end

  # def logout(conn) do
  #   delete_session(conn, :user_id)
  # end
end
