<?php
session_start();

echo 'save_handler: ', ini_get('session.save_handler'), PHP_EOL;
echo 'save_path: ', ini_get('session.save_path'), PHP_EOL;
echo 'session_id: ', session_id(), PHP_EOL;

$_SESSION['libname'] = "PhpRedis";

# Redis Session Test
# routes/web.phpに追記
// Route::get('/put-data', function () {
// 	session()->put(['email' => 'user@example.com']);
// 	return session()->get('email');
// });

// Route::get('/list-data', function () {
// 	return session()->all();
// });
