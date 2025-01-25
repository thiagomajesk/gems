defmodule GEMSWeb.FormHelpers do
  use Phoenix.Component

  alias GEMS.ErrorHelpers

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
    assigns
    |> assign_new(:id, fn -> field.id end)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> assign(:errors, input_errors(field))
  end

  @doc """
  Gets the translated errors for a given form field.
  Can force the errors even if the field was not used.
  """
  def input_errors(field, opts \\ [])

  def input_errors(%Phoenix.HTML.FormField{} = field, opts) do
    if opts[:force] || Phoenix.Component.used_input?(field),
      do: Enum.map(field.errors, &ErrorHelpers.translate_error(&1)),
      else: []
  end
end
