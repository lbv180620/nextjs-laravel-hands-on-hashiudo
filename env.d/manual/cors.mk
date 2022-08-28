#todo [CORS Tips]


#? CORS Originの複数指定方法


# 方法１:

# 【PHP】Access-Control-Allow-Originに複数のドメインを設定する
# https://chusotsu-program.com/php-api-multi-domain/


# <?php

# /**
#  * CORSの設定
#  */

# /**
#  * 全てのドメインからAPIにリクエストを投げること許可
#  */
# // header('Access-Control-Allow-Origin: *');
# // header('Access-Control-Allow-Headers: *');
# // header("Access-Control-Allow-Methods: *");


# /**
#  * 任意のドメインからAPIにリクエストを投げることを許可
#  */
# $reqHeaders = apache_request_headers();

# $allowedOrigin = [
#     'http://localhost:2000',
#     'http://localhost:8081',
# ];

# if (in_array($reqHeaders['Origin'], $allowedOrigin)) header("Access-Control-Allow-Origin: {$reqHeaders['Origin']}");

# header('Access-Control-Allow-Credentials: true');
# header('Access-Control-Allow-Headers: content-type, x-requested-with');
# header('Access-Control-Allow-Methods: *');

# /**
#  * メソッドごとで処理の切り替える
#  */

# require_once dirname(__FILE__, 3) . '/vendor/autoload.php';

# use App\Models\Base;
# use App\Models\Users;

# try {
#     $pdo = Base::getPDOInstance();
#     $dbh = new Users($pdo);
#     $dbh->sayHello($reqHeaders['Origin']);
# } catch (\PDOException $e) {
#     exit($e->getMessage() . PHP_EOL);
# }


# ＝＝＝＝＝

# ⭐️方法2：

# ⭐️(PHP / CORS) Access-Control-Allow-Origin に複数のオリジンを指定したい
# https://crieit.net/posts/php-multi-cors-20201213

# CorsAccessControl.php


# <?php

# declare(strict_types=1);

# namespace App\Utils;

# class CorsAccessControl
# {
#     private $allowedOrigin = [];

#     public function __construct(...$domains)
#     {

#         $this->allowedOrigin = [...$domains];
#     }

#     public function corsProcess()
#     {
#         $reqHeaders = apache_request_headers();

#         if (in_array($reqHeaders['Origin'], $this->allowedOrigin)) header("Access-Control-Allow-Origin: {$reqHeaders['Origin']}");

#         header('Access-Control-Allow-Credentials: true');
#         header('Access-Control-Allow-Headers: content-type, x-requested-with');
#         header('Access-Control-Allow-Methods: *');
#         // var_dump($reqHeaders);
#     }
# }

# ?>

# ----------------------

# public/api/index.php

# <?php

# require_once dirname(__FILE__, 3) . '/vendor/autoload.php';

# use App\Models\Base;
# use App\Models\Users;
# use App\Config\Config;
# use App\Utils\CorsAccessControl;

# $cors = new CorsAccessControl(...Config::ALLOWED_ORIGINS);
# $cors->corsProcess();

# try {
#     $dbh = new Users(Base::getPDOInstance());
#     $dbh->sayHello("Hello");
# } catch (\PDOException $e) {
#     exit($e->getMessage() . PHP_EOL);
# }

# ---------------

# App/Config/Config.php

# require dirname(__FILE__, 3) . '/vendor/autoload.php';

# class Config
# {
#     /** DB関連 */

#     /** @var array ドライバーオプション */
#     // 「PDO::ERRMODE_EXCEPTION」を指定すると、エラー発生時に例外がスローされる
#     const DRIVER_OPTS = [
#         \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
#         \PDO::ATTR_EMULATE_PREPARES => false,
#         \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
#     ];

#     const ALLOWED_ORIGINS = [
#         'http://localhost:2000',
#         'http://localhost:8081',
#     ];
# }
