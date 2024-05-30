<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reviews extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'doc_id',
        'ratings',
        'reviews',
        'reviewed_by',
        'status',
        'appointment_id',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }

    
    public function appointment(){
        return $this->belongsTo(Appointments::class);
    }


}
