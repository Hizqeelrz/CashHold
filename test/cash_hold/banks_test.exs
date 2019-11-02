defmodule CashHold.BanksTest do
  use CashHold.DataCase

  alias CashHold.Banks

  describe "bank_account" do
    alias CashHold.Banks.BankAccount

    @valid_attrs %{account_number: "some account_number", account_title: "some account_title", account_type: "some account_type", bank_name: "some bank_name", branch_address: "some branch_address", branch_name: "some branch_name", branch_number: "some branch_number"}
    @update_attrs %{account_number: "some updated account_number", account_title: "some updated account_title", account_type: "some updated account_type", bank_name: "some updated bank_name", branch_address: "some updated branch_address", branch_name: "some updated branch_name", branch_number: "some updated branch_number"}
    @invalid_attrs %{account_number: nil, account_title: nil, account_type: nil, bank_name: nil, branch_address: nil, branch_name: nil, branch_number: nil}

    def bank_account_fixture(attrs \\ %{}) do
      {:ok, bank_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Banks.create_bank_account()

      bank_account
    end

    test "list_bank_account/0 returns all bank_account" do
      bank_account = bank_account_fixture()
      assert Banks.list_bank_account() == [bank_account]
    end

    test "get_bank_account!/1 returns the bank_account with given id" do
      bank_account = bank_account_fixture()
      assert Banks.get_bank_account!(bank_account.id) == bank_account
    end

    test "create_bank_account/1 with valid data creates a bank_account" do
      assert {:ok, %BankAccount{} = bank_account} = Banks.create_bank_account(@valid_attrs)
      assert bank_account.account_number == "some account_number"
      assert bank_account.account_title == "some account_title"
      assert bank_account.account_type == "some account_type"
      assert bank_account.bank_name == "some bank_name"
      assert bank_account.branch_address == "some branch_address"
      assert bank_account.branch_name == "some branch_name"
      assert bank_account.branch_number == "some branch_number"
    end

    test "create_bank_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Banks.create_bank_account(@invalid_attrs)
    end

    test "update_bank_account/2 with valid data updates the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{} = bank_account} = Banks.update_bank_account(bank_account, @update_attrs)
      assert bank_account.account_number == "some updated account_number"
      assert bank_account.account_title == "some updated account_title"
      assert bank_account.account_type == "some updated account_type"
      assert bank_account.bank_name == "some updated bank_name"
      assert bank_account.branch_address == "some updated branch_address"
      assert bank_account.branch_name == "some updated branch_name"
      assert bank_account.branch_number == "some updated branch_number"
    end

    test "update_bank_account/2 with invalid data returns error changeset" do
      bank_account = bank_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Banks.update_bank_account(bank_account, @invalid_attrs)
      assert bank_account == Banks.get_bank_account!(bank_account.id)
    end

    test "delete_bank_account/1 deletes the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = Banks.delete_bank_account(bank_account)
      assert_raise Ecto.NoResultsError, fn -> Banks.get_bank_account!(bank_account.id) end
    end

    test "change_bank_account/1 returns a bank_account changeset" do
      bank_account = bank_account_fixture()
      assert %Ecto.Changeset{} = Banks.change_bank_account(bank_account)
    end
  end

  describe "bank_transactions" do
    alias CashHold.Banks.BankTransaction

    @valid_attrs %{balance: "some balance", deposit_amount: "some deposit_amount", withdraw_amount: "some withdraw_amount"}
    @update_attrs %{balance: "some updated balance", deposit_amount: "some updated deposit_amount", withdraw_amount: "some updated withdraw_amount"}
    @invalid_attrs %{balance: nil, deposit_amount: nil, withdraw_amount: nil}

    def bank_transaction_fixture(attrs \\ %{}) do
      {:ok, bank_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Banks.create_bank_transaction()

      bank_transaction
    end

    test "list_bank_transactions/0 returns all bank_transactions" do
      bank_transaction = bank_transaction_fixture()
      assert Banks.list_bank_transactions() == [bank_transaction]
    end

    test "get_bank_transaction!/1 returns the bank_transaction with given id" do
      bank_transaction = bank_transaction_fixture()
      assert Banks.get_bank_transaction!(bank_transaction.id) == bank_transaction
    end

    test "create_bank_transaction/1 with valid data creates a bank_transaction" do
      assert {:ok, %BankTransaction{} = bank_transaction} = Banks.create_bank_transaction(@valid_attrs)
      assert bank_transaction.balance == "some balance"
      assert bank_transaction.deposit_amount == "some deposit_amount"
      assert bank_transaction.withdraw_amount == "some withdraw_amount"
    end

    test "create_bank_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Banks.create_bank_transaction(@invalid_attrs)
    end

    test "update_bank_transaction/2 with valid data updates the bank_transaction" do
      bank_transaction = bank_transaction_fixture()
      assert {:ok, %BankTransaction{} = bank_transaction} = Banks.update_bank_transaction(bank_transaction, @update_attrs)
      assert bank_transaction.balance == "some updated balance"
      assert bank_transaction.deposit_amount == "some updated deposit_amount"
      assert bank_transaction.withdraw_amount == "some updated withdraw_amount"
    end

    test "update_bank_transaction/2 with invalid data returns error changeset" do
      bank_transaction = bank_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Banks.update_bank_transaction(bank_transaction, @invalid_attrs)
      assert bank_transaction == Banks.get_bank_transaction!(bank_transaction.id)
    end

    test "delete_bank_transaction/1 deletes the bank_transaction" do
      bank_transaction = bank_transaction_fixture()
      assert {:ok, %BankTransaction{}} = Banks.delete_bank_transaction(bank_transaction)
      assert_raise Ecto.NoResultsError, fn -> Banks.get_bank_transaction!(bank_transaction.id) end
    end

    test "change_bank_transaction/1 returns a bank_transaction changeset" do
      bank_transaction = bank_transaction_fixture()
      assert %Ecto.Changeset{} = Banks.change_bank_transaction(bank_transaction)
    end
  end
end
