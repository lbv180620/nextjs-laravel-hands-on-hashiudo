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

            // $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            // $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP'));

            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP'));

            // 関数の定義
            DB::statement("
                create or replace function set_update_time() returns trigger language plpgsql as
                $$
                    begin
                        new.updated_at = CURRENT_TIMESTAMP;
                        return new;
                    end;
                $$;
            ");

            // トリガーの定義
            DB::statement("
                create trigger update_trigger before update on memos for each row
                    execute procedure set_update_time();
            ");
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('memos');

        // 関数とトリガーの削除処理
        DB::statement("
            DROP TRIGGER update_trigger ON memos;
        ");

        DB::statement("
            DROP FUNCTION set_update_time();
        ");
    }
}