<?php

namespace App\Http\Controllers;

use App\Http\Resources\MemoResource;
use App\Models\Memo;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
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
            throw new Exception('未ログインです。');
        }

        try {
            $memos = Memo::where('user_id', $id)->get();
        } catch (\Exception $ex) {
            throw $ex;
        }

        return MemoResource::collection($memos);
    }
}