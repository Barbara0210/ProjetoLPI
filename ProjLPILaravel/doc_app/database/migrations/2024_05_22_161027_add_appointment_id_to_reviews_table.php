<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('reviews', function (Blueprint $table) {
            // Primeiro, certifique-se de que a tabela appointments existe
            if (Schema::hasTable('appointments')) {
                // Adiciona a coluna appointment_id
                $table->unsignedBigInteger('appointment_id')->nullable();

                // Define a constraint de chave estrangeira
                $table->foreign('appointment_id')->references('id')->on('appointments')->onDelete('cascade');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::table('reviews', function (Blueprint $table) {
            $table->dropForeign(['appointment_id']);
            $table->dropColumn('appointment_id');
        });
    }
};
