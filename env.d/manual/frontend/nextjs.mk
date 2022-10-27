#todo [Next.js Tips]

# Next.jsのAPI RoutesにGraphQLサーバ設定+Vercelにデプロイまでの流れ
# https://reffect.co.jp/react/next-js-graphql


# **** Darkモードの実装方法 ****

# 記事
# https://zenn.dev/minguu42/articles/20220113-nextjs-darkmode
# https://zenn.dev/taka_shino/articles/a6c176da799c91
# https://koredana.info/blog/nextjs-switching-theme/
# https://qiita.com/10mi8o/items/4be3a69731aed0692e40
# https://mebee.info/2022/04/06/post-62511/
# https://www.wantedly.com/companies/tsunagu-grp/post_articles/425027


# **** 配列の更新方法 ****

# 更新方法まとめ

# 種類	bad!!	good!!
# 削除	state.pop()	state.filter(el => el　!==　'xxx')
# 追加	state.push('xxx')	[...state, 'xxx']
# 入れ替え	state[0] = 'y'	state.map(el => el === 'y' ? 'xxx': el)
# 'xxx'にはそれぞれ削除したいもの、追加したいもの、入れ替えたいものが入ります。
# 次にオブジェクトの更新方法をみていきましょう。

# 種類	bad!!	good!!
# 削除	delete state.name	{...state, name: undefined}
# 追加	state.name = 'xxx'	{...state, name: 'xxx'}
# 入れ替え	state.age = 10	{...state, age: 10}
# オブジェクトの場合、追加と入れ替えは同じような書き方なります。
# 削除に関してはlodashを使って以下のように書くこともできます。

# _.omit(state, 'name')


# **** 配列の扱い 追加・編集・削除 ****

# Read
# + Get
# + List

# Write
# + Create
# + Update
# + Delete

# -----------------

# mapは配列の入れ替えとイテレート
# filterは配列から要素を除去
# reducerは計算

# -----------------

#  まとめ

# 更新処理を考えるときは、その処理を実行するまでに何回ボタンをクリックするか考える。
# 1回目: フォーム画面表示 (削除ボタンはスキップ可)
# 2回目: 処理を実行 (追加ボタンはスキップ可)

# [パータン1] トップ画面に追加・編集・削除ボタンがある場合
# 追加: 2
# 編集: 2
# 削除: 2 or 1

# [パータン2] 追加フォーム画面に編集・削除ボタンがある場合
# 追加: 1
# 編集: 2
# 削除: 1

# [パータン3] 追加処理は別で、編集と削除ボタンがモーダル上にある場合
# 追加: クリック無し or 2
# 編集: 2
# 削除: 2


# -----------------

# 配列に要素を追加：
# setState(prev => [...prev, newItem])

# 配列の要素を編集：
# const newArray = state.map((item, idx) => (idx === index ? <変更内容> : item))
#  setState(newArray);

# 配列の要素を削除：
# const newArray = state.filter((_, idx) => idx !== index);
# setState(newArray);


# -----------------

# 配列のstateの扱いポイント！
# 要素が追加されたり、削除されたりして要素数が変化するので、
# その要素数をカウントするstateが必要！
# const [count, setCount] = useState(0);

# また編集する際は編集したい要素の位置情報が必要になるので、その要素のインデックスを管理するstateが必要！
# const [index, setIndex] = useState(0);

# このように別々に管理もできるが、ロジックで調整して一括で管理もできる。
# const [countIndex, setCountIndex] = useState(0);

# countは配列の要素数に一致。
# indexは配列のインデックスに一致。
# 要素数 - 1 = 末尾のインデックス

# countIndexは追加・削除するときは、値に今の要素数を代入し、
# 編集するときは、値にmapで回したときのインデックスを代入することで、
# モード切り替える。


# -----------------

# そもそもなぜこんなややこしいことになっているかと言うと、
# ひとつのボタンで追加・編集を処理させようとしているから。
# 今回は、編集ボタンは単にテキストボックスに編集したい要素のサイズと数量を表示させるだけで、実際の編集処理は追加ボタンで行っている。

# 編集処理を行うには、少なくとも2回クリックが必要。
# 1回目は編集前の内容が表示されたフォーム画面を表示させるため。
# 2回目は編集内容を反映させるため。
# これはMPAでもSPAでも必要な遷移。

# (その1) MPAの場合の編集処理：
# 編集リンクボタンをクリック → 編集フォーム画面に遷移 → 編集 → 編集ボタンをクリック → 編集内容を反映

# (その2) SPAでモーダルを活用した編集処理：
# モーダルを表示させる要素をクリック → フォームがあるモーダルが表示 → 権限がある場合編集 → 編集ボタンをクリック → 編集内容を反映

# (その3) 追加処理と編集処理をひとつのボタンで行う：編集はクリック2回、追加はクリック1回
# 追加フォーム画面で編集ボタンをクリック → 編集前の編集内容がフォームに表示される → 編集 → 追加・編集ボタンをクリック → ロジックで追加処理と編集処理を分岐させて編集内容を反映
# 追加処理と編集処理を分ける条件は、配列の要素数に一致するかどうか。


# **** Global State ****

# Darkモード切り替え用のstate

# ログイン情報

# キャッシュ更新用のstate


# **** React Query ***+

#? リアルタイム性の調節

# リアルタイムとは、他人がデータを変更した時に、自分が見ている画面にすぐに反映されるかのこと。

# ①超リアルタイム
# staleTime: 0
# refetchOnWindowFocus: true

# ②リアルタイム
# staleTime: 0

# ③グラデーション
# # staleTime: 10000 (10秒)

# ④非リアルタイム
# staleTime: Infinity


# **** errors ***+

#! Warning: Expected server HTML to contain a matching <main> in <div>. の対処法

#【Next.js】Hydration時にReact.hydrate()による警告が発生するケースとその解決方法
# https://nishinatoshiharu.com/next-hydration-warning-resolution/


# --------------------


#! Warning: Use the `defaultValue` or `value` props instead of setting children on <textarea>.

#【React】Reactでtextarea要素を使っていたら出たエラー
# https://tektektech.com/react-textarea-default-value-error/


# **** NextAuth ****

# NextAuth.js
# https://next-auth.js.org/

# NextAuthを完全に理解する #1
# https://qiita.com/kage1020/items/bdefabcd09d86e78d474

# NextAuthを完全に理解する #2
# https://qiita.com/kage1020/items/e5b0053d7046a9b1f628

# NextAuthを完全に理解する #3
# https://qiita.com/kage1020/items/195fdd8749f2439849c1

#【Next.js・Typescript】NexAuthを使ってログイン認証をする
# https://zenn.dev/furai_mountain/articles/b54c83f3dd4558
