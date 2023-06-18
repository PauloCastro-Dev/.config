require("slydragonn.settings")
require("slydragonn.maps")
require("slydragonn.plugins")

local themeStatus, onedark = pcall(require, "onedark")

if themeStatus then
	vim.cmd("colorscheme onedark")
else
	return
end
