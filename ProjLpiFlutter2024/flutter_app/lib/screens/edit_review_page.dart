import 'package:flutter/material.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditReviewPage extends StatefulWidget {
  final dynamic appointment;
  final dynamic review;

  const EditReviewPage({Key? key, required this.appointment, required this.review}) : super(key: key);

  @override
  _EditReviewPageState createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  String? token;

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.review['reviews'];
    _rating = widget.review['ratings'].toDouble();
    getToken();
  }

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Avaliação'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Detalhes da Monitorização',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Image.asset('assets/user.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.appointment['doctor_name'] ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Cama: ${widget.appointment['patients'] ?? 'N/A'}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Idade: ${widget.appointment['experience'] ?? 'N/A'} anos',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Info: ${widget.appointment['bio_data'] ?? 'N/A'}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ScheduleCard(
                      date: widget.appointment['date'],
                      day: widget.appointment['day'],
                      time: widget.appointment['time'],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Avaliação Atual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.review['reviews'] ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Apreciação Atual: ${widget.review['ratings'] ?? 'N/A'}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Editar Avaliação',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Comentário',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Apreciação:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: _rating == 1 ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_neutral,
                            color: _rating == 2 ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = 2;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_very_satisfied,
                            color: _rating == 3 ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = 3;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (token != null && token!.isNotEmpty) {
                          final updatedReview = await DioProvider().updateReview(
                            widget.review['id'],
                            _commentController.text,
                            _rating,
                            token!,
                          );

                          if (updatedReview != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Revisão atualizada com sucesso!')),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao atualizar revisão.')),
                            );
                          }
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.date, required this.day, required this.time}) : super(key: key);
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$day, $date',
            style: const TextStyle(color: Config.primaryColor),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              time,
              style: const TextStyle(color: Config.primaryColor),
            ),
          )
        ],
      ),
    );
  }
}
