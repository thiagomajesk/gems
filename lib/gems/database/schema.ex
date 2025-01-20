defmodule GEMS.Database.Schema do
  defmacro __using__(opts) do
    {preset, opts} = Keyword.pop!(opts, :preset)
    apply(__MODULE__, preset, [opts])
  end

  def collection(opts) do
    {required_fields, opts} = Keyword.pop(opts, :required_fields, [])
    {optional_fields, opts} = Keyword.pop(opts, :optional_fields, [])
    {default_preloads, opts} = Keyword.pop(opts, :default_preloads, [])

    quote do
      unquote(default(opts))

      use GEMS.Database.Collection,
        required_fields: unquote(required_fields),
        optional_fields: unquote(optional_fields),
        default_preloads: unquote(default_preloads)
    end
  end

  def default(_opts) do
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
