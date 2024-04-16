return {
	{
		-- LSP client settings
		"neovim/nvim-lspconfig",
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			{ 'j-hui/fidget.nvim', opts = {} },
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall" },
		config = function()
			-- Buffer local mappings: active only when LSP gets attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "<C-Space>", vim.lsp.buf.completion, opts)
					vim.keymap.set("n", "<Leader>gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "<Leader>gI", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
					vim.keymap.set({"n","v"}, "<Leader>ca", vim.lsp.buf.code_action, opts)

					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
					-- vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<A-o>", ":ClangdSwitchSourceHeader<CR>", opts)

					-- TODO: test these, compare gd thru telescope or vim.lsp
					local tel_builtin = require("telescope.builtin")
					vim.keymap.set("n", "gd", tel_builtin.lsp_definitions, opts)
					vim.keymap.set("n", "gI", tel_builtin.lsp_implementations, opts)
					vim.keymap.set("n", "gr", tel_builtin.lsp_references, opts)
					vim.keymap.set("n", "<Leader>D", tel_builtin.lsp_type_definitions, opts)
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
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
			-- capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
			local servers = {
				-- bashls = {},
				clangd = {},
				-- jsonls = {},
				-- marksman = {},
				-- pylyzer = {},
				ruff_lsp = {},
				-- shellcheck = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				lua_ls = {
					-- cmd = {...},
					-- filetypes { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							runtime = { version = 'LuaJIT' },
							workspace = {
								checkThirdParty = false,
								library = {
									'${3rd}/luv/library',
									unpack(vim.api.nvim_get_runtime_file('', true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
							completion = {
								callSnippet = 'Replace',
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			require('mason').setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua', -- Used to format lua code
			})
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			}
		end
	},
	{
		-- Autocomplete engine, no sources
		-- Possibly faster alternative: coq_nvim
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- source from LSP servers
			"hrsh7th/cmp-path", -- source for filename autocompletion
			"hrsh7th/cmp-buffer", -- source from current file
			-- add sources from AI

			{ -- snippets (still don't understand)
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
					return 'make install_jsregexp'
				end)(),
			},
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup {}
			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = 'menu,menuone,noinsert'
				},
				mapping = {
					-- I believe I heard <C-p> <C-n> are not needed here
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
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
