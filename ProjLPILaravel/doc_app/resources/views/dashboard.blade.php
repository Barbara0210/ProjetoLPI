<style> 
.custom-button {
    background-color: #1E90FF; /* Cor de fundo verde */
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
    border-radius: 8px; /* Cantos arredondados */
    transition-duration: 0.4s;
}

.custom-button:hover {
    background-color: #4682B4; /* Mais escuro ao passar o mouse */
} 
</style>

<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
          
            <button onclick="window.location.href='/doctors'" class="custom-button">Lista de utentes na unidade</button>
            <button onclick="window.location.href='/doctors/create'" class="custom-button">Criar novo utente</button>
        </h2>
    </x-slot>

    <div class="min-h-screen py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-center bg-gray-100 py-10 p-14">
                <!-- First stats container -->
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">Utentes na unidade</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>Total</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{ $totalDoctors }}</p>
                    </div>
                </div>

                <!-- Second stats container -->
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">Enfermeiros registados</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>Total</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{ $totalUsers }}</p>
                    </div>
                </div>

                <!-- Third stats container -->
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">Monitorizações registadas hoje</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>Total</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">
                        {{$totalAppointmentsToday}}
                        </p>
                    </div>
                </div>

                <!-- Fourth stats container -->
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5"> Monitorizações </p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>Total</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{$totalAppointments}}</p>
                    </div>
                </div>
            </div>

            <div class="bg-white overflow-hidden shadow-xl sm:rounded-lg">
                <div class="row">
                    <div class="col-md-7 mt-4">
                        <div class="card">
                            <div class="card-header my-3 pb-0 px-3">
                                <h6 class="mb-0">Monitorizações de hoje e suas avaliações</h6>
                            </div>
                            <div class="card-body pt-4 p-3">
                                @if(isset($appointments) && !$appointments->isEmpty())
                                    <ul class="list-group">
                                        @foreach ($appointments as $appointment)
                                            <li class="list-group-item border-0 d-flex p-4 mb-2 bg-gray-100 border-radius-lg">
                                                <div class="d-flex flex-column">
                                                    <h6 class="mb-3 text-sm">Monitorização com utente {{ $appointment->doctor->name }} avaliado por  {{ $appointment->user->name }}</h6>
                                                    <div class="flex justify-between">
                                                        <span class="mb-2 text-xs">Data: {{ \Carbon\Carbon::parse($appointment->date)->format('d-m-Y') }}</span>
                                                        @if($appointment->review)
                                                            <span class="mb-2 text-xs">Comentário: {{ $appointment->review->reviews }}</span>
                                                            <span class="mb-2 text-xs">Apreciação: {{ $appointment->review->ratings }}</span>
                                                        @else
                                                            <span class="mb-2 text-xs">No review available</span>
                                                        @endif
                                                    </div>
                                                </div>
                                            </li>
                                        @endforeach
                                    </ul>
                                @else
                                    <div class="border-0 d-flex p-4 mb-2 mt-3 bg-gray-100 border-radius-lg">
                                        <h6 class="mb-3 text-sm">No Appointments Today!</h6>
                                    </div>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
