<!DOCTYPE html>
<html>
<head>
    <title>Bukti Laporan Kerusakan Jalan</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; }
        .header { text-align: center; margin-bottom: 30px; }
        .content { margin-bottom: 20px; }
        .label { font-weight: bold; width: 150px; display: inline-block; }
        .foto { margin-top: 20px; text-align: center; }
        .foto img { width: 300px; height: auto; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class="header">
        <h2>BUKTI LAPORAN KERUSAKAN JALAN</h2>
        <p>Aplikasi JalanKita</p>
    </div>

    <div class="content">
        <p><span class="label">ID Laporan:</span> #{{ $report->id }}</p>
        <p><span class="label">Pelapor:</span> {{ $report->user->name }} (NIK: {{ $report->user->nik }})</p>
        <p><span class="label">Tanggal Lapor:</span> {{ $report->created_at->format('d M Y H:i') }}</p>
        <p><span class="label">Judul:</span> {{ $report->title }}</p>
        <p><span class="label">Status:</span> <strong>{{ strtoupper($report->status) }}</strong></p>
        <p><span class="label">Deskripsi:</span> {{ $report->description }}</p>
        <p><span class="label">Lokasi GPS:</span> {{ $report->latitude }}, {{ $report->longitude }}</p>
    </div>

    <div class="foto">
        <p><strong>Bukti Foto:</strong></p>
        <img src="{{ public_path('storage/' . $report->image_path) }}">
    </div>
</body>
</html>