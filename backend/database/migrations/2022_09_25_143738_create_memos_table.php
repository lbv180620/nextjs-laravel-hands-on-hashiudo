<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CreateMemosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('memos', function (Blueprint $table) {
            $table->unsignedBigInteger('id', true);

            $table->foreignId('user_id')
                ->constrained()
                ->onUpdate('cascade')
                ->onDelete('cascade')
                ->comment('ユーザーID');

            $table->string('title', 50)->comment('タイトル');
            $table->string('body', 255)->comment('メモの内容');

            // MySQL
            // $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            // $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));

            // PostgreSQL
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP'));
        });

        // 関数の定義
        // DB::statement("
        //         CREATE FUNCTION refresh_updated_at_step1() RETURNS trigger AS
        //         $$
        //         BEGIN
        //             IF NEW.updated_at = OLD.updated_at THEN
        //                 NEW.updated_at := NULL;
        //             END IF;
        //             RETURN NEW;
        //         END;
        //         $$ LANGUAGE plpgsql;
        //     ");

        // DB::statement("
        //         CREATE FUNCTION refresh_updated_at_step2() RETURNS trigger AS
        //         $$
        //         BEGIN
        //             IF NEW.updated_at IS NULL THEN
        //                 NEW.updated_at := OLD.updated_at;
        //             END IF;
        //             RETURN NEW;
        //         END;
        //         $$ LANGUAGE plpgsql;
        //     ");

        // DB::statement("
        //         CREATE FUNCTION refresh_updated_at_step3() RETURNS trigger AS
        //         $$
        //         BEGIN
        //             IF NEW.updated_at IS NULL THEN
        //                 NEW.updated_at := CURRENT_TIMESTAMP;
        //             END IF;
        //             RETURN NEW;
        //         END;
        //         $$ LANGUAGE plpgsql;
        //     ");

        // トリガーの定義
        DB::statement("
            CREATE TRIGGER refresh_memos_updated_at_step1
                BEFORE UPDATE ON memos FOR EACH ROW
                EXECUTE PROCEDURE refresh_updated_at_step1();
        ");
        DB::statement("
            CREATE TRIGGER refresh_memos_updated_at_step2
                BEFORE UPDATE OF updated_at ON memos FOR EACH ROW
                EXECUTE PROCEDURE refresh_updated_at_step2();
        ");
        DB::statement("
            CREATE TRIGGER refresh_memos_updated_at_step3
                BEFORE UPDATE ON memos FOR EACH ROW
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
        Schema::dropIfExists('memos');

        // トリガーの削除処理
        DB::statement("
            DROP TRIGGER IF EXISTS refresh_memos_updated_at_step1 ON memos;
        ");
        DB::statement("
            DROP TRIGGER IF EXISTS refresh_memos_updated_at_step2 ON memos;
        ");
        DB::statement("
            DROP TRIGGER IF EXISTS refresh_memos_updated_at_step3 ON memos;
        ");

        // 関数の削除処理
        DB::statement("
            DROP FUNCTION IF EXISTS refresh_updated_at_step1();
        ");
        DB::statement("
            DROP FUNCTION IF EXISTS refresh_updated_at_step2();
        ");
        DB::statement("
            DROP FUNCTION IF EXISTS refresh_updated_at_step3();
        ");
    }
}