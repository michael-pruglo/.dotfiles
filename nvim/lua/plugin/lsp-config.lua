return {
	{
		-- Package mgr for LSP servers
		"williamboman/mason.nvim",
		opts = {}
	},
	{
		-- Bridge between mason servers and lspconfig client
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"bashls",
				"clangd",
				"jsonls",
				"lua_ls",
				"marksman",
				"pylyzer",
				-- "shellcheck",
			}
		}
	},
	{
		-- LSP client settings
		"neovim/nvim-lspconfig",
		config = function()
			-- Buffer local mappings: active only when LSP gets attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "<C-Space>", vim.lsp.buf.completion, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set({"n","v"}, "<Leader>ca", vim.lsp.buf.code_action, opts)

					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

					-- TODO: test these, compare gd thru telescope or vim.lsp
					local tel_builtin = require("telescope.builtin")
					vim.keymap.set("n", "<Leader>ds", tel_builtin.lsp_document_symbols, opts)
					vim.keymap.set("n", "<Leader>ws", tel_builtin.lsp_dynamic_workspace_symbols, opts)

					-- highlight refs to word under cursor [from kickstart]
					-- maybe switch to mini.cursorword?
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
			local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
			for _, ls in ipairs(language_servers) do
				require('lspconfig')[ls].setup {
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { 'vim' } }
						}
					}
					-- you can add other fields for setting up lsp server in this table
				}
			end

		end
	},
	{
		-- Autocomplete engine, no sources
		-- Possibly faster alternative: coq_nvim
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- snips need to be external: e.g. saadparwaiz1/cmp_luasnip
			"hrsh7th/cmp-nvim-lsp", -- source from LSP servers
			"hrsh7th/cmp-path", -- source for filename autocompletion
			"hrsh7th/cmp-buffer", -- source from current file
			-- add sources from AI
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup {
				mapping = {
					-- I believe I heard <C-p> <C-n> are not needed here
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.scroll_docs(1),
					["<C-n>"] = cmp.mapping.scroll_docs(-1),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.close(),
					["<C-y>"] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					},
					["C-cpace>"] = cmp.mapping.complete(),
				},
				sources = {
					-- Order matters: first items have higher priority
					-- cfg options: keyword_length=5, priority=99, max_item_count=7
					{ name = "clangd" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 5 },
				},
			}

			-- autocmd FileType cpp,c,hpp,h lua require("cmp").setup.buffer {
			-- 	sources = { { name = "clangd" }, },
			-- }
		end
	},
	{
		-- status messages about LSP
		-- alternative: mini.notify
		"j-hui/fidget.nvim",
		opts = {}
	},
}
