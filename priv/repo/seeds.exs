alias GEMS.Seeder

# Default admin user
Seeder.create_admin("123123123")

# Call the on seeds hook
GEMSLua.Manager.trigger_hook(:on_seeds)
