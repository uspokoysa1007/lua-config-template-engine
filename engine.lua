-- Lua Config Template Engine
local function render_template(tmpl, ctx)
    local code = {"local _res = {}"}
    local pos = 1

    while true do
        local b_start, b_end = tmpl:find("<%%", pos, true)
        if not b_start then
            table.insert(code, string.format("_res[#_res+1] = %q", tmpl:sub(pos)))
            break
        end

        table.insert(code, string.format("_res[#_res+1] = %q", tmpl:sub(pos, b_start - 1)))

        local e_start, e_end = tmpl:find("%%>", b_end + 1, true)
        if not e_start then
            error("Unclosed template block starting at position " .. b_start)
        end

        local block = tmpl:sub(b_end + 1, e_start - 1)
        if block:sub(1, 1) == "=" then
            -- Expression interpolation
            local expr = block:sub(2)
            table.insert(code, string.format("_res[#_res+1] = tostring(%s)", expr))
        else
            -- Statement block
            table.insert(code, block)
        end

        pos = e_end + 1
    end

    table.insert(code, "return table.concat(_res)")
    local lua_chunk = table.concat(code, "\n")

    local env = setmetatable({}, { __index = function(_, k)
        if ctx[k] ~= nil then return ctx[k] end
        return _G[k]
    end })

    local fn, err = load(lua_chunk, "template", "t", env)
    if not fn then
        error("Template compilation error: " .. tostring(err))
    end
    return fn()
end

local template_path = arg[1] or "template.nginx.conf"
local context_path = arg[2] or "context.lua"
local output_path = arg[3] or "output.conf"

print("================================================================")
print("             LUA CONFIG TEMPLATE ENGINE                         ")
print("================================================================")
print("Template File: " .. template_path)
print("Context File : " .. context_path)

local tmpl_file = io.open(template_path, "r")
if not tmpl_file then
    error("Unable to open template file: " .. template_path)
end
local tmpl_content = tmpl_file:read("*a")
tmpl_file:close()

local ctx = dofile(context_path)
local rendered = render_template(tmpl_content, ctx)

local out_file = io.open(output_path, "w")
if out_file then
    out_file:write(rendered)
    out_file:close()
end

print("----------------------------------------------------------------")
print("[+] Rendered configuration successfully -> " .. output_path)
print("----------------------------------------------------------------")
print(rendered)
print("================================================================")
