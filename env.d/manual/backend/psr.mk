#todo [PSR: Tips]

# PHP-FIG
# https://www.php-fig.org/

# PHP Standards Recommendations
# https://www.php-fig.org/psr/


# **** PHP_CodeSniffer ****

# https://github.com/squizlabs/PHP_CodeSniffer

# 記事
# https://www.ninton.co.jp/archives/6360#toc2
# https://tadtadya.com/php_codesniffer-should-be-installed/
# https://pointsandlines.jp/server-side/php/php-codesniffer
# https://qiita.com/atsu_kg/items/571def8d0d2d3d594e58

# 自動でコードを整形し、規約違反のコードを検出できる。

comp-add-D-php_codesniffer:
	docker compose exec $(ctr) composer require "squizlabs/php_codesniffer=*" --dev


# --------------------

#? git commit時にCodeSnifferを実行する方法

# husky:
# https://typicode.github.io/husky/#/
# https://typicode.github.io/husky/#/?id=automatic-recommended
# Gitコマンドをフックに別のコマンドを呼び出せる
# 6系から設定方法が変更


# ....................

# 設定手順:
# https://typicode.github.io/husky/#/?id=automatic-recommended

# ⑴ huskyのインストール
husky-init:
	docker compose exec $(ctr) npx husky-init

# ⑵ .huskyを生成
# npx husky-init → package.jsonを以下のように修正 → yarn | m x

# {
#   "scripts": {
#     "prepare": "cd .. && husky install backend/.husky"
#   },
# }

# ⑶ .husky/pre-commitファイルの編集
husky-add:
	docker compose exec $(ctr) npx husky add .husky/pre-commit

# #!/usr/bin/env sh
# . "$(dirname -- "$0")/_/husky.sh"

# docker compose exec web composer phpcbf
# docker compose exec web php artisan test


# ⑷ composer.jsonのscriptsの編集

# "phpcs": [
#     "./vendor/bin/phpcs --standard=phpcs.xml ./"
# ],
# "phpcbf": [
#     "./vendor/bin/phpcbf --standard=phpcs.xml ./"
# ]


# --------------------

#? phpcsで警告が出たときに見直す内容とか

# https://gist.github.com/kkkw/d926a930a99485214925f22621d56230


# Generic.WhiteSpace.DisallowTabIndent.TabsUsed
# → インデントにハードタブを使っている。ソフトタブにすること

# Squiz.Functions.MultiLineFunctionDeclaration.BraceOnSameLine
# → メソッドの開始ブレスは、改行すること

# CakePHP.Commenting.FunctionComment.Missing
# → phpdocのコメントがない

# CakePHP.WhiteSpace.TabAndSpace
# → タブとスペースに関するエラー。インデント揃えのための複数スペースはダメなど。

# Generic.WhiteSpace.DisallowTabIndent.NonIndentTabsUsed
# → インデント揃えをするためにハードタブを使ってはならない。スペースを使うこと

# Squiz.WhiteSpace.SuperfluousWhitespace.EndLine
# → 行末などに不要なスペースがある。もしくは、スペースのみの行がある。

# CakePHP.WhiteSpace.CommaSpacing
# → 関数コールで引数を渡すとき、カンマの前にスペースがある場合など

# CakePHP.NamingConventions.ValidFunctionName.PrivateMethodInCore
# → これはなぞ。

# CakePHP.Strings.ConcatenationSpacing.MissingBefore
# → 文字列連結のためのドットの前にスペースがない

# CakePHP.Strings.ConcatenationSpacing.MissingAfter
# → 文字列連結のためのドットの後ろにスペースがない

# Generic.NamingConventions.CamelCapsFunctionName.MethodDoubleUnderscore
# → メソッド名はアンダースコア2つではじめてはいけない

# Squiz.NamingConventions.ValidFunctionName.MethodDoubleUnderscore
# → メソッド名はアンダースコア2つではじめてはいけない

# PEAR.NamingConventions.ValidFunctionName.MethodDoubleUnderscore
# → メソッド名はアンダースコア2つではじめてはいけない

# PSR2.Classes.ClassDeclaration.OpenBraceNewLine
# → クラスの開始ブレスは改行すること

# Generic.Functions.FunctionCallArgumentSpacing.SpaceBeforeComma
# → 関数コールで引数を渡すとき、カンマの前にスペースがあってはならない

# PSR2.Classes.ClassDeclaration.CloseBraceAfterBody
# → クラスの閉じブレスの前に改行をいれない

# CakePHP.NamingConventions.ValidVariableName.NotCamelCaps
# → 変数がキャメルケースになっていない

# PSR1.Files.SideEffects.FoundWithSymbols
# → シンボル（クラス、関数、定数など）を宣言するためのファイルと、副作用のある処理（出力の生成、ini設定の変更など）を行うためのファイルは、分けるべきです。つまり、クラス宣言の行っているファイルの先頭で、App::usesとかrequireをしてはいけない。

# PSR2.Methods.FunctionCallSignature.MultipleArguments
# → 関数コールの際に、引数を複数行に分けてコールする際は、1行に1つの引数にすること。また、カンマは行頭ではなく行末にすること

# PSR2.Methods.FunctionCallSignature.SpaceBeforeCloseBracket
# → 関数コールの際に、閉じ括弧の前に、空白や改行を入れてはいけない

# CakePHP.WhiteSpace.FunctionOpeningBraceSpace.SpacingAfter
# → functionの開始ブレス直後に空行が存在するのはダメ。

# PEAR.ControlStructures.ControlSignature
# → foreachの直後にスペースがないなど。

# CakePHP.Commenting.FunctionComment.MissingParamComment
# → phpdocのパラメータータグで、引数のコメントがない

# CakePHP.Commenting.FunctionComment.MissingReturn
# → phpdocのリターンタグがない

# CakePHP.Commenting.FunctionComment.IncorrectParamVarName
# → phpdocのパラメータータグの型がおかしいなど

# CakePHP.Commenting.FunctionComment.MissingParamTag
# → phpdocのパラメータータグがない

# Generic.Files.LineLength.TooLong
# → 1行が長すぎる

# Squiz.ControlStructures.ControlSignature.SpaceAfterKeyword
# → ifなどの後にスペースが必要

# Squiz.ControlStructures.ControlSignature.SpaceAfterCloseParenthesis
# → foreachなどの丸閉じ括弧の直後にはスペースが必要

# Squiz.Commenting.DocCommentAlignment.SpaceBeforeStar
# → phpdocの「*」の位置が揃っていない

# Squiz.NamingConventions.ValidFunctionName.PrivateNoUnderscore
# → privateメソッドの名前に「_」がない

# PEAR.NamingConventions.ValidFunctionName.PrivateNoUnderscore
# → privateメソッドの名前に「_」がない

# PSR2.Methods.FunctionCallSignature.Indent
# → 関数コールの際に、引数を複数行に分けて書いた時にインデントがおかしい

# Generic.ControlStructures.InlineControlStructure.NotAllowed
# → ifなどは1行で書いてはいけない

# CakePHP.ControlStructures.ControlStructures.NotAllowed
# → ifなどは1行で書いてはいけない

# CakePHP.WhiteSpace.OperatorSpacing.NoSpaceAfter
# → 「=>」演算子などの後ろにはスペースが必要

# Generic.Functions.FunctionCallArgumentSpacing.NoSpaceAfterComma
# → 関数コールの際の引数で、カンマの後ろにスペースがない

# CakePHP.WhiteSpace.OperatorSpacing.NoSpaceBefore
# → 「=>」演算子などの前にはスペースが必要

# Generic.WhiteSpace.ScopeIndent.Incorrect
# → インデントのスペースがおかしい。4つではなく8つになっているなど

# CakePHP.Commenting.FunctionComment.InvalidReturn
# → phpdocのリターンタグの値が、間違えている。 booleanではなく、bool。 integerではなくint。もしくは、そもそもおかしい

# CakePHP.WhiteSpace.FunctionClosingBraceSpace.SpacingBeforeClose
# → 関数定義のとじカッコの直前に空行を入れてはならない

# Squiz.NamingConventions.ValidFunctionName.PublicUnderscore
# → protectedメソッドの名前はアンダースコアで開始してはならない

# PEAR.NamingConventions.ValidFunctionName.PublicUnderscore
# → protectedメソッドの名前はアンダースコアで開始してはならない

# Squiz.ControlStructures.ControlSignature.SpaceAfterCloseBrace
# → if,elseなどの時に、制御構造のとじ括弧の後ろにスペースがない

# Generic.Formatting.NoSpaceAfterCast.SpaceFound
# → キャストするときに、キャスト演算子と変数の間にスペースがあってはならない

# CakePHP.Commenting.FunctionComment.ParamNameNoMatch
# → phpdocのパラメータータグの名前と実際の定義があっていないなど

# Generic.Functions.FunctionCallArgumentSpacing.TooMuchSpaceAfterComma
# → 関数コール時の引数の指定時、カンマの後にスペースが必要以上に入っている

# Squiz.Commenting.DocCommentAlignment.NoSpaceAfterStar
# → phpdocのアスタリスクの後ろにスペースがないときなど

# Generic.WhiteSpace.ScopeIndent.IncorrectExact
# → インデントのスペースがおかしい。4つではなく8つになっているなど

# PSR2.Files.EndFileNewline.NoneFound
# → ファイルの最後に空行がない

# PSR2.Methods.FunctionCallSignature.CloseBracketLine
# → 関数コールの閉じ括弧の位置がおかしい。関数コールの際に引数を複数行にする場合、関数コールのとじカッコの位置は、引数の行とは別にしなければならないなど

# Generic.Files.LineEndings.InvalidEOLChar
# → 改行コードにcrlfが使われている

# Generic.NamingConventions.CamelCapsFunctionName.ScopeNotCamelCaps
# → 関数名がキャメルケースになっていない

# CakePHP.Commenting.FunctionComment.MissingParamName
# → phpdocのパラメータータグのパラメーター名がない

# Squiz.Functions.MultiLineFunctionDeclaration.SpaceAfterFunction
# → functionの後ろにスペースが必要

# PSR2.Methods.FunctionCallSignature.SpaceAfterOpenBracket
# → 関数コールの際に、開き括弧の直後にスペースを入れてはならない

# CakePHP.Functions.ClosureDeclaration.SpaceAfterFunction
# → 無名関数のfunctionの後ろにスペースが必要

# CakePHP.Strings.ConcatenationSpacing.TooManyBefore
# → 文字列連結のドットの前にスペースが多すぎる場合。ドット連結時に改行したいときは、ドットを行頭にしないで、行末にする。

# Squiz.NamingConventions.ValidFunctionName.ScopeNotCamelCaps
# → メソッド名がキャメルケースではない

# PEAR.NamingConventions.ValidFunctionName.ScopeNotCamelCaps
# → メソッド名がキャメルケースではない

# PSR1.Methods.CamelCapsMethodName.NotCamelCaps
# → メソッド名がキャメルケースではない

# PSR2.ControlStructures.ElseIfDeclaration.NotAllowed
# → else if ではなく elseif

# Generic.PHP.LowerCaseConstant.Found
# → ｔｒｕｅ、false、nullは小文字

# CakePHP.ControlStructures.ElseIfDeclaration.NotAllowed
# → else if ではなく elseif

# CakePHP.Commenting.FunctionComment.ExtraParamComment
# → ｐｈｐｄｏｃに余分なパラメータータグがある

# CakePHP.NamingConventions.ValidClassBrackets.InvalidSpacing
# → クラス宣言の開始ブラケットの前にスペースが必要

# Internal.LineEndings.Mixed
# → ファイルの中に複数種類の改行コードが存在する

# CakePHP.Strings.ConcatenationSpacing.TooManyAfter
# → 文字列のドット連結の際に、ドットの後にスペースが多すぎる場合。

# Squiz.PHP.NonExecutableCode.ReturnNotRequired
# → 必要のないreturn 文

# Squiz.Scope.MethodScope.Missing
# → メソッドのスコープ(public,protected,private)がない

# CakePHP.Functions.FunctionDeclarationArgumentSpacing.NoSpaceBeforeArg
# → function定義がおかしい。引数とカンマの間にスペースがない

# Squiz.Functions.FunctionDeclarationArgumentSpacing.NoSpaceBeforeArg
# → function定義がおかしい。引数とカンマの間にスペースがない

# Squiz.WhiteSpace.ScopeClosingBrace.Indent
# → 閉じタグのインデントがおかしい

# CakePHP.Commenting.FunctionComment.InvalidReturnNotVoid
# → phpdocでは、void以外を指定しているが、return文に何も指定していないとき。

# CakePHP.WhiteSpace.ScopeClosingBrace.Indent
# → 閉じタグのインデントがおかしい

# CakePHP.Commenting.FunctionComment.WrongStyle
# → functionのコメントがphpdoc形式になっていない

# Squiz.Functions.MultiLineFunctionDeclaration.SpaceAfterUse
# → use の後ろにスペースが必要

# Squiz.Classes.ValidClassName.NotCamelCaps
# → クラス名がキャメル(パスカル)ケースになっていない

# CakePHP.Functions.FunctionDeclarationArgumentSpacing.SpaceBeforeEquals
# → 引数がデフォルト値を保つ場合、引数名とイコールの間にスペースが必要

# CakePHP.Functions.FunctionDeclarationArgumentSpacing.SpaceAfterDefault
# → 引数のデフォルト値とイコールの間にスペースが必要

# CakePHP.Functions.FunctionDeclarationArgumentSpacing.SpacingAfterOpen
# → 関数定義のスペースがおかしい。開始丸括弧と最初の引数の間にスペースはいらない

# Squiz.Functions.FunctionDeclarationArgumentSpacing.SpaceAfterDefault
# → 引数のデフォルト値とイコールの間にスペースが必要

# Squiz.Functions.FunctionDeclarationArgumentSpacing.SpaceBeforeEquals
# → 引数がデフォルト値を保つ場合、引数名とイコールの間にスペースが必要

# Squiz.Functions.FunctionDeclarationArgumentSpacing.SpacingAfterOpen
# → 関数定義のスペースがおかしい。開始丸括弧と最初の引数の間にスペースはいらない

# Squiz.Functions.MultiLineFunctionDeclaration.SpaceBeforeOpenParen
# → function定義がおかしい。関数名の後にスペースが入っている。Function foo(… ではなくfunction foo (…になっている

# PSR2.ControlStructures.SwitchDeclaration.SpaceBeforeColonDEFAULT
# → switch文のdefaultとコロンの間にスペースがあってはいけない

# Squiz.Functions.MultiLineFunctionDeclaration.SpaceAfterBracket
# → 無名関数の定義がおかしい。終わりの丸括弧の後と始まりの波括弧の前にスペースが必要

# PSR2.ControlStructures.SwitchDeclaration.BodyOnNextLineDEFAULT
# → switch文のdefaultのbody部は別の行にしないといけない

# PSR2.ControlStructures.SwitchDeclaration.SpaceBeforeColonCASE
# → swich文のコロンの前にスペースが入っている場合

# Squiz.Functions.MultiLineFunctionDeclaration.SpaceBeforeUse
# → 無名関数のｕｓｅキーワードの前にスペースが入ってない

# PSR2.ControlStructures.SwitchDeclaration.BodyOnNextLineCASE
# → switch文のbody部はcase節の次の行に来ること(同一行に書いてはいけない)

# Squiz.WhiteSpace.LogicalOperatorSpacing.TooMuchSpaceAfter
# → &&や||などの論理演算子の後ろにスペースが多すぎる場合。

# Squiz.WhiteSpace.LanguageConstructSpacing.IncorrectSingle
# → 言語の制御構造の後ろはスペース1つであること。 Return文と変数の間に2つスペースがあったりしてはだめ。

# PSR2.Methods.FunctionCallSignature.SpaceBeforeOpenBracket
# → 関数コールの際に、関数名と丸括弧の間にスペースが入っている

# PSR2.ControlStructures.SwitchDeclaration.BreakNotNewLine
# → switch文のbreak文は、単独行になっていること。Caseなどと同じ行に書いてはいけない

# Generic.Formatting.DisallowMultipleStatements.SameLine
# → セミコロン打ったら改行しましょう。

# Squiz.WhiteSpace.ScopeClosingBrace.ContentBefore
# → 閉じ括弧の位置がおかしい。Switch文のcase行とbreak行が一緒に書いてあるなど

# PSR2.Classes.ClassDeclaration.SpaceAfterKeyword
# → クラス定義のクラス名の指定方法がおかしい。 Class キーワードと、クラス名の間にスペースが2つある場合など。

# Squiz.WhiteSpace.SemicolonSpacing.Incorrect
# → セミコロンの前にスペースが存在する。セミコロンの前で改行されている場合など

# PSR2.Files.ClosingTag.NotAllowed
# → phpコードしかない場合は、phpの閉じタグはいらない

# CakePHP.NamingConventions.UpperCaseConstantName.ConstantNotUpperCase
# → 定数が大文字のスネークケースになっていない。

# CakePHP.NamingConventions.ValidFunctionName.PublicWithUnderscore
# → publicメソッドなのに、アンダースコアから始まっている

# CakePHP.WhiteSpace.FunctionCallSpacing.SpaceBeforeOpenBracket
# → 関数名の後にスペースが入っている。foo(… ではなくfoo (…になっている

# CakePHP.WhiteSpace.ScopeClosingBrace.ContentBefore
# → 閉じ括弧の位置がおかしい。Switch文のcase行とbreak行が一緒に書いてあるなど

# Squiz.Operators.ValidLogicalOperators.NotAllowed
# → 「`&&`、`||`」 ではなく 「`and`、`or`」 が使われている

# CakePHP.Commenting.FunctionComment.InvalidReturnVoid
# → phpdocに記載されているreturnの型はvoidだが、じっさいはvoid以外が返されている

# PEAR.Functions.ValidDefaultValue.NotAtEnd
# → 関数定義の際に、デフォルト値を持つ引数が最後に定義されていない場合

# Squiz.Functions.FunctionDeclaration
# → 関数定義がおかしい。

# CakePHP.PHP.TypeCasting.NotAllowed
# → キャストが推奨されていない書き方になっている。(integer)じゃなくて(int)を使うべき
