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
