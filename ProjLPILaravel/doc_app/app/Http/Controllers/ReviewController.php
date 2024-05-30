<?php
namespace App\Http\Controllers;

use App\Models\Reviews;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function getReviewsByAppointment(Request $request)
    {
        $appointmentId = $request->query('appointment_id');
        if (!$appointmentId) {
            return response()->json(['error' => 'Appointment ID is required'], 400);
        }

        $reviews = Reviews::where('appointment_id', $appointmentId)->get();

        return response()->json($reviews);
    }


    public function updateReview(Request $request, $id)
    {
        $review = Reviews::find($id);
        if (!$review) {
            return response()->json(['error' => 'Review not found'], 404);
        }

        $validated = $request->validate([
            'ratings' => 'required|integer',
            'reviews' => 'required|string',
        ]);

        $review->update($validated);

        return response()->json($review);
    }
    public function getLatestReview($doctorId)
    {
        $review = Reviews::with(['user', 'appointment'])
                         ->where('doc_id', $doctorId)
                         ->orderBy('created_at', 'desc')
                         ->first();
    
        if ($review) {
            return response()->json($review, 200);
        } else {
            return response()->json(['message' => 'No reviews found'], 404);
        }
    }
}