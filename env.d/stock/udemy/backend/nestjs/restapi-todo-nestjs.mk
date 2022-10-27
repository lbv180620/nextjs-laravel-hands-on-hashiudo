# todo [NestJS + Next.js によるフルスタックWeb開発]

# https://www.udemy.com/course/nestjs-nextjs-restapi-react/

# https://github.com/GomaGoma676/restapi-todo-nestjs


# ==== セクション2: REST API by NestJS ====

# **** 3. Create NestJS project ****

#~ プロジェクトの作成

#^ 特にdockerは使わなくていい

# ⑴ nestコマンドが使えるように
# npm i -g @nestjs/cli


# ⑵ NestJSのプロジェクト作成
# nest new api-lesson

# nest new api-lesson backend
# or
# nest new .

#^ yarnを選択


# ⑶ tsconfig.jsonの修正
# tsconfig.json

# 型の付け忘れ防止
# "noImplicitAny": true,
# "strict": true


# ⑷ バックエンド用にポート番号の修正
# src/main.ts

# ポート番号の変更
# 3000 → 3005 (8000)


# ⑸ サーバーの立ち上げ
# yarn start:dev

#^ デフォルトで.git/がある。


# --------------------

#~ Structure

# Controller: ルーティング処理
# Service: ビジネスロジック
# ^ ControllerとServiceを疎結合にしている

#^ ※ ControllerからServiceに定義したメソッドを呼び出すために、ServiceをControllerにDIする


                                  # main.ts
                                  # ↓
                                  # app.module.ts
                                  # [imports]
                                  # [controllers]
                                  # [providers]
           # ↙︎                        # ↓                        # ↘︎
    # auth.module.ts              #' todo.module.ts          # prisma.module.ts
    # [imports]                   # [imports]                # [imports]
    # [controllers]               # [controllers]            # [controllers]
    # [providers]                 # [providers]              # [providers]
    # [exports]                   # [exports]                # [exports]


#^ DI(Dependency Injection) → ソフトウェアを疎結合にするためのデザインパターン


#^ main.ts: エントリポイント

#^ NestJSでは各機能をmoduleという単位で開発する。
# auth.module: 認証関係
#' todo.module: コンテンツ
# prisma.module: データベース操作系

#^ プロジェクトで使用したいmoduleをルートmoduleであるapp.moduleにimportすることで、そのmoduleの機能をプロジェクトの中で使用することができる。

#^ 各moduelはControllerとServiceを持つことができる。


# --------------------

#~ NestJS DI demo

# https://docs.nestjs.com/providers#dependency-injection

# "AppControllerでAppServiceのgetHello()メソッドを使用したい"


# src/app.controller.ts
# import { Controller, Get } from '@nestjs/common';
# import { AppService } from './app.service';

# @Controller()
# export class AppController {
#   constructor(private readonly appService: AppService) {}

#   @Get()
#   getHello(): string {
#     return this.appService.getHello();
#   }
# }


# src/app.service.ts
# import { Injectable } from '@nestjs/common';

# @Injectable()
# export class AppService {
#   getHello(): string {
#     return 'Hello World!';
#   }
# }



#・Controller内の実装で、AppServiceをインスタンス化しない！
#・NestJSはConstructorに指定されたAppServiceをIoC Containerでインスタンス化してAppControllerに注入する。生成されたAppServiceのインスタンスは、cacheされて再利用される(Singleton)
#・AppController内で、注入されたAppServiceのメソッドを使用できるようになる。


#^ app.service.tsでは、Injectableというデコレータで装飾されている。
#^ こうすることで、AppService を他のControllerや他のServiceにinjection(注入)することができる。

#^ Controller側で呼び出したいが、この時通常考えられるのが、AppControllerの中でAppServiceをインスタンス化して、そのインスタンスからメソッドを呼び出す。
#^ こうしてしまうと、ControllerとServiceの依存関係が強くなってしまう。

#^ DIを使う場合は、Controllerの内部の実装でインスタンス化するのではなく、すでにインスタンス化されたものをAppControllerのコンストラクタ経由でこのControllerに注入するという形をとっている。

#^ それを実現するために、AppControllerのコンストラクタのところに注入したいServiceを指定する必要がある。
#^ NestJSはコンストラクタに指定されている全てのServiceをチェックしてくれて、AppControllerがインスタンス化される時に、このAppServiceも一緒にインスタンス化してくれる。
#^ インスタンス化されたものは、この場合appServiceという名前で使用することができる。

#^ そして、AppServiceのインスタンスはコンストラクタ経由でAppControllerのインスタンスに注入される。
#^ そうすることで、AppControllerのインスタンスの方からAppServiceのインスタンス経由でAppServiceで定義したメソッドを呼び出すことができる。

#^ 先ほどのコンストラクタのところで指定したServiceを自動的にインスタンス化してくれて注入してくれる処理は、NestJSの中にあるIoC Containerが裏側で全てやってくれている。

#^ そして、 AppServiceからIoC Containerによって自動的にインスタンス化されたappServiceというのは、IoC Containerの中でキャッシュされて、他のControllerやServiceにInjectionされるときはキャッシュされたものが再利用される。
#^ これはSingletonと呼ばれていて、オブジェクト指向のデザインパターンのひとつ。
#^ AppServiceで生成されたインスタンスというのは、プログラム実行時にひとつだけインスタンスが生成されて、他のところから参照される時は、それを再利用するという手法。

#^ 一連のDIを機能させるためには、もうひとつやっておく必要がある。

# src/app.module.ts
# import { Module } from '@nestjs/common';
# import { AppController } from './app.controller';
# import { AppService } from './app.service';

# @Module({
#   imports: [],
#   controllers: [AppController],
#   providers: [AppService],
# })
# export class AppModule {}

#^ controllersのところで、AppControllerを登録しておく必要がある。
#^ providersのところで、AppControllerの中でAppServiceを使いたいので、AppServiceをここに登録する。


# --------------------

#~ Controllerのルートパスについて

# 今Controllerというデコレータ[@Controller()]に何も指定していないので、このGetというデコレータ[@Get()]は、このルートのパスに対応したものになる。
# localhost:3005/

# 例えば、@Controller('root') とすると、@Get() は今度は、localhost:3005/root/ に対応したものになる。

# この状態で、localhost:3005/ にアクセスすると、以下が返って来る。

# {"statusCode":404,"message":"Cannot GET /","error":"Not Found"}

# localhost:3005/root/ すると、この @Get() がヒットして getHello() が実行される。

# さらに個別のメソッドに対してもパスを貼っていける。
# @Get('next') とすると、
# localhost:3005/root/next/ のエンドポイントに対応することになる。


# **** 4. DI (Dependency Injection) ****

#~ Typical DI(Dependency Injection) in NestJS

# 1. Consume own service in own controller

# auth.module
# [imports]
# [controllers]
#  ↑ DI
# [providers]
# [exports]


# ひとつのmoduleの中でserviceのメソッドを使用したいので、serviceをcontrollerにDIする。


# 2. Consume other service in own service

# auth.module           prisma.module
# [imports]             [imports]
# [controllers]         [controllers]
# [providers]   ←DI    [providers]
# [exports]             [exports]


# あるserviceに対して、外部のserviceをDIする。

# 例えば、認証関係の機能を実装したいauth.moduleがあって、具体的な認証関係のビジネスロジックはauth.moduleのprovidersに登録されているとする。
# そして、認証するためにはDBにアクセスする必要があるが、そのDBのやりとりを簡単にしたいので、例えばprisma.moduleの中でビジネスロジックが実装されている、prisma.modulemのserviceを使用したい場合あるとする。
# この場合にauth.moduleのビズネスロジックがあるserviceにprisma.moduleのserviceをDIすることで、prismaの機能をauth.moduleのserviceの中で自由に使うことができるというパターンがある。


# --------------------

#~ 3 steps of DI realization in NestJS

# https://docs.nestjs.com/providers#provider-registration

# 1. Consume own service in own controller

# ⑴ InjectionしたいServiceに@Injectionデコレータをつける

# @Injection()
# export class AuthService {


# ⑵ Serviceを使用したいModuleのproviderに登録

# @Module({
  # imports: [],
  # controllers: [AuthController],
  # providers: [AuthService],
# })


# ⑶ ControllerのコンストラクタにServiceを追加

# @Controller('auth')
# export class AuthController {
#   constructor(private readonly authService: AuthService) {}


#^ Controllerはルーティングだけを担当しているので、具体的な処理はServiceのメソッドを呼び出す必要がある。このとき、ServiceのメソッドをControllerで使えるように、ServiceをDIでControllerに注入する。


# ....................

# 2. Consume other service in own service

# auth.module
# @Module({
#     imports: [PrismaModule],
#     controllers: [AuthController],
#     providers: [AuthService],
# })


# ⑴ InjectionしたいServiceに@Injectionデコレータを付ける

# prisma.controller
# @Injection()
# export class PrismaService {

# prisma.module
# @Module({
#   providers: [PrismaService],
#   exports: [PrismaService],
# })

#! exportsに追加すると、Module importでServiceも使用可能になる。

# ⑵ Serviceを使用したいModuleのimportsに外部Module登録

# auth.module
# @Module({
#    imports: [PrismaModule],
# })

# ⑶ Serviceのコンストラクタに外部Serviceを追加

# auth.service
# @Injection()
# export class AuthService {
#     constructor(
#       private readonly prisma: PrismaService,


# @Injectable()を付けたり、@Moduleのexportsを指定する部分は、自分で１からserviceを作って他のserviceにDIするときには必要だが、それ以外にすでに存在するライブラリを自分のserviceに取り込んでくるというケースが多々ある。

# nestjs/jwt
# https://github.com/nestjs/jwt

# https://github.com/nestjs/jwt/blob/master/lib/jwt.service.ts
# @Injectable()
# export class JwtService {

# https://github.com/nestjs/jwt/blob/master/lib/jwt.module.ts
# @Module({
#   providers: [JwtService],
#   exports: [JwtService]
# })

# 例えばauth.moduleをカスタムで作っていくとして、その中のserviceの中でJWTのserviceを使いたい場合は、auth.moduleのimportsのところに、JWTModuleをimportしてあげるだけで、このJWTのserviceをauth.moduleのserviceの中で使用することができる。


# **** 5. Prisma with Postgres (Docker) ****

# Nest.jsのORMにPrismaを導入してみる
# https://qiita.com/kikikikimorimori/items/5d1098f6a51324ddaab4

# VSCode拡張機能: Prisma

# install prisma
#^ backend配下
# $ yarn add -D prisma
# $ yarn add @prisma/client
# $ npx prisma init

# prisma/schema.prisma
# generator client {
#   provider = "prisma-client-js"
# }

# datasource db {
#   provider = "postgresql"
#   url      = env("DATABASE_URL")
# }


# add docker-compose.yml file
# backend/docker-compose.yml
# version: '3.8'
# services:
#   dev-postgres:
#     image: postgres:14.4-alpine
#     ports:
#       - 5434:5432
#     environment:
#       POSTGRES_USER: udemy
#       POSTGRES_PASSWORD: udemy
#       POSTGRES_DB: udemy
#     restart: always
#     networks:
#       - lesson
# networks:
#   lesson:

# start db
# $ docker compose up -d
# reset db
# $ docker compose rm -s -f -v


# edit DATABASE_URL of .env
#^ docker-compose.ymlで指定した環境変数に合わせる。
# DATABASE_URL="mysql://USER:PASSWORD@HOST:PORT/DATABASE"

# backend/.env
# DATABASE_URL="postgresql://johndoe:randompassword@localhost:5432/mydb?schema=public"
# ⬇️
# DATABASE_URL="postgresql://udemy:udemy@localhost:5434/udemy?schema=public"

# add model definition to schema file
# backend/prisma/schema.prisma
# generator client {
#   provider = "prisma-client-js"
# }

# datasource db {
#   provider = "postgresql"
#   url      = env("DATABASE_URL")
# }

# model User {
#    id Int @id @default(autoincrement())
#    createdAt DateTime @default(now())
#    updatedAt DateTime @updatedAt
#    email String @unique
#    hashedPassword String
#    tasks Task[] // 逆参照の定義, Userから見てTaskは多なので、配列で定義
# }

# model Task {
#    id Int @id @default(autoincrement())
#    createdAt DateTime @default(now())
#    updatedAt DateTime @updatedAt
#    title String
#    description String?
#    userId Int
#    user User @relation(fields: [userId], references: [id], onDelete: Cascade)
# }

#^ User 1:N Task
#^ migration fileに相当


# prisma migrate and type generation
# マイグレーションファイル作成
# $ npx prisma migrate dev
# v0

# テーブル作成
# npx prisma db push

# $ npx prisma studio

# 上は立ち上げたままで
# 定義したモデル構造の型を生成
# $ npx prisma generate


# install packages
# $ yarn add @nestjs/config @nestjs/jwt @nestjs/passport
# $ yarn add cookie-parser csurf passport passport-jwt bcrypt class-validator
# $ yarn add -D @types/express @types/cookie-parser @types/csurf @types/passport-jwt @types/bcrypt


# ....................

#& 自分の環境でやる場合:
# Makefile.env: apache|postgres

# Makefile: launchの項目で、Laravelに関連するところをコメントアウト, useraddの項目で、$(ctr)の箇所をコメントアウト

# env/docs/docker-compose.env:
# DB_HOST=db
# DB_PORT=5432
# DB_DATABASE=nestjs
# DB_USERNAME=phper
# DB_PASSWORD=secret

# env/configs/mac/apache/postgres/docker-compose.yml: dbコンテナ以外コメントアウト

# make launch

# backend/.env
# DATABASE_URL="postgresql://phper:secret@localhost:5432/nestjs?schema=public"


# **** 6. Module・Controller・Service ****

# nestjs/config
# https://github.com/nestjs/config

#~ Create module, controller, service

# $ nest g module auth
# $ nest g module user
# $ nest g module todo
# $ nest g module prisma

#^ デフォルトではspecファイルが生成される。
# $ nest g controller auth --no-spec
# $ nest g controller user --no-spec
# $ nest g controller todo --no-spec

# $ nest g service auth --no-spec
# $ nest g service user --no-spec
# $ nest g service todo --no-spec
# $ nest g service prisma --no-spec


#^ prismaのmoduleはserviceは生成するが、controllerは生成しない。
#^ serviceだけを提供するmoduleを作れて、例えば外部のmoduleはすべてこの形で作られている。
#^ prisma.moduleはprisma.serviceを他のserviceにDIで注入していくだけなので、ルーティングの機能を持たせる必要がないので、contorllerは不要。


# **** 7. Prisma Service ****

# prisma.serviceの中では、環境変数のDATABASE_URLを参照していきたいが、このときにインストールしておいた、nestjs/configのmoduleを使用する。

# この環境変数用のconfigのserviceは、プロジェクトの色んなところで使いたいので、これをglobalにimportする。

# そのためにはapp.moduleを開いて以下のようにする。

# import { ConfigModule } from '@nestjs/config';

# @Module({
#   imports: [ConfigModule.forRoot({isGlobal: true}), AuthModule, UserModule, TodoModule, PrismaModule],
#   controllers: [AppController],
#   providers: [AppService],
# })
# export class AppModule {}


# imports: [ConfigModule.forRoot({isGlobal: true})
# とすると、ConfigModuleをプロジェクト全体にglobalにimportすることができる。
# つまり、個別のmoduleでimportsしなくても、config.serviceが使用できる。


# --------------------

# main.tsに処理を追加する。

# プロジェクトで必要なパッケージをimportする。

# import { ValidationPipe } from '@nestjs/common';
# → 後ほどDTOでクラスバリデーションを学習するが、その実装した機能を有効化するために必要なmodule。

# import { Request } from 'express';
# → Requestのデータ型

# import * as cookieParser from 'cookie-parser';
# → JWTトークンのやりとりをcookieベースでやるので、ClientのリクエストからCookieを取り出すために必要。

# import * as csurf from 'csurf';
# → CSRF対策でCSRFトークンを使えるようにする。


# app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
# → 後ほど学習するDTOとクラスバリデーションの処理を有効化するために必要。


# app.enableCors({
#   credentials: true,
#   origin: ['http://localhost:3000'],
# });
# → CORSの設定。originのホワイトリストのところにBackendのサービスへのアクセスを許可したいFrontendのドメインを指定する。
# → FrontendとBackendでJWTトークンをCookieベースで通信するようにしていくので、credentialsをtrueにする。


# app.use(cookieParser());
# → Frontendから受け取ったCookieを解析する。


# --------------------

# prisma.service.ts


# import { ConfigService } from '@nestjs/config';
# → config.serviceをimport。

# import { PrismaClient } from '@prisma/client';


# constructor(private readonly config: ConfigService) {}
# → prisma.serviceの中でconfig.serviceを利用できるようにするためには、config.serviceをDIする必要があるので、コンストラクタで指定する。


# export class PrismaService extends PrismaClient {
# → カスタムのPrismaServiceのクラスに対して、PrismaClientのクラスの機能を取り込むために、PrismaClientを継承する。
# → PrismaClientで定義されているcreate()やdelete()といったDBを簡単に操作できるメソッドをPrismaServiceで利用できるようになる。


# constructor(private readonly config: ConfigService) {
#   super({
#     datasources: {
#       db: {
#         url: config.get('DATABASE_URL'),
#       },
#     },
#   });
# }
# → super()は、継承しているPrismaClientクラスにあるコンストラクタの処理を参照することができる。


# PrismaClientクラスのコンストラクタを見ると、DBに接続するための処理が定義されている。
# ただどのDBに接続するかの情報が毎回プロジェクト毎に変わってくるので、それをオプションとしてコンストラクタに渡す必要がある。

# PrismaClientOptionsにパラメータを渡してあげることができる。

# PrismaClientOptionsを見てみると、この中にdatasourcesというフィールドがあって、Overwrites the datasource url from your schema.prisma file と書いてあるので、datasourcesのオプションにpostgresのURLを渡してあげることで、それをDatasourcesクラスが使用してくれる。


# url: config.get('DATABASE_URL'),
# → config.get()メソッドを使って、.envのファイルから環境変数を取得している。


# prisma.module.ts
# @Module({
#   providers: [PrismaService],
#   exports: [PrismaService],
# })
# export class PrismaModule {}
# → PrismaServiceをPrismaのmoduleをimportするだけで利用できるようにするには、prisma.moduleのexportsのところにPrismaServiceを追加しておく必要がある。
# → こうすることでPrismaServiceを使いたいmodule側でimportsするだけでPrismaServiceを利用できるなる。


# @Module({
#   imports: [PrismaModule],
# → auth.module, user.module, todo.moduleでimportsする。


# **** 8. Authentication Strategy ****

# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/33366866#overview


#~ Authentication flow

# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/33366866#overview

# 認証の中でCSRFトークンを使っていくが、CSRFトークン自体は、CSRF攻撃の対策として用いられていて、ClientからDBに変更を加えるようなリクエストがあった場合、POST, PUT, PATCH, DELETEのメソッドのリクエストがREST APIにあった場合は、CSRFトークンを使って、そのリクエストがちゃんと正規のサイトから送られて来ているものかを検証する。


# GET: /auth/csrf
# まずFrontendのアプリケーションがブラウザにロードされた時に、CSRFトークンを発行してくれるエンドポイントにGETメソッドでアクセスして、CSRFトークンをJSONの形で取得する。

# ⬇️

# set-cookie: Secret
# httpOnly cookie
# csurf: POST, PUT, PATCH, DELETE -> csrf validation run
# このときBackendではcsurfというライブラリを使っていくが、こちらの仕様では、CSRFトークンのエンドポイントにGETメソッドにアクセスがあった時に(GET: /auth/csrf)、レスポンスの中でset-cookieをサーバーサイドで実行して、Secretと呼ばれる値をhttpOnly cookieという形でブラウザの方に設定してくれる。
# そしてこのSecretというのは、CSRFトークンを生成するために使われたSecret Keyになっている。

# ⬇️

# POST: /task
# cookie: Secret
# httpOnly cookie
# そして一度set-cookieでサーバーサイドからブラウザの方にCookieが設定されると、それ以降のClientからサーバーへのリクエストのときは、自動的にset-cookieの値が自動的にリクエストの中に含まれる形になる。

# ⬇️

# そして正規のサイトからCSRFのエンドポイント(GET: /auth/csrf)にアクセスした時は、ちゃんとCSRFトークンをJSONのレスポンスで返してくれる。

# 非正規のサイトからCSRFのエンドポイントにアクセスがあった場合は、CROSのホワイトリストにその非正規のサイトが登録されていないので、そのサイトへはCSRFトークンのレスポンスを読み取れないようになっている。

# ⬇️

# そして、ユーザーがメールアドレスとパスワードを入力してログインボタンを押すとPOSTメソッドが発行されて、POST: /auth/loginのエンドポイントにメールアドレスとパスワードが送信される。

# ⬇️

# そして、受け取ったメールアドレスとパスワードが正しいかどうかをAuthサービスの方で検証して、問題無ければJWTトークンを生成して、レスポンスを送る時にサーバーサイドでset-cookieを使ってhttpOnlyをtrueにした形でブラウザの方にCookieをセットする。

# httpOnly cookie
# このhttpOnlyはCookieにSecretをセットするときも両方trueになっていて、httpOnlyをtrueにしておくと、このcookieの値はブラウザのJavaScriptから読み込むことができないようにできる。

# ⬇️

# そして、ログインが完了した後に、Todoの機能を使って新しくタスクを作るリクエストが送られて来たとする。

# 例えば、POST: /taskのエンドポイントにPOSTメソッドでtitleとdescriptionの値が送られて来たとする。

# このときに、POSTメソッドなので、CSRFトークンが正しいものか検証を行う。

# そして、リクエストを送るときに、最初にGET: /auth/loginで取得したCSRFトークンをリクエストのheaderに含めてサーバーサイドに送信する。
# header: Csrf Token

# さらに、CSRFトークンを生成される時に使われたSecretのキーとJWTトークンはset-cookieでセットされているので、それ以降のリクエストでは自動的にリクエストにこれらのCookieが付与される。

# cookie: JWT
# httpOnly: cookie

# cookie: Secret
# httpOnly: cookie

# なので、POSTのリクエスト時は自動付与されたJWTのCookieとSecretのCookie、さらにheaderに手動でCsrf Tokenを付与させて、この3つの属性をリクエストの中に含めてサーバーサイドに送信する。

# ⬇️

# そうすると、まずはCSRFトークンが妥当なものか検証するために、この送られて来たSecretのキーをCookieから取り出して、hashをかけて送られてきたCSRFトークンとhashで計算した値が一致するか検証を行う。

# Csrf Token == hash(Secret Key)

# これが一致すれば正規のサイトからリクエストがあったと判断する。

# そして、CSRFトークンが問題なければ、JWTトークンの検証を行なって有効期限が切れてないか、JWTが正しいものかを行なって問題なければ、実際にDBの方にタスクを追加する。


# --------------------

#~ SameSiteとSecure

# Cross domain間通信時のcookieの扱いの違い


# SameSite = lax: default
#^ Chromeではデフォルトでlaxがdefaultとなっている。

# https://frontend.com

# ⇅

# https://api.herokuapp.com


# - POSTメソッドでログイン認証しても、Cookieがsetされない。
# - GoogleによるCSRF対策。

# SameSiteをlaxに設定した場合は、POSTメソッドでリクエストを出した場合は、このCookieを送信することができないという仕様になっている。


# ....................


# SameSite = none

# https://frontend.com

# ⇅

# https://api.herokuapp.com


# - Cookieの送受信が可能になる。
# - Secure: true → httpsで暗号化された通信のみcookie使用可能

# SameSiteをnoneにした場合は、Cross domain間、フロントエンドとバックエンドで自由にCookieの送受信を行うことができる。



#^ なので、フロントエンドとバックエンドでドメインが異なるSPAでが、SameSiteをnoneにしてあげて、Cookieの送受信を自由に行えるようにする必要がある。

#^ そして、SameSiteをnoneに設定した場合は、Google Chromeの制約でSecure属性をtrueに設定する必要がある。
#^ Secure属性をtrueにした場合は、通信をhttpsに変更する必要がある。


# **** 9. AuthService + AuthController ****

# auth.serviceではJWT moduleを使用していくので、auth.moduleでimportsする。

# auth.module.ts
# import { JwtModule } from '@nestjs/jwt';

# @Module({
#   imports: [PrismaModule, JwtModule.register({})],


# ----------------

# .envにJWTを生成するためのSecretキーを追加する。

# JWT_SECRET="<好きな文字列>"


# ----------------

# auth/dtoフォルダを作成。

# DTO (Data Transfer Object)
# - TransferはClientからServerに送られて来るデータのこと。
# - 例えば、ログインをする時は、Eメールとパスワードの両方がオブジェクトとして送られてくるが、このデータのことをDTOと呼ぶ。


# auth/dto/auth.dto.tsを作成し、データの型を指定する。

# 今回はEmailとpasswordが送られてくるので、export classでAuthDtoクラスを作成し、以下のように型を指定する。

# export class AuthDto {
#   email: string;
#   password: string;
# }


#^ このとき、NestJSではクラスバリデーターというものを使って、Clientから送られてくるデータに対してバリデーションを追加していくことできる。

# import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

#^ バリデーションの内容をデコレーションの形で各フィールドに付与していくことができる。

# @IsEmail()
# @IsNotEmpty()
# email: string;
# → Clientから送られてきたEmailの文字列がちゃんとEmailのフォーマットに沿っているか、そしてEmailがちゃんと入力されているかのバリデーションかけることができる。

# @IsString()
# @IsNotEmpty()
# @MinLength(5)
# password: string;


# ----------------

# auth/interfacesフォルダを作成。

# auth/interfaces/auth.interface.tsを作成し、ここにauth.controllerやauth.serviceで使用するデータ型を定義する。

# export interface Msg {
#   message: string;
# }

# export interface Csrf {
#   csrfToken: string;
# }

# export interface Jwt {
#   accessToken: string;
# }


# ----------------

# 先ほどのclass-validatorの機能を有効化するためには、最初にmain.tsで指定した以下のValidationPipeを設定する必要がある。

# app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

# whitelist: trueというのは、DTOクラスに含まれないフィールドを省いてくれる。
# → Laravelのfillableに相当。


# ----------------

#& AuthServiceの実装

# auth.serviceにビジネスロジックを追加する。

# 必要なimport:

# import { Injectable, ForbiddenException } from '@nestjs/common';
# import { PrismaClientKnownRequestError } from '@prisma/client/runtime';
# import { ConfigService } from '@nestjs/config';
# import { JwtService } from '@nestjs/jwt';
# import * as bcrypt from 'bcrypt';
# import { PrismaService } from '../prisma/prisma.service';
# import { Msg, Jwt } from './interfaces/auth.interface';


# ................


# AuthServiceの中では、PrismaService, JwtService, ConfigServiceを使用したいので、コンストラクタを使ってDIでこれらのServiceを注入する。

# constructor(
#   private readonly prisma: PrismaService,
#   private readonly jwt: JwtService,
#   private readonly config: ConfigService,
# ) {}


# ................

# ユーザーを新規作成するsignUp関数を定義。
# この関数はAuthDtoを受け取るので、Emailとpasswordのオブジェクトを受け取れるようにする。

# async signUp(dto: AuthDto) {}


# 受け取ったpasswordをhash化したいので、bcrypt.hash()を使って、受け取ったdtoからpasswordの属性を取り出してhash化を行う。
# hash()の第二引数はroundsというものを指定できて、この12は2の12乗を意味している。
# hashを計算するのに4096回演算が必要という意味になる。

# const hashed = await bcrypt.hash(dto.password, 12);


# 受け取ったEmailとhash化されたpasswordをPrismaServiceのメソッドを使ってDBにcreateしていく処理を書く。

# try {
#   await this.prisma.user.create({
#     data: {
#       email: dto.email,
#       hashedPassword: hashedPassword,
#     },
#   });
#   return {
#     message: 'ok',
#   };
# } catch (error) {}


# await this.prisma.user.create();
# → このuserの部分はモデルに対応していて、prisma/schema.prismaで定義したUserモデルに対応している。
# → Taskを操作したい場合は、his.prisma.task.create(); とすればいい。

# prisma/schema.prisma
# model User {
#   id Int @id @default(autoincrement())
#   createdAt DateTime @default(now())
#   updatedAt DateTime @updatedAt
#   email String @unique
#   hashedPassword String
#   tasks Task[]
# }

# model Task {
#   id Int @id @default(autoincrement())
#   createdAt DateTime @default(now())
#   updatedAt DateTime @updatedAt
#   title String
#   description String?
#   userId Int
#   user User @relation(fields: [userId], references: [id], onDelete: Cascade)
# }


# エラーが発生したい場合の処理を足す。

# } catch (error) {
#   if (error instanceof PrismaClientKnownRequestError) {
#     if (error.code === 'P2002') {
#       throw new ForbiddenException('This email is already taken');
#     }
#   }
#   throw error;
# }

# Prismaの操作に伴うエラーコードは、PrismaClientKnownRequestErrorというクラスで定義されている。

# Error codes 一覧
# https://www.prisma.io/docs/reference/api-reference/error-reference#error-codes

# 新規でユーザーを作成した時に発生するエラーというのは、すでに存在するEmailでユーザーを作成しようとした場合になる。

# そして、prisma/schema.prismaのUserがemail String @uniqueなので、エラーコードとしては、

# P2002
# "Unique constraint failed on the {constraint}"

# に対応する。

# なので、エラーコードがP2002に一致した場合は、ForbiddenExceptionを呼び出して、メッセージを付与してエラーを投げるようにする。

#     if (error.code === 'P2002') {
#       throw new ForbiddenException('This email is already taken');

# それ以外のエラーの場合は、単純にerrorをthrowするようにする。


# signUp関数の返り値は内部でPrismaの非同期通信を行なっているので、返り値としてはPromiseにして、成功した時はMsgの型が返ってくるので、ジェネリックスでMsgを指定する。

# async signUp(dto: AuthDto): Promise<Msg> {


# ................

# loginメソッドを定義する。
# async login(dto: AuthDto) {}


# loginメソッドの中で、JWTを生成するgenerateJwtというメソッドを呼び出していくので、それを定義する。
# async generateJwt(userId: number, email: string) {}


# 受け取ったuserIdとemailを使って、JWTを生成するためのpayloadを定義しておく。
# userIdはsubという名前でpayloadを作っておく。
# async generateJwt(userId: number, email: string) {
#   const payload = {
#     sub: userId,
#     email,
#   };
# }


# そして、環境変数からJWT_SECRETを呼び出して、secretという変数に格納しておく。
# const secret = this.config.get('JWT_SECRET');


# このpayloadとsecretを使って、実際にJWTを生成する処理を書く。
# JWT serviceで提供されているsignAsyncというメソッドを使っていく。
# signAsyncにpayloadを渡して、先ほどのJWT_SECRET、JWTのアクセストークンの有効期限を指定する。
# 今回は5分。
# const token = await this.jwt.signAsync(payload, {
#   expiresIn: '5m',
#   secret: secret,
# });


# そしてメソッド最後に、生成されたJWTトークンをreturnで返す。


# 返り値の型を付ける。
# async generateJwt(userId: number, email: string): Promise<Jwt> {


# ................

# loginメソッドを完成させる。

# loginメソッドの中で最初にやるのは、dtoからemailを取り出して、そのemailに対応するuserがDBに存在するかどうかを検証する。
# findUniqueでdto.emailに一致するuserが存在するかをfindで検索する。

#  const user = await this.prisma.user.findUnique({
#     where: {
#       email: dto.email,
#     },
#   });


# このuserが存在しない場合は、ForbiddenExceptionで例外を作る。
# if (!user) {
#   throw new ForbiddenException('Email or password incorrect');
# }


# userが存在する場合は、dtoで渡されて来た平文のpasswordとDBの中にあるhash化されたpasswordを比較検証して、一致するかどうかを検証する。
# bcryptのcompareメソッドが用意されているので、第一引数に平文、第二引数にhash化されたpasswordを指定すると、比較の検証をしてくれる。
# const isValid = await bcrypt.compare(dto.password, user.hashedPassword);


# 一致する場合は、isValidがtrueになるので、falseの場合はForbiddenExceptionで例外を発生させる。
# if (!isValid) throw new ForbiddenException('Email or password incorrect');


# passwordも問題なければ、最後にgenerateJwtメソッドを使って、user.idとuser.emailを渡してJWTを生成させる。
# return this.generateJwt(user.id, user.email);


# 返り値の型は指定。
# async login(dto: AuthDto): Promise<Jwt> {


# ----------------

#& AuthControllerの実装

# auth/auth.controller

# 必要なモジュールのimport
# import { Controller, Post, Body, HttpCode, HttpStatus, Res, Req, Get } from '@nestjs/common';
# import { Request, Response } from 'express';
# import { AuthService } from './auth.service';
# import { AuthDto } from './dto/auth.dto';
# import { Csrf, Msg } from './interfaces/auth.interface';


# AuthControllerの中ではAuthServiceを使いたいので、AuthServiceをDIするためにコンストラクタを追加する。
# constructor(private readonly authService: AuthService) {}


# 最初のエンドポイントを作成する。

# ユーザーを新規に作成するエンドポイントとして、sinupというエンドポイントを作成する。
# @Post('signup')
# signUp(@Body() dto: AuthDto): Promise<Msg> {
#   return this.authService.signUp(dto);
# }

# こちらはPOSTメソッドにしてsignUpという関数を作る。
# こちらのエンドポイントでClientから送られてくるリクエストボディの内容を取り出したい場合は、@Body()を使うことでリクエストボディの内容を取得することができる。
# そしてClientから送られてくる内容は、auth.dto.tsの内容に対応したものになるので、AuthDtoの型を付けている。
# 実体としてはEmailとpasswordのオブジェクトになる。

# Controllerはルーティングの処理だけやって、ビジネスロジックは全てServiceに任せるというコンセプトなので、受け取ったdto、EmailとpasswordをauthServiceのsignUpメソッドに渡してあげることをする。
# そうすると、authServiceのsignUpメソッドなので、成功したら、messageが返って来るので、戻り値の型はPromise<Msg>にしている。


# 新規ユーザーが生成できるか試す。

# 追加し忘れ。
# yarn add class-transformer

# yarn start:dev

# 動作確認はPostmanを使用。
# POST: http://localhost:8000/auth/signup
# Body → x-www-form-urlencoded
# email: user1@test.com
# password: user1
# Send

# {
#     "message": "ok"
# }

# npx prisma studio
# User


# ................

# loginのエンドポイントを追加

# @HttpCode(HttpStatus.OK)
# @Post('login')
# async login() {}


#^ NestJSでは、POSTメソッドのレスポンスのStatusは全て201 Createdになってしまう。
#^ これはCreateするときはいいが、ログインするときは何かCreateする訳ではないので200のOKのStatusの方が適切になる。
#^ その場合はHttpCodeのデコレータで200のOKを返すように変更ができる。


# @HttpCode(HttpStatus.OK)
# @Post('login')
# async login(@Body() dto: AuthDto, @Res({ passthrough: true }) res: Response) {}

# リクエストボディからClientから送られて来たEmailとpasswordを取得するために、AuthDtoの型を指定しておく。
# そしてResのデコレータでpassthroughをtrueを指定する。
# レスポンスの型はexpressで定義されている型を指定する。


# AuthServiceのloginメソッドを呼び出す。
# このときにClientから受け取ったdtoのEmailとpasswordのデータをloginメソッドに渡す。
# AuthServiceのloginメソッドはJWTを返してくれるので、jwtの変数で受け取れるようにする。
# const jwt = await this.authService.login(dto);


# 今回の認証の流れではloginのエンドポイント(POST: /auth/login)では、サーバーサイドでset-cookieを使ってJWTをhttpOnly trueで付与してあげるという処理なるので、これを追加する。

# res.cookie('access_token', jwt.accessToken, {
#   httpOnly: true,
#   secure: true,
#   sameSite: 'none',
#   path: '/',
# });

# cookieの名前はaccsess_tokenとして、cookieの具体的な値はjwtの中にaccessTokenが入っているのでjwt.accessTokenで取り出してcookieの値として設定している。

# httpOnly: true
# secure: true
# sameSite: 'none'
# path: '/'

#^ secureをtrueにした場合、通信をhttps化する必要があって、このためにはNestJSのプロジェクトをデプロイしてhttpsに変える必要があるが、今はローカルなので、secureはfalseにしておく。
# こちらは最終的にはtrueに戻すが、現状Postmanで動作確認する時にはfalseにしておく。


# メッセージをreturnさせる。
# return {
#   message: 'ok',
# };

# 戻り値の型は、Promise<Msg>


# ................

#? passthrough: true の意味について

# NestJSではStandardモードというものがあって、Controllerの例えばsigninのreturnのところにオブジェクトの形を指定すると、NestJSのStandardモードでは自動的にJSOMの形にシリアライズしてClientに返してくれる機能がある。

# return {
#   message: 'success',
# };


# そして、エンドポイントの関数の引数のところに@Res()を使用すると、このオブジェクトのモードがExpressのオブジェクトのモードに切り替わってしまう仕様になっている。
# ExpressのResponseオブジェクトに切り替えるとcookieの設定が使えるようになるが、これをExpressに切り替えた時に、Standardモードが無効化されてしまい、JSONに自動でシリアライズされなくなってしまう。

# httpOnly: true
# secure: true
# sameSite: 'none'
# path: '/'


#^ このStandardモードとExprssのResponseのオブジェクトのモードを両立させたいとき、両方の機能を有効化させたいときは、@Res()のところにpassthrough: trueを設定することで、StandardのJSONにシリアライズしてくれる機能とCookieを設定する機能を両方を有効化することができる。


# ................

# ログアウト用のエンドポイントを作成する。

# @HttpCode(HttpStatus.OK)
# @Post('/logout')
# logout(@Req() req: Request, @Res({ passthrough: true }) res: Response): Msg {
#   res.cookie('access_token', '', {
#     httpOnly: true,
#     secure: true,
#     sameSite: 'none',
#     path: '/',
#   });

#   return {
#     message: 'ok',
#   };
# }


# ログアウトに関してもPOSTメソッドなので、デフォルトの201 createdから200 okに変えるようにHttpCodeのデコレータを追加。

# logoutの引数のところで、ReqとRes。
# そしてCookieの設定とStandardモードを両立させたいので、Resデコレータにところをpassthrough: trueにする。

# そして、Cookieをリセットしたいので、設定し直しているが、今度はaccess_tokenの値を空の値で設定し直すことでCookieをリセットするという形をとっている。

# ローカルなので、secureが一旦falseにしておく。


# ................

# Postmanを開いて動作確認。

#! テーブルを永続化できない問題
# npx prisma db push


# POST: http://localhost:8000/auth/login
# Body → x-www-form-urlencoded
# email: user1@test.com
# password: user1
# Send

# {
#     "message": "ok"
# }

# Cookiesの確認
#! 返ってこない！ → ローカルなのにsecure: trueにしていた

# Headers set-cookiesの確認
# access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoidXNlcjFAdGVzdC5jb20iLCJpYXQiOjE2NjUzNTcyMjUsImV4cCI6MTY2NTM1NzUyNX0.Of3N7LBB5hpDxwb6-UGEFlbTVoGoQhMWDTloNeXfBEs; Path=/; HttpOnly; SameSite=None

# Cookies
# access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoidXNlcjFAdGVzdC5jb20iLCJpYXQiOjE2NjUzNTcyMjUsImV4cCI6MTY2NTM1NzUyNX0.Of3N7LBB5hpDxwb6-UGEFlbTVoGoQhMWDTloNeXfBEs; Path=/; HttpOnly;



# POST: http://localhost:8000/auth/logout
# Send

# Cookiesの確認
# 返って来た
# Valueが空になっている

# Headers set-cookiesの確認
# access_token=; Path=/; HttpOnly; SameSite=None

# Cookies
# access_token=; Path=/; HttpOnly;


# **** 11. JWT strategy + User Service/Controller ****

# user関係のエンドポイントを作成する。

# ここでは、JWTの認証をかけて、有効なJWTがリクエストのCookieに含まれていれば、ログインしているユーザーのユーザー情報を返すエンドポイントと、
# ユーザーのnicknameというフィールドを作って、そのnicknameを編集するためのエンドポイントを作成する。

# そのために、prisma/schema.prismaを開いて、Userモデルにnicknameというフィールドを新しく追加する。

# model User {
#   id Int @id @default(autoincrement())
#   createdAt DateTime @default(now())
#   updatedAt DateTime @updatedAt
#   email String @unique
#   hashedPassword String
#   nickName String? // 追加 null許容
#   tasks Task[]
# }

# そしてスキーマの内容を変更した場合は、この変更をPosgreSQLに反映させる必要があるので、

# npx prisma migrate dev
# v1
# npx prisma studio
# npx prisma generate 型を再生成


# ----------------

# src/user/dto/update-user.dto.ts

# ここにには、ユーザーの内容を更新するためのエンドポイントにClientからTransferされてくるオブジェクトをDTOとして定義しおく。

# 今回はnickNameだけを更新するので、DTOの内容としては以下の通り。

# import { IsOptional, IsString } from 'class-validator';

# export class UpdateUserDto {
#   @IsOptional()
#   @IsString()
#   nickName?: string;
# }

# そして、class-validatorを使って、IsOptional, IsStringの制約をデコレーションしておく。


# ....................

# 次に、user.service.tsを開いて、ここに処理を追加する。

# import { PrismaService } from '../prisma/prisma.service';
# import { UpdateUserDto } from './dto/update-user.dto';
# import { User } from '@prisma/client';
# → @prisma/clientからUserモデルに対応した型をimportする。

# @prisma/clientの方から、UserとTaskのデータ型が、npx prisma generateのコマンドで生成されている。
# このように、@prisma/clientからimportして使うことができるようになっている。


# UserServiceの中でPrismaServiceを使用していきたいので、コンストラクタのところでPrismaServiceを追加してDIしておく。

# @Injectable()
# export class UserService {
#   constructor(private readonly prisma: PrismaService) {}
# }


# UserServiceの中で、nickNameの内容を更新するための処理を追加する。

# async updateUser(userId: number, dto: UpdateUserDto): Promise<Omit<User, 'hashedPassword'>> {
#   const user = await this.prisma.user.update({
#     where: {
#       id: userId,
#     },
#     data: {
#       ...dto,
#     },
#   });

#   delete user.hashedPassword;

#   return user;
# }


# updateする場合は、どのユーザーを更新するかを、ユーザーIDを渡してあげて指定する必要がある。
# なので、引数にuserId: numberを追加。

# そしてClientから送られてくる新しいnickNameの内容をUpdateUserDtoの型を付けて受け取れるようにする。

# メソッドの中では、prisma.user.update()で更新する。
# この時に引数で受け取ったuserIdに一致するオブジェクトを更新するという部分と、
# Clientから受け取った新しいnickNameのDTOをdataとして渡す。

# updateの返り値は、変更されたユーザーのオブジェクトが返ってくるが、@prisma/clientからimportしたUserの型をみると、hashedPasswordが含まれてしまうので、
# delete user.hashedPassword; で削除してから、retrun user; でユーザーのオブジェクトを返すようにする。


# ----------------

# エンドポイントのルーティングを作るために、UserControllerを作っていく。

# 必要なimport
# import { Controller, Body, Get, Patch, Req, UseGuards } from '@nestjs/common';
# import { AuthGuard } from '@nestjs/passport';
# → JWTのプロテクトをかけるために、NestJSのpassportからAuthGuardをimport

# import { Request } from 'express';
# import { UserService } from './user.service';
# import { UpdateUserDto } from './dto/update-user.dto';
# import { User } from '@prisma/client';


# 今回、ユーザー関係のエンドポイントを全てJWTでプロテクトしていきたいが、NestJSでエンドポイントをプロテクトする場合、UseGuardsデコレータが使えて、この中で認証関係のガードを行うものが予め準備されているので、AuthGuardを使う。
# そして認証にもいろいろあって、今回はJWTのプロテクトをかけたいので、引数にjwtを指定している。

# @UseGuards(AuthGuard('jwt'))

# これでJWTによるプロテクションをuserの全てのエンドポイントに適応させることができる。


# ....................

# UserControllerの中でUserServiceを使用していきたいので、コンストラクタでUserServiceをDIする。

# constructor(private readonly userService: UserService) {}


# ....................

# まずはGETメソッドでユーザーのエンドポイントにアクセスした時に、ログインしているユーザーを取得するエンドポイントを足していく。

# その前にAuthGuard('jwt')をカスタマイズするためのJWT strategyというものを作成する。

# これは、@nestjs/passportのAuthGuardがJWT関係のプロテクションの機能を提供してくれているが、JWTが、例えばheaderに含まれている場合や、今回のようにCookieに含まれる場合、あとはJWTのSecret Keyが何になるかはプロジェクトによって変わったくるので、この辺をオプションを付けてカスタマイズしておく必要がある。

# これを記述するのがJWT strategyというファイルになる。


# auth/strategy/jwt.strategy.ts

# 必要なimport
# import { Injectable } from '@nestjs/common';
# import { ConfigService } from '@nestjs/config';
# import { PassportStrategy } from '@nestjs/passport';
# import { ExtractJwt, Strategy } from 'passport-jwt';
# import { PrismaService } from '../../prisma/prisma.service';


# @Injectable()
# export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {}

# PassportStrategyという抽象クラスを継承させる。

# https://github.com/nestjs/passport/blob/master/lib/passport/passport.strategy.ts

# ソースを見てみると、抽象クラスになっていて、さらに抽象メソッドとしてvalidate()が定義されている。

# なので、PassportStrategyを継承していく場合は、validateを実装する必要がある。


# ....................

# PrismaServiceとConfigServiceをコンストラクタでDIする。


# constructor(private readonly config: ConfigService, private readonly prisma: PrismaService) {
#   super({
#     jwtFromRequest: ExtractJwt.fromExtractors([
#       (req) => {
#         let jwt = null;
#         if (req && req.cookies) {
#           jwt = req.cookies['access_token'];
#         }
#         return jwt;
#       },
#     ]),

#     ignoreExpiration: false,
#     secretOrKey: config.get('JWT_SECRET'),
#   });
# }


# super()の処理を追加。
# これは継承しているPassportStrategyのコンストラクタの処理を参照することができるが、ここでオプションとして、カスタマイズしたい内容を追加していく。

# まずJWTの検証を行うにあたって、リクエストのどこにJWTが格納されているのかを予め指定しておく必要がある。
# これがjwtFromRequestというオプションになっていて、今回はCookieを使ってJWTをClientから送信するので、こちらの処理の中では、そのCookieからJWTを取り出す処理を書く。

#     jwtFromRequest: ExtractJwt.fromExtractors([
#       (req) => {
#         let jwt = null;
#         Clientからのリクエストとその中にCookieが含まれている場合
#         if (req && req.cookies) {
#           access_tokenというCookieにアクセスして、値を取り出す
#           jwt = req.cookies['access_token'];
#         }
#         それをreturnで返す
#         return jwt;
#       },
#     ]),



# 二つ目のオプションのignoreExpirationをtrueにしてしまうと、JWTの有効期限が切れていたとしてもそれを有効なJWTと判定されてしまうので、falseにしておく。
# ignoreExpiration: false,


# そして最後のオプションはsecretOrKeyということで、JWTを生成するのに使ったSecret Keyをここで指定する。
# secretOrKey: config.get('JWT_SECRET'),


# ....................

# PassportStrategyの抽象メソッドのvalidateを実装する。

# async validate(payload: { sub: number; email: string }) {
#   const user = await this.prisma.user.findUnique({
#     where: {
#       id: payload.sub,
#     },
#   });

#   delete user.hashedPassword;
#   return user;
# }


# 引数ではpayloadを受け取れるようにする。
# このpayloadはAuthServiceのところで、JWTを生成するときに使用されたものになる。

# async generateJwt(userId: number, email: string): Promise<Jwt> {
#   const payload = {
#     sub: userId,
#     email,
#   };

#   const secret = this.config.get('JWT_SECRET');

#   const token = await this.jwt.signAsync(payload, {
#     expiresIn: '5m',
#     secret: secret,
#   });

#   return {
#     accessToken: token,
#   };
# }

# JWTというのは、payloadとSecret KeyをあるアルゴリズムにかけることでJWT生成しているが、逆にJWTトークンとSecret Keyが分かれば、このpayloadを復元することができる。


# これをやっているのが、JwtStrategyで、まずClientから送られて来たJWTトークンを受け取って、JWTが正しいかどうかの検証をコンストラクタで行う。

# そして、JWTに問題がなければ、validate()が呼び出される。

# このときに受け取ったJWTとSecret Keyがあるので、この情報を元にpayloadを復元することができる。

# そして復元したpayloadをvalidate()の引数に渡しているという形になる。
# そしてpayloadのsubのところには、userIdが格納されている。
# そしてsubに入っているuserIdを使ってprisma経由でidに一致するユーザーを取得する。
# そしてhashedPasswordの属性だけを削除してから、returnでuserオブジェクトを返すという処理になる。


# ....................

# そしてNestJSのAuthGuardではひとつ便利な機能があって、validate()の返り値のuserのオブジェクト、これはJWTを解析しているので、つまりログインしているユーザーのuserオブジェクトをreturnで返してくれる。

# そしてNestJSではこのuserのオブジェクトを自動的にリクエストに含めてくれるという機能がある。

# そうすると、UserControllerの方はリクエストにアクセスできるので、そこからログインしているユーザーのオブジェクトを取り出すことができる。


# userのエンドポイントにGETメソッドでアクセスしたとき(Get: /user/)に、ログインしているユーザーのオブジェクトを取得するエンドポイントを追加する。

# user.controller.ts
# @Get()
# getLoginUser(@Req() req: Request): Omit<User, 'hashedPassword'> {
#   return req.user;
# }


# Reqデコレータでreq: Requestを作っておくと、req.userで先程のJwtStrategyのvalidate()のreturnのuserオブジェクトにアクセスすることができるので、それをそのまま返すようにする。

# 返り値のデータ型は@prisma/clientのUserのデータ型からhashedPasswordを取り除いたもの。


# ....................

# そして、Requestのデータ型はexpressの標準のものを使っているので、この標準のRequestの中には今回カスタマイズしているUserに対応したデータ型が存在しないので、これをカスタムで追加することができる。

# backend/custom.d.ts

# import { User } from '@prisma/client';

# declare module 'express-serve-static-core' {
#   interface Request {
#     user?: Omit<User, 'hashedPassword'>;
#   }
# }

# 型の処理を追加する。
# これは標準のExpressのRequestの型に対して、user?というフィールドを追加している。
# そしてそのデータ型をカスタムのUser型に置き換えている。

# ⬇️ 上手くいかない場合

# https://www.udemy.com/course/nestjs-nextjs-restapi-react/learn/lecture/34086758#learning-tools
# import { User as CustomUser } from '@prisma/client';

# declare global {
#   namespace Express {
#     export interface Request {
#       user: CustomUser;
#     }
#   }
# }


# UserControllerに戻ると、req.userの型エラーが消えている。


# ....................

# nickNameをupdateするためのエンドポイントも作成する。

# @Patch()
# updateUser(@Req() req: Request, @Body() dto: UpdateUserDto): Promise<Omit<User, 'hashedPassword'>> {
#   return this.userService.updateUser(req.user.id, dto);
# }

# userService.updateUser()の方にreq.user.idでJWTから解析したログインしているユーザーのユーザーIDを渡してあげるのと、
# dtoのところには、Clientから送られてくる新しいnickNameが入っているので、updateUser()に渡している。

# これはuser.serviceのupdateUserの二つの引数に対応している。


# ....................

# jwt.strategy.tsを開いて、@Injectable()になっているので、使用できるようにするために、auth.moduleを開いて、providersのところに追加する。

# providers: [AuthService, JwtStrategy],


# ....................

# この状態でPostmanを使って動作確認をする。

# GET: http://localhost:8000/user
# Send

# {
#     "statusCode": 401,
#     "message": "Unauthorized"
# }

# 今回はuserのエンドポイントをJWTでプロテクトしているので、認証していない場合は、Unauthorizedが返ってくる。


# ログインしていないので、

# POST: http://localhost:8000/auth/login
# Body → x-www-form-urlencoded
# email: user1@test.com
# password: user1
# Send

# {
#     "message": "ok"
# }

# Cookiesを確認すると、access_tokenが付与されているので、再度userのエンドポイントにGETでアクセスする。

# すると、ログインしているユーザーのオブジェクトを取得できる。

# {
#     "id": 1,
#     "createdAt": "2022-10-11T06:04:46.908Z",
#     "updatedAt": "2022-10-11T06:04:46.908Z",
#     "email": "user1@test.com",
#     "nickName": null
# }


# ログアウトする。
# POST: http://localhost:8000/auth/logout
# Send

# Cookiesを確認すると、access_tokenが空になっているので、
# access_token=; Path=/; HttpOnly;

# ログアウトした後に、再度userのエンドポイントにGETでアクセスすると、Unauthorizedになる。

# {
#     "statusCode": 401,
#     "message": "Unauthorized"
# }


# ....................

# 再度ログインしておく。

# 次に、ユーザーのnickNameをupadateするエンドポイントの動作確認をする。

# PATCH: http://localhost:8000/user
# Body → x-www-form-urlencoded
# nickName: test
# Send

# {
#     "id": 1,
#     "createdAt": "2022-10-11T06:04:46.908Z",
#     "updatedAt": "2022-10-11T06:22:50.330Z",
#     "email": "user1@test.com",
#     "nickName": "test"
# }

# nickNameが更新された後のuserオブジェクトが返ってくる。

# prisma studioを開いて、確認。

# ログアウトして、Cookiesでaccess_tokenが空なのを確認して、再度PATCHでuserのエンドポイントにアクセス。

# {
#     "statusCode": 401,
#     "message": "Unauthorized"
# }

# このように、有効なJWTがCookieに無い場合は、ちゃんとエンドポイントがプロテクトできた。


# **** 12. Todo Service + Controller ****

#' todoのエンドポイントをつくる。

#' todo/dto/create-task.dto.ts

# taskを新規作成するときにClientから送られてくるのは、新しいtitleとdescriptionになるので、それらをファイルに定義していく。

# import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

# export class CreateTaskDto {
#   @IsString()
#   @IsNotEmpty()
#   title: string;

#   @IsString()
#   @IsOptional()
#   description?: string;
# }

# description?は任意になるので、IsOptionalをつける。


#' todo/dto/update-task.dto.ts

# import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

# export class UpdateTaskDto {
#   @IsString()
#   @IsNotEmpty()
#   title: string;

#   @IsString()
#   @IsOptional()
#   description?: string;
# }


# --------------------

#' TodoServiceを作成する。

# 必要なimport
# import { Injectable, ForbiddenException } from '@nestjs/common';
# import { PrismaService } from '../prisma/prisma.service';
# import { CreateTaskDto } from './dto/create-task.dto';
# import { UpdateTaskDto } from './dto/update-task.dto';
# import { Task } from '@prisma/client';


# PrismaServiceをDI
# constructor(private readonly prisma: PrismaService) {}


# taskの一覧を取得するメソッドを定義。

# getTasks(userId: number): Promise<Task[]> {
#   return this.prisma.task.findMany({
#     where: {
#       userId,
#     },
#     orderBy: {
#       createdAt: 'desc',
#     },
#   });
# }

# 今回は各taskに対してどのユーザーが作成したかをuserIdのフィールドで識別できるようにしているので、
# schema.prismaのTaskモデルのuserIdフィールドを使って、ログインしているユーザー自身が使ったtaskだけをgetTasks()で全て取得するようにする。

# そのためには、userIdを使って、prisma.task.findMany()でtaskの一覧を取得するが、このときにuserIdが引数で渡されたuserIdに一致するtaskだけを全て取得する処理を書いておく。

# そして、taskを取得する際に、orderByでcreatedAt: 'desc'とすることで、大きい値が新しい値に相当するので、descを指定することで、上から下に新しい順にtaskを並べ替えた状態で一覧を取得するという指定をする。

# 返り値の型は、prismaの部分で非同期が発生するので、Promiseを足して、返り値としては、taskの一覧が返ってくるので、Task[] とする。


# ....................

# 特定のtaskを取得するためのメソッドを定義。

# async getTaskById(userId: number, taskId: number): Promise<Task> {
#   return await this.prisma.task.findFirst({
#     where: {
#       userId,
#       id: taskId,
#     },
#   });
# }

# userIdと取得したいtaskのIDを引数で受け取れるようにする。

# prisma.task.findFirst()を使って、条件式としては、ログインしたユーザーが作成したtaskの中で、引数で渡されたtaskIdに一致するtaskを1件取得する。


# ....................

# 新規でtaskを取得するメソッドを定義。

# async createTask(userId: number, dto: CreateTaskDto): Promise<Task> {
#   const task = await this.prisma.task.create({
#     data: {
#       userId,
#       ...dto,
#     },
#   });

#   return task;
# }


# 引数はuserIdと、今度はdtoを受け取れるようにする。このdtoにはClientから送られて来るtitleとdescriptionが入っている形になる。

# そして、prisma.task.createメソッドを使って、dataの属性としてuserIdとdtoの中に入っているtitle, descriptionを渡していく。

# そして、taskには新しく生成されたtaskが入ってくるので、それをreturnで返す。
# そして、返り値のデータ型はTaskになるので、Promise<Task>となる。


# ....................

# taskをupdateするためのメソッドを追加。

# async updateTaskById(userId: number, taskId: number, dto: UpdateTaskDto): Promise<Task> {
#   const task = await this.prisma.task.findUnique({
#     where: {
#       id: taskId,
#     },
#   });

#   if (!task || task.userId !== userId) {
#     throw new ForbiddenException('No permission to update');
#   }

#   return await this.prisma.task.update({
#     where: {
#       id: taskId,
#     },
#     data: {
#       ...dto,
#     },
#   });
# }


# updateやdeleteする場合は、どのtaskを更新・削除するのかを識別するために、引数のところにtaskIdを渡す必要がある。

# そして、userIdとdtoのところには、Clientから渡されて来る更新後の新しいtitleとdescriptionを受け取るようにする。

# メソッドの中には、まずは更新使用としているオブジェクトがそもそも存在するのか確認する。

# prisma.task.findUnique()を使って、条件としてはtaskIdに一致するidを持つtaskがDBに存在するかを確認する。
# そもそも更新しようとしたtaskが存在しない場合は、ForbiddenExceptionの例外を投げるようにする。

# そして今回はさらにログインしているユーザー自身が作ったtaskだけをupdate, deleteできるように制限をかけていきたいので、更新しようとしているDB内のtaskのuserIdと引数で渡されて来たログインユーザーのuserIdが一致しない場合もForbiddenExceptionの例外を投げるようにする。

# そしてtaskIdで渡されたtaskが存在するかつ、そのtaskがログインユーザー自身が作ったものであれば実際にprisma.task.update()を使ってtaskの内容を更新していく。

# ここではidで更新したいtaskのidを指定するのと、更新したいデータ自体をdtoで受け取っているのでdata属性に渡して、DBに実際にupdateをかける。


# ....................

# 最後にdeleteのメソッドを追加する。

# async deleteTaskById(userId: number, taskId: number): Promise<void> {
#   const task = await this.prisma.task.findUnique({
#     where: {
#       id: taskId,
#     },
#   });

#   if (!task || task.userId !== userId) {
#     throw new ForbiddenException('No permission to delete');
#   }

#   await this.prisma.task.delete({
#     where: {
#       id: taskId,
#     },
#   });
# }


# userIdと削除したいtaskIdを引数で受け取る。

# updateのときの同じように、まずは渡されて来たtaskがDBに存在するかどうかprisma.task.findUnique()で検索する。
# この引数に渡されたtaskIdに一致するIDをもつtaskが存在するのかを確認する。

# そしてそのtaskが存在しない場合、または存在するがそのuserIdがログインしているユーザーのuserIdと一致しない場合、その場合はForbiddenExceptionの例外を投げる。

# そして問題無い場合は、prisma.task.delete()を使ってtaskIdに対応するtaskを削除する。


# --------------------

#’ TodoControllerを実装する。


# import {
#   Controller,
#   Body,
#   Delete,
#   Get,
#   HttpCode,
#   HttpStatus,
#   Param,
#   ParseIntPipe,
#   Patch,
#   Post,
#   UseGuards,
#   Req,
# } from '@nestjs/common';
# import { AuthGuard } from '@nestjs/passport';
# import { Request } from 'express';
# import { TodoService } from './todo.service';
# import { CreateTaskDto } from './dto/create-task.dto';
# import { UpdateTaskDto } from './dto/update-task.dto';
# import { Task } from '@prisma/client';

#' todoのエンドポイントもJWTでプロテクションしたいのでAuthGuardをimport。


# まずtodoのエンドポイントをJWTでプロテクションするために、@UseGuards(AuthGuard('jwt'))を記述。

#' TodoServiceをDI。
# constructor(private readonly todoService: TodoService) {}


# ....................

# GETメソッドでアクセスがあったときに、ログインしているユーザー自身が作ったtaskを全て取得してレスポンスを返すエンドポイント作成する。

# @Get()
# async getTasks(@Req() req: Request): Promise<Task[]> {
#   return await this.todoService.getTasks(req.user.id);
# }

#' todoService.getTasks()の引数にuserIdを渡す必要があるが、これはJwtStrategyのvalidateのreturnのところに、ログインユーザーのオブジェクトが返って来て、これがNestJSによって自動的にexpressのRequestに含まれるので、このreqからuserを取り出して、さらにその中からidの属性だけを取り出して引数で渡している形になる。
# → LaravelのAuth::id()に相当


# ....................

# 特定のtaskをひとつだけ取得するためのエンドポイントを作成する。

# @Get(':id')
# async getTaskById(@Req() req: Request, @Param('id', ParseIntPipe) taskId: number): Promise<Task> {
#   return await this.todoService.getTaskById(req.user.id, taskId);
# }

# 今回はパスの末尾に指定されたパラメータを取得して、それをtaskIdとして取扱いたいので、その場合は、Paramデコレータを使うことができる。

# そしてGetデコレータの引数に':id'という形で変数化すると、/todo/1 という形でリクエストがあった場合、その末尾の1のパラメータを変数として読み取ることができる。

# そして、ParseIntPipeを使うことで取得した末尾の1というものをInt型にParseで変換してからtaskIdに格納してくれる。
# そうするとtaskIdを確実に数値としてその後の処理で使うことができる。

#' todoService.getTaskByIdを呼び出して、userIdの情報とパラメータから取得したtaskIdを渡していく。


# ....................

# createのエンドポイントを作成する。

# @Post()
# async createTask(@Req() req: Request, @Body() dto: CreateTaskDto): Promise<Task> {
#   return await this.todoService.createTask(req.user.id, dto);
# }


# ....................

# updateのエンドポイントを作成する。

# @Patch(':id')
# async updateTaskById(
#   @Req() req: Request,
#   @Param('id', ParseIntPipe) taskId: number,
#   @Body() dto: UpdateTaskDto,
# ): Promise<Task> {
#   return this.todoService.updateTask(req.user.id, taskId, dto);
# }


# ....................

# deleteのエンドポイントを作成する。

# @HttpCode(HttpStatus.NO_CONTENT)
# @Delete(':id')
# async deleteTask(@Req() req: Request, @Param('id', ParseIntPipe) taskId: number): Promise<void> {
#   return await this.todoService.deleteTaskById(req.user.id, taskId);
# }


# @HttpCode(HttpStatus.NO_CONTENT)で、deleteに成功したときのstatusをno contentにカスタマイズする。


# --------------------

# Postmanで動作確認。

# まずはログインする。

# taskを新規作成する。
# POST: http://localhost:8000/todo
# Body → x-www-form-urlencoded
# title: task1
# description: task1
# Send

# 上手くいくと、作成されたtaskが返って来る。
# {
#     "id": 1,
#     "createdAt": "2022-10-11T22:05:20.517Z",
#     "updatedAt": "2022-10-11T22:05:20.517Z",
#     "title": "task1",
#     "description": "task1",
#     "userId": 1
# }

# Prisma Studioで確認


# JWTプロテクションが効いているか確認。
# ログアウト → Create

# {
#     "statusCode": 401,
#     "message": "Unauthorized"
# }


# ログイン

# もうひとつtaskを追加する。

# {
#     "id": 2,
#     "createdAt": "2022-10-11T22:10:53.915Z",
#     "updatedAt": "2022-10-11T22:10:53.915Z",
#     "title": "task2",
#     "description": "task2",
#     "userId": 1
# }


# ....................

# 一覧を取得。

# GET: http://localhost:8000/todo

# [
#     {
#         "id": 2,
#         "createdAt": "2022-10-11T22:10:53.915Z",
#         "updatedAt": "2022-10-11T22:10:53.915Z",
#         "title": "task2",
#         "description": "task2",
#         "userId": 1
#     },
#     {
#         "id": 1,
#         "createdAt": "2022-10-11T22:05:20.517Z",
#         "updatedAt": "2022-10-11T22:05:20.517Z",
#         "title": "task1",
#         "description": "task1",
#         "userId": 1
#     }
# ]


# ログインしてから有効期限の5分が経過してしまうと、Unauthorizedが返ってくるので、その場合は再度ログインして、access_tokenを更新する。


# ....................

# ひとつのtaskを取得する。

# GET: http://localhost:8000/todo/1

# {
#     "id": 1,
#     "createdAt": "2022-10-11T22:05:20.517Z",
#     "updatedAt": "2022-10-11T22:05:20.517Z",
#     "title": "task1",
#     "description": "task1",
#     "userId": 1
# }


# ....................

# update

# PATCH: http://localhost:8000/todo/2
# Body → x-www-form-urlencoded
# title: task2+

# {
#     "id": 2,
#     "createdAt": "2022-10-11T22:10:53.915Z",
#     "updatedAt": "2022-10-11T22:20:01.167Z",
#     "title": "task2+",
#     "description": "task2",
#     "userId": 1
# }

# 一覧取得

# [
#     {
#         "id": 2,
#         "createdAt": "2022-10-11T22:10:53.915Z",
#         "updatedAt": "2022-10-11T22:20:01.167Z",
#         "title": "task2+",
#         "description": "task2",
#         "userId": 1
#     },
#     {
#         "id": 1,
#         "createdAt": "2022-10-11T22:05:20.517Z",
#         "updatedAt": "2022-10-11T22:05:20.517Z",
#         "title": "task1",
#         "description": "task1",
#         "userId": 1
#     }
# ]


# ....................

# delete

# DELETE: http://localhost:8000/todo/2

# 成功すると、204 No Content が返ってくる。

# 一覧取得

# [
#     {
#         "id": 1,
#         "createdAt": "2022-10-11T22:05:20.517Z",
#         "updatedAt": "2022-10-11T22:05:20.517Z",
#         "title": "task1",
#         "description": "task1",
#         "userId": 1
#     }
# ]


# **** 13. CSRF Token ****

# CSRFトークンの設定を行う。

# 今回はcsrufというライブラリを使っていくが、CSRFトークン、認証の処理はこのライブラリがすべて裏でやってくれるので、必要な設定だけやっていく。


# main.tsを開いて、

# CSRFの設定に入る前にPort番号のところを以下のように修正する。
# await app.listen(8000);
# ⬇️
# await app.listen(process.env.PORT || 3005);

# 本番環境にデプロイした時には、この環境変数PORTのポートを使用するようにして、こちらが無い場合は3005に認識されるようにする。


# --------------------

# CSRFの設定を追加する。

# main.ts
# app.use(
#   csurf({
#     cookie: {
#       httpOnly: true,
#       sameSite: 'none',
#       secure: false,
#     },
#     value: (req: Request) => {
#       return req.header('csrf-token');
#     },
#   }),
# );

# csurfのところで、cookieの設定を書いていく。
# このcookieは、CSRFトークンを生成するために使ったSecretがこのcookieに格納されるが、このcookieの設定をしているのが、上記の部分。

# set-cookie: Secret
# httpOnly: true

# このCSRF用のSecretキーはJavaScriptから読み込まれたくないので、httpOnlyをtrueにする。
# そして、sameSiteはnoneで、secureは今はPostmanのローカルなので一旦falseにしておく。


# そしてこのvalueのところは、ClientのリクエストのheaderのところにCsrf Tokenを付与した形でサーバーサイドに問い合わせをするが、サーバーサイド側ではこのトークンを読み込む必要があって、この処理が req.header('csrf-token') に対応している。

# header: Csrf Token

# そして、valueのところで、Clientからheaderで送られて来た、csrf-tokenを渡してあげると、csurfのライブラリの中では、cookieから受け取ったSecretをまずhashにかけて、CSRFトークンを生成する。
# その生成したものとheaderで送られて来たCsrf Tokenを一致するかの検証を自動的に行ってくれる。


# --------------------

# GET: /auth/csrfのエンドポイントにアクセスしたときに、CSRFトークンを返却するというエンドポイントが必要だが、これを追加する。

# auth.controller.ts

# @Get('/csrf')
# getCsrfToken(@Req() req: Request): Csrf {
#   return { csrfToken: req.csrfToken() };
# }

# これはCSRFトークンを生成するメソッドが準備されているので、req.csrfToken()でトークンを生成して、csrfTokenという名前をつけてJSONの形でreturnするようにする。


# --------------------

# この状態でPostmanで動作確認をする。

# ログイン

# {
#     "statusCode": 403,
#     "message": "invalid csrf token"
# }

# POSTメソッドでアクセスしているので、先ほど設定したcsrfのプロテクションが効いてブロックされている。

# この認証を突破するには、まずCSRFトークンを取得する必要がある。

# GET: http://localhost:8000/auth/csrf

# {
#     "csrfToken": "E3WQvbuy-1wiYWy1Q-zdg3rfLDNK-_amioW0"
# }

# レスポンスでCSRFトークンを取得することができる。

# このときに、Cookiesのところを選択すると、_cstfというcookieが自動的に付与されていることがわかる。

# _csrf=P1usAOWJ3tk3glOTg0alLe82; Path=/; HttpOnly;

# これがSecretのキーになっていて、これがhttpOnly: trueで以降自動的にcookieに付与される形になる。


# ................

# 取得したトークンをコピーして、Loginに移動。

# HeadersのValueのところに貼り付け。
# Keyの値はcsrf-tokenとする。

# csrf-token: E3WQvbuy-1wiYWy1Q-zdg3rfLDNK-_amioW0

# この状態でSend

# {
#     "message": "ok"
# }


# ................

# Crate Taskを行う

# こちらはPostメソッドなので、CSRFトークンのバリデーションが自動的に効く形になる。

# task3としてcreateすると、

# {
#     "statusCode": 403,
#     "message": "invalid csrf token"
# }

# こちらもPostメソッドなので、HeadersのところでCSRFトークンを渡す必要がある。

# Headers
# csrf-token: E3WQvbuy-1wiYWy1Q-zdg3rfLDNK-_amioW0

# {
#     "id": 3,
#     "createdAt": "2022-10-11T23:12:49.164Z",
#     "updatedAt": "2022-10-11T23:12:49.164Z",
#     "title": "task3",
#     "description": "task3",
#     "userId": 1
# }


# --------------------

# secureをtrueに戻す。

# main.ts
# auth.controlle.ts login, logout


# ==== セクション3: Integration of Next.js and NestJS

# https://github.com/GomaGoma676/frontend-todo-nextjs


# **** 15. create-next-app ****

# Project setup

# create nextjs project
# $ npx create-next-app frontend --ts


# .prettierrc
# {
#   "singleQuote": true,
#   "semi": true
# }


# install prisma
# $ yarn add -D prisma
# $ npx prisma init
# $ yarn add @prisma/client


# ----------------

# npx prisma initをすると自動的に.envが生成される。
# prismaのひとつの機能で、backendの方でDockerの方にschema.prismaの内容をmigrateで反映してあるが、そのDBの内容にアクセスして、そこからデータ型を生成する機能がある。
# そして、backendで使っていた、UserとTaskのデータ型は、frontendでも同じデータ型を使っていくので、今回はその手法を使って、DBの内容からTypeScriptの型を自動生成する。

# そのためには、backendのNestJSで設定した.envのDATABASE_URL、DockerのpostgresのURLをコピーして、今作成したfrontendのNext.jsの.envのDATABASE_URLのところに貼り付ける。


# ................

# introspect from existing DB

#^ backend側でnpx prisma db pushしている必要がある。
# $ npx prisma db pull

# Dockerコンテナのpostgresの中に作られているDBの構造を解釈して、prisma/schema.prismaの方にUserとTaskのデータ型を復元してくれる。

# prisma/schema.prisma
# generator client {
#   provider = "prisma-client-js"
# }

# datasource db {
#   provider = "postgresql"
#   url      = env("DATABASE_URL")
# }

# model Task {
#   id          Int      @id @default(autoincrement())
#   createdAt   DateTime @default(now())
#   updatedAt   DateTime
#   title       String
#   description String?
#   userId      Int
#   User        User     @relation(fields: [userId], references: [id], onDelete: Cascade)
# }

# model User {
#   id             Int      @id @default(autoincrement())
#   createdAt      DateTime @default(now())
#   updatedAt      DateTime
#   email          String   @unique
#   hashedPassword String
#   nickName       String?
#   Task           Task[]
# }


# frontendでも同じUserとTaskのデータ型をTypeScriptで使用したいので、以下を実行
# $ npx prisma generate

# こうすると、以降Next.jsのプロジェクトでもTypeScriptでUserとTaskのデータ型を使用することができる。


# ----------------

# setup tailwind css
# $ yarn add -D tailwindcss postcss autoprefixer
# $ yarn add -D prettier prettier-plugin-tailwindcss
# $ npx tailwindcss init -p


# Tailwind CSS Nextjs
# https://tailwindcss.com/docs/guides/nextjs

# tailwind.config.js
# /** @type {import('tailwindcss').Config} */
# module.exports = {
#   content: [
#     "./pages/**/*.{js,ts,jsx,tsx}",
#     "./components/**/*.{js,ts,jsx,tsx}",
#   ],
#   theme: {
#     extend: {},
#   },
#   plugins: [],
# }

# Mantine UIとTailwindの互換性問題の解決のために、以下を追記
# corePlugins: {
#   preflight: false,
# },


# styles/globals.css
# @import "tailwindcss/base";
# @import "tailwindcss/components";
# @import "tailwindcss/utilities";


# ----------------

# install necessary packages

# $ yarn add @tanstack/react-query@4.0.10 @tanstack/react-query-devtools@4.0.10

# $ yarn add @mantine/core@5.0.2 @mantine/hooks@5.0.2 @mantine/form@5.0.2 @mantine/next@5.0.2 @emotion/server@11.10.0 @emotion/react@11.10.0

# $ yarn add @heroicons/react@1.0.6 @tabler/icons@1.78.1 yup@0.32.11 axios@0.27.2 zustand@4.0.0


# ----------------

# Mantine UI Nextjs
# https://mantine.dev/guides/next/

# pages/_document.tsx
# import { createGetInitialProps } from '@mantine/next';
# import Document, { Head, Html, Main, NextScript } from 'next/document';

# const getInitialProps = createGetInitialProps();

# export default class _Document extends Document {
#   static getInitialProps = getInitialProps;

#   render() {
#     return (
#       <Html>
#         <Head />
#         <body>
#           <Main />
#           <NextScript />
#         </body>
#       </Html>
#     );
#   }
# }


# pages/_app.tsx

# import { MantineProvider } from '@mantine/core';

# <MantineProvider
#   withGlobalStyles
#   withNormalizeCSS
#   theme={{
#     colorScheme: 'dark',
#     fontFamily: 'Verdana, sans-serif',
#   }}
# >
#   <Component {...pageProps} />
# </MantineProvider>


# ----------------

# .env.local

# ここに、環境変数としてREST APIのURLパスを作っておく。

# NEXT_PUBLIC_API_URL=http://localhost:8000

# この環境変数を読み込ませるために、一度
# yarn run dev


# ----------------

# types/index.ts

# この中にプロジェクトで使用するデータ型を定義しておく。

# ログイン入力フォーム
# export type AuthForm = {
#   email: string;
#   password: string;
# };

# 現在編集中のtaskを管理
# export type EditedTask = {
#   id: number;
#   title: string;
#   description?: string | null;
# };


# ----------------

# components/Layout.tsx

# import { memo, FC, ReactNode } from 'react';
# import Head from 'next/head';

# type Props = {
#   title: string;
#   children: ReactNode;
# };

# export const Layout: FC<Props> = memo(({ children, title = 'Next.js' }) => {
#   return (
#     <div className="flex min-h-screen flex-col items-center justify-center">
#       <Head>
#         <title>{title}</title>
#       </Head>

#       <main className="flex w-screen flex-1 flex-col items-center justify-center">{children}</main>
#     </div>
#   );
# });


# ----------------

# react-queryの設定

# pages/_app.tsx

# import { useEffect } from 'react';

# import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
# import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

# import axios from 'axios';

# const queryClient = new QueryClient({
#   defaultOptions: {
#     queries: {
#       retry: false,
#       refetchOnWindowFocus: false,
#     },
#   },
# });

# retry: false
# → react-queryの標準の設定だと、REST APIへのfetchに失敗した場合は、自動的に3回までretryを繰り返すことになっている。それをfalseで無効化している。

# refetchOnWindowFocus: false
# → ユーザーがブラウザにフォーカスを当てた時にREST APIへのfetchが走るというもの。それをfalseで無効化している。


# ................

# withCredentialsの設定

# axios.defaults.withCredentials = true;

# → アプリケーションが起動した時にaxiosのデフォルトの設定でwithCredentialsをtrueに設定しておく。
#^ このwithCredentialsというのは、frontendサイドとserverサイドでCookieのやりとりをする場合は、このwithCredentialsをtrueにしておく必要がある。


# ................

# Csrf Tokenの設定

# useEffectを使って、このコンポーネントがマウントされた時に実行される処理を書く。

# useEffect(() => {
#   const getCsrfToken = async () => {
#     const { data } = await axios.get(`${process.env.NEXT_PUBLIC_API_URL}/auth/csrf`);
#     axios.defaults.headers.common['csrf-token'] = data.csrfToken;
#   };

#   getCsrfToken();
# }, []);


# 今回はアプリケーションがロードされた時にREST APIの'auth/csrf-token'のエンドポイントにアクセスして、Csrf Tokenを取得したいので、そのための関数をuseEffect内に記述し、実行する。

# axios.get()で取得したdataの中から、csrfTokenを取り出して、axiosのデフォルト設定でheadersに'csrf-token'という名前を付けてCsrf Tokenを設定するようにしている。
# こうすると、これ以降Next.jsからREST APIからリクエストを送る時は全てwithCredentialsがtrueで、csrf-tokenがheadersに自動的に付与されていく形になる。


# ----------------

# プロジェクト全体でreact-queryを使用できるようにする。

# return (
#   <QueryClientProvider client={queryClient}>
#     <MantineProvider
#       withGlobalStyles
#       withNormalizeCSS
#       theme={{
#         colorScheme: 'dark',
#         fontFamily: 'Verdana, sans-serif',
#       }}
#     >
#       <Component {...pageProps} />
#     </MantineProvider>
#     <ReactQueryDevtools />
#   </QueryClientProvider>
# );


# **** 16. Authentication page ****

# 認証のページを作成する。

# pages/index.tsx

# import type { NextPage } from "next";
# import { useCallback, useState } from "react";
# import { useRouter } from "next/router";
# import axios from "axios";
# import * as Yup from "yup";
# import { IconDatabase } from "@tabler/icons";
# import { ShieldCheckIcon } from "@heroicons/react/solid";
# import { ExclamationCircleIcon } from "@heroicons/react/outline";
# import { Alert, Anchor, Button, Group, PasswordInput, TextInput } from "@mantine/core";
# import { useForm, yupResolver } from "@mantine/form";
# import { AuthForm } from "../types";
# import { Layout } from "../components/Layout";

# //* schema
# const schema = Yup.object().shape({
#   email: Yup.string().email("Invalid email").required("No email provided"),
#   password: Yup.string().required("No password provided").min(5, "Password should be min 5 chars"),
# });

# const Home: NextPage = () => {
#   //* router
#   const router = useRouter();

#   //* local state
#   // ログインモードとサインアップモードの切り替え
#   const [isRegister, setIsRegister] = useState(false);
#   const [error, setError] = useState("");

#   //* form
#   const form = useForm<AuthForm>({
#     validate: yupResolver(schema),
#     initialValues: {
#       email: "",
#       password: "",
#     },
#   });

#   //* event
#   // submitが押された時のloginまたはregisterのapiとの通信処理
#   const handleSubmit = useCallback(async () => {
#     try {
#       /**
#        * registerモードの場合は、POST: /auth/signupのエンドポイントに、ユーザーが入力したemailとpasswordを渡す。
#        *
#        * MantineのuseFormではform.values.<呼び出したい属性>でフォームからユーザーが入力した値を取り出せる。
#        *
#        * そして、このデータがDTOとしてNestJSで作ったREST APIに渡される。
#        */
#       if (isRegister) {
#         await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/signup`, {
#           email: form.values.email,
#           password: form.values.password,
#         });
#       }

#       /**
#        * ログインの場合は、POST: /auth/loginのエンドポイントにemailとpasswordを渡す。
#        *
#        * こう書くことで、registerに成功した場合は、そのままログインの処理を続けて行うようになる。
#        */
#       await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/login`, {
#         email: form.values.email,
#         password: form.values.password,
#       });

#       /**
#        * loginまたはregisterに成功した場合は、入力フォームを初期化する
#        */
#       form.reset();

#       /**
#        * ダッシュボードにリダイレクト
#        */
#       router.push("/dashboard");
#     } catch (e: any) {
#       setError(e.response.data.message);
#     }
#   }, [axios, form, isRegister, setError]);

#   return (
#     <Layout title="Auth">
#       <ShieldCheckIcon className="h-16 w-16 text-blue-500" />

#       {error && (
#         <Alert
#           my="md"
#           variant="filled"
#           icon={<ExclamationCircleIcon />}
#           title="Authorization Error"
#           color="red"
#           radius="md"
#         >
#           {error}
#         </Alert>
#       )}

#       {/*
#       本来だとsubmitボタンが押されたときはhandleSubmitの関数側でpreventDefaultを実行してreloadが走らないようにしておく必要があるが、
#       MantineのuseFormでは、form.onSubmit()でラップしてあげることで、preventDefaultの処理を自分で書く必要が無くなる。
#       */}
#       <form onSubmit={form.onSubmit(handleSubmit)} className="w-[25rem]">
#         {/*
#         通常のReact Hooksの入力フォームだと、valueとonChangeというフィールドを作って、そこにstateと更新関数を別々に書く必要があるが、
#         Mantineで提供されるuseFormを使うと、{...form.getInputProps('email')} この一行を書くだけでその両方の処理を裏側で全てやってくれる。
#       */}
#         <TextInput mt="md" id="email" label="Email*" placeholder="example@gmail.com" {...form.getInputProps("email")} />

#         <PasswordInput
#           mt="md"
#           id="password"
#           placeholder="password"
#           label="Password*"
#           description="Must be min 5 chars"
#           {...form.getInputProps("password")}
#         />

#         {/*
#         Groupで横並びの関係にする。
#         position="apart"で引き離してくれる。
#         */}
#         <Group mt="xl" position="apart">
#           {/*
#           今回はクリックできるようにしたいので、componentとtypeのところにbuttonを指定。
#           クリックされた時の処理をonClickで指定。
#           */}
#           <Anchor
#             component="button"
#             type="button"
#             size="xs"
#             className="text-gray-300"
#             onClick={() => {
#               setIsRegister(!isRegister);
#               setError("");
#             }}
#           >
#             {isRegister ? "Have an account? Login" : "Don't have an account? Register"}
#           </Anchor>

#           <Button leftIcon={<IconDatabase size={14} />} color="cyan" type="submit">
#             {isRegister ? "Register" : "Login"}
#           </Button>
#         </Group>
#       </form>
#     </Layout>
#   );
# };

# export default Home;

# // デフォルトだとなぜか入力フォームの幅がおかしい。
# // Anchorに挿入する文字列の長さでフォームの幅が変わる。


# ----------------

# pages/dashboard.tsx

# import { LogoutIcon } from "@heroicons/react/solid";
# import axios from "axios";
# import { NextPage } from "next";
# import { useRouter } from "next/router";
# import { useCallback } from "react";
# import { Layout } from "../components/Layout";

# const Dashboard: NextPage = () => {
#   //* router
#   const router = useRouter();

#   //* event
#   // logout
#   const logout = useCallback(async () => {
#     await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/logout`);
#     router.push("/");
#   }, [axios]);

#   return (
#     <Layout title="Task Board">
#       <LogoutIcon className="mb-6 h-6 w-6 cursor-pointer text-blue-500" onClick={logout} />
#     </Layout>
#   );
# };

# export default Dashboard;


# ----------------

# 動作確認

# 検証 → Application → Cookies → localhost:3000 → _csrfを確認

# _app.tsxで実装した通り、HttpOnlyがtrueで設定されている。

# Name: _csrf
# Value: g07ot8PSOP4l7MR-MA5UIgBk
# Domain: localhost
# Path: /
# Expires/Max-Age: Session
# Size: 29
# HttpOnly: ✓
# Secure: ✓
# SameSite: None
# Priority: Medium


  # useEffect(() => {
  #   const getCsrfToken = async () => {
  #     const { data } = await axios.get(`${process.env.NEXT_PUBLIC_API_URL}/auth/csrf`);
  #     axios.defaults.headers.common['csrf-token'] = data.csrfToken;
  #   };

  #   getCsrfToken();
  # }, []);

# これが実行された時に、サーバーサイドからfrontendのブラウザに自動的に付与される。


# ................

# Networkする。

# main.ts
# auth.controlle.ts login, logout
# のsecureをfalseにする。

# NestJSでuser1というユーザーをすでに作成しているので、そのuser1でちゃんとログインできるか確認する。

# user1@test.com
# user1

# 上手くいけば、Network → Fecth/XHR → login → Headers → Status Code: 200 ok が返って来て、dashboardのページに遷移する。

# Application → Cookies → localhost:3000

# 今ログインしたので、サーバーサイドでset-cookieが働いて、access_tokenがブラウザの方にHttpOnly true, Secure true, SameSite Noneでちゃんと設定されている。

# Name: access_token
# Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoidXNlcjFAdGVzdC5jb20iLCJpYXQiOjE2NjU5MDQyODYsImV4cCI6MTY2NTkwNDU4Nn0.e0PxyNBPWsZhtRqOYStnzOqqDsP1cMvrW-PEOK518fI
# Domain: localhost
# Path: /
# Expires/Max-Age: Session
# Size: 184
# HttpOnly: ✓
# Secure: ✓
# SameSite: None
# Priority: Medium


# ................

# ログアウトボタンをクリック。

# 自動的にindexのページに遷移するのと、access_tokenの値がちゃんと空にリセットされている。

# Name: access_token
# Value:
# Domain: localhost
# Path: /
# Expires/Max-Age: Session
# Size: 12
# HttpOnly: ✓
# Secure: ✓
# SameSite: None
# Priority: Medium

# Network → Fetch/XHR → logout → Headers → Status Code: 200 OK


# ................

# Registerモードを確認する。

# user2@test.com
# user2

# Network → Fetch/XHRを開いてクリック

# まず、signupが成功していて、Status Code: 201 Created。
# そして、成功しているので続けてloginが実行され、自動的にdashboardに遷移する。


# Application → Cookies を確認すると、access_tokenのところに新しいユーザーへのaccess_tokenがちゃんとcookieに付与されているのが分かる。

# Name: access_token
# Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjIsImVtYWlsIjoidXNlcjJAdGVzdC5jb20iLCJpYXQiOjE2NjU5MDcwMjUsImV4cCI6MTY2NTkwNzMyNX0.oj4CyVkGEyH9pVZfrGIEoQ53pY4_p_9j3zHw6lMKHzA
# Domain: localhost
# Path: /
# Expires/Max-Age: Session
# Size: 184
# HttpOnly: ✓
# Secure: ✓
# SameSite: None
# Priority: Medium


# ログアウト。


# **** 17. useQuery ****

# ログインに成功した時に、ログインユーザーの情報を取得するエンドポイントにアクセスして、取得した情報からログインユーザーのemailをdashboardに表示するところを作っていく。

# react-queryのuseQueryを使う。

# hooks/useQueryUser.ts

# import { User } from "@prisma/client";
# import { useQuery } from "@tanstack/react-query";
# import axios from "axios";
# import { useRouter } from "next/router";
# import { useCallback } from "react";

# export const useQueryUser = () => {
#   //* router
#   const router = useRouter();

#   //* func
#   const getUser = useCallback(async () => {
#     const { data } = await axios.get<Omit<User, "hashedPassword">>(`${process.env.NEXT_PUBLIC_API_URL}/user`);

#     return data;
#   }, [axios]);

#   /**
#    * useQueryの返り値の型もgetUserと同じにする。
#    * react-queryはREST APIから取得したuserのオブジェクトをブラウザの方にキャッシュしてくれる機能があって、その時に対応するキャッシュがどこに格納されているのかを識別するためにキーをqueryKeyのところで設定する。
#    */
#   return useQuery<Omit<User, "hashedPassword">, Error>({
#     queryKey: ["user"],
#     queryFn: getUser,
#     onError: (err: any) => {
#       /**
#        * 401 Unauthorized, 403 invalid csrf tokenのどちらかが発生した場合、ログインページに遷移させる。
#        */
#       if (err.response.status === 401 || err.response.status === 403) {
#         router.push("/");
#       }
#     },
#   });
# };


# -----------------

# ユーザー情報を表示するためのコンポーネントを作成する。

# components/UserInfo.tsx

# import { Loader } from "@mantine/core";
# import { FC, memo } from "react";
# import { useQueryUser } from "../hooks/useQueryUser";

# export const UserInfo: FC = memo(() => {
#   //* hooks
#   const { data: user, status } = useQueryUser();

#   //* loading
#   if (status === "loading") {
#     return <Loader />;
#   }

#   return <p>{user?.email}</p>;
# });


# -----------------

# dashboard.tsxにUserInfo.tsxを追加する


# .................

# REST APIから取得したログインしているユーザーの情報はブラウザの方にキャッシュされるので、この情報をログアウトする時に削除する必要がある。

# そのために、react-queryの機能を使う。


# import { LogoutIcon } from "@heroicons/react/solid";
# import { useQueryClient } from "@tanstack/react-query";
# import axios from "axios";
# import { NextPage } from "next";
# import { useRouter } from "next/router";
# import { useCallback } from "react";
# import { Layout } from "../components/Layout";
# import { UserInfo } from "../components/UserInfo";

# const Dashboard: NextPage = () => {
#   //* router
#   const router = useRouter();

#   //* query client
#   // REST APIから取得したログインしているユーザーの情報はブラウザの方にキャッシュされるので、この情報をログアウトする時に削除する必要がある。
#   const queryClient = useQueryClient();

#   //* event
#   // logout
#   const logout = useCallback(async () => {
#     // キャッシュの削除
#     queryClient.removeQueries(["user"]);
#     await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/logout`);
#     router.push("/");
#   }, [axios]);

#   return (
#     <Layout title="Task Board">
#       <LogoutIcon className="mb-6 h-6 w-6 cursor-pointer text-blue-500" onClick={logout} />

#       <UserInfo />
#     </Layout>
#   );
# };

# export default Dashboard;


# ----------------

# 動作確認をする。

# yarn run dev

# login
# user1@test.com
# user1

# そうすると、ログインユーザーのemailが表示される。


# React Query DevTools → ["user"] → Data

# id: 1
# createdAt: "2022-10-16T06:49:56.040Z"
# updatedAt: "2022-10-16T06:49:56.040Z"
# email: "user1@test.com"
# nickName: null

# ブラウザにキャッシュされているログインユーザーのオブジェクトを見ることができる。


# Network → Fetch/XHR → user → Headers → Request Headers

# Cookie: pma_lang=ja; _csrf=g07ot8PSOP4l7MR-MA5UIgBk; access_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImVtYWlsIjoidXNlcjFAdGVzdC5jb20iLCJpYXQiOjE2NjU5MTUwMzgsImV4cCI6MTY2NTkxNTMzOH0.eTwVgg_PrnifmbXLp5xclqi3zv5qV9d1vun94yPYMjE
# csrf-token: wNWLzmrq-t6lox0BpoxfNWx4luyEcBQb6g-Y

# cookieに_csrfとaccess_tokenが含まれている。

# _csrfという属性は、Csrf Tokenを生成する時に使用されたSecretの値が格納されて、RequestにHeaderに自動付与されている状態。

# accsess_tokenの方は、loginした時に設定されたJWTのトークンに対応している。

# csrf-tokenというheaderが自動付与されて、ここにはCsrf Token自体が自動付与されている状態になる。
# これはNext.jsの_app.tsxで設定したuseEffectの中身で、アプリが最初にloadingだれた時に、csrfのエンドポイントからCsrf Tokenを取得してaxiosのheaderのところにデフォルト設定として、csrf-tokenという名前で取得したCsrf Tokenを格納しているので、
# これが自動的にheaderに最初のマウント時に含まれている形になる。

  # useEffect(() => {
  #   const getCsrfToken = async () => {
  #     const { data } = await axios.get(`${process.env.NEXT_PUBLIC_API_URL}/auth/csrf`);
  #     axios.defaults.headers.common['csrf-token'] = data.csrfToken;
  #   };

  #   getCsrfToken();
  # }, []);


# ...................

#^ Postmanで実行した時は、Secureをtrueにするとlocalhostでは上手く起動しないと言ったが、このChromeやFirefoxといったブラウザ経由でSecure trueで動作確認するときは問題無くCookieの送受信を行うことができる。

#^ これはブラウザの仕様になっていて、Firefoxについては、localhostで利用する場合はSecure属性の制限が無視されることが記述されている。
#^ これはChromeの最新版も同じ仕様になっているので、PostmanではSecure falseにしないと上手くCookieの送受信ができなかったが、このようにNext.jsを使ってChromeやFirefoxを使って動作確認する時は、問題無くSecureをtrueにしたままでもCookieの送受信を行うことができる。

# Set-Cookie
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie

# For Firefox, the https: requirements are ignored when the Secure attribute is set by localhost (since Firefox 75).


# ....................

# user2でログインし、ログアウトして動作確認。


# --------------------

# task管理の機能を作成する前に、zustandのstoreを作成する(編集中のtaskの内容をglobal stateで管理するため)。

# store/index.ts

# import createStore from "zustand";
# import { EditedTask } from "../types";

# //* state type
# /**
#  * zustandのstateの中で定義するstateの型と関数の型を定義。
#  *
#  * まずzustandのstateの中ではeditedTaskというstateを作っていくが、そのデータ型はEditedTaskのデータ型にする。
#  *
#  * そして、zustandの関数としてこのeditedTaskのstateを更新するための関数として、updateEditedTaskという関数を作っておく。そしてこの関数のデータ型はpayloadで更新したいtaskの内容を受け取って、返り値はvoidにしておく。
#  * そして、もうひとつresetEditedTaskという、このstateをリセットするための関数を作っておく。こちらは引数は無しで返り値もvoidにしておく。
#  */
# type State = {
#   editedTask: EditedTask;
#   updateEditedTask: (payload: EditedTask) => void;
#   resetEditedTask: () => void;
# };

# //* store
# /**
#  * zustandのstoreをcreateStoreを使って作成する。
#  *
#  * まずstoreの中にstateを定義して、ここではeditedTaskというstateを作っている。
#  * そしてstateの初期値を設定する。
#  *
#  * 次にupdateEditedTaskの具体的な処理をここで書く。
#  * ここでは受け取ったpayloadをzustandの中のeditedTaskのstateの中にsetするという処理になる。
#  *
#  * そして、resetEditedTaskの内容としてはzustandのstateのeditedTaskを初期化するという処理を追加している。
#  */
# const useStore = createStore<State>((set) => ({
#   editedTask: {
#     id: 0,
#     title: "",
#     description: "",
#   },
#   updateEditedTask: (payload) =>
#     set({
#       editedTask: {
#         id: payload.id,
#         title: payload.title,
#         description: payload.description,
#       },
#     }),
#   resetEditedTask: () =>
#     set({
#       editedTask: {
#         id: 0,
#         title: "",
#         description: "",
#       },
#     }),
# }));

# export default useStore;


# **** 18. useMutation ****

# hooks/useQueryTasks.ts

# import { Task } from "@prisma/client";
# import { useQuery } from "@tanstack/react-query";
# import axios from "axios";
# import { useRouter } from "next/router";
# import { useCallback } from "react";

# const useQueryTasks = () => {
#   //* router
#   const router = useRouter();

#   //* func
#   const getTasks = useCallback(async () => {
#     const { data } = await axios.get<Task[]>(`${process.env.NEXT_PUBLIC_API_URL}/todo`);

#     return data;
#   }, [axios]);

#   return useQuery<Task[], Error>({
#     queryKey: ["tasks"],
#     queryFn: getTasks,
#     onError: (err: any) => {
#       if (err.response.status === 401 || err.response.status === 403) {
#         router.push("/");
#       }
#     },
#   });
# };

# export default useQueryTasks;


# ---------------------

# hooks/useMutateTask.ts

# import { Task } from "@prisma/client";
# import { useMutation, useQueryClient } from "@tanstack/react-query";
# import axios from "axios";
# import { useRouter } from "next/router";
# import useStore from "../store";
# import { EditedTask } from "../types";

# const useMutateTask = () => {
#   //* query client
#   const queryClient = useQueryClient();

#   //* router
#   const router = useRouter();

#   //* store
#   const reset = useStore((state) => state.resetEditedTask);

#   //* mutation
#   /**
#    * 新規作成する場合はidは自動的にバックエンドで連番が振られるので、Clientから渡す時はidを取り除いた形でデータを渡す。
#    */
#   const createTaskMutation = useMutation(
#     async (task: Omit<EditedTask, "id">) => {
#       const res = await axios.post<Task>(`${process.env.NEXT_PUBLIC_API_URL}/todo`, task);

#       return res.data;
#     },
#     {
#       /**
#        * 成功した場合、useQueryTasksが実行される時に、既存のtaskの一覧がtasksというキーを付けてキャッシュに格納されているが、
#        * 新規にtaskを作成した時は、その既存のキャッシュにこの作成したtaskを加えてあげて、キャッシュを全て更新するという処理をonSuccessの中で行う。
#        *
#        * そのためには、既存のキャッシュの内容を取得する必要があるので、queryClient.getQueryData()を使ってtasksのキーに紐づいているtaskの一覧の内容をキャッシュから取得する。
#        *
#        * queryClient.setQueryData()を使ってキャッシュの内容を更新する。
#        * このとき、既存の配列の先頭に新しく作成したtaskを追加して、tasksのキーに紐づいているキャッシュ全体を新しい配列で更新する。
#        * そして、この処理が終わった後にzustandのeditedTaskのstateをリセットするために、reset()を呼ぶ。
#        */
#       onSuccess: (res) => {
#         const previousTodos = queryClient.getQueryData<Task[]>(["tasks"]);

#         if (previousTodos) {
#           queryClient.setQueryData(["tasks"], [res, ...previousTodos]);
#         }

#         reset();
#       },
#       /**
#        * 失敗した場合、reset()でzustandのstateをリセットして、401, 403の場合はindexのページにリダイレクトさせる。
#        */
#       onError: (err: any) => {
#         reset();
#         if (err.response.status === 401 || err.response.status === 403) {
#           router.push("/");
#         }
#       },
#     }
#   );

#   const updateTaskMutation = useMutation(
#     async (task: EditedTask) => {
#       const res = await axios.patch<Task>(`${process.env.NEXT_PUBLIC_API_URL}/todo/${task.id}`, {
#         task,
#       });

#       return res.data;
#     },
#     {
#       onSuccess: (res) => {
#         const previousTodos = queryClient.getQueryData<Task[]>(["tasks"]);

#         if (previousTodos) {
#           queryClient.setQueryData(
#             ["tasks"],
#             previousTodos.map((task) => (task.id === res.id ? res : task))
#           );
#         }

#         reset();
#       },
#       onError: (err: any) => {
#         reset();

#         if (err.response.status === 401 || err.response.status === 403) {
#           router.push("/");
#         }
#       },
#     }
#   );

#   const deleteTaskMutation = useMutation(
#     async (id: number) => {
#       await axios.delete(`${process.env.NEXT_PUBLIC_API_URL}/todo/${id}`);
#     },
#     {
#       onSuccess: (_, variables) => {
#         const previousTodos = queryClient.getQueryData<Task[]>(["tasks"]);

#         if (previousTodos) {
#           queryClient.setQueryData(
#             ["tasks"],
#             /**
#              * このvariablesはid: numberに対応していて、ここには削除したtaskのidが入っている。
#              *
#              * 一個一個filterで比較していく時に、既存のtaskのidが削除したtaskのidに一致しないものだけを取り出して配列を作り直す。
#              */
#             previousTodos.filter((task) => task.id !== variables)
#           );
#         }

#         reset();
#       },
#       onError: (err: any) => {
#         reset();
#         if (err.response.status === 401 || err.response.status === 403) {
#           router.push("/");
#         }
#       },
#     }
#   );

#   return { createTaskMutation, updateTaskMutation, deleteTaskMutation };
# };

# export default useMutateTask;


# **** 19. Todo functionality ****

# components/TaskForm.tsx

# import { Button, Center, TextInput } from "@mantine/core";
# import { IconDatabase } from "@tabler/icons";
# import { FC, FormEvent, memo, useCallback } from "react";
# import useMutateTask from "../hooks/useMutateTask";
# import useStore from "../store";

# export const TaskForm: FC = memo(() => {
#   //* store
#   const { editedTask } = useStore();
#   const update = useStore((state) => state.updateEditedTask);

#   //* hooks
#   const { createTaskMutation, updateTaskMutation } = useMutateTask();

#   //* event
#   /**
#    * useForm()を使わない
#    */
#   const handleSubmit = useCallback(
#     async (e: FormEvent<HTMLFormElement>) => {
#       e.preventDefault();

#       /**
#        * editedTaskのidの初期値は0なので、編集モードではないときは、createと判断するようにして、createTaskMutationを実行する。
#        */
#       if (editedTask.id === 0) {
#         createTaskMutation.mutate({
#           title: editedTask.title,
#           description: editedTask.description,
#         });
#       } else {
#         updateTaskMutation.mutate({
#           id: editedTask.id,
#           title: editedTask.title,
#           description: editedTask.description,
#         });
#       }
#     },
#     [editedTask, createTaskMutation, updateTaskMutation]
#   );

#   return (
#     <>
#       <form onSubmit={handleSubmit}>
#         {/**
#          * valueの値がnullになると、warningになってしまうので、editedTask.titleが存在する場合はそのままvalueに割り当てるが、存在しない場合は、右側の空の文字列を代入する。
#          *
#          * update()を使ってtitleを上書き。
#          */}
#         <TextInput
#           mt="md"
#           placeholder="title"
#           value={editedTask.title || ""}
#           onChange={(e) => update({ ...editedTask, title: e.target.value })}
#         />

#         <TextInput
#           mt="md"
#           placeholder="description"
#           value={editedTask.description || ""}
#           onChange={(e) => update({ ...editedTask, description: e.target.value })}
#         />

#         <Center mt="lg">
#           <Button disabled={editedTask.title === ""} leftIcon={<IconDatabase size={14} />} color="cyan" type="submit">
#             {editedTask.id === 0 ? "Create" : "Update"}
#           </Button>
#         </Center>
#       </form>
#     </>
#   );
# });


# --------------------

# components/TaskItem.tsx

# import { PencilAltIcon, TrashIcon } from "@heroicons/react/solid";
# import { List } from "@mantine/core";
# import { Task } from "@prisma/client";
# import { memo, FC } from "react";
# import useMutateTask from "../hooks/useMutateTask";
# import useStore from "../store";

# //* props type
# type Props = Omit<Task, "createdAt" | "updatedAt" | "userId">;

# export const TaskItem: FC<Props> = memo(({ id, title, description }) => {
#   //* store
#   // global stateの更新
#   const update = useStore((state) => state.updateEditedTask);

#   //* hooks
#   // cacheの削除
#   const { deleteTaskMutation } = useMutateTask();

#   return (
#     <List.Item>
#       {/**
#        * divタグの中身を横並びにする
#        */}
#       <div className="float-left mr-10">
#         <PencilAltIcon
#           className="mx-1 h-5 w-5 cursor-pointer text-blue-500"
#           onClick={() => {
#             // global stateを更新
#             update({
#               id,
#               title,
#               description,
#             });
#           }}
#         />

#         <TrashIcon
#           className="h-5 w-5 cursor-pointer text-blue-500"
#           onClick={() => {
#             // cacheを削除
#             deleteTaskMutation.mutate(id);
#           }}
#         />
#       </div>

#       <span>{title}</span>
#     </List.Item>
#   );
# });


# --------------------

# components/TaskList.tsx

# import { List, Loader, ThemeIcon } from "@mantine/core";
# import { IconCircleDashed } from "@tabler/icons";
# import { FC, memo } from "react";
# import useQueryTasks from "../hooks/useQueryTasks";
# import { TaskItem } from "./TaskItem";
# export const TaskList: FC = memo(() => {
#   //* hooks
#   /**
#    * REST APIからログインユーザーのtaskの一覧を取得。
#    * dataのところにログインユーザーが作ったtaskの一覧がこのdataのところに入ってくる。
#    */
#   const { data: tasks, status } = useQueryTasks();

#   //* loading
#   if (status === "loading") {
#     <Loader my="lg" color="cyan" />;
#   }

#   return (
#     <List
#       my="lg"
#       spacing="sm"
#       size="sm"
#       icon={
#         <ThemeIcon color="cyan" size={24} radius="xl">
#           <IconCircleDashed size={16} />
#         </ThemeIcon>
#       }
#     >
#       {tasks?.map((task) => (
#         <TaskItem key={task.id} id={task.id} title={task.title} description={task.description} />
#       ))}
#     </List>
#   );
# });


# --------------------

# 作成したコンポーネントをdashboard.tsxに追加

# import { LogoutIcon } from "@heroicons/react/solid";
# import { useQueryClient } from "@tanstack/react-query";
# import axios from "axios";
# import { NextPage } from "next";
# import { useRouter } from "next/router";
# import { useCallback } from "react";
# import { Layout } from "../components/Layout";
# import { TaskForm } from "../components/TaskForm";
# import { TaskList } from "../components/TaskList";
# import { UserInfo } from "../components/UserInfo";

# const Dashboard: NextPage = () => {
#   //* router
#   const router = useRouter();

#   //* query client
#   // REST APIから取得したログインしているユーザーの情報はブラウザの方にキャッシュされるので、この情報をログアウトする時に削除する必要がある。
#   const queryClient = useQueryClient();

#   //* event
#   // logout
#   const logout = useCallback(async () => {
#     // キャッシュの削除
#     queryClient.removeQueries(["user"]);
#     queryClient.removeQueries(["tasks"]);
#     await axios.post(`${process.env.NEXT_PUBLIC_API_URL}/auth/logout`);
#     router.push("/");
#   }, [axios]);

#   return (
#     <Layout title="Task Board">
#       <LogoutIcon className="mb-6 h-6 w-6 cursor-pointer text-blue-500" onClick={logout} />

#       <UserInfo />
#       <TaskForm />
#       <TaskList />
#     </Layout>
#   );
# };

# export default Dashboard;


# --------------------

# 動作確認

# 検証 → Network

# user1でlogin

# taskの作成

#' todo → Status Code: 201 Created

# React Query DevTools → ['tasks'] → Data

# taskの編集

# taskの削除

# logout

# user2でlogin

#^ JWTの有効期限を5分に設定しているので、loginしてから5分が経過すると、JWTが無効になってしまう。

# 例えば、5分経過した後にtaskを更新しようとすると、401エラーが返って来て、ログインページにリダイレクトされる。


# **** 20. Deploy NestJS to Render ****

# 2022/11月以降Herokuの無償プランが廃止になるため、2022/11月以降無償で進めたい場合は次のレクチャー20動画の0:00〜7:05の代わりに下記のRenderへのDeploy手順で進めてください。Renderで進める場合は、レクチャー20 0:00〜7:05の内容はスキップしてください。


# 1. NestJSのProjectをGitHubにPush (Lecture 20の 0:35〜1:33)

# 2.  render.comでGitHub認証で新規登録

# Render
# https://render.com/


# 3. renderのdashboardからPostgreSQL新規作成

# 4. 好きなDB名、Regionを選択してCreate
# 生成されるまで少し時間が掛かります.

# 5. 作成したDBのConnectionsのセクションからExternal Database URLの値をコピー

# 6. VS Codeの .envのDATABASE_URLにコピーした値を設定
# DockerのDATABASE_URLはコメントアウト

# 7. DashboardからNew Web Serviceをクリック

# 8. DeployしたいRepositoryをConnect


# 9.  好きなService名、Regionの選択及び、下記のBuild + Start Commandを入力

# Build Command yarn && yarn run build

# Start Command yarn run start:prod


# 10. Advancedで環境変数の追加

# JWT_SECRETは右端のgenerateボタンをクリックすると値が自動生成されます。

# DATABASE_URLは、前回コピーしたExternal Database URLの値


# **** 21. Deploy Nextjs to Vercel ****

# g sw -c local
# g sw -c product


# --------------------

# backend: render

# ⑴ db(PostgreSQL)の作成

# ⑵ 作成したDBのURLを.envにコピペ
# backend/.env
# DATABASE_URL="postgres://database_sirs_user:J3h0NLQdrurPJKBidSkZnggUJNsBv26y@dpg-cda1g3qrrk09hios2hu0-a.singapore-postgres.render.com/database_sirs"

# ⑶ webサービス作成

# ⑷ webサービスに環境変数の追加

# DATABASE_URL = dbのURL
# JWT_SECRET = generateでランダムな値を生成

# ⑸ webサービスのデプロイ

# ⑹ VS CodeのTerminalでprisma migrateを実行し、Model構造をRenderのPostgresに反映させる。

# npx prisma migrate deploy


# --------------------

# frontend: vercel

# ⑴ プロジェクトの作成

# ⑵ 環境変数の追加
# NEXT_PUBLIC_API_URL = backendのサービスのURL

# ⑶ デプロイ


# --------------------

# frontendのサービスのドメインをbackendのcorsに追加

# backend/src/main.ts

# app.enableCors({
#   credentials: true,
#   origin: ['http://localhost:3000', 'https://restapi-todo-nestjs.vercel.app'],
# });
