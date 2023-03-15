# v12n-cli

自分の実用と実験のための仮想マシンツール

## 使用方法
```sh
git clone https://github.com/retlat/v12n-cli.git
cd v12n-cli
make
.build/v12n-cli print-config > /path/to/store/config.txt
# /path/to/store/config.txt を編集して CPU 数などの設定やインストーラーを指定する
# os は linux しか実装してない
.build/v12n-cli start /path/to/store/config.txt
```

## やりたかったこと
- Virtualization.Framework で仮想マシンを作って動かす
- Xcode 未インストール (XCTest が無くて Swift PM も使用不可) な状態で複数の Swift ファイルからなるプログラムのビルド
- ただの実行可能ファイルに entitlement を付与する方法を知る
- コマンドから NSApplicationMain を実行した時の動きを知る

## やりたくなったこと
- 仮想マシンの管理を Agent にしてシェルをブロックしないようにしたい
- Agent で管理してるマシンに接続して画面を提供する Application を作ってみたい
  * これも Xcode 無しでいけると思うので悪ふざけしたい
- Swift 以外の言語で実装
