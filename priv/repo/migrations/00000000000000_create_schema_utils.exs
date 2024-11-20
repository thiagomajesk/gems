defmodule GEMS.Repo.Migrations.CreateSchemaUtils do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION check_fk_with_value(target_table TEXT, target_column TEXT, target_value ANYELEMENT)
    RETURNS BOOLEAN AS $$
    DECLARE result BOOLEAN;
    BEGIN
    EXECUTE
    format('SELECT EXISTS (SELECT 1 FROM %I WHERE %I = $1)', target_table, target_column)
    INTO result USING target_value;
    RETURN result;
    END;
    $$ LANGUAGE plpgsql;
    """
  end
end
