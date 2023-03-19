import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionNote extends StatefulWidget {
  var title;
  var description;

  DescriptionNote({required this.title, required this.description});

  @override
  State<DescriptionNote> createState() => _DescriptionNoteState();
}

class _DescriptionNoteState extends State<DescriptionNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
        title: Text(
          'Note Description',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.deepPurple[100],
                    child: ListTile(
                      title: Text(
                        widget.title,
                        style: GoogleFonts.cinzel(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      subtitle: Text(
                        widget.description,
                        style: GoogleFonts.cinzel(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
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
