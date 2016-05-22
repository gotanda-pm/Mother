# Mother

Gotanda.pmのイベント開催の雑務をやってくれる機械。  
最終的には実家に帰ったときのお母さんみたいによしなにしてくれる。

## Setup

```bash
carmel install
```

## Usage

## .connpass

Connpassのユーザー情報を保存する。  
Config::Identityを使っているのでgpgで暗号化しておくことが可能。  
`gpg2 -ea ~/.connpass && mv ~/.connpass{.asc,}` などとするといい。  

Connpassのユーザーはgotanda-pm-robotを利用する。  
パスワードは口伝なので誰かに訊きましょう。

### config/event.yaml

イベントの情報を持っているyamlファイル。
こればっかりはどうしようもない。

### script/make_markdown.pl

テンプレどおりに吐くやつ。タイムテーブルの時間もちゃんと計算してくれる。

```bash
carmel exec -- perl -Ilib script/make_markdown.pl connpass
```

### script/make_event.pl

会場のキャパシティやタイムテーブルからいい感じに枠を計算してconnpass作ってくれるやつ。
募集枠の人数の計算やアンケートの作成も勝手にやってくれる。

```bash
carmel exec -- perl -Ilib script/make_event.pl
```
