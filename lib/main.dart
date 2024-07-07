import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;

  ThemeData getTheme() {
    return _isDarkTheme ? ThemeData.dark() : ThemeData.light();
  }

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.getTheme(),
          home: SearchPage(),
        );
      },
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedExam;
  String? selectedSeries;
  String? selectedYear;

  final List<String> exams = ['BAC', 'PROBAC'];
  final List<String> series = [
    'G1',
    'G2',
    'G3',
    'F1',
    'F2',
    'F3',
    'F4',
    'E',
    'Ti/1'
  ];
  final List<String> years = [
    '2007',
    '2008',
    '2009',
    '2010',
    '2011',
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recherche d\'Examens'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: child.key == ValueKey('icon_dark')
                    ? Tween<double>(begin: 1, end: 0.75).animate(animation)
                    : Tween<double>(begin: 0.75, end: 1).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                Provider.of<ThemeNotifier>(context).isDarkTheme
                    ? Icons.brightness_6_outlined
                    : Icons.brightness_3_outlined,
                key: ValueKey(Provider.of<ThemeNotifier>(context).isDarkTheme
                    ? 'icon_light'
                    : 'icon_dark'),
              ),
            ),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.yellow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Examens disponibles',
                    style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: selectedExam,
                  dropdownColor: Colors.grey[900],
                  hint: Text('Sélectionnez un examen',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedExam = newValue;
                    });
                  },
                  items: exams.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text('Séries', style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: selectedSeries,
                  dropdownColor: Colors.grey[900],
                  hint: Text('Sélectionnez une série',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSeries = newValue;
                    });
                  },
                  items: series.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text('Année', style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: selectedYear,
                  dropdownColor: Colors.grey[900],
                  hint: Text('Sélectionnez une année',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: years.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedExam != null &&
                          selectedSeries != null &&
                          selectedYear != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectsPage(
                              exam: selectedExam!,
                              series: selectedSeries!,
                              year: selectedYear!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Veuillez sélectionner toutes les options'),
                          ),
                        );
                      }
                    },
                    child: Text('Valider la recherche'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectsPage extends StatefulWidget {
  final String exam;
  final String series;
  final String year;

  SubjectsPage({required this.exam, required this.series, required this.year});

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<String>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjects();
  }

  Future<List<String>> _fetchSubjects() async {
    ListResult result = await FirebaseStorage.instance
        .ref()
        .child('${widget.exam}/${widget.series}/${widget.year}')
        .listAll();
    List<String> subjects =
        result.prefixes.map((prefix) => prefix.name).toList();
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Matières pour ${widget.exam} ${widget.series} ${widget.year}'),
      ),
      body: FutureBuilder<List<String>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fichiers'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune matière trouvée'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String subject = snapshot.data![index];
                return ListTile(
                  title: Text(subject),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilesPage(
                          exam: widget.exam,
                          series: widget.series,
                          year: widget.year,
                          subject: subject,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FilesPage extends StatefulWidget {
  final String exam;
  final String series;
  final String year;
  final String subject;

  FilesPage({
    required this.exam,
    required this.series,
    required this.year,
    required this.subject,
  });

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late Future<Map<String, String>> _filesFuture;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filesFuture = _fetchFiles();
  }

  Future<Map<String, String>> _fetchFiles() async {
    ListResult result = await FirebaseStorage.instance
        .ref()
        .child(
            '${widget.exam}/${widget.series}/${widget.year}/${widget.subject}')
        .listAll();
    Map<String, String> files = {};
    for (var item in result.items) {
      String url = await item.getDownloadURL();
      files[item.name] = url;
    }
    return files;
  }

  Future<void> _addComment(String comment) async {
    await FirebaseFirestore.instance.collection('comments').add({
      'exam': widget.exam,
      'series': widget.series,
      'year': widget.year,
      'subject': widget.subject,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Comment>> _getComments() {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('exam', isEqualTo: widget.exam)
        .where('series', isEqualTo: widget.series)
        .where('year', isEqualTo: widget.year)
        .where('subject', isEqualTo: widget.subject)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment(
                  comment: doc['comment'],
                  timestamp: (doc['timestamp'] as Timestamp).toDate(),
                ))
            .toList());
  }

  void _showCommentsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Commentaires pour ${widget.subject}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Ajouter un commentaire',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    _addComment(_commentController.text);
                    _commentController.clear();
                  }
                },
                child: Text('Envoyer'),
              ),
              SizedBox(height: 16),
              StreamBuilder<List<Comment>>(
                stream: _getComments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erreur de chargement des commentaires');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Aucun commentaire trouvé');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final comment = snapshot.data![index];
                          return ListTile(
                            title: Text(comment.comment),
                            subtitle: Text(comment.timestamp.toString()),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichiers pour ${widget.subject}'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fichiers'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun fichier trouvé'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: snapshot.data!.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () async {
                                final url = entry.value;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () async {
                                await FlutterShare.share(
                                  title: 'Partager le fichier',
                                  linkUrl: entry.value,
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: _showCommentsDialog,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class Comment {
  final String comment;
  final DateTime timestamp;

  Comment({required this.comment, required this.timestamp});
}
