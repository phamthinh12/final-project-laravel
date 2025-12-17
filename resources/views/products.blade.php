<!DOCTYPE html>
<html>
<head>
    <title>Danh sách sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-primary">Bài tập cuối kỳ - Danh sách sản phẩm</h1>
        
        <table class="table table-bordered mt-3">
            <thead class="table-dark">
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Giá tiền</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($danhSachSanpham as $sp)
                <tr>
                    <td>{{ $sp['name'] }}</td>
                    <td>{{ number_format($sp['price']) }} VNĐ</td>
                </tr>
                @endforeach
            </tbody>
        </table>
    </div>
</body>
</html>