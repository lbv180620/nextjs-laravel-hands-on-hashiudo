# ==== 1章 : 記事一覧を作ろう ====

# ****  記事一覧画面とナビバーの作成 ****

# https://www.techpit.jp/courses/11/curriculums/12/sections/107/parts/387


# 2. 記事一覧のビューの作成

#? formatメソッド

# {{ $article->created_at->format('Y/m/d H:i') }}

# formatメソッドは、Laravelの日付時刻クラスであるCarbonで使えるメソッドです。

# 引数には、日付時刻表示のフォーマット(形式)を渡します。

# 'Y/m/d H:i'とすれば、2020/02/01 12:00といった表示になります。

# 'Y年m月d日 H時i分'とすれば、2020年02月01日 12時00分といった表示になります。

# もし、月や日を1桁表示にしたければ、mの代わりにn、dの代わりにjを使います。(n月j日)

# 使えるフォーマットは、PHPのdate関数と同じなので、フォーマットの書式をさらに知りたい方は以下を参考にしてください。


#& date - PHP公式マニュアル
# https://www.php.net/manual/ja/function.date.php


# ----------------

# 3. ナビバーのBladeの作成


# **** 記事テーブルとユーザーテーブルの作成 ****

# https://www.techpit.jp/courses/11/curriculums/12/sections/107/parts/388

# 1. データベースの作成
