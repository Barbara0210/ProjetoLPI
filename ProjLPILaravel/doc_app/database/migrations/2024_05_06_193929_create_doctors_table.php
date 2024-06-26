<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    { 
        //create a database table for doctor
        //and this doctor table is refer to user table
        //when a new doctor registered, the doctor details will be created as well

        Schema::create('doctors', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('doc_id')->unique();
            $table->string('name')->nullable();

            $table->string('category')->nullable();
            $table->unsignedBigInteger('patients')->nullable();
            $table->unsignedBigInteger('experience')->nullable();
            $table->unsignedBigInteger('bio_data')->nullable();
            $table->string('status')->nullable();

            //this is state that this doc_id refers to users id
          //  $table->foreign('doc_id')->references('id')->on('users')->onDelete('cascade');


            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('doctors');
    }
};
