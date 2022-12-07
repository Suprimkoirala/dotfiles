local packer = nil
local function init()
  if packer == nil then
    packer = require 'packer'
    packer.init {
      profile = { enable = true },
      disable_commands = true,
      display = {
        open_fn = function()
          local result, win, buf = require('packer.util').float {
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
          }
          vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
          return result, win, buf
        end,
      },
    }
  end

  local use = packer.use
  packer.reset()

  -- Packer
  use '~/projects/personal/packer.nvim'

  use 'lewis6991/impatient.nvim'

  -- Async building & commands
  use {
    'ojroques/nvim-bufdel',
    cmd = 'BufDel',
    config = function()
      require('bufdel').setup {}
    end,
  }

  -- Marks
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end,
    event = 'BufReadPost',
  }

  -- Movement
  use 'chaoren/vim-wordmotion'
  use {
    {
      'ggandor/leap.nvim',
      event = 'User ActuallyEditing',
      requires = 'tpope/vim-repeat',
    },
    {
      'ggandor/flit.nvim',
      config = [[require'flit'.setup { labeled_modes = 'nv' }]],
      event = 'User ActuallyEditing',
    },
  }

  -- Quickfix
  use { 'Olical/vim-enmasse', cmd = 'EnMasse' }
  use 'kevinhwang91/nvim-bqf'
  use {
    'https://gitlab.com/yorickpeterse/nvim-pqf',
    config = function()
      require('pqf').setup()
    end,
  }

  -- Indentation tracking
  use { 'lukas-reineke/indent-blankline.nvim', after = 'nvim-treesitter' }

  -- Commenting
  -- use 'tomtom/tcomment_vim'
  use {
    'numToStr/Comment.nvim',
    event = 'User ActuallyEditing',
    config = function()
      require('Comment').setup {}
    end,
  }

  -- Wrapping/delimiters
  use {
    { 'machakann/vim-sandwich', event = 'User ActuallyEditing' },
    { 'andymass/vim-matchup', setup = [[require('config.matchup')]], event = 'User ActuallyEditing' },
  }

  -- Search
  use 'romainl/vim-cool'

  -- Prettification
  use { 'junegunn/vim-easy-align', disable = true }

  -- Text objects
  use 'wellle/targets.vim'

  -- Search
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
      },
      wants = {
        'popup.nvim',
        'plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      setup = [[require('config.telescope_setup')]],
      config = [[require('config.telescope')]],
      cmd = 'Telescope',
      module = 'telescope',
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    },
    'crispgm/telescope-heading.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  }

  -- Undo tree
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }

  -- Git
  use {
    {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = [[require('config.gitsigns')]],
      event = 'User ActuallyEditing',
    },
    { 'TimUntersberger/neogit', cmd = 'Neogit', config = [[require('config.neogit')]] },
    {
      'akinsho/git-conflict.nvim',
      tag = '*',
      config = function()
        require('git-conflict').setup()
      end,
      event = 'BufReadPost',
    },
  }

  -- Hovers
  use {
    'lewis6991/hover.nvim',
    event = 'BufReadPost',
    config = function()
      require('hover').setup {
        init = function()
          require 'hover.providers.lsp'
        end,
      }

      vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end,
  }

  use {
    'DNLHC/glance.nvim',
    cmd = 'Glance',
    config = function()
      require('glance').setup { border = { enable = true } }
    end,
  }

  -- Pretty symbols
  use 'kyazdani42/nvim-web-devicons'

  -- Completion and linting
  use {
    'neovim/nvim-lspconfig',
    {
      'folke/trouble.nvim',
      cmd = 'Trouble',
      config = function()
        require('trouble').setup {}
      end,
    },
    'ray-x/lsp_signature.nvim',
    {
      'kosayoda/nvim-lightbulb',
    },
  }

  -- C++
  use 'p00f/clangd_extensions.nvim'

  -- Rust
  use {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    config = function()
      require('rust-tools').setup {}
    end,
  }

  -- Endwise
  use { 'RRethy/nvim-treesitter-endwise', after = 'nvim-treesitter' }
  -- Highlights
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
      { 'RRethy/nvim-treesitter-textsubjects', after = 'nvim-treesitter' },
    },
    run = ':TSUpdate',
    event = 'User ActuallyEditing',
    config = [[require 'config.treesitter']],
  }

  -- Documentation
  use {
    'danymat/neogen',
    requires = 'nvim-treesitter',
    config = [[require('config.neogen')]],
    keys = { '<localleader>d', '<localleader>df', '<localleader>dc' },
  }

  -- Lisps
  use 'gpanders/nvim-parinfer'

  -- Snippets
  use {
    {
      'L3MON4D3/LuaSnip',
      opt = true,
    },
    'rafamadriz/friendly-snippets',
  }

  -- Completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      'hrsh7th/cmp-nvim-lsp',
      'onsails/lspkind.nvim',
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      'lukas-reineke/cmp-under-comparator',
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
    },
    config = [[require('config.cmp')]],
    event = 'InsertEnter',
    wants = 'LuaSnip',
  }

  -- Debugger
  use {
    {
      'mfussenegger/nvim-dap',
      setup = [[require('config.dap_setup')]],
      config = [[require('config.dap')]],
      requires = 'jbyuki/one-small-step-for-vimkind',
      wants = 'one-small-step-for-vimkind',
      cmd = { 'BreakpointToggle', 'Debug', 'DapREPL' },
    },
    {
      'rcarriga/nvim-dap-ui',
      requires = 'nvim-dap',
      wants = 'nvim-dap',
      after = 'nvim-dap',
      config = function()
        require('dapui').setup()
      end,
    },
  }

  -- Path navigation
  -- use 'justinmk/vim-dirvish'
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    config = [[vim.g.neo_tree_remove_legacy_commands = true]],
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
  }

  -- LaTeX
  use 'lervag/vimtex'
  use 'barreiroleo/ltex_extra.nvim'

  -- Meson
  use 'igankevich/mesonic'

  -- CMake
  use {
    'Shatur/neovim-cmake',
    requires = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
    wants = 'plenary.nvim',
    cmd = 'CMake',
  }

  -- PDDL
  use 'PontusPersson/pddl.vim'

  -- ROS
  use {
    'thibthib18/ros-nvim',
    requires = 'nvim-telescope/telescope.nvim',
    wants = 'telescope.nvim',
    config = function()
      require('ros-nvim').setup {
        catkin_ws_path = '~/projects/research/riposte_ws',
        catkin_program = 'catkin build',
      }
    end,
    module = 'ros-nvim',
  }

  -- Zig
  use 'ziglang/zig.vim'

  -- Julia
  use { 'JuliaEditorSupport/julia-vim', setup = [[vim.g.latex_to_unicode_tab = 'off']], opt = true }

  -- Profiling
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 15]] }

  -- Refactoring
  use { 'ThePrimeagen/refactoring.nvim', disable = true }

  -- Plugin development
  use 'folke/neodev.nvim'

  -- Highlight colors
  use {
    'NvChad/nvim-colorizer.lua',
    ft = { 'css', 'javascript', 'vim', 'html', 'latex', 'tex' },
    config = [[require('colorizer').setup {}]],
  }

  -- Color scheme
  use '~/projects/personal/vim-nazgul'
  use 'hardselius/warlock'
  use 'arzg/vim-substrata'
  use 'sainnhe/gruvbox-material'
  use 'RRethy/nvim-base16'

  -- Notes
  use {
    '~/projects/personal/pdf-scribe.nvim',
    config = [[require('config.pdf_scribe')]],
    disable = true,
  }

  -- Buffer management
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('config.bufferline')]],
    event = 'User ActuallyEditing',
    disable = true,
  }

  use {
    'b0o/incline.nvim',
    config = [[require('config.incline')]],
    event = 'User ActuallyEditing',
  }

  use {
    'filipdutescu/renamer.nvim',
    branch = 'master',
    requires = { { 'nvim-lua/plenary.nvim' } },
    module = 'renamer',
  }

  use 'teal-language/vim-teal'
  use { 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' } }

  -- Pretty UI
  use 'stevearc/dressing.nvim'
  use 'rcarriga/nvim-notify'
  use 'vigoux/notifier.nvim'
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = 'BufReadPost',
    config = function()
      require('todo-comments').setup {}
    end,
  }

  use {
    'j-hui/fidget.nvim',
    event = 'User ActuallyEditing',
    config = function()
      require('fidget').setup {
        sources = {
          ['null-ls'] = { ignore = true },
        },
      }
    end,
  }

  use {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup {}
    end,
  }
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
