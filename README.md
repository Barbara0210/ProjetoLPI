# ProjetoLPI

Projeto realizado no ambito da unidade curricular de Laboratório de Projeto Integrado

Backend feito em laravel trabalhando com o XAMP e o phpMyAdmin
Frontend feito em flutter trabalhando com emulador android
Fast API em python criada para lidar com os request da compatibilidade e manipular a rede neuronal
Na pasta FilesCsv tem os ficheiros utilizados e gerados para treinar a rede neuronal.
Na pasta OrangeWorkFlow_NeuralNetwork tem o workflow criado no orange e o modelo treinado da rede neuronal.
Na pasta ScriptsParaFormatarMatrizEmCSV tem os scripts usados para ler a matriz e converter a mesma no ficheiro CSV usado para treinar a rede neuronal.

Para iniciar a api em laravel, temos que iniciar o XAMPP no nosso computador. Navegar até a pasta doc_app e executar no terminal npm run dev e noutro terminal php artisan serve

Para iniciar a app em flutter temos que navegar para a pasta flutter_app e executar no terminal flutter run

Para iniciar a FastApi em python que esta na pasta API,  temos que instalar o uvicorn com o comando " pip install fastapi uvicorn",  criar um ambiente virtual em python com o comando por exemplo "py -3.11 -m venv myenv" e depois entrar nel "myenv\Scripts\activate" e depois iniciar a api com o comando "uvicorn.exe main:app --host 127.0.0.1 --port 8001"
