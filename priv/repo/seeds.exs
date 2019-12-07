# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CashHold.Repo.insert!(%CashHold.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CashHold.Banks
alias CashHold.Banks.BankTransaction
alias CashHold.Banks.BankAccount

rand = 1..10000

# bang(!) function do not have {:ok, abc} just abc

for b <- 1..3 do
  
  attrs = %{current_balance: 0}
  {:ok, ba} = Banks.create_bank_account(attrs)
  
  for bt <- 1..3 do
    amount = Enum.random(rand) * 100

    ba1 = Banks.get_bank_account!(ba.id)

    attrs1 = %{
      balance: ba1.current_balance + amount,
      deposit_amount: amount
    }
    {:ok, _} = Banks.create_bank_transaction(attrs1)

    attrs2 = %{
      current_balance: ba1.current_balance + amount
    }
    
    {:ok, ba2} = Banks.update_bank_account(ba1, attrs2)
    
  end

end