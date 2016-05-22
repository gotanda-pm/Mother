# Mother

Gotanda.pmのイベント開催の雑務をやってくれる機械。  
最終的には実家に帰ったときのお母さんみたいによしなにしてくれる。

## Setup

```bash
carmel install
```

## Usage

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
