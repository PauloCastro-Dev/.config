local status, masonlsp = pcall(require, "mason-lspconfig")

if not status then
	return
end

masonlsp.setup({
	automatic_installation = true,
	ensure_installed = {
		"angularls",
		"csharp_ls",
		"cssls",
		"eslint",
		"html",
		"jsonls",
		"pyright",
		"tailwindcss",
		"tsserver",
	},
})
