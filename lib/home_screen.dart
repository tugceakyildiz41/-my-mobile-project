import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<List<String>> _weeklyPlans = List.generate(7, (index) => []);
  final List<String> _days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

  void _showNewPlanBottomSheet(BuildContext context) {
    TextEditingController _timeRangeController = TextEditingController();
    TextEditingController _lessonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Yeni Çalışma Planı Ekle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _timeRangeController,
                decoration: InputDecoration(
                  labelText: 'Saat Aralığı (Örn: 13:00-14:00)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _lessonController,
                decoration: InputDecoration(
                  labelText: 'Çalışılacak Ders',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  String timeRange = _timeRangeController.text.trim();
                  String lesson = _lessonController.text.trim();
                  if (timeRange.isNotEmpty && lesson.isNotEmpty) {
                    setState(() {
                      _weeklyPlans[0].add('$timeRange - $lesson'); // Şimdilik Pazartesi'ye ekle
                    });
                    Navigator.pop(context); // Modal'ı kapat
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen saat aralığı ve dersi girin')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text('Kaydet'),
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
        title: Text('Haftalık Çalışma Planı', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final day = _days[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    day,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  if (_weeklyPlans[index].isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _weeklyPlans[index].length,
                      itemBuilder: (context, planIndex) {
                        final plan = _weeklyPlans[index][planIndex];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('- $plan'),
                        );
                      },
                    )
                  else
                    Text('Bu güne ait henüz plan yok.'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewPlanBottomSheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}