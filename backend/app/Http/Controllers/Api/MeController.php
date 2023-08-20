<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Enums\SuccessEnums\DataFetchSuccessEnum;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class MeController extends Controller
{
    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function __invoke(Request $request): JsonResponse
    {
        $user = $request->user();

        // return new JsonResponse([
        //     'data' => [
        //         'id' => $user->id,
        //         'name' => $user->name,
        //         'email' => $user->email,
        //     ],
        // ]);
        return response()->success(enum: DataFetchSuccessEnum::LOGIN_USER_FETCH_SUCCESS, options: [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
        ]);
    }
}
