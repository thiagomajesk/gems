defmodule GEMS.Macros do
  @moduledoc """
  Pipes value into fun if condition is true, otherwise returns value.
  """
  defmacro maybe(value, condition, fun) do
    quote bind_quoted: [value: value, condition: condition, fun: fun] do
      if condition, do: fun.(value), else: value
    end
  end
end
