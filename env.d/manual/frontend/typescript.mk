#! no-non-null-assertion

#【TypeScript】「as」、「any」、「?」、「!」について
# http://www.code-magagine.com/?p=13492

# "!"
# NULLじゃないと言い切る文法。NonNullAssertionOperatorというTypeScript2.0から登場した機能でどんな型にも使える。

# const test = function(); // functionはstring | undefinedを返す関数。
# test!
# 変数の後につけると「string | undefined」とかの場合はstringとかにキャストしてくれる。

# ただ、使用するとeslintで下記のエラーが出る。

# warning  Forbidden non-null assertion  @typescript-eslint/no-non-null-assertion
# もし、!を使用する場合はeslintの解除を行う。

# // eslint-disable-next-line @typescript-eslint/no-non-null-assertion


# -----------------------

#! cannot read property of undefined 回避


#【JavaScript】オブジェクトが未定義だった場合のエラーを回避する方法　？（クエッション・疑問符）
# https://qiita.com/choco_p/items/68270ffc51687a45d2ac


# JSでオブジェクトがnullやundefinedでもエラーにしない書き方（?・クエッション・疑問符）
# https://skill-upupup-future.com/?p=875


# -----------------------

#? try catchのエラーの型

# 【TypeScript】try catchをTypeScriptで型安全に用いる方法
# https://code-database.com/knowledges/131

# TypeScript のエラーハンドリングを考える
# https://qiita.com/frozenbonito/items/e708dfb3ab7c1fd3824d

# TypeScriptでキャッチされたエラー情報を型安全に扱いたい
# https://labs.septeni.co.jp/entry/2020/07/23/100000

# 例外処理
# https://future-architect.github.io/typescript-guide/exception.html

# 例外のハンドリング
# https://typescript-jp.gitbook.io/deep-dive/type-system/exceptions

# 例外処理 (exception)
# https://typescriptbook.jp/reference/statements/exception

# TypeScriptの異常系表現のいい感じの落とし所
# https://dev.classmethod.jp/articles/error-handling-practice-of-typescript/

# [TypeScript] Axiosのtry/catchでの例外オブジェクトを型付けする
# https://dev.classmethod.jp/articles/typescript-typing-exception-objects-in-axios-trycatch/
