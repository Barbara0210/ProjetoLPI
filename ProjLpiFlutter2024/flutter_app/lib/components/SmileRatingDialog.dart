import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SmileRatingDialog extends StatefulWidget {
  final Function(double rating, String comment) onSubmitted;

  const SmileRatingDialog({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  _SmileRatingDialogState createState() => _SmileRatingDialogState();
}

class _SmileRatingDialogState extends State<SmileRatingDialog> {
  double _rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Qual o estado do utente',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Como se encontra o utente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSmileIcon(1, FontAwesomeIcons.solidFaceFrown),
              _buildSmileIcon(2, FontAwesomeIcons.solidFaceMeh),
              _buildSmileIcon(3, FontAwesomeIcons.solidFaceSmile),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              hintText: 'Avaliação',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmitted(_rating, _commentController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Submeter'),
        ),
      ],
    );
  }

  Widget _buildSmileIcon(double rating, IconData icon) {
    Color color;
    if (rating == 1) {
      color = Colors.red;
    } else if (rating == 2) {
      color = Colors.yellow;
    } else if (rating == 3) {
      color = Colors.green;
    } else {
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _rating = rating;
        });
      },
      child: Icon(
        icon,
        color: _rating == rating ? color : Colors.grey,
        size: 50,
      ),
    );
  }
}
