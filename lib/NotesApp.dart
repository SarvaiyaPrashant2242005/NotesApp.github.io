import 'package:flutter/material.dart';

class MyNotesApp extends StatefulWidget {
  @override
  _MyNotesAppState createState() => _MyNotesAppState();
}

class _MyNotesAppState extends State<MyNotesApp> {
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: NotesPage(
        darkModeEnabled: darkModeEnabled,
        onToggleTheme: () {
          setState(() {
            darkModeEnabled = !darkModeEnabled;
          });
        },
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  final bool darkModeEnabled;
  final VoidCallback onToggleTheme;

  const NotesPage({
    required this.darkModeEnabled,
    required this.onToggleTheme,
  });

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<String> notesList = [];
  final TextEditingController textController = TextEditingController();

  void addNewNote() {
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        notesList.add(textController.text.trim());
      });
      textController.clear();
    }
  }

  void removeNoteAt(int index) {
    setState(() {
      notesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              widget.darkModeEnabled ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
        elevation: 4,
        backgroundColor: widget.darkModeEnabled ? Colors.teal[900] : Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.darkModeEnabled ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.darkModeEnabled ? Colors.black54 : Colors.grey,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Write your note here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.teal),
                    onPressed: addNewNote,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: notesList.isEmpty
                ? Center(
                    child: Text(
                      'No notes yet. Start adding some!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: widget.darkModeEnabled ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(notesList[index]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => removeNoteAt(index),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              notesList[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
