<?php

use Illuminate\Support\Facades\Route;

Route::get('/home', function () {
    return view('welcome');
});

Route::get('/', function () {
    // Tạo dữ liệu giả
    $products = [
        ['name' => 'Laptop Gaming', 'price' => 20000000],
        ['name' => 'Chuột không dây', 'price' => 150000],
        ['name' => 'Bàn phím cơ', 'price' => 800000],
    ];

    // Trả về view products kèm dữ liệu
    return view('products', ['danhSachSanpham' => $products]);
});