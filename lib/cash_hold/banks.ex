defmodule CashHold.Banks do
  @moduledoc """
  The Banks context.
  """

  import Ecto.Query, warn: false
  alias CashHold.Repo

  alias CashHold.Banks.BankAccount

  @doc """
  Returns the list of bank_account.

  ## Examples

      iex> list_bank_account()
      [%BankAccount{}, ...]

  """
  def list_bank_account do
    Repo.all(BankAccount)
  end

  @doc """
  Gets a single bank_account.

  Raises `Ecto.NoResultsError` if the Bank account does not exist.

  ## Examples

      iex> get_bank_account!(123)
      %BankAccount{}

      iex> get_bank_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank_account!(id), do: Repo.get!(BankAccount, id)

  @doc """
  Creates a bank_account.

  ## Examples

      iex> create_bank_account(%{field: value})
      {:ok, %BankAccount{}}

      iex> create_bank_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank_account(attrs \\ %{}) do
    %BankAccount{}
    |> BankAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank_account.

  ## Examples

      iex> update_bank_account(bank_account, %{field: new_value})
      {:ok, %BankAccount{}}

      iex> update_bank_account(bank_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank_account(%BankAccount{} = bank_account, attrs) do
    bank_account
    |> BankAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BankAccount.

  ## Examples

      iex> delete_bank_account(bank_account)
      {:ok, %BankAccount{}}

      iex> delete_bank_account(bank_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank_account(%BankAccount{} = bank_account) do
    Repo.delete(bank_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_account changes.

  ## Examples

      iex> change_bank_account(bank_account)
      %Ecto.Changeset{source: %BankAccount{}}

  """
  def change_bank_account(%BankAccount{} = bank_account) do
    BankAccount.changeset(bank_account, %{})
  end

  alias CashHold.Banks.BankTransaction

  @doc """
  Returns the list of bank_transactions.

  ## Examples

      iex> list_bank_transactions()
      [%BankTransaction{}, ...]

  """
  def list_bank_transactions(params) do

    IO.inspect params
    # today = Timex.to_naive_datetime(Timex.today)
    today = Timex.today
    sday = Timex.beginning_of_year(today)
    eday = Timex.end_of_year(today)


    min = parse_amount(params["min"])
    max = parse_amount(params["max"])

    IO.inspect min
    IO.inspect max


    query = from bt in BankTransaction, order_by: [asc: bt.id]

    query = if params["name"] == "balance", do: (from b in query, where: b.balance > ^min and b.balance < ^max), else: query
    query = if params["name"] == "deposit_amount", do: (from b in query, where: b.deposit_amount > ^min and b.deposit_amount < ^max), else: query
    query = if params["name"] == "withdraw_amount", do: (from b in query, where: b.withdraw_amount > ^min and b.withdraw_amount < ^max), else: query

    Repo.all(query)
  end

  defp parse_amount(num) do
    case Integer.parse(num) do
      {num, _} -> num * 100
      _ -> 0
    end
  end

  def account_last_transaction do
    Ecto.Query.from(u in BankTransaction) 
    |> Ecto.Query.last(:inserted_at) |> Repo.one
  end

  def csv_to_export do
    query = from bt in BankTransaction #, where: bt.deposit_amount == 755095
    Repo.all(query)
  end
  @doc """
  Gets a single bank_transaction.

  Raises `Ecto.NoResultsError` if the Bank transaction does not exist.

  ## Examples

      iex> get_bank_transaction!(123)
      %BankTransaction{}

      iex> get_bank_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank_transaction!(id), do: Repo.get!(BankTransaction, id)

  @doc """
  Creates a bank_transaction.

  ## Examples

      iex> create_bank_transaction(%{field: value})
      {:ok, %BankTransaction{}}

      iex> create_bank_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank_transaction(attrs \\ %{}) do
    %BankTransaction{}
    |> BankTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank_transaction.

  ## Examples

      iex> update_bank_transaction(bank_transaction, %{field: new_value})
      {:ok, %BankTransaction{}}

      iex> update_bank_transaction(bank_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank_transaction(%BankTransaction{} = bank_transaction, attrs) do
    bank_transaction
    |> BankTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BankTransaction.

  ## Examples

      iex> delete_bank_transaction(bank_transaction)
      {:ok, %BankTransaction{}}

      iex> delete_bank_transaction(bank_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank_transaction(%BankTransaction{} = bank_transaction) do
    Repo.delete(bank_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_transaction changes.

  ## Examples

      iex> change_bank_transaction(bank_transaction)
      %Ecto.Changeset{source: %BankTransaction{}}

  """
  def change_bank_transaction(%BankTransaction{} = bank_transaction) do
    BankTransaction.changeset(bank_transaction, %{})
  end

  # refactored methods for bank transaction

  def sum_up_for_nil(bank_transaction_params) do
    bank_transaction_params = Map.put(bank_transaction_params, "balance", 0)

    balance = bank_transaction_params["balance"]
    balance = to_cents(balance)

    deposit_amount = bank_transaction_params["deposit_amount"]
    deposit_amount = to_cents(deposit_amount)

    total_balance = to_dollars(balance) + to_dollars(deposit_amount)
    total_balance = to_cents(total_balance)

    total_balance = Kernel.floor(total_balance)
    deposit_amount = Kernel.floor(deposit_amount)

    bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)
    bank_transaction_params = Map.put(bank_transaction_params, "deposit_amount", deposit_amount)
  end

  def sum_up_for_deposit(last_transaction, bank_transaction_params) do
    bank_transaction_params = Map.put(bank_transaction_params, "balance", last_transaction.balance)

    balance = bank_transaction_params["balance"]
    # balance = to_cents(balance)

    deposit_amount = bank_transaction_params["deposit_amount"]
    deposit_amount = to_cents(deposit_amount)

    total_balance = to_dollars(balance) + to_dollars(deposit_amount)
    total_balance = to_cents(total_balance)
    total_balance = Kernel.floor(total_balance)
    deposit_amount = Kernel.floor(deposit_amount)

    bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)
    bank_transaction_params = Map.put(bank_transaction_params, "deposit_amount", deposit_amount)
  end

  def sub_withdraw_amount(last_transaction, bank_transaction_params) do
    bank_transaction_params = Map.put(bank_transaction_params, "balance", last_transaction.balance)

    balance = bank_transaction_params["balance"]
    # balance = to_cents(balance)

    withdraw_amount = bank_transaction_params["withdraw_amount"]
    withdraw_amount = to_cents(withdraw_amount)

    total_balance = to_dollars(balance) - to_dollars(withdraw_amount)
    total_balance = to_cents(total_balance)
    total_balance = Kernel.floor(total_balance)
    withdraw_amount = Kernel.floor(withdraw_amount)
    withdraw_amount = to_cents(withdraw_amount)

    bank_transaction_params = Map.put(bank_transaction_params, "balance", total_balance)
    bank_transaction_params = Map.put(bank_transaction_params, "withdraw_amount", withdraw_amount)
  end

  # private methods

  def to_cents(amount) do
    amount * 100
  end

  def to_dollars(amount) do
    amount / 100
  end
end
