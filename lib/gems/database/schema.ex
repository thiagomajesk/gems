defmodule GEMS.Database.Schema do
  defmacro __using__(preset) do
    apply(__MODULE__, preset, [])
  end

  def resource do
    quote do
      unquote(default())

      use GEMS.Database.Resource
    end
  end

  def default do
    quote do
      use Ecto.Schema
      import Ecto.Changeset, warn: false
      import Ecto.Query, warn: false

      alias __MODULE__

      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
