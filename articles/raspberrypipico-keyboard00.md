---
title: "Raspberry Pi Picoで自作キーボード"
emoji: "⌨️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["自作キーボード","RaspberryPiPico","KMK","CircutPython"]
published: false
---

Raspberry Pi Pico をコントローラーにつかった自作キーボードの記事を書いてみます。
まだ情報自体少ないので参考になればと思います。

# Raspberry Pi Pico

![Raspberry Pi Pico の写真](https://storage.googleapis.com/zenn-user-upload/2538e0408c6bcf5d9bde9485.jpg)
*Raspberry Pi Pico 秋月電子で購入*

Raspberry Pi Pico は、500円くらいで購入できる小型のマイコンボードです。Raspberry Pi 4 などは Linux ベースで動きますが、Pico の場合 OS はなく、直接プログラムを動かします。
マイコンボードというと C/C++ でコーディングするのが一般的ですが、Pico は MicroPython という Python のサブセット言語でもプログラミングできます。

# ソフトエンジニアとキーボード

私は仕事としてサーバ・インフラエンジニアをしています。プライベートでもプログラミングは趣味の1つなので、ほぼ毎日道具としてのキーボードとマウスに触れています。残念ながらキーボードですべての作業をするほどではないのですが、キーボードにはそれなりのこだわりがあります。
PC購入時に付いてくるキーボードは使わず、いわゆる60%キーボード(テンキーとファンクションキーが省略されている)を購入して使用しています。

![キーボードの写真](https://storage.googleapis.com/zenn-user-upload/afae76972bdeb0dab168d24f.jpg)
*今つかっているキーボード ARCHISS ProgresTouch RETRO TINY 静音赤軸モデル キーーキャップは交換して調査用にトップカバーをはずしてある*

写真は ARCHISS ProgresTouch RETRO TINY 静音赤軸モデルを使用しています。キーキャップは取り替えていますが、スコスコしたキータッチと静かなタイプ音が気に入っています。
実際の所 Mac でつかっているので Karabiner-Elements をつかえばほとんどのキーの変更、カスタマイズはできます。スペースキーの左右にある変換・無変換キーを入力モードの切り替えにしたり、カナキーを右コマンドにしたりと変更して使用しています。
ただ、唯一 FN キーだけはキーボードのコントローラーが動作を決めているのでカスタマイズの手が届きません。FN キー＋↑ で PAGEUP キーとかFN ＋ 1 で F1 等になります。普段ファンクションキーとかほとんどつかわないので、キーがあるのにつかえないのです。
別に使えなくても困らないのですが、いじってみたいのが性分。
最終的には完全自作までやってみたいのですが、その目標への過程として、既存キーボードを改造してカスタマイズできるようにするまでを書こうと思います。

# 自作キーボードの要素

自作キーボードに必要なコンポーネントには大きく分けて以下の要素があります。
UI要素、ハードウェアの要素とソフトウェアの要素が適度に混ざって楽しいです。

## キー自体のレイアウト設計

- **UI要素**
- 自作キーボード設計の一番のキモでしょう。自分の好みにあった使いやすいキーレイアウトを実現するのが最終目標になります。
- 自作キーボードの流行として、左右分割型エルゴノミクスキーボードやコンパクトさを追求したレイアウトがあります。
- キー以外にも、LEDで光らせたりロータリーエンコーダーを回したり、小型のディスプレイをつないで情報表示させたりとオプション要素があります。

## PCB基板

- **ハードより**
- 目標のキーレイアウトを実装するための基板設計です。
- KiCad 等のフリーソフトと基板作成のサービスを使用すると、安価に自分の設計した基板を発注できます。

## ケース・ハウジング

- **ハードより**
- 基板だけでは､ショートしたり耐久性に問題あったりするので、ケースに入れたり上下にプレートを追加したりします。
- 打ち心地や打鍵音にも影響するので工夫がされていることが多いです。

## キーボードコントローラー

- **ソフトによるハード制御**
- キーボードデバイス用のファームウェアを入れることにより、キーボードの回路を制御し、PC側とUSB接続してキーボードデバイスとして認識させます。
- 基本は小型のマイコンチップですが、USBキーボードの動作をするために USB HID として振る舞える必要があります。
- 押されたキーとPCに送るキーコードのマッピングを変更することにより、回路を変更することなくキーの配置や機能を変更できます。
- 現在の自作キーボードには、ほとんどの場合 Pro Micro という Arduino 互換の小型のマイコンボードが採用されています。
![Pro Micro 互換ボード](https://storage.googleapis.com/zenn-user-upload/557c49ee9da4dbd7044b6ed0.jpg)
*Pro Micro 互換ボード(遊舎工房で購入)*

## ファームウェア

- **ソフトより**
- QKM という自作キーボード用のファームウェアにキーレイアウト等を追加して Pro Micro にインストールするのが一般的です。

以上の要素が組み合わさって自作キーボード沼があるようです。

# なぜ Raspberry Pi Pico なのか

上でコントローラーには Pro Micro というのがよく使われると書きましたが、今回つかおうと思うのは Raspberry Pi Pico です。

## 入出力ピンの数

![Pro Micro と Pi Pico](https://storage.googleapis.com/zenn-user-upload/7ba1fae4d18b143a006b070b.jpg)
*上が Raspberry Pi Pico 、下が Pro Micro ピン数もサイズも違う*

なぜあえて Raspberry Pi Pico をつかうかというと、単純に入出力に使えるピン数が多いからです。

![](https://storage.googleapis.com/zenn-user-upload/367d466c90d26cbb210cc762.jpg)
*それぞれ https://learn.sparkfun.com/tutorials/pro-micro--fio-v3-hookup-guide https://datasheets.raspberrypi.org/pico/pico-datasheet.pdf から引用*

今回の目的のキーボードの改造のためにキーマトリックスを調べたところ、横線 8 ライン x 縦線 20 ライン になっていました。単純に 28 本の入出力ピンが必要な計算です。

![キーマトリックス図](https://storage.googleapis.com/zenn-user-upload/c9de3201af68bb30de78e506.jpg)
*キーボードのキーマトリックス。自分で調査したもののため、詳細は伏せています*

上図の通り Pro Micro では最大 18 本の入出力ピンしか出ていません(チップ自体には 25 本ありますが、ボードには全部は出ていない) Raspberry Pi Pico の場合、28 本あるのでカバーできます。

実際には 8 x 20 のマトリックスだと 160 キーまで配置できる計算ですが、実際のキーボードには 70 キーしかありません。おそらくフルサイズの製品(いわゆる108キー配列)との共通化もあって、キーが配置されていない場所が結構あります。横線 8 ラインの方は動かせないですが、縦線 20 ラインの配置でキーの配置箇所と空きの箇所をうまく組み合わせて統合すると、パターンカットなしで 13 ラインまで減らせそうです。

![統合できるラインの例](https://storage.googleapis.com/zenn-user-upload/61b459e134ae9c2eba7558af.jpg =250x)

8 ライン + 13 ライン で 22 ピンで、残りの 6 ピンには LED コントロールや 小型ディスプレイをつなぐなど楽しいことができそうです。

## ファームウェアの違い

もう1つの動機は、作例が少ないということです。
Pro Micro 向けには QMK という自作キーボード向けのファームウェアと豊富なカスタマイズ作例、VMI Tools や REMAP といったコンフィグツールなどのエコシステムがありますが、Raspberry Pi Pico はまだ出たばかりで QKM もその基板となる ChibiOS の移植待ちの状態です。要望もあり移植作業も進んでいるようですが、まだ出ていません。
その代替手段として、CircuitPython という Python のサブセット環境が Raspberry Pi Pico で動きます。PC から見ると USB ストレージのように認識され、そこに直接 `.py` ファイルを置くと実行されるお手軽環境です。その CircuitPython で実装された KMK という QMK に似たキーボードファームウェアが動きます。

QMK は C++ での実装、KMK は CircuitPython と記述言語もちがいますので、QMK と KMK の間にはもちろん互換性はありません。しかし、スクリプト言語で記述できて、CircuitPython の周辺ライブラリ(REG LEDのコントロールやディスプレイ制御など)も結構あるので、動かしてみるにはほどよいと判断しました。
いろいろやっているうちに QMK も移植されるかもしれません。

## Pro Micro よりスペックが高い

Raspberry Pi Pico には、デュアルコア CPU に  2MB Flashメモリ、WRAM 264kB と比較的スペックが高く遊べそうです。これが一番かも。

# 作業環境の準備

私は Mac をつかっているので、以下の作業は Mac での話になります。

## CircuitPython のインストール

最初に CircuitPython を Raspberry Pi Pico にインストールします。

- Raspberry Pi Pico 用の CircuitPython ファイルのダウンロード
  - [CircuitPython サイトのダウンロードページ](https://circuitpython.org/downloads) で `pico` で検索すると Raspberry Pi Pico がリストに出てきます。

    ![](https://storage.googleapis.com/zenn-user-upload/816e9297b50ee1a6822f3109.png)

  - この記事の時点では CircuitPython 6.3.0 が安定版の最新でしたので、ダウンロードします。7.0.0 はまだアルファのようです。

    ![CircuitPython 6.3.0](https://storage.googleapis.com/zenn-user-upload/804fd69a810e9e34a5e1b64f.png)

    ここで言語がデフォルトでは JAPANESE になっています。JAPANESE でダウンロードすると、コンソールに出力される CircuitPython からのメッセージが日本語になるようです。私はそのまま JAPANESE でダウンロードましたが、検索でヒットしたページの例では JAPANESE だとうまく動作しなかった場合があるようですので、うまく動かなかったら ENGLISH で試してみるといいかもしれません。

  - ダウンロードボタンをクリックすると `adafruit-circuitpython-raspberry_pi_pico-ja-6.3.0.uf2` ファイルがダウンロードされます。この拡張子 `.uf2` ファイルが Raspberry Pi Pico の CircuitPython プログラムのイメージファイルです。
- CircuitPython イメージの書き込み
  - Raspberry Pi Pico のボード上の `BOOTSEL` ボタンを押したまま USB に接続すると、イメージの書き込みモードで PC にストレージデバイスとしてマウントされます。購入したままのミントな状態だと、`BOOTSEL` を押していなくてもこのモードになるようです。

    ![](https://storage.googleapis.com/zenn-user-upload/80ff2d3495fbc263879d6fe8.jpg)
    *BOOTSELボタン*

  - `RPI-RP2` のようなボリューム名でマウントされます。このボリュームに、ダウンロードした `.uf2` ファイルをそのままコピーしてやればインストールできます。
  - コピーが終わると `RPI-RP2` ボリュームはアンマウントされ、今度は `CIRCUITPY` という名前のボリュームがマウントされます。これで CircuitPython のインストールができました。

## ライブラリファイルのコピー

CircuitPython はインストールできましたが、まだ Raspberry Pi Pico 用のライブラリファイルを入れる必要があります。

- ライブラリのダウンロードページ [Libraries](https://circuitpython.org/libraries) から、 `Bundle Version 6.x` のライブラリ一式をダウンロードします。
- 適当な場所に `.zip` ファイルを展開します。
- 展開ファイルの中の `lib` ディレクトリの中がライブラリファイルです。ただし、Raspberry Pi Pico のストレージにはすべては入りませんし、必要のないライブラリがほとんどなので、ひとまずは `lib/adafruit_bmp280.mpy` ファイルと `lib/adafruit_bus_device/` ディレクトリをそのまま `CIRCUITPY` ボリュームの `lib/` ディレクトリにコピーしてやります。
