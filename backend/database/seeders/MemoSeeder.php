<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MemoSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        DB::table('memos')->insert([
            [
                'id' => 1,
                'user_id' => 1,
                'title' => 'タイトル1',
                'body' => 'サンプルメモ1',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 2,
                'user_id' => 1,
                'title' => 'タイトル2',
                'body' => 'サンプルメモ2',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 3,
                'user_id' => 1,
                'title' => 'タイトル3',
                'body' => 'サンプルメモ3',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 4,
                'user_id' => 1,
                'title' => 'タイトル4',
                'body' => 'サンプルメモ4',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 5,
                'user_id' => 1,
                'title' => 'タイトル5',
                'body' => 'サンプルメモ5',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'id' => 6,
                'user_id' => 1,
                'title' => 'タイトル6',
                'body' => 'サンプルメモ6',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}