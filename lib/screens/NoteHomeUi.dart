import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/NoteDbHeloer.dart';
import 'descriptionnote.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteHomeUI extends StatefulWidget {
  const NoteHomeUI({super.key});

  @override
  State<NoteHomeUI> createState() => _NoteHomeUIState();
}

class _NoteHomeUIState extends State<NoteHomeUI> {
  ///////////////////////////insert database/////////////////////////////
  insertdatabase(title, description) {
    NoteDbHelper.instance.insert({
      NoteDbHelper.coltitle: title,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }

  updatedatabase(snap, index, title, description) {
    NoteDbHelper.instance.update({
      NoteDbHelper.colid: snap.data![index][NoteDbHelper.colid],
      NoteDbHelper.coltitle: title,
      NoteDbHelper.coldescription: description,
      NoteDbHelper.coldate: DateTime.now().toString(),
    });
  }

  deletedatabase(snap, index) {
    NoteDbHelper.instance.delete(snap.data![index][NoteDbHelper.colid]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.black,
          toolbarHeight: MediaQuery.of(context).size.height * 0.07,
          title: Center(child: Text(
              'Your Notes',
          style: GoogleFonts.cinzel(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),))),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: FutureBuilder(
            future: NoteDbHelper.instance.queryAll(),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
              if (snap.hasData) {
                return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      dragStartBehavior: DragStartBehavior.start,
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you wish to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL")),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                              ],
                            );
                          },
                        );
                      },
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        deletedatabase(snap, index);
                      },
                      background: Container(
                          color: Colors.redAccent[700], child: const Icon(Icons.delete)),
                      child: SizedBox(
                        height: 100,
                        width: 2000,
                        child: Card(
                          color: Colors.deepPurple[100],
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return DescriptionNote(
                                      title: snap.data![index]
                                          [NoteDbHelper.coltitle],
                                      description: snap.data![index]
                                          [NoteDbHelper.coldescription]);
                                },
                              ));
                            },
                            leading: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      var title = '';
                                      var description = '';
                                      return AlertDialog(

                                        title:  Text('Edit Note',
                                        style: GoogleFonts.cinzel(
                                          fontWeight: FontWeight.w800,
                                        ),),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              onChanged: (value) {
                                                title = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: snap.data![index]
                                                      [NoteDbHelper.coltitle]),
                                              style: GoogleFonts.cinzel(

                                              ),
                                            ),
                                            TextField(
                                                onChanged: (value) {
                                                  description = value;
                                                },
                                                decoration: InputDecoration(
                                                    hintText: snap.data![index][
                                                        NoteDbHelper
                                                            .coldescription],),
                                            style: GoogleFonts.cinzel(

                                            ),),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.deepPurple,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel')),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.deepPurple,
                                              ),
                                              onPressed: () {
                                                updatedatabase(snap, index,
                                                    title, description);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'))
                                        ],
                                      );
                                    },
                                  );
                                  //
                                },
                                icon: Icon(Icons.edit)),
                            title:
                                Text(
                                    snap.data![index][NoteDbHelper.coltitle],
                                style: GoogleFonts.cinzel(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),),
                            subtitle: Text(
                                snap.data![index][NoteDbHelper.coldescription],
                            style: GoogleFonts.cinzel(
                              fontWeight: FontWeight.w700,

                            ),),
                            trailing: Text(snap.data![index]
                                    [NoteDbHelper.coldate]
                                .toString()
                                .substring(0, 19),
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    // child: CircularProgressIndicator(),
                    );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              var title = '';
              var description = '';
              return AlertDialog(
                backgroundColor: Colors.grey[200],
                title: const Text('Add New Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        onChanged: (value) {
                          title = value;
                        },
                        decoration: const InputDecoration(hintText: 'Title')),
                    TextField(
                        onChanged: (value) {
                          description = value;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Description')),
                  ],
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        insertdatabase(title, description);
                        Navigator.pop(context);
                      },
                      child: const Text('Save'))
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
