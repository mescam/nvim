return {
  {
    'zbirenbaum/copilot.lua',
    commit = '99654fe9ad6cb2500c66b178a03326f75c95f176',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = true,
          hgcommit = true,
          svn = true,
          cvs = false,
          ['.'] = true,
        },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    lazy = false,
    build = 'make tiktoken',
    opts = {},
    keys = {
      { '<leader>tc', '<cmd>CopilotChatToggle<CR>', desc = '[C]opilot Chat' },
    },
  },
}
