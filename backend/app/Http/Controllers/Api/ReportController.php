<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Report;
use Illuminate\Support\Facades\Validator;

class ReportController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title'       => 'required|string|max:255',
            'description' => 'required|string',
            'image'       => 'required|image|mimes:jpeg,png,jpg|max:5120',
            'latitude'    => 'nullable|numeric',
            'longitude'   => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        $path = $request->file('image')->store('reports', 'public');

        $report = Report::create([
            'user_id'     => auth()->id(),
            'title'       => $request->title,
            'description' => $request->description,
            'image_path'  => $path,
            'status'      => 'pending',
            'latitude'    => $request->latitude,
            'longitude'   => $request->longitude,
        ]);

        return response()->json([
            'status'  => 'success',
            'message' => 'Laporan berhasil dikirim dan menunggu validasi',
            'data'    => $report
        ], 201);
    }

    public function myReports(Request $request)
    {
        $reports = Report::where('user_id', auth()->id())
            ->latest()
            ->get();
    
        return response()->json([
            'status' => 'success',
            'message' => 'Daftar riwayat laporan berhasil diambil',
            'data' => $reports
        ]);
    }
}
