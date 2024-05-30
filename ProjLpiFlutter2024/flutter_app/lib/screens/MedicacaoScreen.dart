import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> classificarCompatibilidade(List<String> medicamentos) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8001/classificar'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'medicamentos': medicamentos}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao classificar a compatibilidade');
  }
}

class MedicacaoScreen extends StatefulWidget {
  @override
  _MedicacaoScreenState createState() => _MedicacaoScreenState();
}

class _MedicacaoScreenState extends State<MedicacaoScreen> {
  final List<String> _medicamentosSelecionados = [''];
  final List<String> _medicamentosDisponiveis = [
    'Adrenaline', 'Alfentanil', 'Aminophyline', 'Amiodarona', 'Atracurium',
    'Bicabornato de sodio', 'Calcio', 'Cetorolac', 'Ciprofloxacin', 'Cis-atracurium'
  ];
  Map<String, dynamic>? _resultado;

  void _addMedicamentoField() {
    setState(() {
      _medicamentosSelecionados.add('');
    });
  }

  void _removeMedicamentoField(int index) {
    setState(() {
      _medicamentosSelecionados.removeAt(index);
    });
  }

  void _cancelarPesquisa() {
    setState(() {
      _medicamentosSelecionados.clear();
      _medicamentosSelecionados.add('');
      _resultado = null;
    });
  }

  Future<void> _classificarCompatibilidade() async {
    try {
      final medicamentos = _medicamentosSelecionados.where((text) => text.isNotEmpty).toList();

      if (medicamentos.isNotEmpty) {
        final resultado = await classificarCompatibilidade(medicamentos);
        setState(() {
          _resultado = resultado;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha os campos de medicamentos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao classificar a compatibilidade')),
      );
    }
  }

  Widget _buildResultadoCard(String title, List<dynamic> pairs, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            ...pairs.map((pair) => ListTile(
                  title: Text(
                    '${pair[0]} e ${pair[1]}',
                    style: TextStyle(color: color),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compatibilidade de Medicação',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._medicamentosSelecionados.asMap().entries.map((entry) {
                int index = entry.key;
                String medicamentoSelecionado = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _medicamentosDisponiveis.where((String option) {
                              return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                          onSelected: (String selection) {
                            setState(() {
                              _medicamentosSelecionados[index] = selection;
                            });
                          },
                          initialValue: TextEditingValue(text: medicamentoSelecionado),
                          fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(labelText: 'Medicamento'),
                              onChanged: (newValue) {
                                setState(() {
                                  _medicamentosSelecionados[index] = newValue;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _removeMedicamentoField(index),
                      ),
                    ],
                  ),
                );
              }),
              ElevatedButton(
                onPressed: _addMedicamentoField,
                child: Text('Adicionar Medicamento'),
              ),
            
              ElevatedButton(
                onPressed: _classificarCompatibilidade,
                child: Text('Classificar'),
              ),
              ElevatedButton(
                onPressed: _cancelarPesquisa,
                child: Text('Limpar Pesquisa'),
              ),
              if (_resultado != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Resultado: ${_resultado!['compatibilidade']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                if (_resultado!['details']['incompatibles'].isNotEmpty) ...[
                  _buildResultadoCard(
                    'Incompatíveis:',
                    _resultado!['details']['incompatibles'],
                    Colors.red,
                  ),
                ],
                if (_resultado!['details']['compatibles'].isNotEmpty) ...[
                  _buildResultadoCard(
                    'Compatíveis:',
                    _resultado!['details']['compatibles'],
                    Colors.green,
                  ),
                ],
                if (_resultado!['details']['no_info'].isNotEmpty) ...[
                  _buildResultadoCard(
                    'Sem informação:',
                    _resultado!['details']['no_info'],
                    const Color.fromARGB(255, 237, 219, 55),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}


