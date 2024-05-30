<!DOCTYPE html>
<html>
<head>
    <title>Lista de Utentes na unidade</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f2f2f2;
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
        .list-group-item {
            padding: 20px;
            border-bottom: 1px solid #ddd;
            transition: background-color 0.3s ease;
        }
        .list-group-item:last-child {
            border-bottom: none;
        }
        .list-group-item:hover {
            background-color: #f9f9f9;
        }
        .card-title {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
            margin-bottom: 5px;
        }
        .card-text {
            color: #555;
            margin-bottom: 10px;
        }
        .btn {
            padding: 8px 16px;
            font-size: 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-align: center;
            text-decoration: none;
        }
        .btn-info {
            background-color: #17a2b8;
            color: #fff;
        }
        .btn-info:hover {
            background-color: #117a8b;
        }
        .btn-primary {
            background-color: #007bff;
            color: #fff;
            margin-left: 10px;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Lista de Utentes na Unidade</h1>
    <ul class="list-group">
        @foreach ($doctors as $doctor)
            <li class="list-group-item">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Nome: {{ $doctor->nome }}</h5>
                       
                        <p class="card-text">Idade: {{ $doctor->experience }} anos</p>
                        <p class="card-text">Numero da cama: {{ $doctor->patients }}</p>
                        <a class="btn btn-info" href="{{ route('doctors.show', $doctor->id) }}">Abrir</a>
                        <a class="btn btn-primary" href="{{ route('doctors.edit', $doctor->id) }}">Editar</a>
                    </div>
                </div>
            </li>
        @endforeach
    </ul>
</div>

</body>
</html>
