// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CircularProgressWidget extends StatefulWidget {
  final Color color;
  final String text;

  const CircularProgressWidget({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  _CircularProgressWidgetState createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  void initState() {
    super.initState();
    // Retrasar la finalización de la tarea durante 3 segundos
    Future.delayed(const Duration(seconds: 4), () {
      // Notificar a la aplicación que la tarea ha finalizado
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: widget.color,
            //strokeWidth: 2.5,
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: "IM",
                color: widget.color,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
