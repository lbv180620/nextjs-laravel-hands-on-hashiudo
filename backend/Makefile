# ==== PHPUnit関連 ====

pu-v:
	./vendor/bin/phpunit --version

phpunit:
	./vendor/bin/phpunit $(path) --colors

pu:
	@make phpunit

pu-d:
	./vendor/bin/phpunit $(path) --colors --debug

# --filter - PHPUnit公式
# https://phpunit.readthedocs.io/ja/latest/textui.html?highlight=--filter
# --filter <テストメソッド名>@<パラメータのパターン名>
pu-f:
	./vendor/bin/phpunit --filter $(regex)

pu-t:
	./vendor/bin/phpunit --testsuite $(name)

pu-tf:
	./vendor/bin/phpunit --testsuite $(name) --filter $(regex)

pu-ls:
	./vendor/bin/phpunit --list-suite


# ==== Composer関連 ====

dump-autoload:
	composer dump-autoload

clear-cache:
	composer clear-cache


# ==== Route List ====

route-list-txt:
	php artisan route:list > route.txt


# ==== Fly.io関連 ====

falogin:
    flyctl auth login

falogout:
    flyctl auth logout

flaunch:
    flyctl launch

fsset:
    flyctl secrets set $(dataset)

fsunset:
    flyctl secrets unset $(key)

fslist:
    flyctl secrets list

fdeploy:
    flyctl deploy

fopen:
    flyctl open

fdeploy-remote:
    flyctl deploy --remote-only

fssh:
    flyctl ssh console

fccreate:
    flyctl certs create $(domain)

fcshow:
    flyctl certs show $(domain)

flaunch-redis:
    flyctl launch --image flyio/redis:6.2.6 --name $(name) --region ams --no-deploy

fvcreate:
    flyctl volumes create $(name) --size 1

frcreate:
    flyctl redis create

frconnect:
    flyctl redis connect

fatoken:
    flyctl auth token
