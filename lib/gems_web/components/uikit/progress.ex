defmodule GEMSWeb.UIKIT.Progress do
  use GEMSWeb, :html

  attr :character, :map, required: true

  def experience(assigns) do
    assigns =
      assigns
      |> assign_new(:value, &(&1.character.experience + 50))
      |> assign_new(:max, &GEMS.Leveling.experience(&1.character.level))
      |> assign_new(:progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div
      class="h-6 bg-black/40 relative shadow-lg rounded-sm grow"
      title={"Experience: #{@value}/#{@max}"}
    >
      <div
        class={[
          "absolute inset-y-0 left-0 transition-all duration-300 rounded-sm",
          exp_gradient_class(@progress)
        ]}
        style={"width: #{@progress}%;"}
      />
      <small class={[
        "absolute inset-0 flex items-center justify-center px-2 text-white",
        "[text-shadow:-1px_-1px_0_#000,1px_-1px_0_#000,-1px_1px_0_#000,1px_1px_0_#000]"
      ]}>
        Level 1
      </small>
    </div>
    """
  end

  attr :max, :integer, required: true
  attr :value, :integer, required: true

  def profession(assigns) do
    assigns = assign_new(assigns, :progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div class="h-2 bg-black/40 relative rounded grow" title={"Experience: #{@value}/#{@max}"}>
      <div
        class={[
          "absolute inset-y-0 left-0 transition-all duration-300 rounded",
          profession_gradient_class(@progress)
        ]}
        style={"width: #{@progress}%;"}
      />
    </div>
    """
  end

  attr :character, :map, required: true

  def stamina(assigns) do
    assigns =
      assigns
      |> assign_new(:value, & &1.character.stamina)
      |> assign_new(:max, &(&1.character.level * 1000))
      |> assign_new(:progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div class="h-1 bg-black/40 relative grow" title={"Stamina: #{@value}/#{@max}"}>
      <div
        class={[
          "absolute inset-y-0 left-0 transition-all duration-300 rounded-full",
          stamina_gradient_class(@progress)
        ]}
        style={"width: #{@progress}%;"}
      />
    </div>
    """
  end

  # Experience gradients (blue/indigo to purple transitions)
  defp exp_gradient_class(progress) when progress <= 25,
    do: "bg-gradient-to-r from-indigo-900 to-purple-800"

  defp exp_gradient_class(progress) when progress <= 50,
    do: "bg-gradient-to-r from-indigo-700 to-purple-600"

  defp exp_gradient_class(progress) when progress <= 75,
    do: "bg-gradient-to-r from-indigo-600 to-purple-500"

  defp exp_gradient_class(_progress),
    do: "bg-gradient-to-r from-indigo-500 to-purple-400"

  # Profession gradients (balanced green transitions)
  defp profession_gradient_class(progress) when progress <= 25,
    do: "bg-gradient-to-r from-emerald-900 via-green-800 to-emerald-700"

  defp profession_gradient_class(progress) when progress <= 50,
    do: "bg-gradient-to-r from-emerald-700 via-green-600 to-emerald-500"

  defp profession_gradient_class(progress) when progress <= 75,
    do: "bg-gradient-to-r from-emerald-600 via-green-500 to-emerald-400"

  defp profession_gradient_class(_progress),
    do:
      "bg-gradient-to-r from-emerald-500 via-green-400 to-emerald-300 shadow-[0_0_8px_rgba(16,185,129,0.2)]"

  # Stamina gradients (red/orange theme with gradual glow)
  defp stamina_gradient_class(progress) when progress <= 25,
    do: "bg-gradient-to-r from-red-900 to-orange-800 shadow-[0_0_4px_rgba(234,88,12,0.1)]"

  defp stamina_gradient_class(progress) when progress <= 50,
    do: "bg-gradient-to-r from-red-700 to-orange-600 shadow-[0_0_6px_rgba(234,88,12,0.3)]"

  defp stamina_gradient_class(progress) when progress <= 75,
    do: "bg-gradient-to-r from-red-600 to-orange-500 shadow-[0_0_8px_rgba(234,88,12,0.5)]"

  defp stamina_gradient_class(_progress),
    do: "bg-gradient-to-r from-red-500 to-orange-400 shadow-[0_0_12px_rgba(234,88,12,0.7)]"

  defp calculate_progress(value, max), do: round(value / max * 100)
end
