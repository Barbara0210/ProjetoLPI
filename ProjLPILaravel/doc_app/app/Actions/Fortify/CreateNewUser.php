<?php

namespace App\Actions\Fortify;

use App\Models\User;
use App\Models\Doctor;
use App\Models\UserDetails;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Laravel\Fortify\Contracts\CreatesNewUsers;
use Laravel\Jetstream\Jetstream;


//this is to register new user/doctor
class CreateNewUser implements CreatesNewUsers
{
    use PasswordValidationRules;

    /**
     * Validate and create a newly registered user.
     *
     * @param  array<string, string>  $input
     */
    public function create(array $input)
    {
        Validator::make($input, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => $this->passwordRules(),
            'terms' => Jetstream::hasTermsAndPrivacyPolicyFeature() ? ['accepted', 'required'] : '',
        ])->validate();

        $user= User::create([
            'name' => $input['name'],
            'email' => $input['email'],
            'type' => 'admin', //since only allow doctor to sign up and login
            'password' => Hash::make($input['password']),
        ]);

    
            $doctorInfo = Doctor::create([
                'doc_id' => $user->id,
                'status' => 'active',

            ]);
     
    //now add new input to register form
    return $user;
}
}