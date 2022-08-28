<?php
session_start();

echo 'save_handler: ', ini_get('session.save_handler'), PHP_EOL;
echo 'save_path: ', ini_get('session.save_path'), PHP_EOL;
echo 'session_id: ', session_id(), PHP_EOL;

$_SESSION['libname'] = "PhpRedis";
