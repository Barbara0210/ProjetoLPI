<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    use HasFactory;

    protected $fillable =[
        'doc_id',
        'nome',
        'category',
        'patients',
        'experience',
        'bio_data',
        'status',
    ];

    public function user(){
       return $this->belongsTo(User::class); 
    }

    public function reviews()
    {
        return $this->hasMany(Reviews::class, 'doc_id', 'id');
    }
}
