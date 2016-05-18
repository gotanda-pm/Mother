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

テンプレどおりに吐くやつ。

```bash
carmel exec -- perl -Ilib script/make_markdown.pl connpass
```

### script/make_event.pl

connpassとか諸々全部作ってくれるやつ。まだ実装してない。

```bash
carmel exec -- perl -Ilib script/make_event.pl
```
