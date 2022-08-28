#todo [WSL Tips]

# ==== WSL Volumeマウント問題 ====

#! PowerShellでホスト上のディレクトリをボリュームとしてマウントし，そのボリュームでコンテナへマウントする場合は、以下のようにして実行する。

#& wsl make <Makefileに設定したコマンド>

#! → WSLではdocker-compose.ymlで$PWDが使えず、またWindowsでのパス形式にdocker-composeが対応していないため。


#^ driver_optsのdeviceを使わないなら、ubuntu上で立ち上げて問題無い。

# 参考記事
# https://zenn.dev/ningensei848/scraps/22b312d5195979
# https://qiita.com/ragnar1904/items/d0e2709c2c7e827d09e2
# https://thinkami.hatenablog.com/entry/2020/03/29/091220
# https://tamosblog.wordpress.com/2019/03/11/volume_mount_by_docker_on_wsl/
# https://qiita.com/tettsu__/items/c50c17b4eef3c960e9b8


# ----------------

#todo [結論]

#^ powershellで、ちゃんとボリュームを削除してから起動すると、マウントできた。
# docker-compose.yml:device: /c/users/k_yoshikawa/IdeaProjects/workspace/self-study/infra/ci/laravel-ci-3/infra/data
# powershell: docker compose down --volumes --remove-orphans
# powershell: make up
#^ けどパーミッション問題が発生！
# drwx------ 1 systemd-coredump k_yoshikawa 512 Aug 25 12:57 data/


#^ なので、WSLではトップレベルでの名前付きボリュームだけにして、生成した名前付きボリュームをさらにローカルのディレクトリにバインドするのは諦める。


# レガシー:
setwsl:
	cat env/configs/wsl/wsl.mk >> Makefile

mount:
	@make destroy-volumes
	@make up


# --------------------

#? 使用方法

#^ upコマンドが含まれるmakeコマンドはpowershell上で実行する！

# プロジェクトの立ち上げ:
# powershellで、wsl make launch

# downしたプロジェクトの起動:
# powershellで、wsl make up

# クローンして来たプロジェクトの立ち上げ:
# powershellで、wsl make relaunch

# purgeしたプロジェクトの立ち上げ:
# powershellで、wsl make init


# --------------------


#? Docker for WindowsをWSLから使う時のVolumeの扱い方

# 記事
# https://qiita.com/gentaro/items/7dec88e663f59b472de6


# ⑴ PowerShell（またはコマンドライン）でローカルディレクトリをマウントする場合

# docker-compose.yml
# volumes:
#       - C:\hoge\fuga:/var/lib/mysql


# ⑵ WSLでローカルディレクトリをマウントする場合

# docker-compose.yml
# volumes:
#       - /C/hoge/fuga:/var/lib/mysql


#! WSLのディレクトリ構造は使えない
# $PWD → /home/... も相対パスも使えない

# ................

# 解決案:
# https://qiita.com/gentaro/items/fd0c32af2b12033f9cae

# .zshrc
# $ alias docker='/mnt/c/Program\ Files/Docker/Docker/resources/bin/docker.exe'


# ................

#! 症状:
#! local volumeを有効にすると、以下のエラーが発生し、make db-setがこけて、dbコンテナがExit1となる。
#! failed to retrieve console master: read unix /tmp/pty2940151148/pty.sock->@: EOF:

# 参考記事:
# B.3.3.6 MySQL の UNIX ソケットファイルを保護または変更する方法
# https://dev.mysql.com/doc/refman/8.0/ja/problems-with-mysql-sock.html

# 解決案:
# https://qiita.com/gentaro/items/7dec88e663f59b472de6
# https://nabinno.github.io/posts/58

# 事前にVolumeを作成する案
# https://qiita.com/Yukimura127/items/c798cf9c3b19498ab8bf


# ==== 環境構築 ====

# 記事
# https://zenn.dev/ttani/articles/wsl2-docker-setup
