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

QMK は C での実装、KMK は CircuitPython と記述言語もちがいますので、QMK と KMK の間にはもちろん互換性はありません。しかし、スクリプト言語で記述できて、CircuitPython の周辺ライブラリ(REG LEDのコントロールやディスプレイ制御など)も結構あるので、動かしてみるにはほどよいと判断しました。
いろいろやっているうちに QMK も移植されるかもしれません。

## Pro Micro よりスペックが高い

Raspberry Pi Pico には、デュアルコア CPU に  2MB Flashメモリ、WRAM 264kB と比較的スペックが高く遊べそうです。これが一番かも。

# 作業環境の準備

私は Mac をつかっているので、以下の作業は Mac での話になります。

## CircuitPython のインストール

最初に CircuitPython を Raspberry Pi Pico にインストールします。

- Raspberry Pi Pico 用の CircuitPython ファイルのダウンロードページで `pico` で検索すると Raspberry Pi Pico がリストに出てきます。

https://circuitpython.org/downloads

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

CircuitPython で各種機能・デバイスを操作するときに便利なライブラリがありますので、ライブラリーをつかいたい場合は `lib/` ディレクトリに入れば使用できます。
KMK を動かすだけなら、KMK パッケージ内ですべてそろっているので追加のライブラリファイルは必要ありませんが、独自にデバイス追加する場合は必要になるかもしれません。

- ライブラリのダウンロードページから、 `Bundle Version 6.x` のライブラリ一式をダウンロードします。

https://circuitpython.org/libraries

- 適当な場所に `.zip` ファイルを展開します。
- 展開ファイルの中の `lib` ディレクトリの中がライブラリファイルです。ただし、Raspberry Pi Pico のストレージにはすべては入りませんし、必要のないライブラリがほとんどなので、ひとまずは `lib/adafruit_bus_device/` ディレクトリをそのまま `CIRCUITPY` ボリュームの `lib/` ディレクトリにコピーしてやります。
  - ライブラリファイルは `.mpy` フォーマットでプリコンパイルされています。ソースコードはこちらから確認できます。

https://github.com/adafruit/Adafruit_CircuitPython_Bundle

## 開発環境のセットアップ

基本的には `CIRCUITPY` ボリュームに特定のファイル名で CircuitPython のスクリプトファイルを作成すれば、自動的に実行されます。ただし、プログラムのエラーログ、とくにライブラリーがインポートできないなどのエラーはコンソールログを確認しないとわからないので、ログを確認できる環境を構築します。

### Mu Editor

CircuitPython 公式では、Mu Editor を進めています

https://learn.adafruit.com/welcome-to-circuitpython/installing-mu-editor

ダウンロードはこちらから。

https://codewith.mu/

日本化されています。

![Mu Editor](https://storage.googleapis.com/zenn-user-upload/d57a65d472b8cc3846686afa.png)

- 左上の `モード` ボタンを押し、`CircuitPython` を選択します。
- エディター部分にスクリプトを書き、`保存` ボタンで `CIRCUITPY` ボリュームのファイルを保存すると書き込めます。
- `シリアル` ボタンを押すと、シリアルペインが表示され、ログが表示されます。
  - シリアルペインで `Ctrl+C` を入力すると、プログラムの実行が停止され、さらにキーを入力すると CircuitPython の REPL モードになります。プログラムを再度実行する場合は `Ctrl+D` でソフトリブートがかかり再実行されます。

### VS Code

実は、プログラムは `CircuitPython` ボリュームに書くだけでいいですし、直接開いて編集しても大丈夫(エディタソフトによっては保存してもすぐにボリュームがフラッシュされずにすぐに実データが書き換わらないものもあるらしい)なので、VS Code で書いて実行することもできます。

ログは統合ターミナルを開いて、接続されている `/dev/tty〜` デバイスに接続すれば確認できます。

```bash
$ ls -1 /dev/tty.usbmodem*
/dev/tty.usbmodem222301
```

と出てきたら、そのデバイスに `screen` コマンドで接続します。デバイス名は異なると思います。

```bash
$ screen /dev/tty.usbmodem222301
オートリロードがオンです。ファイルをUSB経由で保存するだけで実行できます。REPLに入ると無効化します。

Press any key to enter the REPL. Use CTRL-D to reload.

Adafruit CircuitPython 6.3.0 on 2021-06-01; Raspberry Pi Pico with rp2040
>>> print("hello")
hello
>>>
```

こらも `Ctrl+D` でソフトリセットがかかり、プログラムが再実行されます。
じっさい、なれている VS Code の方がいいかもです。

# とりあえずLチカ

Raspberry Pi Pico のボード上には LED が1つ実装されているので、何もつながなくてもLチカだけはできます。
オンボードの LED は GPIO25 に接続されているので、このピンへの出力を変更すればLEDの点灯を制御できます。

`code.py` というファイル名で `CIRCUITPY` に書き込みます。

```python:code.py
import board
import digitalio
import time

led = digitalio.DigitalInOut(board.GP25)
led.direction = digitalio.Direction.OUTPUT

wait = 0.5

while True:
    led.value = True
    time.sleep(wait)
    led.value = False
    time.sleep(wait)
```

# KMK のインストール

インストール用のファイルは、プリコンパイルされたパッケージ
KMK のソースコードは GitHub からダウンロードできます。

https://github.com/KMKfw/kmk_firmware

ドキュメントをみるとインストール用のパッケージが用意されているのですが、どうもリビジョンが古いのかいろいろエラーが出ました。素直にソースからコピーします。

パッケージのファイルは、展開された `boot.py` ファイルと `kmk/` ディレクトリをまるごと `CIRCUITPY` ボリュームにコピーします。
このほかにボードの定義ファイル `kb.py` と、キーマップや動作のプログラムを記述した `main.py` が必要になります。

`github.com/KMKfw/kmk_firmware` を git clone すると、`board/` ディレクトリと `user_keymaps/` ディレクトリがあります。これを参考にして自分の環境用の `kb.py` と `main.py` を書きます。

その前に、Lチカのために入れた `code.py` ファイルを削除しておかないといけません。CircuitPython の実行スクリプトを検索する優先順位があって、以下の順に探して見つかったファイルを実行するようになっています。

- `code.txt`
- `code.py`
- `main.txt`
- `main.py`

`.txt` が優先順位が上なのは、メモ帳でもかけるようにでしょうか。ともかく `code.py` が優先順位が上なので、消しておかないと `main.py` が実行されません。

# KMK のテストをしてみる

## キーボードの準備

肝心のキーボード本体の準備です。いきなり改造キーボードにつないでもいいのですが、簡単なものから試してみます。
手元に以前遊舎工房さんから購入した、たのしい人生さんの meishi2 のキーマトリックス(2x2)を借りてテストしてみました。

https://twitter.com/Biacco42

https://shop.yushakobo.jp/collections/keyboard-1/products/meishi2

![meishi2](https://storage.googleapis.com/zenn-user-upload/adb8d626da712485d2e5195b.jpg)

ちなみに、meishi2 キットは自作キーボードの入門にはちょうどよかったです。回路もシンプルだし、QMK ファームウェアカスタマイズして4キーマクロパッドとして使用しています。

![meishi2 キーマトリックス](https://storage.googleapis.com/zenn-user-upload/ff2df7e9c40674434258f46f.jpg)
*meishi2 のキーマトリックス 回路図から引用*

この `row0` `row1` `col0` `col1` からコードを引き出して Raspberry Pi Pico につなげます。
4 本だけなので、接続先のピンは近いところにまとめてしまいました。

![ブレッドボード図](https://storage.googleapis.com/zenn-user-upload/eeb1f5365139fa4afcffcf05.png)
*こんな感じです*

```
row0 -> GP12
row1 -> GP13
col0 -> GP14
col1 -> GP15
```

↑の接続になります。

## KMK のファイルコーディング

`board/` ディレクトリと `user_keymaps/` ディレクトリのふぁいるを参考に、まずは `kb.py` から。

```python:kb.py
import board

from kmk.kmk_keyboard import KMKKeyboard as _KMKKeyboard
from kmk.matrix import DiodeOrientation

class KMKKeyboard(_KMKKeyboard):
    row_pins = (board.GP12, board.GP13)
    col_pins = (board.GP14, board.GP15)
    diode_orientation = DiodeOrientation.COLUMNS
```

シンプルにピンの割り当てだけです。ボード側の物理ピンと KMK 側のロジカルな割り当ての対応を `kb.py` に記述するようです。

```python:main.py
import board

from kb import KMKKeyboard
from kmk.keys import KC

keyboard = KMKKeyboard()

keyboard.keymap = [
    [  #Base
        KC.N0, KC.N1, KC.N2, KC.N3
    ]
]

if __name__ == '__main__':
    keyboard.go()
```

こちらもシンプルに、最低限の設定とキー割り当てだけです。
それぞれのファイルを保存してエラーが出なければ、キーを押すとそれぞれ `0` `1` `2` `3` と入力されるはずです。ファイルを保存するだけでリロードされるので簡単です。

# KMK の機能を調べてみる

`README.md` には以下の機能が挙げられています。

- 分割キーボードサポート
- Unicode マクロ
- REG LED、単色LEDのアンダーグローサポート
- タップダンス
- Bluetooth HID

kmk ディレクトリの中をみると、 `extensions/` ディレクトリと `modules/` ディレクトリがあります。`layer.py` とか `led.py` などの機能がモジュール化されているようです。

## `Module` と `Extension` の違い

ドキュメントには `Module` はファームウェアのコア機能を変更できる、`Extension` はコア機能ではなく操作性を変更する機能を追加しサンドボックスで動作すると書いてあります。サンドボックスといっても Python なので大げさなものではないようです。`Module` はキーマトリックスの変更やレイヤー操作ができます。

## `Module` の内容

- `modules/layers.py` いうまでもなくレイヤー操作
- `modules/modtap.py` モデファイヤキー
- `modules/power.py` 省エネルギー設定。LEDオフやキースキャンの頻度、スリープ設定など
- `modules/split.py` 分割キーボード設定

## `Extension` の内容

- `extensions/international.py` ANSI 以外のキーコード定義
- `extensions/led.py` 単色LEDの制御機能
- `extensions/media_keys.py` メディアコントロールキーの定義
- `extensions/rgb.py` RGB LEDの制御機能

## その他の機能

- `handlers/sequences.py` 文字列送信機能

## レイヤーと文字列送信、LEDアニメーションを追加してみる

レイヤー機能と LED アニメーション、マクロキー送信を実装してみました。
LEDアニメーションは、起動時とキーを押したときに1回だけ明滅するようにユーザ定義にしました。

```python:kb.py
import board

from kmk.kmk_keyboard import KMKKeyboard as _KMKKeyboard
from kmk.matrix import DiodeOrientation

class KMKKeyboard(_KMKKeyboard):
    row_pins = (board.GP12, board.GP13)
    col_pins = (board.GP14, board.GP15)
    diode_orientation = DiodeOrientation.COLUMNS
    led_pin = board.GP25
```

LED の制御ピンを GP25 に設定。

```python:main.py
import board
from math import e, exp, pi, sin

from kb import KMKKeyboard
from kmk.extensions.led import AnimationModes, LED
from kmk.keys import KC
from kmk.modules.layers import Layers
from kmk.handlers.sequences import simple_key_sequence

# キーを押したときの process_key をオーバーライドする
class MyKeyboard(KMKKeyboard):
    def process_key(self, key, is_pressed, coord_int=None, coord_raw=None):
        global led_pos, led_flag
        if is_pressed == 1 or is_pressed:
            led_flag = True
            led_pos = 0

        return super().process_key(key, is_pressed, coord_int, coord_raw)

# LEDを一回だけ点滅させるユーザー定義LEDアニメーション
# LED.effect_breathing　を流用
led_pos = 0
led_flag = True
def effect_user(led):
    global led_pos, led_flag
    sined = sin((led_pos / 255.0) * pi)
    multip_1 = exp(sined) - led.breathe_center / e
    multip_2 = led.brightness_limit / (e - 1 / e)

    led_brightness = int(multip_1 * multip_2)
    led_pos = (led_pos + led.animation_speed) % 256
    if led_flag:
        led.set_brightness(led_brightness)
    if led_pos == 0:
        led_flag = False
        led.set_brightness(0)


keyboard = MyKeyboard()
# debug_enabled = True にするとデバッグログが表示される
keyboard.debug_enabled = False

# Cleaner key names
_______ = KC.TRNS
XXXXXXX = KC.NO

# レイヤーモジュールを組み込み
layers_mod = Layers()
keyboard.modules = [layers_mod]

# LED拡張を組み込み
led_ext = LED(led_pin=MyKeyboard.led_pin, animation_speed=0.5 ,animation_mode=AnimationModes.USER, user_animation=effect_user)
keyboard.extensions = [led_ext]

RAISE = KC.MO(1)
# 通常の文字列送信は send_string で実行できるはずだが、あらかじめ KC.A 等初期化しておかないと
# エラーになるので simple_key_sequence を使用
MACRO_BASE = simple_key_sequence((KC.A, KC.B, KC.C, KC.D,))
MACRO_RAISE = simple_key_sequence((KC.N0, KC.N1, KC.N2, KC.N3,))

keyboard.keymap = [
    [  #Base
        RAISE, KC.A, KC.LED_TOG, MACRO_BASE
    ],
    [  #RAISE
        _______, KC.N0, _______, MACRO_RAISE
    ]
]

if __name__ == '__main__':
    keyboard.go()
```

キーを押したときのハンドラーを乗っ取るために process_key メソッドを上書きしたのと、1回だけLED明滅アニメーションさせるユーザー定義関数を追加しました。
ひととおり動作確認できました。
