<?php
namespace App\Http\Controllers;
use App\Models\Appointments;

use App\Models\Doctor;
use App\Models\Reviews;
use App\Models\User;

use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();

        // Retrieve appointments for today with related reviews, users, and doctors
        $appointments = Appointments::with(['review', 'user', 'doctor'])
            ->whereDate('date', $today)
            ->get();
    
        // Count the total number of doctors
        $totalDoctors = User::where('type', 'doctor')->count();
        $totalUsers = User::where('type', 'user')->count();
        $totalAdmins = User::where('type', 'admin')->count();
        $totalAppointmentsToday = $appointments->count();
        $totalAppointments = Appointments::count();

        return view('dashboard', compact('appointments', 'totalDoctors','totalUsers','totalAdmins', 'totalAppointmentsToday','totalAppointments'));
    }
}
