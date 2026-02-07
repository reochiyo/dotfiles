# Neovim Configuration

[LazyVim](https://github.com/LazyVim/LazyVim) をベースにしたカスタム Neovim 設定です。

## 必要条件

- Neovim >= 0.8
- Git
- lazygit
- [Nerd Font](https://www.nerdfonts.com/) (アイコン表示用)
- ripgrep (Telescope の live grep 用)
- make (telescope-fzf-native のビルド用)

## ディレクトリ構成

```
~/.config/nvim/
├── init.lua              # エントリーポイント
├── lazy-lock.json        # プラグインバージョンロック
├── lazyvim.json          # LazyVim 設定
├── stylua.toml           # Lua フォーマッター設定
└── lua/
    ├── config/
    │   ├── autocmds.lua  # 自動コマンド
    │   ├── keymaps.lua   # キーマップ
    │   ├── lazy.lua      # プラグインマネージャー設定
    │   └── options.lua   # Vim オプション
    ├── craftzdog/
    │   └── discipline.lua # Cowboy モード (連続キー押下警告)
    └── plugins/
        ├── ai.lua        # Claude Code 連携
        ├── colorscheme.lua # カラースキーム
        ├── editor.lua    # エディター拡張
        └── ui.lua        # UI カスタマイズ
```

## カラースキーム

[solarized-osaka](https://github.com/craftzdog/solarized-osaka.nvim) を使用。透過背景対応。

## プラグイン一覧

### AI 連携
- **claudecode.nvim** - Claude Code との統合

### エディター
- **telescope.nvim** - ファジーファインダー + ファイルブラウザ
- **nvim-highlight-colors** - カラーコードのハイライト表示
- **git.nvim** - Git blame/browse
- **blink.cmp** - 補完エンジン
- **close-buffers.nvim** - バッファ一括削除

### UI
- **noice.nvim** - コマンドライン/通知 UI
- **nvim-notify** - 通知システム
- **bufferline.nvim** - バッファタブライン
- **lualine.nvim** - ステータスライン
- **zen-mode.nvim** - 集中モード
- **snacks.nvim** - ダッシュボード等

## キーマップ

### 一般
| キー | 動作 |
|------|------|
| `<Space>` | Leader キー |
| `<C-a>` | 全選択 |
| `+` / `-` | 数値の増減 |
| `x` | 削除 (レジスタ影響なし) |
| `<Leader>p/P` | レジスタ 0 からペースト |
| `<Leader>c/d` | 変更/削除 (レジスタ影響なし) |

### ウィンドウ操作
| キー | 動作 |
|------|------|
| `ss` | 水平分割 |
| `sv` | 垂直分割 |
| `sh/sj/sk/sl` | ウィンドウ移動 |
| `sq` | ウィンドウを閉じる |
| `<C-w>矢印` | ウィンドウリサイズ |

### タブ/バッファ
| キー | 動作 |
|------|------|
| `te` | 新規タブ |
| `<Tab>` / `<S-Tab>` | 次/前のバッファ |
| `tw` | タブを閉じる |
| `\\` | バッファ一覧 |
| `<Leader>th` | 非表示バッファを閉じる |
| `<Leader>tu` | 名前なしバッファを閉じる |

### Telescope
| キー | 動作 |
|------|------|
| `;f` | ファイル検索 |
| `;r` | テキスト検索 (live grep) |
| `;t` | ヘルプタグ |
| `;e` | 診断一覧 |
| `;s` | Treesitter シンボル |
| `;c` | LSP incoming calls |
| `;;` | 前回の検索を再開 |
| `sf` | ファイルブラウザ |

### Git
| キー | 動作 |
|------|------|
| `<Leader>gb` | Git blame |
| `<Leader>go` | Git でファイルを開く |

### Claude Code
| キー | 動作 |
|------|------|
| `<Leader>ac` | Claude Code トグル |
| `<Leader>af` | Claude Code フォーカス |
| `<Leader>ar` | セッション再開 |
| `<Leader>aC` | 続行 |
| `<Leader>am` | モデル選択 |
| `<Leader>ab` | 現在のバッファを追加 |
| `<Leader>as` | 選択範囲を送信 (visual) |
| `<Leader>aa` | Diff を承認 |
| `<Leader>ad` | Diff を拒否 |

### その他
| キー | 動作 |
|------|------|
| `<Leader>z` | Zen Mode |

## レジスタ影響なしについて

Vim ではテキストを削除（`d`）や変更（`c`）すると、削除されたテキストが自動的にデフォルトレジスタに保存されます。これにより、先にヤンク（コピー）した内容が上書きされてしまう問題があります。

**通常の問題:**
```
1. yiw で単語をヤンク（コピー）
2. diw で別の単語を削除
3. p でペースト → 削除した単語が貼り付けられる（ヤンクした内容が消えている）
```

**この設定での解決策:**

ブラックホールレジスタ（`"_`）を使用することで、削除したテキストを破棄し、他のレジスタに影響を与えません。

```lua
keymap.set("n", "x", '"_x')         -- 文字削除
keymap.set("n", "<Leader>d", '"_d') -- 削除
keymap.set("n", "<Leader>c", '"_c') -- 変更
```

**使い分け:**
| 操作 | 動作 |
|------|------|
| `d` | 削除してレジスタに保存（通常動作） |
| `<Leader>d` | 削除してレジスタに保存しない |
| `p` | デフォルトレジスタからペースト |
| `<Leader>p` | レジスタ0（最後にヤンクした内容）からペースト |

これにより、ヤンクした内容を保持したまま別のテキストを削除・変更できます。

## Cowboy モード

`h`, `j`, `k`, `l`, `+`, `-` を10回以上連続で押すと警告が表示されます。カウントや相対移動の使用を促す機能です。

## カスタマイズ

- `lua/plugins/` 配下に新しいファイルを作成してプラグインを追加
- `lua/config/keymaps.lua` でキーマップを変更
- `lua/config/options.lua` で Vim オプションを調整

## 参考

- [LazyVim Documentation](https://lazyvim.github.io/)
- [craftzdog/dotfiles-public](https://github.com/craftzdog/dotfiles-public)
