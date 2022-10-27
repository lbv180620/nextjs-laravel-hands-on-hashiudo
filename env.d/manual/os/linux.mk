#todo [Linuxコマンド]


# **** よく使うコマンド ****

# ファイルのスタック移動
# pushd popd → auto_pushd

# ファイル検索
# find -name '*.py' → fzf

# ファイル削除
# find -name ".pyc" | xargs echo
# find -name ".pyc" | xargs rm → pyclean

# ファイル名の摘出
# find -name "*.py" | cut -d '/' -f5 | cut -d '.' -f1

# ファイルの中身の検索
# grep "test" -nr

# プロセスのkills
# ps auwx | grep a.py | grep -v grep | awk '{print $2}' | xargs kill -9

# ソートからヘッド
# du | sort -nr | head -n 5

# seq 20

# 行のカウント
# ls -al | wc -l


#? よく使うcurlコマンドのオプション ****

# https://qiita.com/ryuichi1208/items/e4e1b27ff7d54a66dcd9
# https://www.setouchino.cloud/blogs/99
# https://www.pg-fl.jp/program/dos/doscmd/curl.htm


#? シンボリックリンクの作成・変更・削除

# 記事
# https://s-port.shinwart.com/tech-column/kawatama03/
# https://qiita.com/takeoverjp/items/bb1576e90a8a495db4b3
# https://choppydays.com/linux-ln-command-crate-override-symbolic-link/
# https://eng-entrance.com/linux-command-ln
# https://orebibou.com/ja/home/201704/20170415_001/
# http://kawatama.net/web/linux/1827

# シンボリックリンクの作成
# ln -s [TARGET] [LINK_NAME]

# シンボリックリンクの上書き
# ln -nfs  [TARGET] [LINK_NAME]

# シンボリックリンクの削除
# unlink [TARGET]

