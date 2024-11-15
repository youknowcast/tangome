# tangome

ローカルで簡易的なマイ辞書を作成することができます．

## Installation

```
% bundle install
% sudo ln -s /path/to/tangome /usr/local/bin
```

## 使い方

### 検索 & 登録

```
% tangome rumor
rumor: うわさ、風聞、流言
```


### 辞書一覧

コマンド(`tangome`)だけを実行すると辞書ファイルの一覧を出力します． 
fzf, peco と組み合わせて一覧からフィルタリングで検索ができます．

```
% tangome | fzf
  :
```

### 辞書の直接編集

自動登録された内容を変更したい場合は辞書を直接編集してください

```
% vi $(tangome dic)
```
