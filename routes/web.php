<?php

use Illuminate\Support\Facades\Route;

Route::get('/home', function () {
    return view('welcome');
});

Route::get('/', function () {
    // Tạo dữ liệu giả
    $products = [
        ['name' => 'Màn hình', 'price' => 2000000],
        ['name' => 'Ghế', 'price' => 1500000],
        ['name' => 'Bàn ikea', 'price' => 800000],
    ];

    // Trả về view products kèm dữ liệu
    return view('products', ['danhSachSanpham' => $products]);
});