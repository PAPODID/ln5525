import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';

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

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedExam;
  String? selectedSeries;
  String? selectedYear;
  String? selectedEducationType;

  final List<String> educationTypes = ['Technique', 'Générale'];
  final List<String> exams = ['BAC', 'PROBAC'];
  final List<String> technicalSeries = [
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
  final List<String> generalSeries = ['A4', 'C', 'D'];
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

  List<String> get series {
    if (selectedEducationType == 'Technique') {
      return technicalSeries;
    } else if (selectedEducationType == 'Générale') {
      return generalSeries;
    }
    return [];
  }

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
                    ? Tween<double>(begin: 0.75, end: 1).animate(animation)
                    : Tween<double>(begin: 1, end: 0.75).animate(animation),
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
                Text('Types d\'enseignement',
                    style: TextStyle(color: Colors.white)),
                DropdownButton<String>(
                  value: selectedEducationType,
                  dropdownColor: Colors.grey[900],
                  hint: Text('Sélectionnez un type d\'enseignement',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEducationType = newValue;
                      selectedSeries = null;
                    });
                  },
                  items: educationTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
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
                      if (selectedEducationType != null &&
                          selectedExam != null &&
                          selectedSeries != null &&
                          selectedYear != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectsPage(
                              educationType: selectedEducationType!,
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
  final String educationType;
  final String exam;
  final String series;
  final String year;

  SubjectsPage({
    required this.educationType,
    required this.exam,
    required this.series,
    required this.year,
  });
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
        .child(
            '${widget.educationType}/${widget.exam}/${widget.series}/${widget.year}')
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
            return ListView(
              children: snapshot.data!.map((subject) {
                return ListTile(
                  title: Text(subject),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectFilesPage(
                          educationType: widget.educationType,
                          exam: widget.exam,
                          series: widget.series,
                          year: widget.year,
                          subject: subject,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class SubjectFilesPage extends StatelessWidget {
  final String educationType;
  final String exam;
  final String series;
  final String year;
  final String subject;

  SubjectFilesPage({
    required this.educationType,
    required this.exam,
    required this.series,
    required this.year,
    required this.subject,
  });

  Future<Map<String, String>> _fetchFiles() async {
    ListResult result = await FirebaseStorage.instance
        .ref()
        .child('$educationType/$exam/$series/$year/$subject')
        .listAll();
    Map<String, String> files = {};
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      files[ref.name] = url;
    }
    return files;
  }

  Future<void> _downloadFile(String url, String fileName) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _shareFile(String url, String fileName) async {
    await FlutterShare.share(
      title: 'Partager fichier',
      text: 'Consultez ce fichier : $fileName',
      linkUrl: url,
      chooserTitle: 'Partager fichier via',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichiers pour $subject'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des fichiers'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun fichier trouvé'));
          } else {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.file_download),
                        onPressed: () {
                          _downloadFile(entry.value, entry.key);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          _shareFile(entry.value, entry.key);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
