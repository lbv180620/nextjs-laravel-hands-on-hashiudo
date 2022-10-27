# Docker導入手順書(Windows版)
#  2022/08/17

# ソースは以下の記事です。
# https://www.kagoya.jp/howto/cloud/container/wsl2_docker/



# WSL2を使えるようにする!

# Windows 11の場合:


# ⑴「Windows」＋「R」キーを押す。

# ⑵「ファイル名を指定して実行」メニューが表示されたら、検索欄に「cmd」と入力し、「OK」をクリックする

# ⑶ コマンドプロンプト(黒い画面)が表示されたら、以下コマンドを入力し、「Enter」キーをクリックする

# wsl --install


# 本コマンドによって、以下4つの作業が実行されます。

# 「Linux用Windowsサブシステム（WSL）」と「仮想マシン プラットフォーム」を有効化する
# WSL2用Linuxカーネルをダウンロード・インストールする
# WSL2を既定のバージョンとする
# Ubuntuディストリビューションをダウンロード・インストールする


# さらにWindows11では、Windows Terminalがあらかじめインストール済みとなっています。



# Windows 10の場合:


# 1. WSLと「仮想マシン プラットフォーム」を有効化する

# ⑴ Windowsのスタートボタンから「設定」→「アプリ」→「アプリと機能」→「プログラムと機能」→「Windowsの機能の有効化または無効化」の順で遷移する。

# ⑵ 「Windowsの機能の有効化または無効化」が表示される。
# 「Linux用Windowsサブシステム（WSL）」「仮想マシン プラットフォーム」にチェックを入れ「OK」をクリックする。

# ⑶ 画面の指示に従って再起動



# 2. WSL2用Linuxカーネルをインストールする


# ⑴ ブラウザで「https://aka.ms/wsl2kernel」にアクセスする

# ⑵「x64マシン用WSL2 Linuxカーネル更新プログラムパッケージ」をクリックして、インストーラをダウンロードする

# ⑶ ダウンロードしたインストーラをダブルクリックして起動させる

# ⑷ インストーラが起動したら「Next」をクリックしてインストールをすすめる



# 3. WSL2を既定のバージョンで利用できるようにする


# ※Windowsの初期設定では、WSL1が既定のバージョンとなっています。WSL2を既定のバージョンへ変更するため、以下の操作を行ってください。

# ⑴「Windows」＋「R」キーを押す。

# ⑵「ファイル名を指定して実行」メニューが表示されたら、検索欄に「cmd」と入力し、「OK」をクリックする

# ⑶ コマンドプロンプト(黒い画面)が表示されたら、以下コマンドを入力し、「Enter」キーをクリックする


# wsl --set-default-version 2



# 4. WSL2用Linuxディストリビューションをインストールする


# 以下手順で「Microsoft Store」から、Linuxディストリビューションを取得してインストールします。

# ※以下「Ubuntu」をインストールする


# ⑴ Windowsの「スタートボタン」→「Microsoft Store」と進む

# ⑵ 検索欄に「Ubuntu」と入力して検索を実行する

# ⑶ 検索結果の中から「Ubuntu」を選択して、次の画面で「入手」をクリックする
# ※ Ubuntu 20.04.4 LTSをインストール

# ⑷ 表示された画面で「開く」をクリックする
# ※インストールが開始されます。

# ⑸ Ubuntuの初期設定画面が表示される


# 画面に従い、以下の順番で入力を進める

# -「Enter new UNIX username」	新しく作成するユーザー名を入力します
# -「New password」	パスワードを入力します
# -「Retype new password」	同じパスワードをもう一度入力します

# Ubuntuのインストール作業は完了です。お手元のWindowsにて、Ubuntuが使えるようになっています。



# 5. Windows Terminalでより簡単にLinuxを使えるようにする


# ⑴ Windowsの「スタートボタン」→「Microsoft Store」と進む

# ⑵ 検索欄に「Windows Terminal」と入力して検索を実行する

# ⑶「Windows Terminal」が見つかったら「入手」をクリックする※インストールが始まります

# ⑷ インストールが完了したら「開く」をクリックする




# 「Docker Desktop for Windows」をインストールする!

# ⑴ Dockerの公式サイト（https://www.docker.com/）にアクセスし、画面右上部の「Get Started」をクリックする

# ⑵ 遷移先の画面で「Download for Windows」をクリックする。
# ※「Docker Desktop for Windows」のインストーラーがダウンロードされます。

# ⑶ ダウンロードしたらインストーラをダブルクリックしてインストールをすすめる

# ⑷ インストーラが起動したら、「OK」をクリックし画面の指示に従ってインストールをすすめる。
# ※「Configuration」のチェックはそのままでかまいません。




# 以上の手順が完了すると、Windows10・11上でDockerが使えるようになります。

# Dockerがインストールされていることは、Windows Terminal上から以下のように確認できます。

# docker -v





# Ubuntu上でもDockerを操作できるようにするには、以下の手順を踏んでください。

# Docker Desktop for Windowsを開き、
# 「歯車マーク」→ ｢Resources｣ → ｢WSL Integration｣ → ｢Ubuntu-20.04を有効化｣ →「Apply & Restart」


# ※ UbuntuでDockerを使う場合は、sudoコマンドをつける必要があります。




# 以下のエラーが発生して、Ubuntu上でDockerを操作できない場合の対処法:


# Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

# power shellを管理者権限で開く。

# 以下のコマンドでwslをシャットダウンする。
# wsl –shutdown

# 再度ターミナルを起動する。
