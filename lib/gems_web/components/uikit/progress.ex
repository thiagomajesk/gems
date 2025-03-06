defmodule GEMSWeb.UIKIT.Progress do
  use GEMSWeb, :html

  attr :activity, :map, required: true
  attr :timer, :map, required: true

  def activity(assigns) do
    %{activity: activity, timer: timer} = assigns

    timestamp =
      if timer do
        remaining = Process.read_timer(timer)

        DateTime.utc_now()
        |> DateTime.add(remaining, :millisecond)
        |> DateTime.to_iso8601()
      end

    main_id = "activity-progress-main-#{activity.id}"
    trail_id = "activity-progress-trail-#{activity.id}"
    wrapper_id = "activity-progress-wrapper-#{activity.id}"

    props = %{
      main: "##{main_id}",
      trail: "##{trail_id}",
      timestamp: timestamp
    }

    assigns =
      assigns
      |> assign(:main_id, main_id)
      |> assign(:trail_id, trail_id)
      |> assign(:wrapper_id, wrapper_id)
      |> assign_props(props)

    ~H"""
    <div
      id={@wrapper_id}
      phx-update="ignore"
      phx-hook="ActivityProgress"
      data-props={@props}
      class="relative flex w-full h-2 outline-2 outline-base-content/10 bg-base-content/5 rounded-box overflow-hidden group"
      role="progressbar"
    >
      <div
        id={@trail_id}
        class={[
          "absolute h-2 flex flex-col justify-center rounded-box overflow-hidden text-xs text-white text-center whitespace-nowrap",
          "transition duration-500 transition-[width] ease-out bg-gradient-to-r from-orange-200 via-amber-200 to-yellow-100 shadow"
        ]}
      >
      </div>
      <div
        id={@main_id}
        class={[
          "absolute h-2 flex flex-col justify-center rounded-box overflow-hidden bg-blue-600 text-xs text-white text-center whitespace-nowrap",
          "transition duration-500 transition-[width] ease-out bg-gradient-to-r from-orange-500 via-amber-500 to-yellow-400 shadow"
        ]}
      >
      </div>
    </div>
    """
  end

  attr :character, :map, required: true

  def experience(assigns) do
    assigns =
      assigns
      |> assign_new(:value, & &1.character.experience)
      |> assign_new(:max, &GEMS.Leveling.class_experience(&1.character.level))
      |> assign_new(:progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div
      aria-valuenow={@value}
      aria-valuemax={@max}
      class="flex w-full h-5 relative bg-base-content/5 rounded overflow-hidden"
      title={"Experience: #{@value}/#{@max}"}
    >
      <div
        class={[
          "flex flex-col justify-center overflow-hidden transition-all duration-300",
          "bg-linear-to-r from-indigo-600 to-cyan-400"
        ]}
        style={"width: #{@progress}%;"}
      />
      <div class="absolute inset-0 flex items-center justify-center">
        <span class="glass rounded-selector px-2 text-[10px] uppercase font-semibold">
          Level {@character.level}
        </span>
      </div>
    </div>
    """
  end

  attr :max, :integer, required: true
  attr :value, :integer, required: true

  def profession(assigns) do
    assigns = assign_new(assigns, :progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div
      aria-valuenow={@value}
      aria-valuemax={@max}
      class="flex w-full h-2 relative bg-base-content/5 rounded-full overflow-hidden"
      title={"Experience: #{@value}/#{@max}"}
    >
      <div
        class={[
          "flex flex-col justify-center overflow-hidden transition-all duration-300",
          "bg-linear-to-r from-green-400 to-emerald-300"
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
      |> assign_new(:max, &GEMS.Engine.Constants.max_stamina(&1.character.level))
      |> assign_new(:progress, &calculate_progress(&1.value, &1.max))

    ~H"""
    <div
      aria-valuenow={@value}
      aria-valuemax={@max}
      class="h-1 bg-base-300 relative grow"
      title={"Stamina: #{@value}/#{@max}"}
    >
      <div
        class={[
          "absolute inset-y-0 left-0 transition-all duration-300 rounded-full",
          "bg-linear-to-r from-red-500 to-orange-400 shadow-[0_0_12px_rgba(234,88,12,0.7)]"
        ]}
        style={"width: #{@progress}%;"}
      />
    </div>
    """
  end

  defp calculate_progress(value, max), do: min(round(value / max * 100), max)
end
