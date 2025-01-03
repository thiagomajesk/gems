defmodule GEMSWeb.FormHelpers do
  use Phoenix.Component

  alias GEMSWeb.ErrorHelpers

  @doc """
  Checks if any of the given fields are used in the form
  """
  def used_any_input?(form, fields) do
    Enum.any?(fields, &Phoenix.Component.used_input?(form[&1]))
  end

  @doc """
  Assigns the basic state for a input using form field
  """
  def assign_input_state(assigns, %Phoenix.HTML.FormField{} = field) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil)
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> assign(:errors, Enum.map(errors, &ErrorHelpers.translate_error(&1)))
  end
end
