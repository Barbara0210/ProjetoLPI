import 'package:flutter/material.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/screens/view_appointment_page.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_app/screens/edit_review_page.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<dynamic> schedules = [];
  List<dynamic> filteredSchedules = [];
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    print('Received appointment data: $appointment');
    if (appointment != 'Error') {
      setState(() {
        schedules = json.decode(appointment);
        filterSchedulesByDate();
        print('Decoded schedules: $schedules');
      });
    }
  }

  void filterSchedulesByDate() {
    setState(() {
      filteredSchedules = schedules.where((schedule) {
        return schedule['date'] == selectedDate;
      }).toList();
    });
  }

  Future<dynamic> getReviewByAppointmentId(int appointmentId, String token) async {
    final response = await DioProvider().fetchReview(appointmentId, token);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Monitorizações Realizadas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.spaceSmall,
            DropdownButton<String>(
              value: selectedDate,
              items: List.generate(8, (index) {
                final date = DateTime.now().subtract(Duration(days: index));
                final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                return DropdownMenuItem(
                  value: formattedDate,
                  child: Text(formattedDate),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedDate = value!;
                  filterSchedulesByDate();
                });
              },
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  var schedule = filteredSchedules[index];
                  bool isLastElement = index == filteredSchedules.length - 1;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLastElement ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
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
                                    schedule['doctor_name'] ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Cama: ${schedule['patients'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Idade: ${schedule['experience'] ?? 'N/A'} anos',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Info: ${schedule['bio_data'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          ScheduleCard(
                            date: schedule['date'],
                            day: schedule['day'],
                            time: schedule['time'],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewAppointmentPage(appointment: schedule),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Ver',
                                    style: TextStyle(color: Config.primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Config.primaryColor,
                                  ),
                                  onPressed: () async {
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    final token = prefs.getString('token') ?? '';
                                    final review = await getReviewByAppointmentId(schedule['id'], token);
                                    if (review != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditReviewPage(
                                            appointment: schedule,
                                            review: review,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Nenhuma revisão encontrada.')),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Editar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
