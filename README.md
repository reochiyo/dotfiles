# dotfiles

個人用の設定ファイル管理リポジトリです。

## 含まれる設定

- Neovim (LazyVim ベース)
- Herdr (AI コーディングエージェント用ターミナルマルチプレクサ)
- Karabiner-Elements

## Neovim キーマップ

### レジスタを汚さない操作

| モード | キー | 説明 |
|--------|------|------|
| n | `x` | 削除（レジスタに入れない） |
| n | `<Leader>p` | ヤンクレジスタからペースト |
| n | `<Leader>P` | ヤンクレジスタから前にペースト |
| v | `<Leader>p` | ヤンクレジスタからペースト |
| n, v | `<Leader>c` | 変更（レジスタに入れない） |
| n, v | `<Leader>C` | 行末まで変更（レジスタに入れない） |
| n, v | `<Leader>d` | 削除（レジスタに入れない） |
| n, v | `<Leader>D` | 行末まで削除（レジスタに入れない） |

### 数値操作

| モード | キー | 説明 |
|--------|------|------|
| n | `+` | 数値をインクリメント |
| n | `-` | 数値をデクリメント |

### 編集

| モード | キー | 説明 |
|--------|------|------|
| n | `dw` | 単語を後方削除 |
| n | `<C-a>` | 全選択 |
| n | `<Leader>o` | 下に空行を挿入して挿入モード |
| n | `<Leader>O` | 上に空行を挿入して挿入モード |

### ジャンプ

| モード | キー | 説明 |
|--------|------|------|
| n | `<C-m>` | ジャンプリストを進む |

### タブ操作

| モード | キー | 説明 |
|--------|------|------|
| n | `te` | 新しいタブを開く |
| n | `<Tab>` | 次のタブへ |
| n | `<S-Tab>` | 前のタブへ |
| n | `tw` | タブを閉じる |

### ウィンドウ操作

| モード | キー | 説明 |
|--------|------|------|
| n | `ss` | 水平分割 |
| n | `sv` | 垂直分割 |
| n | `sh` | 左のウィンドウへ移動 |
| n | `sj` | 下のウィンドウへ移動 |
| n | `sk` | 上のウィンドウへ移動 |
| n | `sl` | 右のウィンドウへ移動 |
| n | `sq` | ウィンドウを閉じる |
| n | `<C-w><left>` | ウィンドウ幅を縮小 |
| n | `<C-w><right>` | ウィンドウ幅を拡大 |
| n | `<C-w><up>` | ウィンドウ高さを拡大 |
| n | `<C-w><down>` | ウィンドウ高さを縮小 |

## Herdr

AI コーディングエージェント（Claude Code 等）を並列で動かすためのターミナルマルチプレクサ。
tmux を置き換えるものとして導入した。設定は `.config/herdr/config.toml`。

### なぜ tmux をやめたか

Zed のリモート SSH では、ターミナルパネルの Claude Code も Agent Panel の thread も
SSH 切断で死ぬ（zed-industries/zed#20589 / #60413。Zed の永続ターミナル実装は
ローカルシェル限定でリモートには効かない）。エージェントをエディタの外に出して
デタッチ可能なマルチプレクサの中で動かす必要があり、その役割を herdr に寄せた。

tmux との違いはエージェント状態の可視化。各 pane の前面プロセスを検出して
`blocked` / `working` / `idle` / `done` を判定し、`blocked` は tab → space へ伝播するので、
サイドバーを見るだけで「どの作業の Claude が入力待ちか」が分かる。

エディタ機能は持たない（pane は「本物のターミナル 1 つ」で、プラグインでもネイティブ UI は作れない）。
コードの閲覧・編集は Zed や nvim を併用する。

### 階層

| 階層 | 用途 | 分ける基準 |
|------|------|-----------|
| space (workspace) | トップレベルのプロジェクト container | repo / タスク / worktree ごと |
| タブ | space 内のレイアウト | 同じ作業対象の別ビュー（agents / logs / review / test） |
| pane | 実ターミナル 1 つ | 同じビュー内で並べて見たいもの |

迷ったらタブ。pane 分割は幅を食うので、実際に見比べる必要があるときだけにする。

### キーマップ

prefix は `<C-b>`（tmux と同じ）。

#### space 操作（Shift 系）

| キー | 説明 |
|------|------|
| `prefix + <S-n>` | 新しい space を作成 |
| `prefix + w` | space 一覧から切り替え |
| `prefix + g` | space へジャンプ（picker） |
| `prefix + <S-w>` | space 名を変更 |
| `prefix + <S-d>` | space を閉じる |
| `prefix + b` | サイドバーの表示/非表示 |

#### タブ操作

| キー | 説明 |
|------|------|
| `prefix + c` | 新しいタブ |
| `prefix + n` | 次のタブへ |
| `prefix + p` | 前のタブへ |
| `prefix + 1-9` | 番号でタブを選択 |
| `prefix + <S-t>` | タブ名を変更 |
| `prefix + <S-x>` | タブを閉じる |

#### pane 操作

| キー | 説明 |
|------|------|
| `prefix + v` | 右に分割 |
| `prefix + -` | 下に分割 |
| `prefix + h/j/k/l` | pane 間を移動 |
| `prefix + <S-h/j/k/l>` | pane を入れ替え |
| `prefix + r` | リサイズモード |
| `prefix + z` | pane をズーム |
| `prefix + x` | pane を閉じる |
| `prefix + [` | コピーモード |

#### セッション

| キー | 説明 |
|------|------|
| `prefix + q` | デタッチ |
| `prefix + ?` | ヘルプオーバーレイ（**このキーが常に正典**） |

### カスタムキーバインド（config.toml の `[keys]`）

| キー | 説明 |
|------|------|
| `<C-S-left>` | 前の space へ（prefix なし・1 打鍵） |
| `<C-S-right>` | 次の space へ（prefix なし・1 打鍵） |

既定の `prefix + w` は picker を開いて上下で選ぶ形で、space が数個のときは冗長だったため
直接循環に寄せた。

**prefixless バインドを選ぶときの制約**: prefix なしのキーは pane 内のアプリにキーが届かなくなる。
Claude Code / shell / vim が使う `<C-n>` / `<C-p>` 系は避ける必要がある。
`<C-S-left/right>` を選んだのはこのため。端末アプリ（WezTerm 等）側に先に奪われていないかは
マシンごとに確認が必要。

### Claude Code 連携

エージェント状態の検出には 2 方式あり、精度が違う。

1. lifecycle hooks — エージェント側から状態遷移を直接報告（正確）
2. 画面バッファのパターン照合 — 端末下部を読んで推測（フォールバック。`blocked` を取りこぼす方向に倒してある）

1 を有効にするには各マシンで以下を実行する（**dotfiles には含めない**。
`~/.claude/hooks/herdr-agent-state.sh` は herdr 管理下で `herdr update` に上書きされるため）。

```sh
herdr integration install claude
herdr integration status | grep claude   # current (vN) を確認
```

`~/.claude/settings.json` に `hooks.SessionStart` が 1 件追加されるだけで、プロジェクトの
`.claude/settings.json` は変更されない。hook 自体は `HERDR_ENV=1` のときだけ動くので、
herdr の外で起動した Claude Code には影響しない。

なお `SessionStart` は起動時以外に `/clear`・コンテキスト圧縮・`--resume` でも発火するので、
hook 導入前から動いているセッションも、そのいずれかの時点で自動的に hook 方式に切り替わる。

### セットアップ

```sh
curl -fsSL https://herdr.dev/install.sh -o /tmp/herdr-install.sh
# 中身を確認（sudo 不使用・~/.local/bin へ配置・SHA-256 検証のみ）してから
sh /tmp/herdr-install.sh
```

`~/.local/bin` が `PATH` に入っていること。設定を書き換えたら `herdr server reload-config`。

### 既知の問題

- **リネーム入力欄でカーソルが動かない**（herdrdev/herdr#1803、未修正）。
  `state.name_input` が単なる `String` で「末尾に足す / 末尾を削る」しか実装されておらず、
  `Home` / `<C-a>` / 矢印キーが効かない。先頭に文字を足したいときは `<C-u>` で全消しして打ち直すか、
  CLI の `herdr workspace rename` を使う（シェルの行編集が効く）。
- Backspace の長押しリピートが効かない（#3417）。

### 注意

herdr 自身がこの config.toml に書き込むことがある（初回起動の `onboarding = false`、
`herdr config reset-keys` は `[keys]` を削除する）。**コメントが保持される保証はない**ため、
キーバインドの選定理由はこの README 側に持たせている。
