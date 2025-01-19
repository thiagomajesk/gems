GEMS = GEMS or {}
GEMS.utils = GEMS.utils or {}

--- Recursively prints the contents of a table in a formatted manner.
--
-- This function takes a table as an argument and prints each key-value pair
-- in the format "key: value". If a value is a table, it recursively prints
-- its contents. If the argument is not a table, it raises an error.
--
-- @param table The table to be printed.
-- @param indent The current indentation level (used for recursive calls).
-- @raise Error if the argument is not a table.
function GEMS.utils.dump_table(table, indent)
    if type(table) ~= "table" then
        error("Argument is not a table.")
    end

    indent = indent or 0
    local indentStr = string.rep("  ", indent)

    for key, value in pairs(table) do
        if type(value) == "table" then
            print(string.format("%s%s = {", indentStr, tostring(key)))
            GEMS.utils.dump_table(value, indent + 1)
            print(string.format("%s}", indentStr))
        else
            print(string.format("%s%s = %s", indentStr, tostring(key), tostring(value)))
        end
    end
end
