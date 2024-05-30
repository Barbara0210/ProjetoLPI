import 'package:flutter/material.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAppointmentPage extends StatefulWidget {
  final dynamic appointment;

  const ViewAppointmentPage({Key? key, required this.appointment}) : super(key: key);

  @override
  _ViewAppointmentPageState createState() => _ViewAppointmentPageState();
}

class _ViewAppointmentPageState extends State<ViewAppointmentPage> {
  Map<String, dynamic>? review;
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    getTokenAndFetchReview();
  }

  Future<void> getTokenAndFetchReview() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    if (token != null && token!.isNotEmpty) {
      final fetchedReview = await DioProvider().fetchReview(widget.appointment['id'], token!);
      setState(() {
        review = fetchedReview;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildRatingWidget(double rating) {
    IconData iconData;
    Color color;

    switch (rating.toInt()) {
      case 1:
        iconData = Icons.sentiment_very_dissatisfied;
        color = Colors.red;
        break;
      case 2:
        iconData = Icons.sentiment_neutral;
        color = Colors.yellow;
        break;
      case 3:
        iconData = Icons.sentiment_very_satisfied;
        color = Colors.green;
        break;
      default:
        iconData = Icons.sentiment_dissatisfied;
        color = Colors.grey;
        break;
    }

    return Row(
      children: [
        Icon(iconData, color: color),
        const SizedBox(width: 5),
        Text('Nota: $rating', style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Compromisso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Detalhes do Compromisso',
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
                      'Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    isLoading
                        ? const CircularProgressIndicator()
                        : review != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    review!['reviews'],
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  buildRatingWidget(review!['ratings'].toDouble()),
                                ],
                              )
                            : const Text(
                                'No review available.',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
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
