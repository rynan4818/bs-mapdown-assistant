# bs-mapdown-assistant
BeatSaverからOneClickでダウンロードする時にModAssistantの間に入り込んで指定プレイリストの末尾にダウンロードした譜面を追加します。

# 注意

インストールにレジストリを直接さわる必要があります。
レジストリの修正方法はご自分で調べて下さい。
分からない方は危険なので止めておいて下さい。

**2020/12/20 BeatSaverの仕様変更で使えなくなっています。使用中の方はアンインストール方法で機能を削除して下さい**

# インストール方法
1. [リリースページ](https://github.com/rynan4818/bs-mapdown-assistant/releases)から最新のリリースをダウンロードします。または、Gitでクローンもしくは、`Code`から`Downlaod ZIP`しても構いません。

2. zipを適当なフォルダに解凍します。例：C:\TOOL\bs-mapdown-assistant\
**※注意　Program Files や Program Files (x86) 以下のフォルダにインストールしないで下さい。**

3. `bs-mapdown-setting.exe` を実行して、`PlayList` に追加対象のプレイリストを選択し、`ModAssistant PATH` にOPEN ボタンからModAssistantの実行ファイルを選択して下さい。

![imange](https://rynan4818.github.io/bs-mapdown-assistant_constant.png)

5. レジストリエディタを起動して、エディタのアドレスバーに `Registory setting`の`PATH`をコピーして貼り付けると、該当のキーに飛びます。`(規定)`の`REG_SZ`の`値のデータ`に`Registory setting`の`REG_SZ`をコピーして貼り付けます。

![imange](https://rynan4818.github.io/bs-mapdown-assistant_registry.png)

6. 最後に`bs-mapdown-assistant setting`の`OK`を押すと、`bs-mapdown-assistant.rb`の設定値を変更して保存し完了です。

BeatSaverから譜面情報の取得にcurlコマンドを使いますが、Windows 10 April 2018 Update から curl が標準コマンドとして追加された様なので同梱していません。
curlコマンドが実行できない場合は、以下からダウンロードして bs-mapdown-assistant.exe と一緒のフォルダに置いて下さい。

- https://curl.haxx.se/windows/

# アンインストール方法

ModAssistantのOptionsのENABLE OneClick Installs のBeatSaverのチェックをOFF後にした後、再度ONするとレジストリが元の状態に戻ります。
あとは、インストールしたフォルダごと削除すればアンインストールできます。

# ライセンスと著作権について

bs-mapdown-assistant はプログラム本体と各種ライブラリから構成されています。

bs-mapdown-assistant のソースコード及び各種ドキュメントについての著作権は作者であるリュナン(Twitter [@rynan4818](https://twitter.com/rynan4818))が有します。
ライセンスは MIT ライセンスを適用します。

それ以外のbs-mapdown-assistant.exe に内包しているrubyスクリプトやバイナリライブラリは、それぞれの作者に著作権があります。配布ライセンスは、それぞれ異なるため詳細は下記の入手元を確認して下さい。

# 開発環境、各種ライブラリ入手先

各ツールの入手先、開発者・製作者（敬称略）、ライセンスは以下の通りです。

bs-mapdown-assistant.exe に内包している具体的なライブラリファイルの詳細は [Exerbレシピファイル](source/core_cui.exy) を参照して下さい。

## Ruby本体入手先
- ActiveScriptRuby(1.8.7-p330)
- https://www.artonx.org/data/asr/
- 製作者:arton
- ライセンス：Ruby Licence

## GUIフォームビルダー入手先
- FormDesigner for Project VisualuRuby Ver 060501
- https://ja.osdn.net/projects/fdvr/
- Subversion リポジトリ r71(r65以降)の/formdesigner/trunk を使用
- 開発者:雪見酒
- ライセンス：Ruby Licence

## 使用拡張ライブラリ、ソースコード

### Ruby本体 1.8.7-p330              #開発はActiveScriptRuby(1.8.7-p330)を使用
- https://www.ruby-lang.org/ja/
- 開発者:まつもとゆきひろ
- ライセンス：Ruby Licence

### Exerb                            #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- http://exerb.osdn.jp/man/README.ja.html
- 開発者:加藤勇也
- ライセンス：LGPL

### gem                              #開発はActiveScriptRuby(1.8.7-p330)同封版を使用
- https://rubygems.org/
- ライセンス：Ruby Licence

### VisualuRuby                      #開発はActiveScriptRuby(1.8.7-p330)同封版を使用 ※swin.soを改造
- http://www.osk.3web.ne.jp/~nyasu/software/vrproject.html
- 開発者:にゃす
- ライセンス：Ruby Licence

### json-1.4.6-x86-mswin32
- https://rubygems.org/gems/json/versions/1.4.6
- https://rubygems.org/gems/json/versions/1.4.6-x86-mswin32
- 開発者:Florian Frank
- ライセンス：Ruby Licence

### DLL

#### libiconv 1.11  (iconv.dll)       #Exerbでbs_movie_cut.exeに内包
- https://www.gnu.org/software/libiconv/
- Copyright (C) 1998, 2019 Free Software Foundation, Inc.
- ライセンス：LGPL
