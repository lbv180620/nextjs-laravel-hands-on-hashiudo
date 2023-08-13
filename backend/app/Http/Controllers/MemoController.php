<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\ErrorEnums\TestErrorEnum;
use App\Http\Exceptions\TestException;
use App\Http\Requests\MemoPostRequest;
use App\Http\Resources\MemoResource;
use App\Models\Memo;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;

final class MemoController extends Controller
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
            // throw new TestException(TestErrorEnum::UNAUTHORIZED);
            throw new TestException(TestErrorEnum::INVALID_FORMAT_DATA);
            // abort(404);
            // abort(418);
            // abort(405);
            // abort(419);
            // abort(422);
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
            // $memo->user_id = Auth::id();
            $memo->user_id = 1;
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

        $status = Response::HTTP_CREATED;
        $url = $request->fullUrl();
        $details = [
            'memo_id' => $memo->id,
        ];

        return response()->success(...compact('status', 'url', 'details'));
    }
}
