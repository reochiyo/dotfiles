return {
  -- JSX/TSXの自動タグ補完・リネーム
  -- <div> と打つと自動で </div> が補完される
  -- タグ名を変更すると閉じタグも自動で変わる
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- TypeScript LSP 追加設定
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- vtsls は typescript-language-server の高速な代替
        -- LazyVim の typescript extra でデフォルト有効
        vtsls = {
          settings = {
            typescript = {
              -- インレイヒント（関数の引数名などを薄く表示）
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
              -- 未使用のimportをグレーアウト
              preferences = {
                includePackageJsonAutoImports = "on",
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
              },
            },
          },
        },
      },
    },
  },

  -- Treesitter: JSX/TSXのシンタックスハイライト
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "jsonc",
      },
    },
  },

  -- ESLint: 保存時に自動修正
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        typescript = { "eslint" },
        typescriptreact = { "eslint" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
      },
    },
  },

  -- Prettier: フォーマット対象のファイルタイプ
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
      },
    },
  },
}
