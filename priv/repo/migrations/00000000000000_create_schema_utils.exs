defmodule GEMS.Repo.Migrations.CreateSchemaUtils do
  use Ecto.Migration

  def change do
    execute """
    create or replace function check_column_value(
      foreign_id uuid,
      foreign_table text,
      check_column text,
      expected_value text
    ) returns boolean as $$
    declare
      result boolean;
    begin
      execute format(
        'select exists(select 1 from %I where id = %L and %I = %L)',
        foreign_table, foreign_id, check_column, expected_value
      ) into result;
      return result;
    end;
    $$ language plpgsql;
    """
  end
end
