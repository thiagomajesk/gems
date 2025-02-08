alias GEMS.Seeder

# Creates or updates the admin user.
# The default values are mostly useful for development.
# It's recommended to use environment variables for sensitive data.
config = Application.fetch_env!(:gems, Seeder)
Seeder.insert_admin(config[:admin_email], config[:admin_password])

# Trigger the seeds hook to execute the Lua code.
# You can define your custom code in the game's init.lua.
GEMSLua.Manager.trigger_hook(:on_seeds)
