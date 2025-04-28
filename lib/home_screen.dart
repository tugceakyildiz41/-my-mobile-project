import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<List<String>> _weeklyPlans = List.generate(7, (index) => []);
  final List<String> _days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

  void _showNewPlanBottomSheet(BuildContext context, int dayIndex, {String? existingPlan, int? planIndex}) {
    TimeOfDay? _startTime;
    TimeOfDay? _endTime;
    TextEditingController _lessonController = TextEditingController(text: existingPlan?.split(' - ').last.trim());

    if (existingPlan != null) {
      final parts = existingPlan.split(' - ');
      if (parts.length == 2) {
        _startTime = _parseTimeOfDay(parts[0].trim());
        _endTime = _parseTimeOfDay(parts[1].split(' ')[0].trim());
      }
    }

    Future<void> _selectTime(BuildContext context, bool isStartTime) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          if (isStartTime) {
            _startTime = picked;
          } else {
            _endTime = picked;
          }
        });
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                existingPlan == null ? 'Yeni Çalışma Planı Ekle' : 'Çalışma Planını Düzenle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(_startTime == null ? 'Başlangıç Saati Seçin' : 'Başlangıç: ${_startTime!.format(context)}'),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text('Başlangıç Seç'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(_endTime == null ? 'Bitiş Saati Seçin' : 'Bitiş: ${_endTime!.format(context)}'),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text('Bitiş Seç'),
                  ),
                ],
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
                  if (_startTime != null && _endTime != null && _lessonController.text.trim().isNotEmpty) {
                    final String formattedTimeRange = '${_startTime!.format(context)} - ${_endTime!.format(context)}';
                    setState(() {
                      if (existingPlan == null) {
                        _weeklyPlans[dayIndex].add('$formattedTimeRange - ${_lessonController.text.trim()}');
                      } else {
                        _weeklyPlans[dayIndex][planIndex!] = '$formattedTimeRange - ${_lessonController.text.trim()}';
                      }
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen başlangıç ve bitiş saatini ve dersi girin')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: Text(existingPlan == null ? 'Kaydet' : 'Güncelle'),
              ),
            ],
          ),
        );
      },
    );
  }

  TimeOfDay _parseTimeOfDay(String time) {
    final format = DateFormat.Hm();
    return TimeOfDay.fromDateTime(format.parse(time));
  }

  void _deletePlan(BuildContext context, int dayIndex, int planIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Planı Sil'),
          content: Text('Bu planı silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _weeklyPlans[dayIndex].removeAt(planIndex);
                });
                Navigator.of(context).pop();
              },
              child: Text('Sil', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd.MM.yyyy', 'tr_TR');

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
          final dayDate = now.add(Duration(days: index - now.weekday + 1)); // Pazartesi'den başlayarak tarihleri hesapla
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dateFormat.format(dayDate),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (_weeklyPlans[index].isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _weeklyPlans[index].length,
                          itemBuilder: (context, planIndex) {
                            final plan = _weeklyPlans[index][planIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('- $plan'),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showNewPlanBottomSheet(context, index, existingPlan: plan, planIndex: planIndex);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deletePlan(context, index, planIndex);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      else
                        Text('Bu güne ait henüz plan yok.'),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          _showNewPlanBottomSheet(context, index);
                        },
                        child: Text('Plan Ekle'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}