local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local function split_top_level(text, delimiter)
	local parts = {}
	local current = {}
	local depth = 0
	local quote = nil
	local escaped = false

	for char in text:gmatch(".") do
		if quote then
			table.insert(current, char)

			if escaped then
				escaped = false
			elseif char == "\\" then
				escaped = true
			elseif char == quote then
				quote = nil
			end
		elseif char == "'" or char == '"' then
			quote = char
			table.insert(current, char)
		elseif char:match("[%(%[%{]") then
			depth = depth + 1
			table.insert(current, char)
		elseif char:match("[%]%}%)]") then
			depth = math.max(depth - 1, 0)
			table.insert(current, char)
		elseif char == delimiter and depth == 0 then
			table.insert(parts, table.concat(current))
			current = {}
		else
			table.insert(current, char)
		end
	end

	table.insert(parts, table.concat(current))
	return parts
end

local function split_first_top_level(text, delimiter)
	local current = {}
	local depth = 0
	local quote = nil
	local escaped = false

	for index = 1, #text do
		local char = text:sub(index, index)

		if quote then
			table.insert(current, char)

			if escaped then
				escaped = false
			elseif char == "\\" then
				escaped = true
			elseif char == quote then
				quote = nil
			end
		elseif char == "'" or char == '"' then
			quote = char
			table.insert(current, char)
		elseif char:match("[%(%[%{]") then
			depth = depth + 1
			table.insert(current, char)
		elseif char:match("[%]%}%)]") then
			depth = math.max(depth - 1, 0)
			table.insert(current, char)
		elseif char == delimiter and depth == 0 then
			return table.concat(current), text:sub(index + 1)
		else
			table.insert(current, char)
		end
	end

	return table.concat(current), nil
end

local function parse_python_arg(raw_arg)
	local arg = vim.trim(raw_arg)

	if arg == "" or arg == "*" or arg == "/" then
		return nil
	end

	local without_default = split_first_top_level(arg, "=")
	local name_part, type_part = split_first_top_level(without_default, ":")
	local name = vim.trim(name_part)

	if name == "" or name == "*" or name == "/" then
		return nil
	end

	local bare_name = name:gsub("^%*+", "")
	if bare_name == "" or bare_name == "self" or bare_name == "cls" then
		return nil
	end

	local type_name = type_part and vim.trim(type_part) or ""
	if type_name == "" then
		type_name = nil
	end

	return {
		name = name,
		key = bare_name,
		type = type_name,
	}
end

local function python_args_doc(args)
	local arg_text = args[1] and table.concat(args[1], " ") or ""
	local params = {}

	for _, raw_arg in ipairs(split_top_level(arg_text, ",")) do
		local param = parse_python_arg(raw_arg)
		if param then
			table.insert(params, param)
		end
	end

	local nodes = { t("Args:") }

	if #params == 0 then
		table.insert(nodes, t({ "", "        None" }))
		return sn(nil, nodes)
	end

	for index, param in ipairs(params) do
		local label = param.name
		if param.type then
			label = label .. " (" .. param.type .. ")"
		end

		table.insert(nodes, t({ "", "        " .. label .. ": " }))
		table.insert(nodes, r(index, "arg_doc_" .. param.key, i(nil, "Description.")))
	end

	return sn(nil, nodes)
end

local function python_return_doc(args)
	local return_type = args[1] and table.concat(args[1], " ") or ""
	return_type = vim.trim(return_type)

	if return_type == "" then
		return sn(nil, {
			r(1, "return_doc", i(nil, "Description.")),
		})
	end

	if return_type == "None" then
		return sn(nil, {
			t("None."),
		})
	end

	return sn(nil, {
		t(return_type .. ": "),
		r(1, "return_doc", i(nil, "Description.")),
	})
end

local function return_type_choice(position)
	return c(position, {
		i(nil, "None"),
		i(nil, "bool"),
		i(nil, "int"),
		i(nil, "str"),
		i(nil, "float"),
		i(nil, "list[str]"),
		i(nil, "dict[str, typing.Any]"),
		i(nil, "typing.Any"),
		i(nil, "CustomType"),
	})
end

local function function_doc_nodes(opts)
	opts = opts or {}

	local decorators = opts.decorators or {}
	local prefix = opts.prefix or ""
	local arg_prefix = opts.arg_prefix or ""
	local default_args = opts.default_args or "path: str, strict: bool = False"

	local nodes = {}
	for _, decorator in ipairs(decorators) do
		table.insert(nodes, t({ decorator, "" }))
	end

	vim.list_extend(nodes, {
		t(prefix .. "def "),
		i(1, "name"),
		t("(" .. arg_prefix),
		i(2, default_args),
		t(") -> "),
		return_type_choice(3),
		t({ ":", '    """' }),
		i(4, "Summary."),
		t({ "", "", "    " }),
		d(5, python_args_doc, { 2 }),
		t({ "", "", "    Returns:", "        " }),
		d(6, python_return_doc, { 3 }),
		t({ "", '    """', "    " }),
		i(7, "pass"),
		i(0),
	})

	return nodes
end

return {
	s({
		trig = "defdoc",
		dscr = "Python function with generated docstring args",
	}, function_doc_nodes()),

	s(
		{
			trig = "mdefdoc",
			dscr = "Python method with generated docstring args",
		},
		function_doc_nodes({
			arg_prefix = "self, ",
		})
	),
	s(
		{
			trig = "cmdefdoc",
			dscr = "Python classmethod with generated docstring args",
		},
		function_doc_nodes({
			decorators = { "@classmethod" },
			arg_prefix = "cls, ",
		})
	),
	s(
		{
			trig = "adefdoc",
			dscr = "Async Python classmethod with generated docstring args",
		},
		function_doc_nodes({
			prefix = "async ",
		})
	),
}
