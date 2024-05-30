import 'package:flutter/material.dart';
import 'package:flutter_app/components/button.dart';
import 'package:flutter_app/models/auth_model.dart';
import 'package:flutter_app/providers/dio_provider.dart';
import 'package:flutter_app/utils/config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({Key? key, required this.doctor, required this.isFav}) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  late Map<String, dynamic> doctor;
  late bool isFav;

  @override
  void initState() {
    doctor = widget.doctor;
    isFav = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Detalhes Utente',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async {
              final list = Provider.of<AuthModel>(context, listen: false).getFav;
              if (list.contains(doctor['doc_id'])) {
                list.removeWhere((id) => id == doctor['doc_id']);
              } else {
                list.add(doctor['doc_id']);
              }
              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                final response = await DioProvider().storeFavDoc(token, list);
                if (response == 200) {
                  setState(() {
                    isFav = !isFav;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutDoctor(doctor: doctor),
            DetailBody(doctor: doctor),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Button(
                width: double.infinity,
                title: 'Marcar Monitorização',
                onPressed: () {
                 Navigator.of(context).pushNamed('booking_page', arguments: {"doctor_id": doctor['doc_id'], "nome": doctor['nome']});

                },
                disable: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({Key? key, required this.doctor}) : super(key: key);

  final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          const CircleAvatar(
            radius: 65.0,
            backgroundImage: AssetImage('assets/user.png'),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            'Utente ${doctor['nome'] ?? 'N/A'}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Unidade dos cuidados intensivos piso 6',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: const Text(
              'Hospital São João',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.doctor}) : super(key: key);

  final Map<String, dynamic> doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DoctorInfo(
            patients: doctor['patients'],
            exp: doctor['experience'],
          ),
          Config.spaceSmall,
          const Text(
            'Sobre Utente',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text(
            'Utente ${doctor['nome']} deu entrada nos cuidados intensivos no dia 01/05/24 por volta das 14h',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({Key? key, required this.patients, required this.exp}) : super(key: key);

  final int patients;
  final int exp;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(label: 'Cama', value: '$patients'),
        const SizedBox(width: 15),
        InfoCard(label: 'Idade', value: '$exp anos'),
        const SizedBox(width: 15),
        const InfoCard(label: 'Estabilidade', value: '4.0'),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value}) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
