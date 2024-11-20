defmodule GEMS.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GEMS.Accounts` context.
  """

  def user_fixture(attrs \\ %{}) do
    attrs = valid_user_attributes(attrs)
    with {:ok, user} <- GEMS.Accounts.register_user(attrs), do: user
  end

  defp valid_user_attributes(attrs) do
    Enum.into(attrs, %{
      email: "user#{System.unique_integer()}@example.com",
      password: "hello world!"
    })
  end
end
