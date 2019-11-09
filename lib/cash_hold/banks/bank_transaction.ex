defmodule CashHold.Banks.BankTransaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kernel

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bank_transactions" do
    field :balance, :integer, default: 0
    field :deposit_amount, :integer
    field :withdraw_amount, :integer
    field :user_id, :binary_id
    field :bank_account_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(bank_transaction, attrs) do
    bank_transaction
    |> cast(attrs, [:balance, :deposit_amount, :withdraw_amount, :user_id, :bank_account_id])
    |> validate_required([:balance])
    # |> calculate()
  end

  # defp calculate(%Ecto.Changeset{valid?: true, changes: %{balance: balance, deposit_amount: deposit_amount, withdraw_amount: withdraw_amount}} = changeset) do
  #   IO.inspect "This is working inside changset"
  #   IO.inspect changeset
  #   IO.inspect "this is below the changeset struct"

  #   case changeset.changes do
  #     %{deposit_amount: deposit_amount} when not is_nil(deposit_amount) ->
  #       IO.inspect deposit_amount
  #       IO.inspect "deposit amount is above"
  #       deposit_amount = get_change(changeset, :deposit_amount)
  #       changeset = put_change(changeset, :deposit_amount, deposit_amount * 100)
  #       IO.inspect changeset
  #       IO.inspect "changeset is between deposit amount"

  #       balance = get_change(changeset, :balance)

  #       IO.inspect balance
  #       IO.inspect "Balance is below deposit amount"
  #       changeset = put_change(changeset, :balance, balance * 100)
  #       deposit_amount2 = get_change(changeset, :deposit_amount)
  #       balance2 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, (balance2 / 100) + (deposit_amount2 / 100))
  #       balance3 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, balance3 * 100 )
  #       balance4 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, Kernel.floor(balance4))
  #       changeset = put_change(changeset, :deposit_amount, Kernel.floor(deposit_amount2))
  #       changeset

  #     %{withdraw_amount: withdraw_amount} when not is_nil(withdraw_amount) ->
  #       withdraw_amount = get_change(changeset, :withdraw_amount)
  #       changeset = put_change(changeset, :withdraw_amount, withdraw_amount * 100)
  #       balance = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, balance * 100)
  #       withdraw_amount2 = get_change(changeset, :withdraw_amount)
  #       balance2 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, (balance2 / 100) - (withdraw_amount2 / 100))
  #       balance3 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, balance3 * 100 )
  #       balance4 = get_change(changeset, :balance)
  #       changeset = put_change(changeset, :balance, Kernel.floor(balance4))
  #       changeset = put_change(changeset, :withdraw_amount, Kernel.floor(withdraw_amount2))
  #       changeset
  #     _ ->
  #       changeset
  #   end
  # end

  # defp calculate(changeset), do: changeset
end

# def calculate(%Ecto.Changeset{valid?: true, changes: %{balance: balance, deposit_amount: deposit_amount, withdraw_amount: withdraw_amount}} = changeset) do
#   case changeset.changes do
#     %{deposit_amount: deposit_amount} when not is_nil(deposit_amount) ->
#       deposit_amount = Ecto.Changeset.get_change(changeset, :deposit_amount)
#       changeset = Ecto.Changeset.put_change(changeset, :deposit_amount, deposit_amount * 100)
#       balance = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, balance * 100)
#       deposit_amount2 = Ecto.Changeset.get_change(changeset, :deposit_amount)
#       balance2 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, (balance2 / 100) + (deposit_amount2 / 100))
#       balance3 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, balance3 * 100 )
#       balance4 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, Kernel.floor(balance4))
#       changeset = Ecto.Changeset.put_change(changeset, :deposit_amount, Kernel.floor(deposit_amount2))
#       changeset
#     %{withdraw_amount: withdraw_amount} when not is_nil(withdraw_amount) ->
#       withdraw_amount = Ecto.Changeset.get_change(changeset, :withdraw_amount)
#       changeset = Ecto.Changeset.put_change(changeset, :withdraw_amount, withdraw_amount * 100)
#       balance = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, balance * 100)
#       withdraw_amount2 = Ecto.Changeset.get_change(changeset, :withdraw_amount)
#       balance2 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, (balance2 / 100) - (withdraw_amount2 / 100))
#       balance3 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, balance3 * 100 )
#       balance4 = Ecto.Changeset.get_change(changeset, :balance)
#       changeset = Ecto.Changeset.put_change(changeset, :balance, Kernel.floor(balance4))
#       changeset = Ecto.Changeset.put_change(changeset, :withdraw_amount, Kernel.floor(withdraw_amount2))
#       changeset
#   end
# end

# def to_cents(amount) do
#   amount * 100
# end

# def to_dollars(ammount) do
#   amount / 100
# end