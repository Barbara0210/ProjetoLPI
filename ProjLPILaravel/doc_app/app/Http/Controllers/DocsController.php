<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\Reviews;
use App\Models\Doctor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DocsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //get doctor's appointments,patients and display on dashboard
        $doctor = Auth::user();
        $appointments = Appointments::where('doc_id',$doctor->id)->where ('status','upcoming')->get();
        $reviews = Reviews::where('doc_id',$doctor->id)->where ('status','active')->get();

        //return all data to dashboard
        return view('dashboard')->with(['doctor'=>$doctor, 'appointments'=>$appointments, 'reviews'=>$reviews]);
    }


    public function listindex()
    {
        $doctors = Doctor::all();
        return view('doctors.index', compact('doctors'));
    }


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
        return view( 'doctors.create');
    }

     /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //this controller is to store booking details post from mobile app
        $reviews = new Reviews();
        //this is to update the appointment status from "upcoming" to "complete"
        $appointment = Appointments::where('id', $request->get('appointment_id'))->first();

        //save the ratings and reviews from user
        $reviews->user_id = Auth::user()->id;
        $reviews->doc_id = $request->get('doctor_id');
        $reviews->ratings = $request->get('ratings');
        $reviews->reviews = $request->get('reviews');
        $reviews->reviewed_by = Auth::user()->name;
        $reviews->status = 'active';
        $reviews->save();

        //change appointment status
        $appointment->status = 'complete';
        $appointment->save();

        return response()->json([
            'success'=>'The appointment has been completed and reviewed successfully!',
        ], 200);
    }


    public function createUtente()
    {
        return view('doctors.create');
    }

    public function storeUtente(Request $request)
    {
        $validatedData = $request->validate([
            'doc_id' => 'required',
            'nome' => 'required',
            'category' => 'required',
            'patients' => 'required|integer',
            'experience' => 'required|integer',
            'bio_data' => 'required',
            'status' => 'required',
        ]);

        Doctor::create($validatedData);

        return redirect()->route('doctors.create')->with('success', 'Doctor created successfully!');
    }

    

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $doctor = Doctor::findOrFail($id);
        return view('doctors.show', compact('doctor'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
        $doctor = Doctor::findOrFail($id);
        return view('doctors.edit', compact('doctor'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $validatedData = $request->validate([
            // Definir regras de validação conforme necessário para a atualização do médico
        ]);

        Doctor::whereId($id)->update($validatedData);
        
        return redirect()->route('doctors.index')->with('success', 'Doctor updated successfully!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $doctor = Doctor::findOrFail($id);
        $doctor->delete();
        return redirect()->route('doctors.index')->with('success', 'Doctor deleted successfully!');
    }
}
