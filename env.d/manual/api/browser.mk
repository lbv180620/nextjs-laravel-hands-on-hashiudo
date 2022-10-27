# 429 Too Many Requests
# https://developer.mozilla.org/ja/docs/Web/HTTP/Status/429


# ==== CORSにおけるブラウザの仕様 ====

#^ Chromeではデフォルトでlaxがdefaultとなっている。

# ................

#^ SameSiteをnoneにした場合は、Cross domain間、フロントエンドとバックエンドで自由にCookieの送受信を行うことができる。
#^ なので、フロントエンドとバックエンドでドメインが異なるSPAでが、SameSiteをnoneにしてあげて、Cookieの送受信を自由に行えるようにする必要がある。
#^ そして、SameSiteをnoneに設定した場合は、Google Chromeの制約でSecure属性をtrueに設定する必要がある。
#^ Secure属性をtrueにした場合は、通信をhttpsに変更する必要がある。

# ................

#^ secureをtrueにした場合、通信をhttps化する必要があって、このためにはNestJSのプロジェクトをデプロイしてhttpsに変える必要があるが、今はローカルなので、secureはfalseにしておく。


# ................

#^ このwithCredentialsというのは、frontendサイドとserverサイドでCookieのやりとりをする場合は、このwithCredentialsをtrueにしておく必要がある。


# ................

#^ Postmanで実行した時は、Secureをtrueにするとlocalhostでは上手く起動しないと言ったが、このChromeやFirefoxといったブラウザ経由でSecure trueで動作確認するときは問題無くCookieの送受信を行うことができる。

#^ これはブラウザの仕様になっていて、Firefoxについては、localhostで利用する場合はSecure属性の制限が無視されることが記述されている。
#^ これはChromeの最新版も同じ仕様になっているので、PostmanではSecure falseにしないと上手くCookieの送受信ができなかったが、このようにNext.jsを使ってChromeやFirefoxを使って動作確認する時は、問題無くSecureをtrueにしたままでもCookieの送受信を行うことができる。

# Set-Cookie
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie

# For Firefox, the https: requirements are ignored when the Secure attribute is set by localhost (since Firefox 75).


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

