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
  def list_bank_transactions do
    Repo.all(BankTransaction)
  end

  # def calculate_balance do
    
  # end

  # def deposit_and_withdraw(deposit \\ nil, withdraw \\ nil) do
    
  # end

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
end
