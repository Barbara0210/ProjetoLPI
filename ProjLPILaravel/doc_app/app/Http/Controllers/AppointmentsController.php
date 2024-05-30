<?php

namespace App\Http\Controllers;

use App\Models\Appointments;
use App\Models\User;
use App\Models\Reviews;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
class AppointmentsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
{
    // Retrieve all appointments for the authenticated user
    $appointments = Appointments::where('user_id', Auth::user()->id)->get();
    $doctors = User::where('type', 'doctor')->with('doctor')->get();

    // Merge appointment and doctor details
    foreach ($appointments as $appointment) {
        foreach ($doctors as $doctor) {
            if ($appointment['doc_id'] == $doctor['id']) {
                $details = $doctor->doctor;
                $appointment['doctor_name'] = $doctor['name'];
                $appointment['doctor_profile'] = $doctor['profile_photo_url'];
                $appointment['category'] = $details['category'];
                $appointment['patients'] = $details['patients'];
                $appointment['bio_data'] = $details['bio_data'];
                $appointment['experience'] = $details['experience'];
               
            }
        }
    }

    return $appointments;
}

public function storeReview(Request $request) {
    $review = Reviews::create([
        'user_id' => auth()->id(),
        'doc_id' => $request->input('doctor_id'),
        'appointment_id' => $request->input('appointment_id'),
        'ratings' => $request->input('ratings'),
        'reviews' => $request->input('reviews'),
        'reviewed_by' => auth()->id(), // ou outro campo adequado
        'status' => 'active', // ou qualquer outro status adequado
    ]);

    return response()->json($review, 201);
}
public function ListAppointmentDashboard()
    {
        // Obtém a data atual
        $currentDate = now()->toDateString();

        // Obtém todos os appointments do dia atual com suas reviews associadas, se houver
        $appointments = Appointments::whereDate('date', $currentDate)
            ->with('review')
            ->get();

        // Retorna a view com os appointments e reviews associadas
        return view('dashboard.index', compact('appointments'));
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
        $appointment = new Appointments();
        $appointment->user_id = Auth::user()->id;
        $appointment->doc_id = $request->get('doctor_id');
        $appointment->date = $request->get('date');
        $appointment->day = $request->get('day');
        $appointment->time = $request->get('time');
        $appointment->status = 'upcoming'; //new appointment will be saved as upcoming by default
        $appointment->save();
    
        return response()->json([
            'success' => 'New appointment has been made successfully!',
            'id' => $appointment->id, // Return the ID of the created appointment
        ], 200);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $appointment = Appointments::with('doctor', 'user')->find($id);
    
        if (!$appointment) {
            return response()->json(['message' => 'Appointment not found'], 404);
        }
    
        // Get the review for this appointment
        $review = Reviews::where('appointment_id', $appointment->id)->first();
    
        return response()->json([
            'appointment' => $appointment,
            'review' => $review
        ]);
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
    public function update(Request $request, $id)
    {
        $appointment = Appointments::find($id);
    
        if (!$appointment) {
            return response()->json(['error' => 'Appointment not found'], 404);
        }
    
        $appointment->date = $request->input('date');
        $appointment->day = $request->input('day');
        $appointment->time = $request->input('time');
        $appointment->save();
    
        return response()->json(['success' => 'Appointment updated successfully'], 200);
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
