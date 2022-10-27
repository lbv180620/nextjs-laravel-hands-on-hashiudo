#todo 13. JVM環境構築


# https://dekirukigasuru.com/blog/2018/02/28/sdkman/

# https://zenn.dev/y_u_t_a/articles/e7dd725c868b7b

# https://pepese.github.io/blog/sdkman-basics/

# https://qiita.com/uhooi/items/c9caa9a9ed6c934a789b

# spring.pleiades.io/spring-boot/docs/current/reference/html/getting-started.html

# https://qiita.com/iyuichi/items/75110ce3e5255c70a87c

# @Ant
# AsciidoctorJ
# Ceylon
# CRaSH
# Gaiden
# Glide
# @Gradle
# Grails
# Griffon
# @Groovy
# GroovyServ
# @Java
# JBake
# Kobalt
# @Kotlin
# kscript
# Lazybones
# Leiningen
# @Maven
# @sbt
# @Scala
# @Spring Boot
# Sshoogr
# Vert.x

# --------------------------

# SDKMANの導入

# sudo apt-get update

# sudo apt-get install -y \
#     unzip \
#     zip \
#     curl

# sudo apt-get install -y vim

# curl -s "https://get.sdkman.io" | bash

# # デフォルトでは $HOME/.sdkman にインストールされる
# # インストール先を変更したい場合は、以下のように SDKMAN_DIR を設定した上でインストールする
# # export SDKMAN_DIR="/usr/local/sdkman" && curl -s "https://get.sdkman.io" | bash

# source "$HOME/.sdkman/bin/sdkman-init.sh"

# # SDKMAN_DIR を設定した場合は以下のコマンド
# # source "$SDKMAN_DIR/bin/sdkman-init.sh"

# sdk version


# --------------------------

# sdklコマンド

# $ sdk help                     # help を表示
# $ sdk version                  # SDKMAN 自体のバージョン
# $ sdk selfupdate force         # SDKMAN 自体のバージョンアップ
# $ sdk install xxxx             # xxxx をインストール
# $ sdk install xxxx [version]   # xxxx を version 指定でインストール
# $ sdk uninstall xxxx [version] # xxxx を version 指定でアンインストール
# $ sdk list xxxx                # xxxx の version の一覧を表示
# $ sdk use xxxx [version]       # xxxx の現ターミナルの version を指定
# $ sdk default xxxx [version]   # xxxx のデフォルトの version を指定
# $ sdk current xxxx             # xxxx の現在の version を表示


# --------------------------

# Javaの導入

# # インストール可能な Java 一覧
# sdk list java

# # AdoptOpenJDK 16 をインストールする
# sdk i java 16.0.1.hs-adpt

# # -zulu は OpenJDK 、 -oracle は Oracle Java を指す。
# # HotSpot は OpenJDK コミュニティの JVM です。 現在最も広く使用されている JVM であり、 Oracle の JDK で使用されています。
# #Eclipse OpenJ9 は Eclipse コミュニティーの JVM です。低メモリ使用量と高速起動用に設計されたエンタープライズクラスの JVM であり、 IBM の JDK で使用されています。

# # Java のインストール確認
# java -version

# # 再ログインしたら JAVA_HOME が設定される
# exec $SHELL -l
# echo $JAVA_HOME


# --------------------------

# Kotlinの導入

# # インストール可能な Kotlin 一覧
# sdk list kotlin

# # Kotlin 1.5.21 をインストールする
# sdk i kotlin 1.5.21

# # Kotlin のインストール確認
# kotlin -version


# --------------------------

# Scalaの導入

# sdk list scala

# sdk i scala

# scala -version


# --------------------------

# Mavenの導入

# sdk list maven

# sdk i maven

# mvn -vesion


# --------------------------

# Gradleの導入

# sdk list gradle

# sdk i gradle

# gradle -vesion


# --------------------------

# Spring Bootの導入

# sdk list springboot

# sdk i springboot

# spring version


# --------------------------

# sbtの導入

# sdk list sbt

# sdk i sbt

# sbt -version


# --------------------------

#? SDKMAN のアンインストール


# SDKMAN 関連のパスを PATH から除去

# # SDKMAN でインストールしたライブラリを把握する
# sdk current

# # インストールしたライブラリの数だけ sed -e "s,$SDKMAN_DIR/candidates/<ライブラリ名>/current/bin:,," でパスを除去する
# # 今回のケースでは java と kotlin が対象
# # sed のデリミタはスラッシュ以外でも OK
# # スラッシュ以外の文字をデリミタにすればスラッシュをエスケープする必要がなくて楽
# export PATH=$(echo $PATH | sed \
# 	-e "s,$SDKMAN_DIR/candidates/java/current/bin:,," \
# 	-e "s,$SDKMAN_DIR/candidates/kotlin/current/bin:,,"
# )


# ..........................

# sdkman-init.sh を呼び出さないようにする

# ~/.bashrc と ~/.zshrc から以下のような記述を除去する。

# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="/root/.sdkman"
# [[ -s "/root/.sdkman/bin/sdkman-init.sh" ]] && source "/root/.sdkman/bin/sdkman-init.sh"

# ..........................

# SDKMAN がインストールされているディレクトリを削除

# SDKMAN が有効になっている環境では $SDKMAN_DIR が設定されているので、以下のコマンドで SDKMAN 関連のファイルを削除できる。

# rm -rf $SDKMAN_DIR

# ..........................

# 環境変数を削除

# # SDKMAN が設定した XXX_HOME 系の環境変数を表示する
# export -p | grep -i _HOME
# # Java と Kotlin をインストールした場合は JAVA_HOME と KOTLIN_HOME を削除
# export -n JAVA_HOME
# export -n KOTLIN_HOME

# # SDKMAN 関連の環境変数を表示する
# export -p | grep -i SDKMAN
# # SDKMAN 関連の環境変数を削除する
# export -n \
#     SDKMAN_CANDIDATES_API \
#     SDKMAN_CANDIDATES_DIR \
#     SDKMAN_DIR SDKMAN_PLATFORM \
#     SDKMAN_VERSION \
#     binary_input \
#     zip_output

# ..........................

# アンインストール後の動作確認
# # ログインし直す
# exec $SHELL -l

# # PATH に SDKMAN 関連のパスが含まれていないこと
# echo $PATH
# # JAVA_HOME が設定されていないこと
# echo $JAVA_HOME
# # SDKMAN 関連の環境変数が残っていないこと
# export -p | grep -i SDKMAN
# # 以下のコマンドが無効であること
# sdk
# java
# kotlin
