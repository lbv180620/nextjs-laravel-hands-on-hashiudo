# todo [Laravel で Fat Controller をリファクタリングしよう]


# ==== 0章 : 環境構築と本教材の概要 ====

# https://www.techpit.jp/courses/176/curriculums/179/sections/1191/parts/4675


# **** 環境構築(Mac) ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1191/parts/4677

# https://github.com/TeXmeijin/LaravelBookmark_FatController


#~ データベースへの接続方法

# Sequel Pro https://www.sequelpro.com/
# Table Plus https://tableplus.com/
# MySQL Workbench https://www.mysql.com/jp/products/workbench/


# --------------------

#~ ブラウザで localhost を開く

# https://localhost

#^ もしブラウザで Google Chrome をご利用で、警告画面が出て開けなかった場合、以下のように対処してください。

# ⑴ 以下のリンクにアクセス
# chrome://flags/#allow-insecure-localhost

# ⑵ Allow invalid certificates for resources loaded from localhost. をEnabledにする。

# ⑶ Relaunchをクリックして再起動


# ==== 1章 : 「ユースケース」を作って処理を引っ越しさせてみよう ====

# **** 今回リファクタリングする Fat Controller の処理を読んでみよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1192/parts/4680


# ****「ユースケース」を置くディレクトリを作ろう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1192/parts/4682

# mkdir src/app/Bookmark
# mkdir src/app/Bookmark/UseCase


# ****「ユースケース」クラスを作ろう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1192/parts/4683

# touch src/app/Bookmark/UseCase/ShowBookmarkListPageUseCase.php

# <?php

# namespace App\Bookmark\UseCase;

# use App\Models\Bookmark;
# use App\Models\BookmarkCategory;
# use App\Models\User;
# use Artesaos\SEOTools\Facades\SEOTools;

# final class ShowBookmarkListPageUseCase
# {
#     /**
#      * SEO
#      * title, description
#      * titleは固定、descriptionは人気のカテゴリTOP5を含める
#      *
#      * ソート
#      * ・投稿順で最新順に表示
#      *
#      * ページ内に表示される内容
#      * ・ブックマーク※ページごとに10件
#      * ・最も投稿件数の多いカテゴリ※トップ10件
#      * ・最も投稿数の多いユーザー※トップ10件
#      * @return array
#      */
#     public function handle(): array
#     {
#         /**
#          * SEOに必要なtitleタグなどをファサードから設定できるライブラリ
#          * @see https://github.com/artesaos/seotools
#          */
#         SEOTools::setTitle('ブックマーク一覧');

#         $bookmarks = Bookmark::query()->with(['category', 'user'])->latest('id')->paginate(10);

#         $top_categories = BookmarkCategory::query()->withCount('bookmarks')->orderBy('bookmarks_count', 'desc')->orderBy('id')->take(10)->get();

#         // Descriptionの中に人気のカテゴリTOP5を含めるという要件
#         SEOTools::setDescription("技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。{$top_categories->pluck('display_name')->slice(0, 5)->join('、')}など、気になる分野のブックマークに絞って調べることもできます");

#         $top_users = User::query()->withCount('bookmarks')->orderBy('bookmarks_count', 'desc')->take(10)->get();

#         return [
#             'bookmarks' => $bookmarks,
#             'top_categories' => $top_categories,
#             'top_users' => $top_users
#         ];
#     }
# }


# ****「ユースケース」に処理を引っ越ししよう ****

# src/app/Http/Controllers/Bookmarks/BookmarkController.php

# use Illuminate\View\View;
# // 以下を追加！
# use App\Bookmark\UseCase\ShowBookmarkListPageUseCase;

# class BookmarkController extends Controller
# {

# //...中略

#     /**
#      * ブックマーク一覧画面
#      * @return Application|Factory|View
#      */
#     public function list(Request $request, ShowBookmarkListPageUseCase $useCase)
#     {
#         return view('page.bookmark_list.index', [
#             'h1' => 'ブックマーク一覧',
#         ] + $useCase->handle());
#     }


# ==== 2章 : Fat Controllerとはどんな状態か知ろう ====

# **** Fat Controller の特徴 ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1193/parts/4687


# Fat Controller とは、以下のような状態になっている Controller を指します。

#!「Controller が本来果たすべき責任のみならず、複数の責任を持ってしまっている状態」


#^ 1 つのクラスに複数の責任が負わされている場合は、責任は 1 つのみに絞り、他の処理は別のクラスなどに切り出すようにリファクタします。

# Controller が本来果たすべき役割は、アクセスされた URL に沿った HTML を返すことです。
# ということは、HTML を返す以外の処理は Controller 以外のクラスが実行するのが望ましいです。


# --------------------

#? 単一責任の原則
# 処理をクラスの責任ごとに切り分けていくことで守られる原則は「単一責任の原則」と呼ばれています。

# 興味のある方は、SOLID 原則、といったワードで調べてみてください。



# **** Fat Controller の問題点 ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1193/parts/4688


# ==== 3章 : FormRequest、MiddlewareなどLaravelの機能を使いこなそう ====

# **** 今回リファクタリングする Fat Controller の処理を読んでみよう ****


# 基本的には自分でこういう種類のクラスが必要だ、と定義して namespace を切って開発していくことが大事です。

# しかし、Laravel の機能で提供されているものがあるのなら、それらを利用することで Laravel エンジニア同士の共通認識を持ちやすくなるというメリットがあります。


# **** ブックマーク作成リクエストを FormRequest で表現しよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1194/parts/4691


#~ バリデーション処理の複雑さ:

# 以上より、バリデーションと一口に言ってもいくつもの処理が含まれていることがわかります。

# 1. 入力された各項目について条件を満たしているかチェック
# 2. 1 つでも条件を満たしていなければ例外を投げる
# 3. レスポンスにどのパラメータがどの原因でバリデーションに引っかかったのかを含める

# 従って、バリデーション処理は Controller から切り出しておいたほうが、Fat になるリスクが小さくなると言えます。そのために Laravel で用意されているスマートな解決策が FormRequest です。


# ----------------

#~ FormRequest の概要

# FormRequest とは、リクエストに対してバリデーションチェックを実行し、失敗時に例外を吐くところまでやってくれるクラスで、Laravel の機能として用意されています(Illuminate/Foundation/Http/FormRequest.php)。


# Laravel の Controller でよく使われるRequestクラスの拡張版で、Controller のアクションメソッドの引数として渡された時点で既にバリデーションチェックが終わっているという特徴を持っています。

# （正確に言うと、作成した FormRequest をサービスコンテナが依存解決したタイミングで、登録したバリデータが動いています。詳しく知りたい方は FormRequest.php、およびIlluminate/Foundation/Providers/FormRequestServiceProvider.php あたりを読んでみてください）


# Controller が負うべきではない処理を「ユースケース」というクラスに任せました。今回は、「バリデーションチェックを実行する」処理を FormRequest に任せます。処理の責任ごとにクラスを作ることが大事です。


# ----------------

#~ 新規 FormRequest の作成


# ----------------

#~ 総括

# ここでは、バリデーション処理は FormRequest に任せることで Controller をスリムにできる、しかもその実装方法は引数のクラスを書き換えるだけでよい、ということを覚えておいてください。


# **** ログインチェック処理を Middleware に移行しよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1194/parts/4692


#~ ログインチェック処理の特徴


#・いろいろな Controller で利用される（投稿だけでなく、更新や削除でも使う。自身のプロフィール更新でも使うかも）
#・ほとんどの場合、ログインページへのリダイレクトを行う点で処理が似ている

# 以上から、ログインしているかどうかチェックして、未ログインであればログインページに遷移する、という処理を切り出して、さまざまな Controller で共通して利用する方法が良いと言えます。

# そのための解決策として、Laravel では Middleware が用意されています。


# ----------------

#~ Middleware

# Middleware はログインチェックだけの仕組みではないのですが、最もよく利用される場面の一つにログインチェックがあります。

# Controller で処理を行う前に動かすことができる、という意味では前節の FormRequest と類似しています。イメージとしては、それぞれの Controller に特有の、サービスの仕様に依存したバリデーションを実行したいときは FormRequest が適していますが、認証やセキュリティ関連の処理など、サービスの仕様に関係なくさまざまな Controller で使いたい処理は Middleware に書くほうが適しています。


# ----------------

#~ Authenticate ミドルウェア

# 実は、Laravel には Authenticate ミドルウェアという、ログインチェックをしてログインページに遷移する Middleware が用意されています。

# src/app/Http/Middleware/Authenticate.php

# <?php

# namespace App\Http\Middleware;

# use Illuminate\Auth\Middleware\Authenticate as Middleware;

# class Authenticate extends Middleware
# {
#     /**
#      * Get the path the user should be redirected to when they are not authenticated.
#      *
#      * @param  \Illuminate\Http\Request  $request
#      * @return string|null
#      */
#     protected function redirectTo($request)
#     {
#         if (! $request->expectsJson()) {
#             return route('login');
#         }
#     }
# }


# そして、この Middleware はsrc/app/Http/Kernel.phpにて、authという名前で$routeMiddlewareに登録されています。

# protected $routeMiddleware = [
#     'auth' => \App\Http\Middleware\Authenticate::class,
#     // 以下略
# ];


# この紐付けにより、src/routes/web.phpでAuthenticateミドルウェアを利用できます。

# web.phpを開き、以下のようにブックマーク作成ルートを書き換えてください。

# Route::post('/', 'Bookmarks\BookmarkController@create')->middleware('auth'); // ->middleware('auth')を追加


# ->middleware('auth')を書き足すだけで、そのアクションは認証済みのユーザーしかアクセスできなくなります。

# つまり、Controller からログインチェックの処理を取り除くことができます。


# **** 他の処理を「ユースケース」に移行しよう ****


#~ ファイルの作成、実装、Controller のスリム化

# touch src/app/Bookmark/UseCase/CreateBookmarkUseCase.php


# <?php

# namespace App\Bookmark\UseCase;

# use App\Models\Bookmark;
# use Dusterio\LinkPreview\Client;
# use Illuminate\Support\Facades\Auth;
# use Illuminate\Support\Facades\Log;
# use Illuminate\Validation\ValidationException;

# final class CreateBookmarkUseCase
# {
#     /**
#      * ブックマーク作成処理
#      *
#      * 未ログインの場合、処理を続行するわけにはいかないのでログインページへリダイレクト
#      *
#      * 投稿内容のURL、コメント、カテゴリーは不正な値が来ないようにバリデーション
#      *
#      * ブックマークするページのtitle, description, サムネイル画像を専用のライブラリを使って取得し、
#      * 一緒にデータベースに保存する※ユーザーに入力してもらうのは手間なので
#      * URLが存在しないなどの理由で失敗したらバリデーションエラー扱いにする
#      *
#      * @param string $url
#      * @param int $category
#      * @param string $comment
#      * @throws ValidationException
#      */
#     public function handle(string $url, int $category, string $comment)
#     {
#         // 下記のサービスでも同様のことが実現できる
#         // @see https://www.linkpreview.net/
#         $previewClient = new Client($url);
#         try {
#             $preview = $previewClient->getPreview('general')->toArray();

#             $model = new Bookmark();
#             $model->url = $url;
#             $model->category_id = $category;
#             $model->user_id = Auth::id();
#             $model->comment = $comment;
#             $model->page_title = $preview['title'];
#             $model->page_description = $preview['description'];
#             $model->page_thumbnail_url = $preview['cover'];
#             $model->save();
#         } catch (\Exception $e) {
#             Log::error($e->getMessage());
#             throw ValidationException::withMessages([
#                 'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
#             ]);
#         }
#     }
# }



# 最後に、Controller をスリム化させましょう。

# // 追加
# use App\Bookmark\UseCase\CreateBookmarkUseCase;

# // 中略

#     /**
#      * ブックマーク作成処理
#      * @param CreateBookmarkRequest $request
#      * @return Application|\Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
#      */
#     public function create(CreateBookmarkRequest $request)
#     {
#         $useCase = new CreateBookmarkUseCase();
#         $useCase->handle($request->url, $request->category, $request->comment);

#         // 暫定的に成功時は一覧ページへ
#         return redirect('/bookmarks', 302);
#     }


# **** Before-After を見比べよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1194/parts/4694


#~ 補足

# ちなみに Laravel には、他にもたくさんの Fat Controller を卒業するための機能が用意されています。本教材では個人的に最低限覚えておいて欲しいものだけ紹介しましたので、その他の機能はドキュメントを読んでみてください。

# Policy:
# データベースへのデータの読み書きをユーザーごとに制限するロジックをまとめる
# ブックマーク投稿者以外は編集できない、といった認可処理
# 個人的には、かなり書き方に癖があり使いにくいのでユースケースやドメインオブジェクトに実装するほうが好み

# ViewComposer:
# blade ファイルの共通モジュールを作るのに便利
# 共通のデータを取得してくれるが、使いすぎると意図しないデータ読み出しが起きるので注意

# Event:
# ユースケースによらない、○○ が起こったとき ○○ する、といったイベント駆動のロジックを実装する
# テストコードが書きやすい


# **** 【FAQ】処理を移行したらどのような処理が行われているかわからなくなりました ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1194/parts/4805


# 知らなくてよくなるからこそ、

#・再利用しやすいソースコードとして扱えますし、
#・単体でテストがしやすくなりますし、
#・ソースコードを調査するときも、どこに探している仕様が記述されているかあたりをつけやすくなります


# 私は実務ではUseCase、Entity、ValueObject、Repository、Eventなどに処理を切り分けているのですが、これらの切り分けルールがある程度統一されていると、
# 毎回Controllerから実装を辿らなくても、いきなり最初にここに求めている実装がされているとあたりをつけて見に行くこともできるようになります。


# とはいえ注意点というかトレードオフとしては、クラス名とか引数、メソッド名などでできるだけ何をやっているのか読みやすくする努力が必要だと言えます。これは慣れていくしかありません。OSSを読んだり先輩のソースコードを読んで、なるほどそういう英単語を使うのか！と学んでいくことが良いと思います。


# ==== 4章 : インターフェースとサービスコンテナを使いこなそう ====


# **** 本章の学習目標 ****

# 3 章までで実装したユースケースクラスは外部サービスにアクセスするため、テストがやりにくいことを理解している [4-2 節]

#・外部サービスにアクセスする部分を個別のクラスに切り出し、戻り値も専用のクラスとするようにリファクタリングできる [4-3 節]

#・PHP におけるインターフェースと実装クラスの関係性や文法について理解している [4-4 節]

#・クラス A がクラス B に依存している、とはどういうことか説明できる [4-5 節]

#・同じインターフェースを実装しているが、中身の異なるクラスを実装することができる [4-6 節]

#・サービスコンテナ経由でインターフェースと実装クラスを結びつける（bind する）ことで、Controller や UseCase から実装クラスへの依存を完全に引き離すことができる [4-7 節]

#・サービスコンテナでバインドするクラスを切り替えるだけで、実際に動作するクラスを切り替えられることを理解している [4-7 節]


# **** CreateBookmarkUseCase のテスタビリティ ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1195/parts/4696


#~ CreateBookmarkUseCase に残っている問題

# CreateBookmarkUseCase がやっていること:

# 3-1 節で、ブックマークされた URL に実際にアクセスして<title></title>タグなどのメタ情報をスクレイピングしていることを説明しました。

# ここでは dusterio/link-preview パッケージの Dusterio\LinkPreview\Client というクラスを使っています。Client クラスに URL を渡すとその URL が示すページを開き、<title></title>タグなどからメタ情報を引っ張ってくることができます。

#^ 本章で特に重要なことは、CreateBookmarkUseCase は実在する URL を渡さなければ動作確認ができないことです。


# ...............


# Fat Controller の問題点は解消できているか？:

# 続いて、2 章で説明した Fat Controller の問題点も再掲します。

# 理由 1: どの処理とどの処理が関連づいているかが分かりにくい
# 理由 2: 全部まとめて動作検証する以外の選択肢がない
# このうち、1 つ目の「どの処理とどの処理が関連づいているかが分かりにくい」については、役割ごとにクラスを分けることで、可読性が改善できたと言えるでしょう（※1）。

# しかし 2 つ目の動作検証の観点でいえばどうでしょうか。私はまだ課題が残っていると思います。

# というのも、 CreateBookmarkUseCase は実在する URL にアクセスしてメタ情報を引っ張ってくるからこそ、テストコードが書きにくいのです。


# --------------------

#~ テストコードが書きにくいとは？

# // ※このテストコードは use などを省略しているのでそのままでは動きません
# final class CreateBookmarkUseCaseTest extends TestCase
# {
#     public function testCreateSuccess()
#     {
#         // ①テストしたいメソッドを呼び出す
#         $usecase = new CreateBookmarkUseCase();
#         $usecase->handle('https://techpit.jp');

#         // ②データベースに正しくデータが保存されたことをチェックする
#         $this->assertDatabaseHas('bookmarks', [
#             'page_title' => 'Techpit（テックピット）|サービスを作りながら学べるプログラミング学習プラットフォーム',
#             'page_description' => 'Techpitは、現役のエンジニアが作った教材でサービス開発に必要なスキルが学べるプログラミング学習プラットフォームです。',
#             'page_thumbnail_url' => 'https://user-images.githubusercontent.com/42291263/85671906-522ec780-b6fd-11ea-8c23-eca15138646b.png',
#         ]);
#     }

#     // 他にも必要に応じてテストパターンが並ぶ
# }


# まずはテストしたいメソッドを呼び出します（①）。そのあとassertDatabaseHasメソッドを使い、データベースのbookmarksテーブルに正しく値が保存されたことをチェックしています（②）。


#! 重要なのは、テストコードにおいては、入力する値や期待する値を実装者が指定してあげなければいけない点です。

# 上記のテストコードにおいて、CreateBookmarkUseCaseクラスのhandleメソッドには、ブックマークしたい URL を渡す必要があります。 このテストコードを動作させるためには実在する URL を使わなければいけません。


# --------------------

#~ 実在する URL にアクセスするテストコードの課題


#^ 致命的な欠点とは、Techpit さんのトップページの タイトル、 Description、サムネイル URL はいずれ変わってしまうことです。

# あなたがこの教材を読む頃には変わってしまっている可能性も高いです（もしよければチェックしてみてください）。タイトル、Description、サムネイル URL が変わるとテストコードは失敗します。


# 自分のソースコードを改修したわけでもないのに、ある日突然テストコードが落ちてしまったら本末転倒ですよね。

# 以上より、現在の CreateBookmarkUseCase に対するテストコードが書きにくい、つまりテスタビリティが低いといえます。


# --------------------

#~ その他の問題

# 他にも実在する URL を使ってテストをすることの問題はいくつもあります。

# まず、軽いアクセスとはいえ、他のサービス（Techpit）にアクセスを飛ばしていることです。大量のテストを同時に動かした時に想定以上にリクエストが飛んで、迷惑をかける可能性があります。あえていうと、このテストケースのために自分でドメインを取って簡単なサイトを公開しておくとその問題は無視できますが、ちょっと面倒ですね。

# それに、「Title が 50 文字を超えたらそれ以降は”...”にする」という仕様が追加されたとしたらどうでしょう。Title がぴったり 49 文字のサイトと、50 文字のサイトを少なくとも用意しなければテストになりませんね。そんなサイトをその都度簡単に見つけられるでしょうか。


# --------------------

#~「モック」を使ってテスタビリティを向上しよう！

# ここまでの問題提起を簡潔にまとめてみます。

#・ソースコードから”外部サービス”へのアクセスを行っている部分のテストは、”外部サービス”へ依存してしまうため書きにくいし、場合によっては迷惑を掛けてしまう
#・必要なテストケースが多岐にわたった際、条件を満たす”外部サービス”を探さなければならない
# 今回の URL の例に限らず、意外と実際に運用されているシステムから”外部サービス”へアクセスされることは多いです（※2）。

# こういったとき、実際には”外部サービス”へアクセスしなくてもテストが通るようにテストコードを書くための技法があります。

# それを実現する方法は本章と次章で順を追って説明していきますが、簡単に説明すると「モック」と呼ばれるクラスを作成し、実際に動作するクラスの一部を差し替えてテストを行うという手法です。


# モックを使うことで「Title が 50 文字を超えたらそれ以降は”...”にする」という仕様が追加されたとしても、Title がぴったり 49 文字の”偽物の”サイトを使うモックと、50 文字の”偽物の”サイトを使うモックを利用したテストコードを書くことができます。

# 実在する URL へアクセスする場合と、モックを使った場合を簡単な図にまとめました。モックとなるクラスを実装して、仕様に応じて差し替えてテストすることができれば、実在する URL を使ってテストするよりテスタビリティが高いことがイメージできると思います。


# --------------------

#~ モックを実装するための条件

# モックを実装するだけなら簡単ですが、それを臨機応変に差し替えながらテストができる仕組みを構築するのはいくつかリファクタリング必要があります。

# ざっくり言えば以下の 2 条件を満たすようにリファクタリングしていきます。

#^・FatController を卒業し、さらに Interface を駆使することで、クラス間の依存を疎結合にしていること
#^・サービスコンテナを使い、Interface の依存解決時にモックを Injection すること

# 疎結合、そして依存解決という言葉が出てきました。クラス間の依存を疎結合にして、Interface をサービスコンテナによって依存解決させる技法はテスタビリティを向上させるとともに、設計手法としても望ましいやり方です。


# --------------------

# ※1 実際は、まだまだクラスを分けていく余地はあります。handle メソッドの引数がどんどん増えていくことを防ぐために引数全体をクラスにしたり、URL を文字列ではなく文字列を表す”ValueObject”にしたり、分岐や繰り返しがあればそれらの意図が命名された”仕様クラス”に分けるといったことが可能です。しかしこれ以上進めると、大半の Web アプリケーションにとっては説明しすぎな内容になってしまうことを恐れました。もっと学びたい方はクリーンアーキテクチャ、ドメイン駆動設計などの書籍を読んでみてください。


#^ モックとは、実際に外部サービス”へアクセスしなくてもテストが通るように、その代わりとなるクラスを作成し、実際に動作するクラスの一部を差し替えてテストを行うという手法のこと


# **** メタ情報取得処理を別クラスに切り出してみよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1195/parts/4697


# 前節で最後に挙げた、「モック」を実現するための手順を進めていきます。

#・FatController を卒業し、さらに Interface を駆使することで、クラス間の依存を疎結合にしていること
#・サービスコンテナを使い、Interface の依存解決時にモックを Injection すること
# これからメタ情報取得処理の周辺をリファクタし、テストが実施しやすい環境を実現していきます。

# 本節では、まずメタ情報取得処理を別のクラスに切り出すところから始めます。
#^ すべてはクラスを責任ごとに切り分けることからスタートです。


# --------------------

#~ 実際には”外部サービス”へアクセスしなくてもテストが通るまで

# 大きく分けて、以下の 5 つの手順をクリアすれば、「”外部サービス”へアクセスしなくてもテストが通る」状態が実現できます。

# ⑴ メタ情報取得処理を別のクラスに切り分ける
# ⑵ 切り分けたクラスに対応するインターフェースを作成する
# ⑶ メタ情報取得処理のクラスをインターフェースに依存させる
# ⑷ 同じインターフェースを満たすが、実際に外部アクセスはしない 「モック」を作成する
# ⑸ サービスコンテナを使って 「モック」とインターフェースを結びつける

# ちょっと道程が長いですが、1 つ 1 つ節を分けて開発していきますので、少しずつ進めていきましょう。


# --------------------

#~ メタ情報取得処理の切り分け

# 最初は「メタ情報取得処理を別のクラスに切り分ける」です。といっても、これはこれまで Controller の処理を UseCase に切り分けた方法と同じ感覚で進めます。

# メタ情報取得処理を切り分けるクラスは、App\Lib\LinkPreview以下に置くことにします。ブックマーク関連機能に限らず、URL からメタ情報を取得してくる処理は一般的に使われそうです。そのため、Libという名前のディレクトリに置くことにしました。

# 以下のコマンドを実行してsrc/app/Lib/LinkPreviewディレクトリとLinkPreview.phpファイルを作成してください。


# mkdir -p src/app/Lib/LinkPreview && touch src/app/Lib/LinkPreview/LinkPreview.php


# 作成したLinkPreview.phpファイルに以下を記述してください。

# <?php
# namespace App\Lib\LinkPreview;

# use Dusterio\LinkPreview\Client;

# final class LinkPreview
# {
#     public function get(string $url): array
#     {
#         $previewClient = new Client($url);
#         return $previewClient->getPreview('general')->toArray();
#     }
# }


# 続いて、CreateBookmarkUseCase.php を編集します。

# <?php

# namespace App\Bookmark\UseCase;

# use App\Lib\LinkPreview\LinkPreview;
# use App\Models\Bookmark;
# use Dusterio\LinkPreview\Client;
# use Illuminate\Support\Facades\Auth;
# use Illuminate\Support\Facades\Log;
# use Illuminate\Validation\ValidationException;

# final class CreateBookmarkUseCase
# {
#     /**
#      * 中略
#      */
#     public function handle(string $url, int $category, string $comment)
#     {
#         try {
#             // $preview = $previewClient->getPreview('general')->toArray();
#             $preview = (new LinkPreview())->get($url);

#             $model = new Bookmark();
#             $model->url = $url;
#             $model->category_id = $category;
#             $model->user_id = Auth::id();
#             $model->comment = $comment;
#             $model->page_title = $preview['title'];
#             $model->page_description = $preview['description'];
#             $model->page_thumbnail_url = $preview['cover'];
#             $model->save();
#         } catch (\Exception $e) {
#             Log::error($e->getMessage());
#             throw ValidationException::withMessages([
#                 'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
#             ]);
#         }
#     }
# }


# シンプルに切り分けただけなので、特に解説することはないでしょう。動作確認すると、無事に動くはずです。

# メタ情報取得処理の部分が(new LinkPreview())->get($url);という内容に書き換わっていますね。


# --------------------

#~ (ついでに)返り値を array からクラスに変更する

# さて、せっかくクラスを切り分けたので、本筋とは関係ないですがついでにもっとリファクタしましょう。

# LinkPreview の get メソッドの返り値は array です。そして CreateBookmarkUseCase では以下のように内容を取り出しています。

# $model->page_title = $preview['title'];
# $model->page_description = $preview['description'];
# $model->page_thumbnail_url = $preview['cover'];


# これはつまり、array にtitle、description、coverといったキーが含まれており、それぞれ取り出すことでメタ情報をデータベースに保存しているわけです。また、これらのキーはLinkPreviewクラスが内部で利用しているDusterio\LinkPreview\Clientパッケージの仕様です。

#^ つまり、CreateBookmarkUseCase を実装しているときに、Dusterio\LinkPreview\Clientの仕様を理解していないといけません。

# それでは切り分けた意味が無いといえませんか？

#^ クラスを切り分けるメリットは、それぞれのクラスが自分がやるべき責務に集中できることです。せっかく切り分けたのにも関わらず、返り値がただの array ですと、受け取った側が array の中に何が入っているかいちいち調べなければなりません。

# PHP でプログラムをある程度書いたことのある方であれば、大きな array を関数の引数として渡したり、返り値として受け取ってしまったことでソースコードを追うのが大変になった経験が 1 度はあるのではないでしょうか。

# このときに私がおすすめするリファクタ手法は、引数や返り値専用のクラスを作ることです。

# 今回はgetメソッドの返り値専用のクラスを作ります。


# ............

# 以下のコマンドを実行してGetLinkPreviewResponse.phpファイルを作成してください。

# touch src/app/Lib/LinkPreview/GetLinkPreviewResponse.php


# 作成したGetLinkPreviewResponse.phpファイルに以下を記述してください。

# <?php
# namespace App\Lib\LinkPreview;

# final class GetLinkPreviewResponse
# {
#     public string $title;
#     public string $description;
#     public string $cover;

#     public function __construct(string $title, string $description, string $cover)
#     {
#         $this->title = $title;
#         $this->description = $description;
#         $this->cover = $cover;
#     }
# }


# 続いてsrc/app/Lib/LinkPreview/LinkPreview.phpを編集します。

# <?php
# namespace App\Lib\LinkPreview;

# use Dusterio\LinkPreview\Client;

# final class LinkPreview
# {
#     // public function get(string $url): array
#     public function get(string $url): GetLinkPreviewResponse
#     {
#         $previewClient = new Client($url);
#         $response = $previewClient->getPreview('general')->toArray();

#         // return $previewClient->getPreview('general')->toArray();
#         return new GetLinkPreviewResponse($response['title'], $response['description'], $response['cover']);
#     }
# }


# get メソッドの返り値がGetLinkPreviewResponseになっていることがわかります。

# そして、get メソッド内で連想配列からGetLinkPreviewResponseへの詰替えを行っています。

#^ こうすることで、title、description、cover といったキーがあるというDusterio\LinkPreview\Clientの仕様が get メソッド内に閉じ込められていることが分かります。

#^ 加えて、もしライブラリの仕様が変更になり返ってくるキーの名前が変わったとしても、LinkPreviewクラスを書き換えるだけで済むメリットもありますね。

#^ このように、自分でクラスを作ってライブラリ特有の値を詰め替えることで、影響範囲を狭めたり、ライブラリ特有の知識を色々なクラスを実装する時に気を使わなくて良くなるというメリットがあります。


# 最後にCreateBookmarkUseCaseを書き換えましょう。

# <?php
# /**
#  * 中略
# **/
# final class CreateBookmarkUseCase
# {
#     /**
#      * 中略
#     **/
#     public function handle(string $url, int $category, string $comment)
#     {
#         // 下記のサービスでも同様のことが実現できる
#         // @see https://www.linkpreview.net/
#         $previewClient = new Client($url);
#         try {
#             $preview = (new LinkPreview())->get($url);

#             $model = new Bookmark();
#             $model->url = $url;
#             $model->category_id = $category;
#             $model->user_id = Auth::id();
#             $model->comment = $comment;
#             // $model->page_title = $preview['title'];
#             // $model->page_description = $preview['description'];
#             // $model->page_thumbnail_url = $preview['cover'];
#             $model->page_title = $preview->title;
#             $model->page_description = $preview->description;
#             $model->page_thumbnail_url = $preview->cover;
#             $model->save();
#         } catch (\Exception $e) {
#             Log::error($e->getMessage());
#             throw ValidationException::withMessages([
#                 'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
#             ]);
#         }
#     }
# }


# クラスにすると嬉しい点として、エディタで入力中に補完が効くことです(※1)。クラスを使うことで、CreateBookmarkUseCase.phpを実装している時にDusterio\LinkPreview\Clientに仕様を追いに行くことがなくなります。


# --------------------

# ※1: クラスでなくても、連想配列等でも上手く PHPDocs 等でコメントを書き込むことで各要素の型をエディタで補完させることが(おそらく)可能です。が、クラスを作ってしまったほうが PHP の土俵の上で書けるため、個人的にはこのやり方が好みです


# **** 切り出したクラスに対応するインターフェースを定義しよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1195/parts/4698


# 前節で切り出したLinkPreviewクラスに対応したインターフェースを定義しましょう。
# 本来はインターフェースを定義してから実装クラスを作成するのですが、今回はリファクタリングのため、後からインターフェースを定義する順で進めます。

#^ インターフェースを定義する理由は、クラスを差し替えることを可能にするためです。

# この時点では目的がよく分からないかもしれませんが、とにかく定義してみましょう。


# --------------------

#~ インターフェースについて

# PHP 公式マニュアル オブジェクトインターフェース
# https://www.php.net/manual/ja/language.oop5.interfaces.php


#^ インターフェースでは、メソッドの名前、引数、戻り値といった仕様だけを定義します。具体的なメソッドの実装は定義しません。

# interface iTemplate
# {
#     public function setVariable(string $name, string $var): void;
#     public function getHtml(string $template): string;
# }


# そして、インターフェースを実装したいクラスでは、以下の条件を満たす必要があります。

#^・クラス名の後にimplements {インターフェース名}と書きます
#^・少なくともインターフェースで定義されているメソッドと互換性があるメソッドを実装しなければなりません（※1）。

# class Template implements iTemplate
# {
#     private $vars = array();

#     public function setVariable(string $name, string $var): void
#     {
#         $this->vars[$name] = $var;
#     }

#     public function getHtml(string $template): string
#     {
#         foreach($this->vars as $name => $value) {
#             $template = str_replace('{' . $name . '}', $value, $template);
#         }

#         return $template;
#     }
# }


# 以下、本教材ではインターフェースを実装したクラス（ここではTemplateクラス）を実装クラスと呼びます。


#^ ※1 「互換性がある」というのは、正確にはインターフェースの各メソッドと全く同じ仕様（シグネチャ）を実装しなければならないわけではなく、”リスコフの置換原則”を満たしている仕様であればクラスで実装可能です（ドキュメント）。しかし、紛らわしいので最初は全く同じ引数や戻り値の型で定義するのに慣れましょう。
# https://www.php.net/manual/ja/language.oop5.basic.php#language.oop.lsp


# **** インターフェースの定義と implements の追記 ****

# それではインターフェースの定義と implements の追記をおこないます。

# 以下のコマンドを実行してLinkPreviewInterface.phpファイルを作成してください。

# touch src/app/Lib/LinkPreview/LinkPreviewInterface.php


# 作成したLinkPreviewInterface.phpファイルを以下のように編集してください。

# <?php

# namespace App\Lib\LinkPreview;

# interface LinkPreviewInterface
# {
#     public function get(string $url): GetLinkPreviewResponse;
# }


# そして、LinkPreview.phpを開き、LinkPreviewInterfaceを implements するように宣言を書き換えてください。

# <?php
# namespace App\Lib\LinkPreview;

# use Dusterio\LinkPreview\Client;

#  // final class LinkPreview
#  final class LinkPreview implements LinkPreviewInterface
# {
#     public function get(string $url): GetLinkPreviewResponse
#     {
#         $previewClient = new Client($url);
#         $response = $previewClient->getPreview('general')->toArray();

#         return new GetLinkPreviewResponse($response['title'], $response['description'], $response['cover']);
#     }
# }


# implements LinkPreviewInterfaceを書き加えています（同じディレクトリ内に置いたので use 文の追加は不要です）。

# これにより、LinkPreviewクラスのgetメソッドは

#^ 必ずgetという名前で、string型の引数を受け取りGetLinkPreviewResponse型の値を返す

# と決まりました。なぜならLinkPreviewInterfaceでそう書かれているからです。


# たとえば戻り値の型を?GetLinkPreviewResponseに変えてしまったら、（エディタによりますが）赤線が引かれてエラーになってしまうことがわかります。インターフェースの実装クラスとして宣言することで、ある種の”縛り”が掛かった状態になるとも言えますね。

# →　interfaceを使えばメソッドに対して型定義みたなことができる。


# **** インターフェースと実装クラスの比較 ****

# インターフェースと、そのインターフェースを実装したクラスを作成しました。最後にこれらの比較をしてみましょう。

# まずLinkPreviewInterfaceですが、このソースコードを読んでみますと、「string型の変数を受け取ったら、GetLinkPreviewResponse型の戻り値を返すgetメソッドがある」ことがわかりますね。

# 続いてその実装クラスであるLinkPreviewクラスを読んでみますと、「string型の変数を受け取ったら、 Dusterio\LinkPreview\Clientクラスを利用してメタ情報を取得し、 GetLinkPreviewResponse型の戻り値を返すgetメソッドがある」ことがわかります。

#^ ざっくり説明すると、インターフェースは「何を受け取って何を返すか(What)」という責任のみを持っていますが、実装クラスは加えて「どうやって実現するか(How)」という責任も持っていると言うことができます。

#^ 逆に言えば、インターフェースはクラスに比べて「どうやって実現するか」という責任が欠けていると言うこともできます。

#^ 責任が欠けている、という言い回しは欠点にも聞こえますが、実はクラス設計においては持っている責任が少ないことのほうが好都合な場合が多いです。

# この点を頭の隅に置きながら読み進めていってください。


# インターフェースのこの性質を活用することで、 実際には”外部サービス”へアクセスしなくてもテストができる状態を実現することができますので、引き続き実装を進めていきましょう。


# **** CreateBookmarkUseCase をインターフェースに依存させよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1195/parts/4699


# 本節ではCreateBookmarkUseCaseがLinkPreviewInterfaceに依存するようにリファクタリングします。

# 急に「依存する」という言い方が出てきましたね。まずは「依存するってどういうこと？」について解説します。


# --------------------

#~ (プログラミングにおける)依存とは？

# A が B に依存している、とはどういう状況のことを指すのでしょうか。

# たとえば「どうしても空いた時間に SNS のタイムラインを眺めずには居られない」という人を「SNS に依存している」と言いますね（私です）。極端に言えば SNS がなければ生きられないような状況というわけです。

# プログラミングにおける依存も同じような意味です。
# 「A が B に依存している」とは「B が削除されたら A は生きられない(≒ エラーになって動作しない)」とか「B の仕様が変わったら A も追従しなければならない」といった状況のことを指します。

# 分かりやすく言えば、PHP においては、クラス A にてクラス B をuseしている状態が「A が B に依存している」といえます。

# これを念頭に置いて、次節以降を読み進めてください。


# --------------------

#~ CreateBookmarkUseCase と LinkPreview の依存関係

# さて、それではまず CreateBookmarkUseCase と LinkPreview の関係性について考えてみましょう。

# CreateBookmarkUseCaseを今すぐ削除したり、中身を書き換えたりしてもLinkPreviewの動作には全く影響がありません。

# しかし、LinkPreviewを削除するとCreateBookmarkUseCaseはエラーになってしまいます。削除ほどでなくても、getメソッドの引数の仕様などが変わった場合も修正が必要です。


# LinkPreview.phpを削除すれば、CreateBookmarkUseCase.phpのこの行でエラーになるでしょう
# $preview = (new LinkPreview())->get($url);


# よって、CreateBookmarkUseCase は LinkPreviewに依存しています。

# LinkPreviewクラスはDusterio\LinkPreview\Clientに依存しているため、CreateBookmarkUseCaseは必ずDusterio\LinkPreview\Clientを利用することになるといえます。これでは 実在する URL へアクセスせずにテストすることは難しいです。


# --------------------

#~ CreateBookmarkUseCase を LinkPreviewInterface に依存させる

# 以下のようにCreateBookmarkUseCase.phpを修正してください。

# <?php

# namespace App\Bookmark\UseCase;

# // use App\Lib\LinkPreview\LinkPreview;
# use App\Lib\LinkPreview\LinkPreviewInterface;
# use App\Models\Bookmark;
# use Illuminate\Support\Facades\Auth;
# use Illuminate\Support\Facades\Log;
# use Illuminate\Validation\ValidationException;

# final class CreateBookmarkUseCase
# {
#     private LinkPreviewInterface $linkPreview;

#     public function __construct(LinkPreviewInterface $linkPreview)
#     {
#         $this->linkPreview = $linkPreview;
#     }

#     /**
#      * (コメント略)
#      */
#     public function handle(string $url, int $category, string $comment)
#     {
#         try {
#             // $preview = (new LinkPreview())->get($url);
#             $preview = $this->linkPreview->get($url);

#             $model = new Bookmark();
#             $model->url = $url;
#             $model->category_id = $category;
#             $model->user_id = Auth::id();
#             $model->comment = $comment;
#             $model->page_title = $preview->title;
#             $model->page_description = $preview->description;
#             $model->page_thumbnail_url = $preview->cover;
#             $model->save();
#         } catch (\Exception $e) {
#             Log::error($e->getMessage());
#             throw ValidationException::withMessages([
#                 'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
#             ]);
#         }
#     }
# }


# ちょっと多めに変更を加えました。

#・private LinkPreviewInterface $linkPreview;とし、LinkPreviewInterface型のメンバ変数を持たせる
#・コンストラクタで$linkPreviewを初期化する。コンストラクタの引数でLinkPreviewInterface型の変数を受け取るように実装する
#・$preview = $this->linkPreview->get($url);のように、LinkPreviewInterface型のメンバ変数を使って処理を実行する

# けっこうな量の変更を施しましたが、改めて上記のソースコードを眺めていただくと、LinkPreviewへの依存がなくなっていることがお分かりでしょうか。
# その代わり LinkPreviewInterfaceへ依存しています。

# LinkPreviewInterfaceにも当然ながらgetメソッドがあるわけなので、$preview = $this->linkPreview->get($url);は文法的に問題のない書き方です。


# --------------------

#~ 動作確認とエラーの修正

# ここまで修正した時点でブックマーク投稿をサイト上から試してみましょう！

# ブックマーク作成ページから投稿ボタンを押すと、以下のエラーが表示されます。

# Too few arguments to function App\Bookmark\UseCase\CreateBookmarkUseCase::__construct(), 0 passed in /opt/laravel-bookmark/app/Http/Controllers/Bookmarks/BookmarkController.php on line 109 and exactly 1 expected

# このエラーの末尾にあるBookmarkController.php on line 116という記載を見ると、Controller でエラーが起きていることが分かります(行番号は環境によって異なります。実際の行を参考にしてください)。

# エラーが示している行は、BookmarkControllerの以下の行を指し示しているはずです。

# $useCase = new CreateBookmarkUseCase();


# エラーの冒頭にToo few argumentsとある通り、引数(arguments)が少なすぎるというエラーですね。CreateBookmarkUseCaseのコンストラクタに先程引数を追加しましたので、引数が足りなくなってしまいました。

# public function __construct(LinkPreviewInterface $linkPreview)
# {
#     $this->linkPreview = $linkPreview;
# }


# それではBookmarkControllerを開き、createメソッドを以下のように修正しましょう。

# <?php

# namespace App\Http\Controllers\Bookmarks;

#  use App\Lib\LinkPreview\LinkPreview;
# // 中略

# class BookmarkController extends Controller
# {
#     // 中略

#     public function create(CreateBookmarkRequest $request)
#     {
#         // $useCase = new CreateBookmarkUseCase();
#         $useCase = new CreateBookmarkUseCase(new LinkPreview());
#         $useCase->handle($request->url, $request->category, $request->comment);

#         // 暫定的に成功時は一覧ページへ
#         return redirect('/bookmarks', 302);
#     }
#     // 中略
# }


# コンストラクタの引数はLinkPreviewInterface型の値を渡す必要がありますが、ここではLinkPreviewInterfaceを implements したLinkPreviewクラスのインスタンスを渡しています。

#^ あるインターフェースを引数の型としているメソッドには、そのインターフェースを実装しているクラスを渡すことができます。

# 前節では「インターフェースを実装しているクラスでは、少なくともインターフェースで定義されているメソッドと互換性があるメソッドを実装しなければなりません」と説明しました。LinkPreviewがgetメソッドを実装していることは、PHP の文法によって担保されています。だからこそ、今回のように引数の型をインターフェースにしておいて、実際に使うときは実装したクラスのインスタンスを渡すことが可能なのです。

#^ このように、メソッドの引数の型はインターフェースとして宣言しているけど、実際にそのメソッドを使うときはインターフェースを実装したクラスのインスタンスを渡す、というのは常套手段ですのでぜひ覚えてください。

# ここまで実装した上でブックマーク投稿をやり直してみてください。上手く行けば成功です。


# --------------------

#~ 依存関係がどう変わったか？

# ここまでの実装によって、以下のように依存関係が変わりました。


# CreateBookmarkUseCaseではLinkPreviewを use していないため、依存関係がなくなっています。代わりに LinkPreviewInterfaceに依存 していますね。

# むしろBookmarkControllerが直接LinkPreviewに依存しています。

# また、LinkPreviewとLinkPreviewInterfaceにも依存関係は存在します（Interface を削除したら実装クラスは落ちる）ので、区別できるよう別の形状の矢印をつなげています。


# --------------------

#~ 本節のまとめ

# 本節のポイントは、CreateBookmarkUseCaseには、LinkPreviewInterfaceを実装したクラスならなんでも渡せるようになったことです。

# そして、インターフェースを実装するときはメソッドの引数や戻り値だけ従っておけば良くて、具体的にどうやって処理するか(How)は自由でした。

# つまり、当初の目的だった「モック」（本章におけるモックとは実在する URL にアクセスしないクラスのことでしたね）への差し替えが可能になったということです。


# **** 実際に外部アクセスはしない「モック」を作成しよう ****

# 前節までの実装によって、CreateBookmarkUseCaseがLinkPreviewInterfaceに依存している状況を作り出しました。そして、Controller からLinkPreviewクラスのインスタンスを生成し、渡すことで動作させました。

# ここからより核心に向けて実装を進めていきます。

# そもそも目的は実在する URL へアクセスせずにテストができる状態を実現することでした。ついに本節ではその立役者となる「モック」を開発します。


# --------------------

#~ MockLinkPreview.php の作成

# 以下のコマンドを実行してMockLinkPreview.phpファイルを作成してください。

# touch src/app/Lib/LinkPreview/MockLinkPreview.php


# 作成したMockLinkPreview.phpファイルを以下のように編集してください。

# <?php
# namespace App\Lib\LinkPreview;

# final class MockLinkPreview implements LinkPreviewInterface
# {
#     public function get(string $url): GetLinkPreviewResponse
#     {
#         return new GetLinkPreviewResponse(
#             'モックのタイトル',
#             'モックのdescription',
#             'https://i.gyazo.com/634f77ea66b5e522e7afb9f1d1dd75cb.png'
#         );
#     }
# }


# ポイントは 2 つです。

#・LinkPreviewInterface を 実装している
#・引数の URL は使わず、必ず固定の内容でGetLinkPreviewResponseを返している

# モックはテストのために仮の動作をさせるプログラムなので、中身は外部サービスへのアクセスをすること無く固定の内容を返すようにしています。ただしインターフェースは実装しているので、getメソッドの仕様はしっかり守っています。


# --------------------

#~ 試しにモックを動かしてみよう

# MockLinkPreviewはLinkPreviewInterfaceを 実装しているため、CreateBookmarkUseCaseの引数にnew MockLinkPreview()を渡してもエラーにはなりません。試しに実装してみましょう。

# src/app/Http/Controllers/Bookmarks/BookmarkController.phpファイルを以下のように編集してください。


# <?php

# // 中略

# use Illuminate\View\View;
#   use App\Lib\LinkPreview\MockLinkPreview;

# class BookmarkController extends Controller
# {
#     // 中略

#     public function create(CreateBookmarkRequest $request)
#     {
#         // $useCase = new CreateBookmarkUseCase(new LinkPreview());
#         $useCase = new CreateBookmarkUseCase(new MockLinkPreview());
#         $useCase->handle($request->url, $request->category, $request->comment);

#         // 暫定的に成功時は一覧ページへ
#         return redirect('/bookmarks', 302);
#     }
#     // 中略
# }


# 実装後、再度ブックマーク作成画面を開き、適当な URL とコメント、カテゴリを入力して送信してみてください。

# MockLinkPreviewが動いているため、何を投稿しても以下スクリーンショットのように固定の画像、タイトル、Description が投稿されてしまいます。


# これでMockLinkPreviewは意図したとおり動作していることがわかりました。

# ポイントは、CreateBookmarkUseCaseの中身は一切実装を変えていないのに、メタ情報取得処理がモックに置き換わっていることです。

# ということは、CreateBookmarkUseCaseのテストをしたいなと思ったら、テストケースに応じてモッククラスを実装し、CreateBookmarkUseCaseへ渡して実行してみたらいいのです。


# --------------------

#~ 依存関係を整理してみよう

# ここまでの依存関係を整理してみましょう。前節と比べて、MockLinkPreviewに差し替わっていることが分かりますし、Dusterio\LinkPreviewライブラリへの依存がなくなっていることが分かります。つまり外部サービスへのアクセスもないということです。


# --------------------

#~ 本節までで達成したこと

# 達成できた内容を振り返ります。

#^・クラス同士が依存するのではなく、インターフェース(=LinkPreviewInterface)に依存するようにした
#^・インターフェースを実装したクラス(=LinkPreview, MockLinkPreview)のインスタンスを、外部のクラス(=Controller)から受け取るようにした

# ここまで進めれば Controller を書き換えるだけで「モックに差し替える」ことができます。
#^ 本節のリファクタリングによって、UseCase を書き換えずにモックが動くように実装を差し替えることができました。

#^ あるクラスが依存している実装クラスを、そのクラスの外側から渡すようにするだけで、テストコードを書くときなどにモックのクラスに差し替えて渡して動かすことができるので大変便利になります。

#! ただしまだ課題は残っています。その課題とは実際にモックを動かすために Controller を手動で書き換えなければならない点です。手動で書き換えなければならない箇所が残っている以上、テストコードを書いて動作確認することはできません。

# 実は Controller も UseCase も書き換えることなく、モックにしたりしなかったりを切り替えられる方法が存在します。それを実現してようやく、テストコードで臨機応変にモックに差し替えることが可能になります。

# その方法がサービスコンテナという Laravel が用意してくれている仕組みです。このサービスコンテナを使いこなすことで、クラス間の依存をインターフェースで整理した努力が報われます。

# 次節にてサービスコンテナの解説をします。


# **** サービスコンテナとサービスプロバイダを使ってみよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1195/parts/4701


# 前章までのリファクタリングによって、クラス間の依存関係を整理し、UseCase がインターフェースに依存するようにしました。

# ただ一応まだ課題点は残っており、実際にモックを動かすためには Controller を書き換えなければならない悩みがありました。

# 本章ではサービスコンテナとサービスプロバイダを使うことにより、Controller までもがインターフェースに依存した状況を作ります。


# --------------------

#~ サービスコンテナとサービスプロバイダの定義

#? サービスコンテナとは、Laravel 上で実行されるクラスを依存解決する仕組みです。そして、サービスプロバイダは Laravel のあらゆる処理の開始前にセットアップを行うクラスで、サービスコンテナに対して依存解決の方法を指示できます。

#? 依存解決をとてもざっくり説明すると、クラスを渡すとインスタンスを生成した上で返してくれたり、インターフェースを渡すとその実装クラスのインスタンスを生成した上で返してくれることです。

# 説明を読んで考えるより、実際に動かしたほうが体で覚えることができるので話を進めましょう。


# --------------------

#~ メソッドインジェクション

# 実はサービスコンテナは Laravel の開発者であれば日常的に使っています。
# それは Controller のアクションメソッドで使われている「メソッドインジェクション」です。

# 以下のソースは前節でリファクタリングしたcreateメソッドです。


# public function create(CreateBookmarkRequest $request)
# {
# 	$useCase = new CreateBookmarkUseCase(new LinkPreview());
# 	$useCase->handle($request->url, $request->category, $request->comment);

# 	// 暫定的に成功時は一覧ページへ
# 	return redirect('/bookmarks', 302);
# }


# createメソッドの第 1 引数に FormRequest を拡張したCreateBookmarkRequestが渡されていますが、私たちはいつcreateメソッドの第 1 引数にCreateBookmarkRequest型の値を渡すという実装をしたでしょうか？

# 考えてみると引数に指定するだけでそのクラスのインスタンスが渡ってくるというのは変な話です。Controller 以外で、自分で作ったクラスであればその呼び出し側でちゃんと引数を渡してあげなければエラーになるわけですから。

# ここで利用されているのが「メソッドインジェクション」です。
#^ Controller のメソッドの引数に型を明示しておくと、Controller が実行されるタイミングでサービスコンテナがそのクラスのインスタンスを生成して（つまり、依存解決して）渡してくれています（※1）。

#^ メソッドの引数で指定したクラスのインスタンスをインジェクション（渡す）しているのでメソッドインジェクションと呼びます。


# ................

# ※1 どうして？って思った方のためにちょっと詳しく説明します。Laravel の Controller はサービスコンテナを介して実行されているのです。サービスコンテナを介して実行されている全てのクラスではサービスコンテナの機能が使えます。そのため Laravel の Controller および Controller から呼ばれるクラスでは、メソッドインジェクションが使えます。以下に簡単に図解してみましたが、さらに気になった方は本教材を読み終わったあと、public/index.phpから順に追っていくと仕組みがある程度見えてくると思います。


# --------------------

#~ CreateBookmarkUseCase をメソッドインジェクションしてみる

# さて、CreateBookmarkRequest は引数に指定するだけでメソッドインジェクションされ、createメソッドへとインスタンスが渡ってきました。CreateBookmarkUseCaseを引数に指定するとどうなるか実験してみましょう。
# 同様にメソッドインジェクションしてくれるでしょうか。

# BookmarkControllerのcreateメソッドを以下のように編集してください。


#  * @param CreateBookmarkRequest $request
#  * @param CreateBookmarkUseCase $useCase <- 一応、ここのコメントをちゃんと追記しておきましょう
#  * @return Application|\Illuminate\Http\RedirectResponse|\Illuminate\Routing\Redirector
#  * @throws ValidationException
#  */
# // public function create(CreateBookmarkRequest $request)
# public function create(CreateBookmarkRequest $request, CreateBookmarkUseCase $useCase)
# {
#     // $useCase = new CreateBookmarkUseCase(new MockLinkPreview());
#     $useCase->handle($request->url, $request->category, $request->comment);

#     // 暫定的に成功時は一覧ページへ
#     return redirect('/bookmarks', 302);
# }


# 以上のように、第 2 引数にCreateBookmarkUseCase $useCaseなどと書けばメソッドインジェクションの実装は完了です。変数名は何でも良いのですがこれまでが$useCaseだったので合わせました。

# さて、ぜひ一度ここまで実装が終わった状況でブラウザを開き、ブックマーク作成を行ってください。

# しかし投稿したタイミングで以下のエラーが出てしまいました。

# Illuminate\Contracts\Container\BindingResolutionException
# Target [App\Lib\LinkPreview\LinkPreviewInterface] is not instantiable while building [App\Bookmark\UseCase\CreateBookmarkUseCase].

# 英語を読んでみますと、BindingResolutionExceptionは Binding が「結びつける」、Resolution が「解決する」といった意味でしょうか。つまり、結びつけようとしたが解決できなかったので例外を投げました、という意味の命名に読み取れますね。

# 続いて、LinkPreviewInterface is not instantiableというのはLinkPreviewInterfaceをインスタンスにできませんでしたという意味のようですね。あくまでインスタンスにできるのは実装クラスだけなので、インターフェースをインスタンス化しようとしたら失敗するに決まっています。

# それではこのエラーの原因を考えてみましょう。


# --------------------

#~ サービスコンテナは実装クラスの場所を知らない

# これまでは以下のように、CreateBookmarkUseCaseのインスタンスを作るときの引数にはLinkPreviewInterfaceの実装クラスを渡していました。

# $useCase = new CreateBookmarkUseCase(new MockLinkPreview());
# または
# $useCase = new CreateBookmarkUseCase(new LinkPreview());


# しかしサービスコンテナは、LinkPreviewInterfaceの実装クラスがどこにあるかなんて知りません。そのため、メソッドインジェクションするためにCreateBookmarkUseCase型の値を作ろうとすると以下のコンストラクタを実行しようとし、そしてインターフェースに対応する実装クラスが見つかりませんというエラーを出してしまうわけです。

# /**
#  * CreateBookmarkUseCase constructor.
#  * @param LinkPreviewInterface $linkPreview
#  */
# public function __construct(LinkPreviewInterface $linkPreview)
# {
#     $this->linkPreview = $linkPreview;
# }


# ということで、仕上げとしてサービスコンテナに実装クラスの場所を教えてあげる必要があります。


# --------------------

#~ サービスプロバイダを使い、サービスコンテナに実装クラスの場所を教える


# サービスコンテナに対して実装クラスを教えるために、少しだけ追加で実装する必要があります。その実装場所は、一般的にはsrc/app/Providers/AppServiceProvider.phpを選ぶことが多いです。

# このクラスの名前を見れば分かる通り、まさにサービスプロバイダというクラスの正体がAppServiceProviderを始めとするHogeHogeServiceProviderクラスです（※1）。

# サービスプロバイダはあらゆる処理に先立って実行されます。なのであらかじめサービスコンテナにインターフェースと実装クラスの紐付けについて教えておくことができます

# AppServiceProviderを開き、以下のように実装しましょう。


# <?php

# namespace App\Providers;

# use Illuminate\Support\ServiceProvider;

# class AppServiceProvider extends ServiceProvider
# {
#     /**
#      * Register any application services.
#      *
#      * @return void
#      */
#     public function register()
#     {
#         $this->app->bind(\App\Lib\LinkPreview\LinkPreviewInterface::class, \App\Lib\LinkPreview\LinkPreview::class);
#     }

#     /**
#      * Bootstrap any application services.
#      *
#      * @return void
#      */
#     public function boot()
#     {
#     }
# }


# 追加したのは以下の 1 行のみです。

# $this->app->bind(\App\Lib\LinkPreview\LinkPreviewInterface::class, \App\Lib\LinkPreview\LinkPreview::class);

# $this->app->bindというメソッドを実行していますが、このメソッドの定義を確認してみると以下のようにIlluminate\Contracts\Container\Containerインターフェースに属しているメソッドであることが分かります。この名前の通り、bindメソッドはサービスコンテナのメソッドです。


#^ 以上のように、第 1 引数にインターフェース、第 2 引数にそのインターフェースを実装したクラスを指定することで、サービスコンテナに「LinkPreviewInterfaceが求められたときはLinkPreviewクラスのインスタンスを生成して渡してください」と教えることができます。


# ここまで実装した状態で、再度ブックマーク作成を実行すると、無事にブックマークが作成できます。

# サービスコンテナがLinkPreviewInterfaceとLinkPreviewの結びつきを知っている状態で実行できるので、メソッドインジェクションのためにnew CreateBookmarkUseCaseしたときにコンストラクタを正常に実行できます。



# ここで$linkPreviewにはサービスコンテナを介して、LinkPreviewのインスタンスが渡ってきている
# public function __construct(LinkPreviewInterface $linkPreview)
# {
#     $this->linkPreview = $linkPreview;
# }


#^ このときコンストラクタで指定したインターフェースの実装クラスがインジェクションされているため、この機能をコンストラクタインジェクションと呼びます。本節で紹介したメソッドインジェクションとコンストラクタインジェクションが、サービスコンテナとサービスプロバイダによる代表的な機能です。


# ................

# ※1 src/app/Providers/RouteServiceProvider.phpといった、ルーティングに関する初期設定をするサービスプロバイダもあります。このように、サービスコンテナはサービスプロバイダによってその価値を発揮しますが、サービスプロバイダ自体は Laravel 全体の心臓部として動作しているため、サービスコンテナ以外にも使いどころがあります。


# ................

# MockLinkPreviewを結びつけてみる:

# サービスコンテナのbindメソッドがきちんと結びつける役割を果たしているかどうか、AppServiceProvider.phpの編集箇所を以下のように書き換えて動作検証しましょう。

#  // $this->app->bind(\App\Lib\LinkPreview\LinkPreviewInterface::class, \App\Lib\LinkPreview\LinkPreview::class);
#  $this->app->bind(\App\Lib\LinkPreview\LinkPreviewInterface::class, \App\Lib\LinkPreview\MockLinkPreview::class);


# この状態で実行すると、MockLinkPreviewが動くため、どんな内容を投稿しても同じ内容がブックマークされるはずです。


# ここで$linkPreviewにはサービスコンテナを介して、MockLinkPreviewのインスタンスが渡ってきている
# public function __construct(LinkPreviewInterface $linkPreview)
# {
# 	$this->linkPreview = $linkPreview;
# }


# --------------------

#~ サービスコンテナによって整理された依存関係

# 本節で学習したサービスコンテナによって、クラス間の依存関係は以下のように整理されました。


# BookmarkControllerとCreateBookmarkUseCaseといった私たちプログラマが実装するクラスは、LinkPreviewInterfaceの実装クラスには一切依存していません。そのため、サービスコンテナの設定次第でモックにも本物のクラスにも差し替えができます。

# ここまで準備が整えば、次章でテストコードを書く時に「テスト実行時のみモックに差し替える」ことができるようになります。

# 次章に進む前に、ぜひ各節の末尾に用意した依存関係の図をもう一度見直して、実装内容とその依存関係が整理されていく流れを覚えてください。


# --------------------

#~ 依存関係を整理するテスタビリティ以外のメリット

# サービスコンテナを利用するメリットをもう 1 つ解説します。

#^ それはサービスリリース後、別のライブラリや外部サービスにリプレイスすることが決まったときの影響範囲を小さくできることです。

# たとえば、Dusterio\LinkPreview\Clientライブラリが非推奨になってしまい、別のライブラリでメタ情報取得処理を実行したい！と開発方針が決まったとします。
# あちこちで直接LinkPreviewクラスを呼んでいれば、その利用箇所すべてが影響範囲になってしまいます。

# しかしそんな場合でもサービスコンテナを利用していることで、ソースコードの変更箇所が最小限になります。

#^ 具体的に言うと、NewLinkPreview implements LinkPreviewInterfaceといった内容のクラスを作成し、新しいライブラリを使ってメタ情報取得処理を実装します。そしてサービスコンテナでの$this->app->bind()メソッドの第 2 引数をNewLinkPreviewに修正すれば、Controller や UseCase の修正は全く必要ありません。

# 実際には、変更すべきクラスはもっと多岐にわたるでしょうから、サービスコンテナで差し替えるだけでいつでも大規模な変更が可能になっているというのはとても心強いわけです。

#^ このように、インターフェースに切り分けて引数や返り値も整備しておけば変更に強い設計も可能になります。

# 以上で本章は終わりになります。
# 5 章のテストコードもセットで学習することで、これまでの学習内容が真価を発揮します。ラストスパート頑張っていきましょう！


# ==== 5章 : テストコードを書いて品質維持できる体制を作ろう！ ====

# **** テストコードの書き方 ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1196/parts/4702


# 本章ではテストコードの書き方を解説します。前章までで紹介した、ユースケースクラスの切り分けや FormRequest、Middleware の利用、サービスコンテナによる依存関係の整理を駆使すれば Fat Controller を卒業することはできます。

# ここに加えてテストコードをしっかり書ききることが保守性の高いアプリケーション開発において重要なポイントです。


# --------------------

#~ どうしてテストコードを書くの？


# 一般的にテストコードを書くことの恩恵は、ソースコードを一度リリースして運用フェーズに入ったあとに実感することができます。

# ある時点で実装したソースコードに対して、「こういう入力を与えるとこういう結果になる」ことがテストコードの形で記述されていれば、別の機能を実装した際にそのテストコードを実行すればデグレしていないことをかなり高い確度で証明できます（もちろん絶対バグが起きないとは言い切れないですよ）。

# 新機能を実装したときにその機能が動作するのは当たり前です。本当に怖いのは、いつの間にか既存の機能に影響していることです。テストコードを実装のたびに書き続け、加えてテストコードを自動で実行する体制（CI と呼ばれます）を整えておけば、リリース前や Pull Request のタイミングでデグレに気がつくことができます。


# ちなみにある程度慣れてくると、クラスを分割して開発しつつ、細かい粒度でテストコードを書くことで確実に動作確認しながら進める開発スタイルを実践できます。すると仕事の段取り自体を改善していくことができたりしますので、デグレ対策だけではなく純粋に開発効率の改善にも繋がります。

# Fat Controller を卒業したあとは、ぜひテストコードを書くことも習慣づけていただきたいという思いで、本章を書いていきます。


# --------------------

#~ テストコードを書くための段取り

# テストコードを書けるようになるためには、以下のような手順を進める必要があります。

# 〜テストコードを書き始める前に〜

# 1. テストフレームワークを選ぶ
# 2. テストコードを書くためのディレクトリ構造や、命名規則を決める
# 3. テストコードの基底クラスを作成する


# 〜テストコードを書く〜

# 1. テストコードを書くディレクトリを決める
# 2. テストしたい内容を決める
# 3. テストコードを書き、実行する
# 4. テストしたい内容をすべてカバーできるまで 3.を繰り返す


# 〜テストコードを運用する〜

# 1. テストコードを自動実行する技術を選ぶ
# 2. 自動実行の設定を行う


# これら 3 つが完了すれば、あとは日々の開発でテストコードを書いていくことができます。

# 本節では 1 つ目の「テストコードを書き始める前に」について解説します


# --------------------

#~ テストフレームワークを選ぶ

# テストフレームワークとは、テストコードを実行するためのフレームワークです。

# メジャーな言語にはテストフレームワークがたいてい存在しています。または Rust などのように言語そのものにテストコードを実行する機能が内包されている言語もあります。

# PHP におけるテストフレームワークでは PHPUnit がよく知られているため、本章では PHPUnit について解説します。

# ちなみにpestという PHP のテストフレームワークも話題に上がることがあるため、興味がある方はチェックしてみるといいでしょう。

# PHPUnit
# https://phpunit.readthedocs.io/ja/latest/

# pest
# https://pestphp.com/docs/installation


# --------------------

#~ テストコードを書くためのディレクトリ構造や、命名規則を決める

# Laravel においては、慣例としてプロジェクトルートディレクトリにtestsというディレクトリを切ってその中にテストを書いていきます。ブックマーク投稿サイトでもその慣例に従ってtestsディレクトリを作っています。

# また、PHPUnitで実装するテストコードのクラス名は必ず末尾がTestになっている必要があります。もしテストコードを書いたはずなのに実行されない、といったトラブルが発生したら命名規則に従っているかを疑ってみてください。


# --------------------

#~ テストコードの基底クラスを作成する

# PHPUnit でテストコードを書く場合は、基本的にはPHPUnit\Framework\TestCaseクラスを拡張したクラスでテストを書きます。PHPUnit\Framework\TestCaseクラスには 2 つの値を比較するメソッドなどが定義されており、便利にテストを書くことができます。

#^ しかし実務でテストを書く場合においては、開発しているシステムや運用フローの都合で「あらゆるテストに共通してこの動作をさせたい」といった要望が発生するかもしれません。その場合は、PHPUnit\Framework\TestCaseを拡張した独自のクラスを作成し、そのクラスをさらに拡張することで各テストを書きましょう。

# なお、Laravel で PHPUnit を使う場合は Tests\TestCaseクラスが用意されており、ここで Laravel 独自の環境などのセットアップが行われていることから、Tests\TestCaseを拡張したクラスでテストを書きます。


# **** ブックマーク一覧ユースケースのテストを書こう ****

# 本節ではブックマーク一覧ユースケースのテストを実装します。


# --------------------

#~ 画面単位のテストを書くか、ユースケースのテストを書くか

# ブックマーク一覧ユースケースのテストを書くのではなく、ブックマーク一覧画面（https://localhost/bookmarks ）のテストコードを書くことも可能です。


#^ これらの違いを簡単に説明します。ユースケースのテストでは、 PHP で定義した値を入力として与えて PHP で定義した値を出力として得ることで、理想とする値を比較してテストをします。対して Web 上に表示される画面のテストをする際は、HTML をスクレイピングしてその中に含まれている文字列が正しいかをテストします。


# laravel/duskというライブラリを使うことで HTML を読み込んだテストも可能になります。しかし HTML の中身を読み取るテストはテスト範囲が広くなり解説する内容がブレることになります。そのため本教材では HTML を使ったテストは実施せずに進めていきます。


# Laravel 6.x Laravel Dusk
# https://readouble.com/laravel/6.x/ja/dusk.html


# ユースケースのテストでは、テストコードでShowBookmarkListPageUseCase.phpを直接実行します。ShowBookmarkListPageUseCaseの返り値は配列なので、何も外部のライブラリを使わなくてもテストコードを書くことが可能です。


# もしlaravel/duskを使う場合は、以下のように「訪れるページの URL」「表示したい DOM を特定する ID など」「確認したいテキスト」を指定することでテストできます。

# $this->browse(function ($browser) use ($user) {
#     $browser->visit('/pay')
#             ->scrollToElement('#credit-card-details')
#             ->assertSee('Enter Credit Card Details');
# });


# --------------------

#~ ユースケース単位のテストを書いてみよう


# ⑴ テストケースを書くディレクトリとファイルの作成

# ユースケースのテストは機能（Feature）のテストです。よって Feature ディレクトリの下に、Bookmarks という名前のディレクトリを切ります（※1）。

# mkdir -p src/tests/Feature/Bookmarks

# touch src/tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php

# or
# m mktest model=Bookmarks/ShowBookmarkListPageUseCase


# ※1 テストコードを配置するディレクトリ名に標準的な規約はありませんので、プロジェクトで個別にルールを定めてください。筆者自身は複数クラスのテストを Feature、1 つのクラスのみのテストを Unit というディレクトリ以下に置いています。今回のユースケースのテストでは、結果としてデータの保存を行う Eloquent Model が正しくデータを保存できているかのテストも含まれていることから、Feature ディレクトリ以下に置いています。


# ....................

# ⑵ テストケースの記述

# テストケースは一旦以下のところまで書いてみてください。

# src/tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php
# <?php

# namespace Tests\Feature\Bookmarks;

# use App\Bookmark\UseCase\ShowBookmarkListPageUseCase;
# use Artesaos\SEOTools\Facades\SEOTools;
# use Tests\TestCase;

# class ShowBookmarkListPageUseCaseTest extends TestCase
# {
#     private ShowBookmarkListPageUseCase $useCase;

#     /**
#      * setUpメソッドは、各テストケース(testXXXという名前のメソッド)が
#      * 実行される前に毎回実行されます。
#      * なので、テストデータのセットアップや利用するクラスの初期化を行うのに最適です
#      */
#     protected function setUp(): void
#     {
#         parent::setUp();

#         $this->useCase = new ShowBookmarkListPageUseCase();
#     }

#     public function testResponseIsCorrect()
#     {
#         /**
#          * SEOについて
#          * ・<title>タグの中身が正しく設定されていること
#          * ・<meta description>の中身が正しく設定されていること
#          */
#         SEOTools::shouldReceive('setTitle')->withArgs(['ブックマーク一覧'])->once();
#         SEOTools::shouldReceive('setDescription')->withArgs(['技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。HTML、CSS、JavaScript、Rust、Goなど、気になる分野のブックマークに絞って調べることもできます'])->once();

#         // シンプルにユースケースを実行する
#         $response = $this->useCase->handle();

#         /**
#          * テストすること
#          * ・ブックマーク一覧について：10件取得できていること、最新順で10件になっていること
#          * ・トップカテゴリーについて：10件取得できていること、内容が投稿数順になっていること
#          * ・トップユーザーについて：10人取得できていること、内容が投稿数順になっていること
#          */
#         self::assertCount(10, $response['bookmarks']);
#     }
# }


# ....................

# ⑶ テストコードの実行

# 以下コマンドを実行してください。phpunitコマンドがPHPUnitフレームワークによって提供されており、そのコマンドを通してテストコードを記述した PHP ファイルを実行することで、テスト結果の集計を得ることができたり、いくつものファイルを同時にテストすることができます。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php

# or
# m app → vendor/bin/phpunit tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php


# 実行結果が以下のようになれば OK です。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# .                                                                   1 / 1 (100%)

# Time: 530 ms, Memory: 18.00 MB

# OK (1 test, 3 assertions)


# 最後の行にOK (1 test, 3 assertions)と書いてあります。これは「テストが書かれたクラスが 1 つでした。そして合計 3 つのアサーション(assertion)を実行しました」という意味です。

# assertion とは、1 つ 1 つの実際のテスト内容のことを指します。ここまで書いたテストケースで 3 つのテストケースが実行されたというわけです。

# 続いて、テストコードの内容について軽く解説していきます。


# ....................

# テストコードの解説：Facade(ファサード):

# さっそくですが本節の内容はプラスアルファな内容になりますので、理解できなくても大丈夫です。知っておくと Laravel 周辺ライブラリを使ったコードのテストを書くときに有用だと思います。

# 以下の 2 行のテストコードについて説明します。


# SEOTools::shouldReceive('setTitle')->withArgs(['ブックマーク一覧'])->once();
# SEOTools::shouldReceive('setDescription')->withArgs(['技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。HTML、CSS、JavaScript、Rust、Goなど、気になる分野のブックマークに絞って調べることもできます'])->once();


# こちらのテストコードは、 SEOToolsクラスがsetTitleおよびsetDescriptionメソッドを正しい引数で呼び出していることをテストしています。
# ユースケースクラスを見返してみると、以下のように書かれていました。


# src/app/Bookmark/UseCase/ShowBookmarkListPageUseCase.php
# SEOTools::setTitle('ブックマーク一覧');
# SEOTools::setDescription("技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。{$top_categories->pluck('display_name')->slice(0, 5)->join('、')}など、気になる分野のブックマークに絞って調べることもできます");


# テストコードで使っているshouldReceiveメソッドは、SEOToolsクラスに実装されているメソッドです。テストコードで実行すると「指定したメソッドがどんな引数で、何回呼び出されるか」をテストすることができます。
# 今回どうしてこれらのテストをしなければいけないかはsetDescriptionメソッドが実行している内容を見ていただけると理解しやすいと思います。

# ユースケースでは引数内に{$top_categories->pluck('display_name')->slice(0, 5)->join('、')}といったように、動的に文字列が生成されている箇所がありますね。ここがもし今後誰かの改修時に誤ってslice(0, 50)のように書き換わってしまったら<meta>タグの内容が意図せず変更されてしまいます。

# そのため、テストコードでは、動的に生成されている部分をHTML、CSS、JavaScript、Rust、Goとあえて固定の文字列で記述しています。
# テストコード実行時には Laravel のシーダーが実行されますので、ここのテストの結果は必ず上記のプログラミング言語の並びになります。


# src/app/Bookmark/UseCase/ShowBookmarkListPageUseCase.php
# したがって、以下のようにShowBookmarkListPageUseCase.phpを書き換えてテストを再実行してみると、きちんとテストコードは失敗します。

# -        SEOTools::setDescription("技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。{$top_categories->pluck('display_name')->slice(0, 5)->join('、')}など、気になる分野のブックマークに絞って調べることもできます");
# +        SEOTools::setDescription("技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。{$top_categories->pluck('display_name')->slice(0, 50)->join('、')}など、気になる分野のブックマークに絞って調べることもできます");


# 上記のように書き換えたら以下のコマンドを実行してください。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php


# 以下のようなメッセージが表示され、テストコードが失敗したことがわかります。


# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# E                                                                   1 / 1 (100%)

# Time: 1.03 seconds, Memory: 18.00 MB

# There was 1 error:

# 1) Tests\Feature\Bookmarks\ShowBookmarkListPageUseCaseTest::testResponseIsCorrect
# Mockery\Exception\NoMatchingExpectationException: No matching handler found for Mockery_0_Artesaos_SEOTools_SEOTools::setDescription('技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。HTML、CSS、JavaScript、Rust、Go、Java、C#、PHP、TypeScript、Pythonなど、気になる分野のブックマークに絞って調べることもできます'). Either the method was unexpected or its arguments matched no expected argument list for this method

# 失敗したことが確認できたら、編集したコードをもとに戻しておいてください。


# さて、shouldReceiveメソッドはSEOToolsに限った話ではありません。Laravel の Facade(ファサード)という仕組みを使っているクラスであれば外部のライブラリであっても、自分が開発したクラスであってもテストコードで活用ができます。


# Laravel 6.x ファサード
# https://readouble.com/laravel/6.x/ja/facades.html

#^ ただ自分で Facade を使った実装をできるには必要な手順が多いため、慣れるまでチャレンジしないことをおすすめします。Facade を使っているライブラリを利用する場合のみ、今回紹介したテスト技法を使いましょう。


# ....................

#& 補足: $top_categories->pluck('display_name')->slice(0, 5)->join('、')の意味

# bookmark_categoriesのdisplay_nameカラムに登録にされている上位の10件のデータのみをpluck()を使って配列として取り出し、さらにslice(0, 5)で先頭から5件のデータを配列として取り出し、join('、')で'、'を区切り文字として5件の配列に含まれる値を文字列として結合している。


# Laravel 5.5 コレクション
# https://readouble.com/laravel/5.5/ja/collections.html

# pluck()
# pluckメソッドは指定したキーの全コレクション値を取得します。

# slice()
# sliceメソッドは指定したインデックスからコレクションを切り分けます。

# join()


# ....................

# テストコードの解説：assertCount:

# self::assertCount(10, $response['bookmarks']);


# assertCountメソッドはPHPUnitが用意しているメソッドです。
# 第 1 引数に開発者が期待しているカウント数、第 2 引数にカウントを測定したい配列（などのカウント可能な変数）を指定すると、合っているか合っていないかを判定してくれます。
# PHPUnitが用意しているメソッドを使うことで、assertが成功したら Success 扱い、失敗したら Fail 扱いにして最後に集計結果を出してくれます。
# そのため、テストコードではテストしたい内容を原則assert系のメソッドを使って書きましょう。

# ついでにassertCountメソッドがどこに定義されているのか少し追ってみましょう。実装したテストケースをよく見ると、PHPUnit のTestCaseクラスを継承しています。


# use Tests\TestCase;

# class ShowBookmarkListPageUseCaseTest extends TestCase


# このTestCaseの定義をたどっていくと、assertCountメソッドの実装にたどり着くことができます。最終的にsrc/vendor/phpunit/phpunit/src/Framework/Assert.phpに行き着くことができますので、ぜひ読んでみてください。

# さて、PHPUnit を使いこなすためにはこういったassertHogeメソッドをいくつか把握しておくことが重要です。

# すべてのリストは公式ドキュメントをご覧いただくとして、ここでは最も基本となるassertSameメソッドの解説をします。

# 1. アサーション
# https://phpunit.readthedocs.io/ja/latest/assertions.html

# assertSameメソッドは渡した 2 つの引数が完全に一致しているかどうかをテストします。

# そのため、ShowBookmarkListPageUseCase.phpのテストは以下のように書き換えても成功します。ぜひ手元で動かしてみてください。

# // self::assertCount(10, $response['bookmarks']);
# self::assertSame(10, count($response['bookmarks']));


#^ 極端に言えば、assertSameさえ使えばたいていのテストコードを書くことができます。しかしassertCountといった個別の assert メソッドを適宜使ったほうが読み手に目的が通じやすいですし、 かつテストが失敗した時のエラーメッセージもわかりやすく出力されます。そのため、使える場面では積極的にassertSame以外のメソッドを使いましょう。

#^ また、assertSameでテストを書けない事例で言いますと、配列や文字列のなかに特定の値が含まれているかどうかテストするassertContainsメソッドなどもあります。これらは実際のテストコードを書きながら覚えておくと良いと思います。


# ....................

# ⑷ テストケースを増やす

# この調子でShowBookmarkListPageUseCaseTest.phpにテストコードを増やした結果が以下になります。実際に手元で書き加えて実行してください。


# public function testResponseIsCorrect()
# {
# 	/**
# 		* SEOについて
# 		* ・<title>タグの中身が正しく設定されていること
# 		* ・<meta description>の中身が正しく設定されていること
# 		*/
# 	SEOTools::shouldReceive('setTitle')->withArgs(['ブックマーク一覧'])->once();
# 	SEOTools::shouldReceive('setDescription')->withArgs(['技術分野に特化したブックマーク一覧です。みんなが投稿した技術分野のブックマークが投稿順に並んでいます。HTML、CSS、JavaScript、Rust、Goなど、気になる分野のブックマークに絞って調べることもできます'])->once();

# 	$response = $this->useCase->handle();

# 	/**
# 		* テストすること
# 		* ・ブックマーク一覧について：10件取得できていること、最新順で10件になっていること
# 		* ・トップカテゴリーについて：10件取得できていること、内容が投稿数順になっていること
# 		* ・トップユーザーについて：10人取得できていること、内容が投稿数順になっていること
# 		*/
# 	self::assertCount(10, $response['bookmarks']);

# 	// 以下が追加した内容です！
# 	self::assertCount(10, $response['top_categories']);
# 	self::assertCount(10, $response['top_users']);

# 	// bookmarksの中身を軽くチェック。IDが大きい順に格納されていればOK
# 	for ($i = 100; $i > 90; $i--) {
# 		self::assertSame($i, $response['bookmarks'][100 - $i]->id);
# 	}

# 	// top_categoriesの中身を軽くチェック。IDが小さい順に格納されていればOK
# 	for ($i = 1; $i < 10; $i++) {
# 		self::assertSame($i, $response['top_categories'][$i - 1]->id);
# 	}

# 	// top_usersの中身を軽くチェック。IDが小さい順に格納されていればOK
# 	for ($i = 1; $i < 10; $i++) {
# 		self::assertSame($i, $response['top_users'][$i - 1]->id);
# 	}
# }


# 後半の assertSame メソッドは、src/database/seeds/BookmarkSeeder.phpに記述しているテストデータがそのままデータベースに入っていることが前提です。ブックマークを投稿するユーザーや、ブックマークが投稿されるカテゴリをバラけさせることでランキングの結果を常に同じにして、テストを書きやすくしています。

# 実際は Seeder を使ってもいいですし、ファクトリを使ってテストケースごとにテスト用のデータを生成してもいいでしょう。


# Laravel 8.x データベーステスト
# https://readouble.com/laravel/8.x/ja/database-testing.html


# 以下のコマンドを実行してください。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php


# 実行していただければわかりますが、このままだとテストが失敗してしまいます。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# F                                                                   1 / 1 (100%)

# Time: 762 ms, Memory: 18.00 MB

# There was 1 failure:

# 1) Tests\Feature\Bookmarks\ShowBookmarkListPageUseCaseTest::testResponseIsCorrect
# Failed asserting that 5 is identical to 4.

# /opt/laravel-bookmark/tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php:54

# FAILURES!
# Tests: 1, Assertions: 28, Failures: 1.


# テストコードを書いてテストが失敗することは悲しむべきことではなく、むしろ本稼働させる前にバグの予兆を発見できて喜ばしいことです。

# テストが失敗したと表示されている 54 行目を見てみましょう。


# self::assertSame($i, $response['top_users'][$i - 1]->id);


# Failed asserting that 5 is identical to 4.とエラーメッセージにありますので、4 であるとテストしようとしたら実際は 5 でした、ということで assert に失敗していることがわかります。

# top_usersのテストで失敗しているため、ブックマーク数の多いユーザー順に取得しているときに、意図しない動きになっています。

# そこでBookmarkSeeder.phpを改めて読み直し、どんなデータを生成していたのかを確認しましょう。


# /**
#  * シーダーの内容
#  * ・投稿者となるユーザーアカウントを30人作る
#  * ・ブックマークのカテゴリを30個作る
#  * ・ブックマークを100件作る
#  *
#  * ・ユーザーごとに、作成するブックマークは1,2,5,5,10,10,17,20,30,残りは0
#  * ・ブックマークのカテゴリは多い順に13,12,11,10,9,9,8,...,1,残りは0
#  */

# ユーザーごとに、作成するブックマークは1,2,5,5,10,10,17,20,30,残りは0とありますので、投稿数が多い順にユーザーを並べたときに投稿数 10 のユーザーが 2 名、4 位タイで並ぶことがわかりますね。この事実とエラーメッセージを紐付けて考えますと、ブックマーク投稿数が同数で並んだユーザーが取得される順番が ID 順になっていないためにテストが失敗しました。

# 実際には、同率のときにどの順でソートすべきかはビジネスサイドと話し合って決めるべきですが、ここでは同率なら ID が小さいユーザーが勝つと決めてしまいましょう。

# ということでShowBookmarkListPageUseCaseに戻り、同率だったときに ID 順で取得するようにクエリを修正しましょう。


# // $top_users = User::query()->withCount('bookmarks')->orderBy('bookmarks_count', 'desc')->take(10)->get();
# $top_users = User::query()->withCount('bookmarks')->orderBy('bookmarks_count', 'desc')->orderBy('id')->take(10)->get();


# これでテストを動かすとすべて成功します。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/ShowBookmarkListPageUseCaseTest.php

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# .                                                                   1 / 1 (100%)

# Time: 805 ms, Memory: 18.00 MB

# OK (1 test, 33 assertions)


# このように、テストを書くことと、実装することをある意味同時並行で進めていくことで、仕様の抜け漏れやバグの予兆に気がつくことができますので、ぜひテストコードの記述に慣れて日頃から実践してください。


# ....................

# 次節へ向けて:

# 今回は表示のテストだったのでデータを取得できるかどうかのテストでした。次節では更新処理のテストとして、ブックマーク作成ユースケースのテストコードを書きます。

# 前章で学習したサービスコンテナがここにきてついに活用されますので、楽しみに進めてください。


# **** ブックマーク作成ユースケースのテストを書こう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1196/parts/4704


# 本節では、 4 章でサービスコンテナを活用してモック化などの解説をしたブックマーク作成ユースケースCreateBookmarkUseCaseのテストを実装します。

# テストコードでもサービスコンテナを活用してモックに差し替えることができます！という話をしますので、内容を忘れてしまったという方は事前にさらっと見直しておいてください。


# --------------------

#~ ベースとなるテストケースのコード

# まずはファイルを作成します。

# touch src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php


# src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php
# <?php

# namespace Tests\Feature\Bookmarks;

# use App\Bookmark\UseCase\CreateBookmarkUseCase;
# use App\Lib\LinkPreview\LinkPreview;
# use App\Lib\LinkPreview\LinkPreviewInterface;
# use App\Lib\LinkPreview\MockLinkPreview;
# use App\Models\BookmarkCategory;
# use App\Models\User;
# use Illuminate\Support\Facades\Auth;
# use Tests\TestCase;

# class CreateBookmarkUseCaseTest extends TestCase
# {
#     private CreateBookmarkUseCase $useCase;

#     protected function setUp(): void
#     {
#         parent::setUp();

#         $this->useCase = new CreateBookmarkUseCase();
#     }

#     public function testSaveCorrectData()
#     {
#         // 念のため絶対に存在しないURL（example.comは使えないドメインなので）を使う
#         $url = 'https://notfound.example.com/';
#         $category = BookmarkCategory::query()->first()->id;
#         $comment = 'テスト用のコメント';

#         // ログインしないと失敗するので強制ログイン
#         $testUser = User::query()->first();
#         Auth::loginUsingId($testUser->id);

#         $this->useCase->handle($url, $category, $comment);

#         Auth::logout();

#         // データベースに保存された値を期待したとおりかどうかチェックする
#         $this->assertDatabaseHas('bookmarks', [
#             'url' => $url,
#             'category_id' => $category,
#             'user_id' => $testUser->id,
#             'comment' => $comment,
#             'page_title' => 'モックのタイトル',
#             'page_description' => 'モックのdescription',
#             'page_thumbnail_url' => 'https://i.gyazo.com/634f77ea66b5e522e7afb9f1d1dd75cb.png',
#         ]);
#     }
# }


# サービスコンテナの説明をする前に簡単にテストコードそのものの解説をします。


# ........................

# テストで URL を使うとき

# テストコードで URL やメールアドレスを使うときは、example.comを使うのがおすすめです。このドメインは取得することができない、必ず実在しないドメインですので、テスト用に安心して使うことができます（※1）。

# https://datatracker.ietf.org/doc/html/rfc2606#section-3

# 4-2 節で説明したとおり、外部サービスへのアクセスをテストコードで書くことには問題がありますので、今回はそれを禁じつつテストできる範囲でテストコードを書きましょう。そのためには存在しない URL を指定しつつ、全体としては無事に動作させなければいけません。


# ........................

# assertDatabaseHas

# 今回は更新処理のテストですので、最終的にデータベースに意図した値が保存できているのか？をテストすることが必要です。
# 第 1 引数がテーブル名で、第 2 引数にカラム名をキーに値を指定した連想配列を渡すことでテストができます。
# 今回は bookmarks テーブルに、たとえばcommentカラムにテスト用のコメントが保存されていることなどをテストできるわけです。
# page_titleカラムなどに指定されている文字列を見るとネタバレになっているかもしれませんが、見なかったことにしてください。

# 保存されているデータと、連想配列の内容に齟齬があればしっかりテストが失敗してくれます。
# 余裕のある方は、引数に渡っている配列を少し書き換えて実行してみるといいでしょう。


# --------------------

#~ 1 度目の実行

# 本テストコードの実行コマンドは以下のとおりです。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php


# しかし実行するとこちらのテストコードは以下のように失敗します。毎度のことながら、テストコードが成功するために何度か失敗する様子を一緒に追体験していければと思います。


# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# E                                                                   1 / 1 (100%)

# Time: 716 ms, Memory: 16.00 MB

# There was 1 error:

# 1) Tests\Feature\Bookmarks\CreateBookmarkUseCaseTest::testSaveCorrectData
# ArgumentCountError: Too few arguments to function App\Bookmark\UseCase\CreateBookmarkUseCase::__construct(), 0 passed in /opt/laravel-bookmark/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php on line 23 and exactly 1 expected

# /opt/laravel-bookmark/app/Bookmark/UseCase/CreateBookmarkUseCase.php:19
# /opt/laravel-bookmark/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php:23

# ERRORS!
# Tests: 1, Assertions: 0, Errors: 1.


# これは初歩的ですが、Too few argumentsとある通り、以下のコードでCreateBookmarkUseCaseに引数を渡していないことが原因です。


# --------------------

#~ 2 度目の実行

# それではCreateBookmarkUseCaseTest.phpを開き、引数にLinkPreviewクラスを渡しましょう。これで仕様上は問題ないはずですね。

# src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php

# $this->useCase = new CreateBookmarkUseCase();
# ↓
# $this->useCase = new CreateBookmarkUseCase(new LinkPreview());


# しかし実行すると相変わらず失敗してしまいます。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# E                                                                   1 / 1 (100%)

# Time: 1.25 seconds, Memory: 20.00 MB

# There was 1 error:

# 1) Tests\Feature\Bookmarks\CreateBookmarkUseCaseTest::testSaveCorrectData
# Illuminate\Validation\ValidationException: The given data was invalid.

# /opt/laravel-bookmark/vendor/laravel/framework/src/Illuminate/Validation/ValidationException.php:71
# /opt/laravel-bookmark/app/Bookmark/UseCase/CreateBookmarkUseCase.php:57
# /opt/laravel-bookmark/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php:47


# よく見るとエラーの内容が先程と異なります。CreateBookmarkUseCase.php:57とありますので、該当の行を見てみますと、

# throw ValidationException::withMessages([
# 	'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
# ]);


# とありますので、どうやら URL からメタ情報を取得する過程で失敗したみたいですね。

# これは当然のことです。なぜなら存在しない URL を引数に渡しており、メタ情報を取得できなかったからです。

# $url = 'https://notfound.example.com/';


# --------------------

#~ 3 度目の実行

# ここで MockLinkPreview クラスの出番です。このクラスは実際の URL へアクセスせずにどんな引数に対しても固定の値を返してくるのでした。

# CreateBookmarkUseCaseTest.phpを開いて以下のように修正しましょう。


# src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php

# $this->useCase = new CreateBookmarkUseCase(new LinkPreview();
# ↓
# $this->useCase = new CreateBookmarkUseCase(new MockLinkPreview());


# これで、めでたくテストの実行結果が通ります。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# .                                                                   1 / 1 (100%)

# Time: 1.08 seconds, Memory: 18.00 MB

# OK (1 test, 1 assertion)


# 改めてassertDatabaseHasの内容を見てみますと、MockLinkPreviewの戻り値がデータベースに入っていることをテストできています。

# $this->assertDatabaseHas('bookmarks', [
# 	'url' => $url,
# 	'category_id' => $category,
# 	'user_id' => $testUser->id,
# 	'comment' => $comment,
# 	'page_title' => 'モックのタイトル',
# 	'page_description' => 'モックのdescription',
# 	'page_thumbnail_url' => 'https://i.gyazo.com/634f77ea66b5e522e7afb9f1d1dd75cb.png',
# ]);


# つまり、MockLinkPreviewを使うようにCreateBookmarkUseCaseに指定した上でテストコードを実行すれば、実際の URL にアクセスすることなく、それ以外の機能（データベースに意図したとおりに値を保存している！）ことがテストできるわけです。

# しかしこのやり方には落とし穴があり、もっと良いテストコードの実装方法があります。それを次節で説明しましょう。


# --------------------

#~ 4 度目の実行（最終結果）

# 今回のケースでもっとも良いテストコードの実装方法は以下のとおりです。CreateBookmarkUseCaseTest.phpを修正しましょう。


# src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php
# $this->useCase = new CreateBookmarkUseCase(new MockLinkPreview());
# ↓
# $this->app->bind(LinkPreviewInterface::class, MockLinkPreview::class);
# $this->useCase = $this->app->make(CreateBookmarkUseCase::class);


# ....................

# まず$this->app->bind(LinkPreviewInterface::class, MockLinkPreview::class);の実装について解説します。これは前章でsrc/app/Providers/AppServiceProvider.phpに実装した以下の内容と酷似していますね。


# src/app/Providers/AppServiceProvider.php
# $this->app->bind(\App\Lib\LinkPreview\LinkPreviewInterface::class, \App\Lib\LinkPreview\LinkPreview::class);


# おさらいですが、AppServiceProviderに上記のようにbindしたから、前章では UseCase が LinkPreviewInterface にのみ依存する形で実装できたわけです。実際に実行されるクラスはLinkPreviewInterfaceを実装したLinkPreviewになるようにAppServiceProviderでbindメソッドを実行しています。

# テストコードでもAppServiceProviderが実行されたあとにテストが実行されるためLinkPreviewが動作します。しかしsetupメソッド内などでそのbindを上書きすることができます。

# 今回はテストコードの実行前に bindメソッドを再度実行することで、MockLinkPreviewに差し替わった状態でテストコードを実行できました。この”差し替える”という感覚にはぜひ慣れていただければと思います。


# ....................

# 続いて$this->useCase = $this->app->make(CreateBookmarkUseCase::class);の部分について解説します。

# これまで useCase はnew HogeHoge($何らかの引数)の形で初期化してきましたので、この書き方は見慣れないと思います。

#^ $this->app->makeメソッドを使ってクラスのインスタンスを生成すると、サービスコンテナ経由でインスタンスを得ることができます 。つまり、依存解決したうえでインスタンスを生成できます。

#^ 以下のユースケースの生成処理部分を見ていただきたいのですが、引数にLinkPreviewInterface型のインスタンスを渡さなくてもよくなっています。

# $this->useCase = new CreateBookmarkUseCase(new MockLinkPreview());
# ⇔
# $this->useCase = $this->app->make(CreateBookmarkUseCase::class);


#^ $this->app->makeメソッドによりサービスコンテナ経由でクラスのインスタンスを取得すると、そのクラスが依存している Interface の実装クラスを適切に探しだした（=依存解決した）上でコンストラクタに渡すことができます。あらかじめbindしたものから探してきているわけです。

#^ ちなみにサービスコンテナの凄い点として、依存解決した先の実装クラスがまた別の Interface などに依存していても依存解決を続けてくれる点があります。今回の例ですと、LinkPreviewクラスがコンストラクタでまた別の Interface に依存していたとしても、再帰的にサービスコンテナが適切なクラスを探してきてくれます（もちろんAppServiceProviderで bind している前提です）。

#^ サービスコンテナを使えば使うほど、ソースコード上からnewが減っていきます。newを使っているということは、使っているクラスと呼び出されているクラスが、Interface を介さず直接お互いに依存しているということ。つまりテスタビリティが低いということなのです。


# --------------------

#~ エラーハンドリングをテストしよう

# さて、モック化のメリットを知っていただくためにもう一つ事例を挙げようと思います。

# それは「エラーハンドリングのテスト」です。

# 外部サービスを利用している部分は、利用している外部サービスで障害が発生してもできるだけ影響範囲を小さくすることが必要です。

# ということで外部サービスが落ちてしまってもユーザーに対してエラーメッセージが返せているかなどをテストすることは必要なわけですが、そのために実際に外部サービスを落とすわけにはいきませんね。

# そこで「必ずメタ情報の取得に失敗する LinkPreview クラス」をモックで作成することで、メタ情報の取得に失敗したときの挙動もテストしましょう。CreateBookmarkUseCaseTest.phpを修正してください。


# src/tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php
# // 以下を追加
# use Illuminate\Validation\ValidationException;

# // 中略

#     public function testWhenFetchMetaFailed()
#     {
#         $url = 'https://notfound.example.com/';
#         $category = BookmarkCategory::query()->first()->id;
#         $comment = 'テスト用のコメント';

#         // これまでと違ってMockeryというライブラリでモックを用意する
#         $mock = \Mockery::mock(LinkPreviewInterface::class);

#         // 作ったモックがgetメソッドを実行したら必ず例外を投げるように仕込む
#         $mock->shouldReceive('get')
#             ->withArgs([$url])
#             ->andThrow(new \Exception('URLからメタ情報の取得に失敗'))
#             ->once();

#         // サービスコンテナに$mockを使うように命令する
#         $this->app->instance(
#             LinkPreviewInterface::class,
#             $mock
#         );

#         // 例外が投げられることのテストは以下のように書く
#         $this->expectException(ValidationException::class);
#         $this->expectExceptionObject(ValidationException::withMessages([
#             'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
#         ]));

#         // 仕込みが終わったので実際の処理を実行
#         $this->useCase = $this->app->make(CreateBookmarkUseCase::class);
#         $this->useCase->handle($url, $category, $comment);
#     }


# これまでは MockLinkPreviewといったモック用のクラスを作りましたが、今回は簡易的にMockeryというライブラリでモックを生成しています。

# 作ったモックを$mockという変数に代入したあとは、shouldReceiveで実行するメソッド名を指定、withArgsでメソッドが受け取る引数を指定します。

# 最後に例外を投げることも指定しておくと、これでこのモックは必ず例外を投げるLinkPreviewInterfaceの実装クラスとして機能することになります。

# もちろん以下のように例外が必ず起こる実装クラスを作っても OK ですが、毎回作るのも面倒です。私は実際テストコードを書くときは Mockery を使うことのほうが多いです。余力があれば実装クラスの方法でもテストコードを書いてみてください。


# <?php
# namespace App\Lib\LinkPreview;

# final class ErrorLinkPreview implements LinkPreviewInterface
# {
#     public function get(string $url): GetLinkPreviewResponse
#     {
#         throw new \Exception('URLからメタ情報の取得に失敗');
#     }
# }



# さて、作成したモックを利用するようにサービスコンテナに指定する必要がありますので、以下のように実装します。

# $this->app->instance(
# 	LinkPreviewInterface::class,
# 	$mock
# );


#^ ポイントとしては bind メソッドではなく instance メソッドを使うことです。
#^ bind メソッドのときは第 2 引数がXXXClass::classといったクラス名を示す文字列でしたが、今回は実際に$mock という変数に作ったモックの”実体”が入っているため利用するメソッドを変える必要があります。

# ここまでお膳立てが終われば、あとは PHPUnit の記法に則って例外のテストをすればいいです。


# // 例外が投げられることのテストは以下のように書く
# $this->expectException(ValidationException::class);
# $this->expectExceptionObject(ValidationException::withMessages([
# 	'url' => 'URLが存在しない等の理由で読み込めませんでした。変更して再度投稿してください'
# ]));

# // 仕込みが終わったので実際の処理を実行
# $this->useCase = $this->app->make(CreateBookmarkUseCase::class);
# $this->useCase->handle($url, $category, $comment);


# ここまで書いたらテストを再度実行してみましょう。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/CreateBookmarkUseCaseTest.php


# 以下のようなメッセージが表示されます。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# ..                                                                  2 / 2 (100%)

# Time: 2.03 seconds, Memory: 34.01 MB

# OK (2 tests, 5 assertions)



# 今回はテストメソッドが 2 つあったので2 testsとなっています。

#^ クラス間の依存関係を Interface にしておくことで、テストで柔軟に処理内容を差し替えられて色々なパターンのテストが書けることが分かっていただけたと思います。

#^・サービスコンテナを使ってインスタンスを差し替え可能にすること
#^・日頃から new を使ってインスタンスを初期化せず、できるだけメソッドインジェクションなどでサービスコンテナ経由でインスタンスを得ること（※もちろん、密結合になっても構わないようなクラスをわざわざインジェクションさせる必要はありません。最低でも外部サービスへのアクセスだけは守って欲しいところです）

# このあたりを心がけていただければと思います。

# 次節ではテストコードの自動化について解説します。


# ................

#! Mockery mock() Expected type 'object'. Found 'string'.intelephense(1006)

# Splat based method definition - Expected type 'object'. Found 'string'. #2153
# https://github.com/bmewburn/vscode-intelephense/issues/2153

# Intelephense thinks Mockery::mock() returns a string #1784
# https://github.com/bmewburn/vscode-intelephense/issues/1784


# **** GitHub Actions でテストコードを自動化しよう ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1196/parts/4705


# 本節ではPHPUnitで書いたテストコードをGitHub Actionsを使って自動化します。

# 自動化することで、develop ブランチへの Pull Request が出されたタイミングなどにこれまで書いたテストコードをすべて実行し直してエラーが起きないかチェックできます。

# テストコードを自動化する活動のことを CI(Continuous Integration の略) と呼びます。


# --------------------

#~ テストコードを自動で実行するメリット

# テストコードを自動化すると、デグレの検知をより行いやすくなります。

# わざわざ自動化していなくてもデグレの検知は可能です。毎回 develop ブランチや master ブランチにマージする前にこれまで書いたすべてのテストコードを実行すればいいのですから。

# しかし手動で実行する運用には人間特有のミスである「実行するのを忘れたままリリースしてしまった」といった”うっかりミス”や「この小さなプルリクでまさかデグレしてしまうとは」といった油断が生じるリスクがあります。自動化しておくことでそれらのミスをなくすことができます。

# たった 1 行のミスでさえシステムの停止に繋がってしまうプログラミングだからこそ、毎回のテストコード実行は自動化しておきたいのです。


# --------------------

#~ GitHub Actions のメリット

# テストコードの自動化を行う方法には複数の選択肢がありますが、本教材ではGitHub Actionsを紹介します。

# GitHub Actionsは GitHub を使っている方であれば環境のセットアップが不要で使い始めることができます。それに私の知っている範囲では他の CI ツールのセットアップ方法と大きな差が無いため、GitHub Actionsを 1 回学んでおくと職場環境によって他のツールで CI を行うときにも知識の横展開が可能だと感じています。


# --------------------

#~ テスト実行用の yaml 設定ファイルを書く

# GitHub Actionsの設定ファイルは、ソースリポジトリの中に配置し、以下のような項目を書きます。

#・どのタイミングで実行したいか
#・どんな環境で実行したいか
#・どんなコマンドを実行したいか

# GitHub Actionsはテストコードを実行するためだけのサービスではなく、GitHub 上で行われる特定のアクションの際に特定の環境上で指定したコマンドを実行してその結果を得られるサービスです。それをテストコード実行のために使っている、という構図だと考えてください。

# テストコードを実行させるためには以下のように考えれば OK です。

#・master ブランチへ Pull Request が出されたときに
#・PHP7.4 と MySQL8.0 の環境で
#・PHPUnitのテストコマンドを実行する

# それではまずGitHub Actionsの設定ファイルを置くディレクトリを作成しましょう。この位置に設定ファイルを置くことはルールで決まっています。


# mkdir -p .github/workflows

# 続いてphpunit.ymlというファイル名で以下の内容を記述しましょう。

# touch .github/workflows/phpunit.yml

# name: PHPUnit GitHub Actions Test

# on:
#   pull_request:
#     branches:
#       - master

# defaults:
#   run:
#     working-directory: src

# jobs:
#   run-test:
#     runs-on: ubuntu-latest

#     container:
#       image: kirschbaumdevelopment/laravel-test-runner:7.4

#     services:
#       mysql:
#         image: mysql:8.0
#         env:
#           MYSQL_ROOT_PASSWORD: secret
#           MYSQL_DATABASE: laravel-bookmark
#         ports:
#           - 33306:3306
#         options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3

#     steps:
#       - uses: actions/checkout@v1

#       - name: Install dependencies
#         run: composer install --prefer-dist --no-progress --no-suggest

#       - name: Migrate And Setup
#         run: cp .env.ci .env && php artisan key:generate && php artisan migrate && php artisan db:seed --class=DatabaseSeeder && chmod -R 777 storage

#       - name: Run test suite
#         run: composer run-script test


# 詳細な文法は公式リファレンスを参照いただくとして、ここではざっくり何を指定しているのかを解説します。

#& Workflow syntax for GitHub Actions
#& https://docs.github.com/ja/actions/using-workflows/workflow-syntax-for-github-actions


# ....................

# on:
#   pull_request:
#     branches:
#       - master

# master ブランチへの Pull Request のタイミングで実行することを指定しています。main ブランチを利用していればここを書き換えれば OK です。


# ....................

# container:
#   image: kirschbaumdevelopment/laravel-test-runner:7.4

# services:
#   mysql:
#     image: mysql:8.0
#     env:
#       MYSQL_ROOT_PASSWORD: secret
#       MYSQL_DATABASE: laravel-bookmark
#     ports:
#       - 33306:3306
#     options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3


# laravel-test-runnerを利用して Laravel 環境のセットアップを行いつつ、MySQL8.0 のコンテナも起動しています。もしアプリケーションで Redis など他のミドルウェアを使っていてテストコードで必要なのであれば、ここで追記してそれらも起動します。


#& kirschbaum-development/laravel-test-runner-container
#& https://github.com/kirschbaum-development/laravel-test-runner-container


# ....................

# - name: Install dependencies
#   run: composer install --prefer-dist --no-progress --no-suggest

# - name: Migrate And Setup
#   run: cp .env.ci .env && php artisan key:generate && php artisan migrate && php artisan db:seed --class=DatabaseSeeder && chmod -R 777 storage

#^ GitHub Actionsは GitHub が用意している環境で実行されるため、実行のたびにcomposer installや.envファイルの設定を行わなければなりません（これらをキャッシュする方法もあるので興味あれば調べてください）。


# ....................

# - name: Run test suite
#   run: composer run-script test

# 最後にテストコードを実行するコマンドを動かしています。


# --------------------

#~ 動作確認

# まず前節で書いたphpunit.ymlを master ブランチに Push しましょう。

# 続いて何かしらのブランチを作成し（これまで実装したテストコードでも構いません）何かしらのファイルを作成してコミット、プッシュして Pull Request を作成してみましょう。

# すると以下のスクリーンショットのように「PHPUnit GitHub Actions Test / run-test」のテストが通ったことが緑色のチェックマークで示されます。


# 「PHPUnit GitHub Actions Test / run-test」というのは、phpunit.ymlファイルで冒頭のnameに指定した名前が前半、後半にはjobsに指定した文字列が来ています。1 ファイルで複数のタスクをこなすこともできるため、このような表記になっています。


# --------------------

#~ ちなみに

# GitHub Actionsでは他にもさまざまなタスクが実行できます。

#・特定のブランチにマージされたことをトリガーにして、ソースコードのデプロイを動かすことができる（わかり易い例ですと、firebase deployコマンドを実行するなど）
#・PHPUnit だけではなく、Node.js の jest だったり、コマンド上で実行できるテストであればどんなタスクでも動かすことができる
#・ESLint、Prettier、Stylelint、textlint などの lint ツールを動かして、Pull Request に含まれるファイルの内容が特定のルールに則っているかチェックできる

# また、設定のカスタマイズも色々と可能です。

#・Pull Request 内の差分が markdown ファイルだけだった場合などにテストコードを実行しないpaths設定
#・特にデプロイなどを動かすときに必要な API キーは GitHub の secrets 設定から保存する
#・インストールするライブラリやビルドする Docker コンテナをキャッシュすることで実行時間を短縮する
#・on設定にはcronも指定できるので、予め指定した時間帯にだけコマンドを実行できる

# このあたりについて詳解し始めると紙面がいくらあっても足りないため、ぜひ日々いろいろな技術ブログに投稿されるユースケースを参照しつつ、公式のリファレンスを見て試してみてください。


# ....................

# ※GitHub Actions は無料枠があります。本教材で紹介した内容では基本的に無料の範囲内で実行できるはずですが、実行時間が多くなると枠を超える可能性があります。利用の際は不必要に実行しすぎないように注意する、事前に最新の価格情報を確認するなどご注意ください。

#& 最新の価格情報
#& https://github.com/pricing


# **** 【総集編】テストコードを駆使してリファクタにチャレンジ！ ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1196/parts/4706


# 本節では、これまでの総復習として「テストコードを書きながら安全に Fat Controller をリファクタする」ことにチャレンジしてみましょう！


# --------------------

#~ テストコードを書きながらリファクタするとは？

# テストコードを書きながらリファクタするとはどういう意味でしょうか？

# 実際に業務でソースコードをリファクタリングするとき、最も恐ろしいことはデグレしてしまうことです。そして、Fat Controller なソースコードにはおそらくテストコードが付いていないことでしょう。

# そこで本節では、まずテストコードを書いて動作が保証されてからリファクタリングすると、デグレしていないことを証明しながら進められて安心！ということを実証してみたいと思います。


# --------------------

#~ 今回リファクタリングする Fat Controller

# src/app/Http/Controllers/Bookmarks/BookmarkController.phpのupdateメソッドをリファクタリングしましょう。


# public function update(Request $request, int $id)
# {
#     if (Auth::guest()) {
#         // @note ここの処理はユーザープロフィールでも使われている
#         return redirect('/login');
#     }

#     Validator::make($request->all(), [
#         'comment' => 'required|string|min:10|max:1000',
#         'category' => 'required|integer|exists:bookmark_categories,id',
#     ])->validate();

#     $model = Bookmark::query()->findOrFail($id);

#     if ($model->can_not_delete_or_edit) {
#         throw ValidationException::withMessages([
#             'can_edit' => 'ブックマーク後24時間経過したものは編集できません'
#         ]);
#     }

#     if ($model->user_id !== Auth::id()) {
#         abort(403);
#     }

#     $model->category_id = $request->category;
#     $model->comment = $request->comment;
#     $model->save();

#     // 成功時は一覧ページへ
#     return redirect('/bookmarks', 302);
# }


# 復習ついでに、簡単にupdateメソッドの改善点を洗い出しましょう。

#・ログインしていないユーザーは/loginにリダイレクトさせる処理は Middleware でできる
#・バリデーションは FormRequest でできる
#・データベースに保存するあたりの処理はユースケースクラスに切り出すことができる


# --------------------

#~ テスト駆動でリファクタリングしよう

# それではさっそくリファクタリングに入りたいところですが、今回はあえてテストコードから書きましょう。
# テスト駆動開発という言葉がありますが、テスト駆動リファクタリングといったところでしょうか。

#^ リファクタリングする前には、まずテストコードを書いて正常終了するところまで進めることが重要です。
#^ 最初にテストコードが通っている状態からソースコードをリファクタリングし始めます。すると、リファクタリングが原因でデグレしたときに早期発見できます。
#^ しかもリファクタリングが終わった頃にはテストコードが完成しているという一石二鳥の成果が得られます。

# ざっくり言うと以下の要領で進めていきます。

#& 1. 正常終了するテストコードを書く
#& 2. リファクタリングする
#& 3. テストコードを実行する
#& 4. 通れば次のリファクタリングを始める。失敗すればデグレしたということなので 2. の内容を見返す
#& 5. 以上を繰り返す


# --------------------

#~ テストコードの実装

# まずはUpdateBookmarkTest.phpを実装して動作させましょう。

# 以下のコマンドを実行してUpdateBookmarkTest.phpファイルを作成してください。

# touch src/tests/Feature/Bookmarks/UpdateBookmarkTest.php

# 作成したファイルを以下のように編集してください。


# or
# m mktest model=Bookmarks/UpdateBookmarkUseCase


# src/tests/Feature/Bookmarks/UpdateBookmarkTest.php
# <?php

# namespace Tests\Feature\Bookmarks;


# use App\Http\Middleware\VerifyCsrfToken;
# use App\Models\User;
# use Illuminate\Support\Str;
# use Tests\TestCase;

# class UpdateBookmarkTest extends TestCase
# {
#     protected function setUp(): void
#     {
#         parent::setUp();
#         // このミドルウェアがあると419で失敗するし、今回テストしたいことではないので外す
#         $this->withoutMiddleware(VerifyCsrfToken::class);
#     }

#     /**
#      * ユーザー認証済み
#      * ユーザーIDが作成者と一致
#      * 投稿内容がバリデーション通る
#      *
#      * →保存まで成功する
#      * @dataProvider updateBookmarkPutDataProvider
#      */
#     public function testUpdateCorrect(?string $comment, ?int $category, string $result, array $sessionError)
#     {
#         $user = User::query()->find(1);
#         /**
#          * fromでどのURLからリクエストされたかを仮想的に設定できる
#          */
#         $response = $this->actingAs($user)->from('/bookmarks/create')->put('/bookmarks/1', [
#             'comment' => $comment,
#             'category' => $category,
#         ]);

#         /**
#          * データプロバイダー側の結果指定に応じてアサートする内容を変える
#          */
#         if ($result === 'success') {
#             $response->assertRedirect('/bookmarks');
#             $this->assertDatabaseHas('bookmarks', [
#                 'id' => 1,
#                 'comment' => $comment,
#                 'category_id' => $category,
#             ]);
#         }
#         if ($result === 'error') {
#             // Formで失敗したときって元のページに戻りますよね
#             $response->assertRedirect('/bookmarks/create');
#             /**
#              * @see https://readouble.com/laravel/6.x/ja/http-tests.html#assert-session-has-errors
#              * @see https://qiita.com/iakio/items/f7a1064235c39db3f392
#              */
#             $response->assertSessionHasErrors($sessionError);
#             $this->assertDatabaseMissing('bookmarks', [
#                 'id' => 1,
#                 'comment' => $comment,
#                 'category_id' => $category,
#             ]);
#         }
#     }

#     /**
#      * データプロバイダ
#      * @see https://phpunit.readthedocs.io/ja/latest/writing-tests-for-phpunit.html#writing-tests-for-phpunit-data-providers
#      *
#      * @return array
#      */
#     public function updateBookmarkPutDataProvider()
#     {
#         return [
#             // $comment, $category, $result(success || error), $sessionError
#             [Str::random(10), 1, 'success', []],
#             [Str::random(9), 1, 'error', ['comment']],
#             [Str::random(1000), 1, 'success', []],
#             [Str::random(1001), 1, 'error', ['comment']],
#             [Str::random(10), 0, 'error', ['category']],
#             [Str::random(9), 0, 'error', ['comment', 'category']],
#             [null, 1, 'error', ['comment']],
#             [Str::random(10), null, 'error', ['category']],
#             [null, null, 'error', ['comment', 'category']],
#         ];
#     }

#     /**
#      * ユーザーが未認証
#      *
#      * →ログインページへのリダイレクト
#      */
#     public function testFailedWhenLogoutUser()
#     {
#         $this->put('/bookmarks/1', [
#             'comment' => 'ブックマークのテスト用のコメントです',
#             'category' => 1,
#         ])->assertRedirect('/login');
#     }

#     /**
#      * ログインはしているが他人による実行
#      *
#      * →ステータス403で失敗
#      */
#     public function testFailedWhenOtherUser()
#     {
#         $user = User::query()->find(2);
#         $this->actingAs($user)->put('/bookmarks/1', [
#             'comment' => 'ブックマークのテスト用のコメントです',
#             'category' => 1,
#         ])->assertForbidden();
#     }
# }


# 今回のテストコードでもポイントとなる PHPUnit の書き方としてデータプロバイダを紹介します。それ以外の書き方についても新しく登場しているものがありますが、コメントを読んでみてください。


# ....................

#? データプロバイダ

# データプロバイダは「ほとんど同じ内容のテストケースを、異なるいくつものテストデータで一気に実行したい」ときに便利です。

# ブックマーク投稿時はバリデーションとして、コメントが 10 文字以上 1000 文字以下というものがあります。
# ということは最低でも、9 文字、10 文字、1000 文字、1001 文字の 4 パターンでテストしなければなりません。

# そのためにほとんど同じテストコードを 4 回も書くのは面倒です。そこでデータプロバイダの出番となります。

# 今回データプロバイダの役目を果たすのはupdateBookmarkPutDataProviderメソッドです。

# データプロバイダメソッドは（基本的には）配列の配列を返します。それぞれの配列が、データプロバイダを利用する関数の引数に挿入されます。データプロバイダを利用する関数testUpdateCorrectには、コメントに@dataProvider {データプロバイダメソッドの名前}と書きます。


#  * @dataProvider updateBookmarkPutDataProvider
#  */
# public function testUpdateCorrect(?string $comment, ?int $category, string $result, array $sessionError)
# {


# updateBookmarkPutDataProviderは 9 つの配列を返していますので、testUpdateCorrectは 9 回実行されます。


# --------------------

#~ リファクタリングの実践

#? テストコードの実行

# リファクタリングを始める前に、手元でテストコードを実行して正常終了することを確認しましょう。

# 以下のコマンドを実行してください。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/UpdateBookmarkTest.php

# 以下のようなメッセージが表示されます。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# ...........                                                       11 / 11 (100%)

# Time: 4.82 seconds, Memory: 36.00 MB

# OK (11 tests, 46 assertions)


# ..................

#? 認証処理を Middleware へ移行

# まずは認証処理を Middleware へと移行します。

# src/app/Http/Controllers/Bookmarks/BookmarkController.phpを開き、以下の処理を削除します。


# src/app/Http/Controllers/Bookmarks/BookmarkController.php
# public function update(Request $request, int $id)
# {
# 		if (Auth::guest()) {
# 			// @note ここの処理はユーザープロフィールでも使われている
# 			return redirect('/login');
# 		}

# 	Validator::make($request->all(), [

# 	// 中略


# ここでテストコードをもう一度実行しましょう。

# 以下のコマンドを実行してください。


# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/UpdateBookmarkTest.php


# 以下のようなメッセージが表示されます。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# .........F.                                                       11 / 11 (100%)

# Time: 2.91 seconds, Memory: 36.00 MB

# There was 1 failure:

# 1) Tests\Feature\Bookmarks\UpdateBookmarkTest::testFailedWhenLogoutUser
# Response status code [403] is not a redirect status code.
# Failed asserting that false is true.

# /opt/laravel-bookmark/vendor/laravel/framework/src/Illuminate/Foundation/Testing/TestResponse.php:201
# /opt/laravel-bookmark/tests/Feature/Bookmarks/UpdateBookmarkTest.php:76

# FAILURES!
# Tests: 11, Assertions: 45, Failures: 1.


# テストコードが失敗しました。つまりデグレしたということです。

# 失敗した行番号が表示されていますので、該当する箇所を見ると以下のテストメソッドになっているはずです。


# public function testFailedWhenLogoutUser()
# {
# 	$this->put('/bookmarks/1', [
# 		'comment' => 'ブックマークのテスト用のコメントです',
# 		'category' => 1,
# 	])->assertRedirect('/login');
# }


# 単に処理を消しただけなのでテストコードが失敗して当然なのですが、これにより、認証コードのテストコードは意図した通りに動いていることが証明されました。
#^ テストコード自体のテストは、元のプロダクトコードをあえて落ちるように書き換えることで可能です。

#^ この考え方を応用したのがテスト駆動開発です。テスト駆動開発では最初に空っぽのテストを書き、あえて落ちる状態にしてからプロダクトコードを書いていくことで、テストコードを書きながら品質を保証してコードを書くことができます。


# ↑ 補足
# $this->put()は、引数のエンドポイントにPUTメソッドでデータを送信するという意味。その結果、BookmarkController@updateアクションにデータが渡され、未ログイン状態だとloginページにリダイレクトされるはずだから、loginページにリダイレクトしたらテストが通るようになっていた。
# しかし、ログインしているか判別する処理を消したので、テストに通らなくなった。


# この状態でsrc/routes/web.phpを開き、Middleware を設定しましょう。


#  Route::put('/{id}', 'Bookmarks\BookmarkController@update');
# ↓
#  Route::put('/{id}', 'Bookmarks\BookmarkController@update')->middleware('auth');


# 設定できたら以下のコマンドを実行してください。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/UpdateBookmarkTest.php

# 以下のようなメッセージが表示され、テストが成功したことがわかります。

# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# ...........                                                       11 / 11 (100%)

# Time: 2.8 seconds, Memory: 36.00 MB

# OK (11 tests, 46 assertions)

# テストコードに守られながらリファクタリングをする安心感を感じていただけたでしょうか。


# ..................

#? FormRequest への移行

# 続いてバリデーション処理のリファクタリングです。
# まずはsrc/app/Http/Controllers/Bookmarks/BookmarkController.phpを開き、updateメソッドからバリデーション処理の既存処理を単純に削除しましょう。

# Validator::make($request->all(), [
# 	'comment' => 'required|string|min:10|max:1000',
# 	'category' => 'required|integer|exists:bookmark_categories,id',
# ])->validate();

# 以下のコマンドを実行してください。

# docker-compose exec app vendor/bin/phpunit tests/Feature/Bookmarks/UpdateBookmarkTest.php

# 以下のように結果は散々なものになりました。バリデーションに関するテストはデータプロバイダを使っていてたくさん実行しているので仕方ないですね。


# PHPUnit 8.5.14 by Sebastian Bergmann and contributors.

# .F.FFFFFF..                                                       11 / 11 (100%)

# Time: 3.52 seconds, Memory: 38.00 MB

# There were 7 failures:

# 1) Tests\Feature\Bookmarks\UpdateBookmarkTest::testUpdateCorrect with data set #1 ('2FhXkyOuR', 1, 'error', array('comment'))
# Failed asserting that two strings are equal.
# --- Expected
# +++ Actual
# @@ @@
# -'http://localhost/bookmarks/create'
# +'http://localhost/bookmarks'

# 〜長いので中略〜

# /opt/laravel-bookmark/vendor/laravel/framework/src/Illuminate/Foundation/Testing/TestResponse.php:205
# /opt/laravel-bookmark/tests/Feature/Bookmarks/UpdateBookmarkTest.php:52

# 7) Tests\Feature\Bookmarks\UpdateBookmarkTest::testUpdateCorrect with data set #8 (null, null, 'error', array('comment', 'category'))
# Response status code [500] is not a redirect status code.
# Failed asserting that false is true.

# /opt/laravel-bookmark/vendor/laravel/framework/src/Illuminate/Foundation/Testing/TestResponse.php:201
# /opt/laravel-bookmark/tests/Feature/Bookmarks/UpdateBookmarkTest.php:52

# FAILURES!
# Tests: 11, Assertions: 19, Failures: 7.


# それでは FormRequest を作成しましょう。

# 以下のコマンドを実行してUpdateBookmarkRequest.phpファイルを作成してください。


# touch src/app/Http/Requests/UpdateBookmarkRequest.php


# or
# m mkreq model=UpdateBookmark

# 作成したファイルを以下のように編集してください。


# src/app/Http/Requests/UpdateBookmarkRequest.php

# <?php

# namespace App\Http\Requests;

# use Illuminate\Foundation\Http\FormRequest;

# /**
#  * Class UpdateBookmarkRequest
#  * @package App\Http\Requests
#  *
#  * TIPS このようにコメントを書くと、利用しているControllerのほうで型の補完が効きます
#  * @property-read string comment
#  * @property-read int category
#  */
# class UpdateBookmarkRequest extends FormRequest
# {
#     /**
#      * Determine if the user is authorized to make this request.
#      *
#      * @return bool
#      */
#     public function authorize()
#     {
#         return true;
#     }

#     /**
#      * Get the validation rules that apply to the request.
#      *
#      * @return array
#      */
#     public function rules()
#     {
#         return [
#             'comment' => 'required|string|min:10|max:1000',
#             'category' => 'required|integer|exists:bookmark_categories,id',
#         ];
#     }
# }


# BookmarkControllerを編集して、作成した FormRequest を利用します。

# src/app/Http/Controllers/Bookmarks/BookmarkController.php
#   use App\Http\Requests\UpdateBookmarkRequest;

# 〜中略〜

#      // public function update(Request $request, int $id)
#      public function update(UpdateBookmarkRequest $request, int $id)


# ここまで書き換えてテストコードを実行すると正常終了します（もう何度も貼っているので省略しますね）。


# ..................

#~ まとめ

# 本節のポイントをまとめます。

#・テストコードもない、Fat なソースコードをリファクタリングするときはまずテストコードを作ろう
#・テストコードがデグレしないようにリファクタリングしよう
#・あえて失敗させることでテストコードのテストも並行して行おう

# 余談ですが、テストコードだけ提示してこれを満たすコードを実装せよ、といったコンセプトの教材も面白いかもしれないですね。


# --------------------

#~ 演習課題

# BookmarkControllerにはまだリファクタリングされていないメソッドが残っているはずです。ぜひテストコードを実装した上でリファクタリングにチャレンジしてみましょう！


# **** 総まとめ ****

# https://www.techpit.jp/courses/176/curriculums/179/sections/1196/parts/4707


# ここまで進めていただいてありがとうございます。そしてお疲れさまでした。

# 本節では、本教材全体のまとめとして、これまで行ってきたことを簡単にまとめます。


# --------------------

#~ できるようになったこと

# 1 章

# 1 章では、とにかく Fat Controller な状況を卒業するために、Controller が本来やるべき HTML を返す部分以外の処理を全部 UseCase に移行しました。

# Laravel 等のフレームワークが用意しているディレクトリ以外の場所として、自分で決めてディレクトリを作成してクラスを作成し、処理を記述できました。


# ....................

# 2 章

# 2 章では、1 章の内容を踏まえつつ Fat Controller を卒業するメリットを説明しました。


# ....................

# 3 章

# 3 章では Form Request や Middleware など Laravel の機能を使うことで Fat Controller からどんどん処理を引き剥がしていきました。

# 理論上はあらゆる実装を自分で組むことができますが、フレームワークが用意しているものがあり、使い勝手も問題ないのであれば開発メンバーの学習コストも下がりますし導入するのがいいでしょう。


# ....................

# 4 章

# 本章が本教材で最も山場となる内容だったと思います。ここの内容は雰囲気でしか分からなかったという方も多いかもしれません。

# Interface を使ってクラス間の関係を疎結合にするのは常套手段なのですが、そもそも Interface って何なのか、Interface に依存させるとは何なのか、サービスコンテナとは何なのかと次々に難しい説明が続きました。

# 外部の Web サイトへアクセスしてメタ情報を取得する処理をモック化することで、実際のアクセスをせずに動作確認ができることを確認しました。


# ....................

# 5 章

# 4 章で苦労してモック化を学んだことがテストコードで活きてきます。PHPUnit を用いたテストコードの書き方を学び、モック化の方法としてサービスコンテナを使ってモックの実装クラスや Mockery で作成したモックへの差し替えを学びました。

# 最後には実務にもすぐ応用できるであろう、GitHub Actions での自動化についても軽く試してみました。


# --------------------

#~ 学んだ内容を実践していこう

# 本教材の内容を一通り行っていただいた方にお伝えしたいのは、ぜひ手を動かして実践していこうということです。

# 教材を読んでなんとなく理解した気になっても、実際にサービスを実現するためのコードは思ったより複雑になっており、学んだ内容がそのまま活かせないことがほとんどだと思います。

# そのため、可能であれば実務で関わっているソースコードにて、クラスを切り分けてみたり Interface を切ってみたりテストコードを書いたりテスト自動化の設定に取り組んでみていただきたいです。

# なぜ実務で取り組むのが良いかというと、0 章で「設計に絶対の正解はありません。なぜなら、本教材で解説する設計手法は、開発するアプリケーションの性質、満たすべき要件などによって正解に成り得ないからです。」とお話したとおり、ある程度複雑な要件で、リファクタリングを努力する価値のあるプロダクトに対して取り組むことが望ましいと考えているからです。

#^ もし実務ではソースコードを書ける環境にない場合は、個人開発で設計を学んでいくのが良いと思いますが、その場合は「要件にこだわる」ことが大事です。たとえばよくある ToDo リストを作って満足するのではなく、「実際自分が ToDo リストを使うなら、タスクの全文検索くらいは欲しいな。」など要件を自分で押し上げていくことが大事ですし、本教材で学んだ設計手法を応用して「全文検索はどうやって実装するかわからないけど、全文検索するクラスの Interface だけ切って他の部分を先に開発しちゃおうかな」などと考えながら開発すれば、きっと自分の血肉になるかと思います。

# 筆者自身も執筆時点では開発経験のあるプロダクトが数種類しかない若輩者です。まだまだ色々な事例を聞いて学んでいきたいと思っています。ぜひ皆さんにもご自身が関わったプロジェクトから学び取った設計の Tips を発信していただければ幸いです。
