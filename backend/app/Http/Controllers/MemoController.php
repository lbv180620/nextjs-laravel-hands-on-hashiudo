<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Enums\ErrorEnums\AuthErrorEnum;
use App\Http\Enums\SuccessEnums\MemoSuccessEnum;
use App\Http\Exceptions\AuthException;
use App\Http\Requests\MemoCreateRequest;
use App\Models\Memo;
use Illuminate\Support\Facades\Auth;

final class MemoController extends Controller
{
    /**
     * メモの全件取得
     *
     */
    public function fetch()
    {
        // ログインユーザーのID取得
        $id = Auth::id();

        if (!$id) {
            throw new AuthException(AuthErrorEnum::UNAUTHORIZED);
        }

        try {
            $memos = Memo::where('user_id', $id)
                ->latest()
                ->select('id', 'title', 'body')
                ->get();
        } catch (\Exception $ex) {
            throw $ex;
        }

        return response()->success(enum: MemoSuccessEnum::MEMO_LIST_FETCH_SUCCESS, options: $memos->toArray());
    }

    /**
     * メモの登録
     *
     */
    public function create(MemoCreateRequest $request, Memo $memo)
    {
        // $id = null;
        $id = request()->user()->id;

        if (!$id) {
            throw new AuthException(AuthErrorEnum::UNAUTHORIZED);
        }

        try {
            // パラメータセット
            $memo->user_id = $id;
            // $memo->user_id = 1;
            $memo->fill($request->all());
            // モデルの保存
            $memo->save();
        } catch (\Exception $ex) {
            throw $ex;
        }

        return response()->success(enum: MemoSuccessEnum::MEMO_CREATE_SUCCESS, options: ['id' => $memo->id]);
    }
}
