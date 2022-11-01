<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->unsignedBigInteger('id', true);

            $table->string('name');
            $table->string('email')->unique();
            $table->string('password');

            // MySQL
            // $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            // $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));

            // PostgreSQL
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP'));
        });

        // 関数の定義
        DB::statement("
                CREATE FUNCTION refresh_updated_at_step1() RETURNS trigger AS
                $$
                BEGIN
                    IF NEW.updated_at = OLD.updated_at THEN
                        NEW.updated_at := NULL;
                    END IF;
                    RETURN NEW;
                END;
                $$ LANGUAGE plpgsql;
            ");

        DB::statement("
                CREATE FUNCTION refresh_updated_at_step2() RETURNS trigger AS
                $$
                BEGIN
                    IF NEW.updated_at IS NULL THEN
                        NEW.updated_at := OLD.updated_at;
                    END IF;
                    RETURN NEW;
                END;
                $$ LANGUAGE plpgsql;
            ");

        DB::statement("
                CREATE FUNCTION refresh_updated_at_step3() RETURNS trigger AS
                $$
                BEGIN
                    IF NEW.updated_at IS NULL THEN
                        NEW.updated_at := CURRENT_TIMESTAMP;
                    END IF;
                    RETURN NEW;
                END;
                $$ LANGUAGE plpgsql;
            ");

        // トリガーの定義
        DB::statement("
            CREATE TRIGGER refresh_users_updated_at_step1
                BEFORE UPDATE ON users FOR EACH ROW
                EXECUTE PROCEDURE refresh_updated_at_step1();
            CREATE TRIGGER refresh_users_updated_at_step2
                BEFORE UPDATE OF updated_at ON users FOR EACH ROW
                EXECUTE PROCEDURE refresh_updated_at_step2();
            CREATE TRIGGER refresh_users_updated_at_step3
                BEFORE UPDATE ON users FOR EACH ROW
                EXECUTE PROCEDURE refresh_updated_at_step3();
        ");
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('users');

        // 関数とトリガーの削除処理
        DB::statement("
            DROP TRIGGER IF EXISTS refresh_users_updated_at_step1 ON users;
            DROP TRIGGER IF EXISTS refresh_users_updated_at_step2 ON users;
            DROP TRIGGER IF EXISTS refresh_users_updated_at_step3 ON users;
        ");

        DB::statement("
            DROP FUNCTION IF EXISTS refresh_updated_at_step1();
            DROP FUNCTION IF EXISTS refresh_updated_at_step2();
            DROP FUNCTION IF EXISTS refresh_updated_at_step3();
        ");
    }
}