<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProviderUserController extends Controller
{
    //
    public function login(Request $request, string $provider)
    {
        dd($provider);
        dd($request);
    }
}
