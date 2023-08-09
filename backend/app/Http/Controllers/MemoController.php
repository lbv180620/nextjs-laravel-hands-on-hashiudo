<?php

namespace App\Http\Controllers;

use App\Http\ErrorEnums\TestErrorEnum;
use App\Http\Exceptions\TestException;
use App\Http\Requests\MemoPostRequest;
use App\Http\Resources\MemoResource;
use App\Models\Memo;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;

class MemoController extends Controller
{
    /**
     * メモの全件取得
     *
     * @return AnonymousResourceCollection
     */
    public function fetch(): AnonymousResourceCollection
    {
        // ログインユーザーのID取得
        $id = Auth::id();

        if (!$id) {
            // throw new TestException(TestErrorEnum::Unauthorized);
            abort(404);
        }
        try {
            $memos = Memo::where('user_id', $id)
                ->latest()
                ->get();
        } catch (\Exception $ex) {
            throw $ex;
        }

        return MemoResource::collection($memos);
    }

    /**
     * メモの登録
     *
     */
    public function create(MemoPostRequest $request, Memo $memo)
    {
        try {
            // モデルのインスタンス化
            // $memo = new Memo();

            // パラメータセット
            $memo->user_id = Auth::id();
            // $memo->title = $request->title;
            // $memo->body = $request->body;
            $memo->fill($request->all());

            // モデルの保存
            $memo->save();

            // Memo::create([
            //     'user_id' => Auth::id(),
            //     'title' => $request->input('title'),
            //     'body' => $request->input('body'),
            // ]);
        } catch (\Exception $ex) {
            throw $ex;
        }

        return response()->json([
            'message' => 'メモの登録に成功しました。',
        ], 201);
    }
}
