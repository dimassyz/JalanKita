<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function showUser(Request $request) {
        return response()->json([
            'status' => 'success',
            'data' => $request->user()
        ]);
    }
}
