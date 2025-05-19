local vimrc = vim.fn.stdpath("config") .. "/vimrc"
vim.cmd.source(vimrc)


-- Language servers for python (my love), rust (my love), cpp (ok)


local lspconfig = require('lspconfig')
-- jedi is simple to install
-- pip install -U jedi-language-server
lspconfig.jedi_language_server.setup{}
-- Rust analyzer too, after you've installed rust
-- rustup component add rust-analyzer
lspconfig.rust_analyzer.setup{}
-- Haha....this isn't set up yet and is purely aspirational
-- lspconfig.clangd.setup{}
-- For nvim 11+ this will be easier
-- vim.lsp.enable({'jedi-language-server', 'rust_analyzer', 'clangd'})


-- Virtual text was looking weird with the circles 
vim.diagnostic.config({
  virtual_text = {
    prefix = '|',
  },
  severity_sort = true,
  float = {
    source = "always",  -- Or "if_many"
  },
})
