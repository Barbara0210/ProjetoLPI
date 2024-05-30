<!DOCTYPE html>
<html>
<head>
    <title>Show Doctor</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e9ecef;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-size: 28px;
        }
        .info-container, .reviews-container {
            margin-bottom: 20px;
        }
        .info-container p, .reviews-container p {
            margin-bottom: 10px;
            font-size: 16px;
        }
        .info-container p strong, .reviews-container p strong {
            color: #007bff;
        }
        .review {
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 10px 15px;
            margin-bottom: 10px;
            border-radius: 5px;
        }
        .review p {
            margin: 5px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-align: center;
            text-decoration: none;
        }
        .btn-info {
            background-color: #007bff;
            color: #fff;
        }
        .btn-info:hover {
            background-color: #0056b3;
        }
        .btn-back {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Detalhes Utente</h1>
        <div class="info-container">
            <p><strong>Nome:</strong> {{ $doctor->nome }}</p>
            <p><strong>Idade:</strong> {{ $doctor->experience }} anos</p>
            <p><strong>Número de cama:</strong> {{ $doctor->patients }}</p>
            <p><strong>Informação:</strong> {{ $doctor->bio_data }}</p>
            <p><strong>Estado:</strong> {{ $doctor->status }}</p>
        </div>
        <div class="reviews-container">
            <h2>Avaliações</h2>
            @forelse($doctor->reviews as $review)
                <div class="review">
                    <p><strong>Avaliado por:</strong> {{ $review->reviewed_by }}</p>
                    <p><strong>Comentário:</strong> {{ $review->reviews }}</p>

                    <p><strong>Avaliação:</strong> {{ $review->ratings }}</p>
                </div>
            @empty
                <p>No reviews available.</p>
            @endforelse
        </div>
        <div class="btn-back">
            <a class="btn btn-info" href="{{ route('doctors.index') }}">Voltar à lista</a>
        </div>
    </div>
</body>
</html>
