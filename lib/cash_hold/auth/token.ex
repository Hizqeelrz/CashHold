defmodule CashHold.Token do
  use Joken.Config

  def token_config, do: default_claims(default_exp: 60 * 60) # this is set for 2h by default
end