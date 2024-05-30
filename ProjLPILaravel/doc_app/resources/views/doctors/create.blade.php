<!DOCTYPE html>
<html>
<head>
    
    <title>Adicionar Novo Utente</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        form {
            display: grid;
            grid-gap: 20px;
        }
        label {
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
        }
        button[type="submit"] {
            padding: 15px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error {
            color: #dc3545;
            font-size: 14px;
        }
        .success {
            color: #28a745;
            font-size: 16px;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Adicionar novo utente</h2>

    @if ($errors->any())
        <div class="error">
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    @if (session('success'))
        <div class="success">
            {{ session('success') }}
        </div>
    @endif

    <form method="POST" action="{{ route('doctors.store') }}">
        @csrf
    
        <div>
            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome">
        </div>
       
        <div>
            <label for="patients">Número Cama:</label>
            <input type="number" id="patients" name="patients">
        </div>
        <div>
            <label for="experience">Idade:</label>
            <input type="number" id="experience" name="experience">
        </div>
        <div>
            <label for="bio_data">Informação</label>
            <textarea id="bio_data" name="bio_data"></textarea>
        </div>
        <div>
            <label for="status">Estado:</label>
            <input type="text" id="status" name="Estado">
        </div>
        <button type="submit">Submit</button>
        
    </form>
</div>

</body>
</html>
