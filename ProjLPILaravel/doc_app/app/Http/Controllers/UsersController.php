<?php

namespace App\Http\Controllers;



use App\Models\Appointments;
use App\Models\User;
use App\Models\Doctor;
use App\Models\UserDetails;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        $user = array(); //this will return a set of user and doctor data
        $user = Auth::user();
        $doctor = User::where('type','doctor')->get();
        $details = $user->user_details;
        $doctorData = Doctor::all();

        //return today appointment together with userdata
        $date = now()->format('n/j/Y');
        $appointment = Appointments::where('status','upcoming')->where('date',$date)->first();

        //collect all user and doctor details

        foreach($doctorData as $data){
            foreach($doctor as $info){
                if($data['doc_id'] == $info ['id']){
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] =$info ['profile_photo_utl'];

                    if (isset($appointment) && $appointment['doc_id'] == $info['id']){
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }

        $user['doctor'] = $doctorData;
        $user['details'] = $details; //return user details here together with doctor list
        return $user; //return all data
    }

     /**
     * Login
     */
    public function login(Request $reqeust)
    {
        //validate incoming inputs
        $reqeust->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);

        //check matching user
        $user = User::where('email', $reqeust->email)->first();

        //check password
        if(!$user || ! Hash::check($reqeust->password, $user->password)){
            throw ValidationException::withMessages([
                'email'=>['The provided credentials are incorrect'],
            ]);
        }

        //then return generated token
        return $user->createToken($reqeust->email)->plainTextToken;
    }


    
     /**
     * Login
     */
    public function register(Request $request)
    {
        //validate incoming inputs
        $request->validate([
            'name' => 'required|string',
            'email'=>'required|email',
            'password'=>'required',
        ]);

   $user = User::create([
    'name'=>$request->name,
    'email'=>$request->email,
    'type'=>'user',
    'password' => Hash::make($request->password),

   ]);
         
   $userInfo = UserDetails::create([
        'user_id' => $user->id,
        'status'=>'active',
   ]);
       return $user;
    }


    public function storeFavDoc(Request $request)
    {

        $saveFav = UserDetails::where('user_id',Auth::user()->id)->first();

        $docList = json_encode($request->get('favList'));

        //update fav list into database
        $saveFav->fav = $docList;  //and remember update this as well
        $saveFav->save();

        return response()->json([
            'success'=>'The Favorite List is updated',
        ], 200);
    }

      /**
     * logout.
     *
     * @return \Illuminate\Http\Response
     */
    public function logout(){
        $user = Auth::user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'success'=>'Logout successfully!',
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
