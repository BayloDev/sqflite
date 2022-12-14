// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite_project/sql_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SqlFunctions sqlDB = SqlFunctions();
  int updateTime = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SQL Functions'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, Object?>>? maxID = await sqlDB.readData(
                    'SELECT id FROM notes WHERE id=(SELECT MAX(id) FROM notes)',
                  );
                  int max = maxID.isEmpty ? 0 : (maxID[0]['id'] as int);

                  int response = await sqlDB.insertData(
                    "INSERT INTO notes(id,note) VALUES('${max + 1}','note ${max + 1}')",
                  );
                  print(response);
                },
                child: const Text('Insert Data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, Object?>> response = await sqlDB.readData(
                    "SELECT * FROM notes",
                  );
                  print(response);
                },
                child: const Text('Read Data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, Object?>> maxID = await sqlDB.readData(
                    'SELECT id FROM notes WHERE id=(SELECT MAX(id) FROM notes)',
                  );
                  int max = maxID.isEmpty ? 0 : (maxID[0]['id'] as int);
                  int response = await sqlDB.deleteData(
                    "DELETE FROM notes WHERE id = $max",
                  );
                  print(response);
                },
                child: const Text('Delete Data'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() => updateTime++);
                  List<Map<String, Object?>> maxID = await sqlDB.readData(
                    'SELECT id FROM notes WHERE id=(SELECT MAX(id) FROM notes)',
                  );

                  int max = maxID.isEmpty ? 0 : maxID[0]['id'] as int;
                  int response = await sqlDB.updateData(
                    "UPDATE notes SET note='note $max Updated $updateTime times' WHERE id= $max ",
                  );
                  print(response);
                },
                child: const Text('Update Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
