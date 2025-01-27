alias GEMS.Seeder

# Creates or updates the admin user.
# The default values are most useful for development.
# It's recommended to use environment variables for sensitive data
email = System.get_env("GEMS_ADMIN_EMAIL", "mail@domain.com")
password = System.get_env("GEMS_ADMIN_PASSWORD", "123123123")
Seeder.create_admin(email, password)

# Trigger the seeds hook to execute the Lua code.
# You can define your custom code in the game's init.lua.
GEMSLua.Manager.trigger_hook(:on_seeds)
