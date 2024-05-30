<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Testar Previsão de Compatibilidade</title>
</head>
<body>
    <h1>Testar Previsão de Compatibilidade</h1>
    <form action="/resultados_previsao" method="post">
        @csrf
        <label for="medicacao1">Medicação 1:</label>
        <input type="text" id="medicacao1" name="medicacao1">
        <br>
        <label for="medicacao2">Medicação 2:</label>
        <input type="text" id="medicacao2" name="medicacao2">
        <br>
        <button type="submit">Testar Previsão</button>
    </form>
</body>
</html>
