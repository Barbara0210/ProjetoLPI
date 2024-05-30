import 'package:flutter/widgets.dart';
import 'package:flutter_app/components/SmileRatingDialog.dart';
import 'package:flutter_app/components/button.dart';
import 'package:flutter_app/components/custom_appbar.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/screens/doctor_details.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _currentDay = DateTime.now();
  String? token;
  Map<String, dynamic>? latestReview;
  bool _isInitialized = false;
  String? _errorMessage;

  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
  }

  Future<void> fetchLatestReview(int doctorId) async {
    if (token == null) await getToken(); // Ensure token is available
    try {
      final review = await DioProvider().getLastReview(doctorId.toString(), token!);
      setState(() {
        latestReview = review;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final doctorId = doctor['doctor_id'];
      getToken().then((_) => fetchLatestReview(doctorId));
      _isInitialized = true;
    }
  }

  Widget _buildSmileIcon(double rating) {
    IconData icon;
    Color color;

    if (rating == 1) {
      icon = FontAwesomeIcons.solidFaceFrown;
      color = Colors.red;
    } else if (rating == 2) {
      icon = FontAwesomeIcons.solidFaceMeh;
      color = Colors.yellow;
    } else if (rating == 3) {
      icon = FontAwesomeIcons.solidFaceSmile;
      color = Colors.green;
    } else {
      icon = FontAwesomeIcons.question;
      color = Colors.grey;
    }

    return Icon(
      icon,
      color: color,
      size: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final doctorId = doctor['doctor_id'];
    final doctorName = doctor['nome'];

    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Monitorização/Utente',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AboutDoctor(doctor: doctor),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: _errorMessage != null
                  ? Text('Error: $_errorMessage', style: TextStyle(color: Colors.red))
                  : latestReview != null
                      ? Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ultima Avaliação',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  _buildSmileIcon(latestReview!['ratings'].toDouble()), // Ensure rating is double
                                  SizedBox(width: 10),
                                  Text(
                                    'Apreciação: ${latestReview!['ratings']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.comment, color: Colors.grey),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      'Commentário: ${latestReview!['reviews']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text(
                                    'Avaliado por: ${latestReview!['user']['name']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Colors.green),
                                  SizedBox(width: 5),
                                  Text(
                                    'Data da monitorização: ${latestReview!['appointment']['date']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text(
                                    'Hora da monitorização: ${latestReview!['appointment']['time']}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Center(child: Text('Sem avaliações anteriores')),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Button(
                width: double.infinity,
                title: 'Fazer avaliação',
                onPressed: () async {
                  final getDate = _currentDay.toIso8601String().split('T')[0];
                  final getDay = _currentDay.weekday.toString();
                  final getTime = TimeOfDay.now().format(context);

                  try {
                    final booking = await DioProvider().bookAppointment(getDate, getDay, getTime, doctorId, token!);

                    if (booking != 'Error') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SmileRatingDialog(
                            onSubmitted: (double rating, String comment) async {
                              final reviewResponse = await DioProvider().storeReviews(
                                  comment, rating, booking['id'], doctorId, token!);
                              print(reviewResponse);
                              if (reviewResponse == 201) {
                                MyApp.navigatorKey.currentState!.pushNamed('success_booking');
                              }
                            },
                          );
                        },
                      );
                    } else {
                      print('Failed to book appointment');
                    }
                  } catch (e) {
                    print('Error booking appointment: $e');
                  }
                },
                disable: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
