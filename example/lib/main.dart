// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:zrepository/zrepository.dart';

void main() async {
  ZRepository.setInstances({
    Person: Person.fromMap,
  });

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final String repositoryKey = 'person';
  late Stream<List<Person>> _stream;

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_)  async {
      _stream = await ZRepository.stream<Person>(repositoryKey);
      _stream.listen((event) => setState(() {}));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: 300,
            height: 500,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10)
            ),
            child: StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () { 
                                if(nameController.text == '') return;
                                ZRepository.addInList(
                                  key: repositoryKey, object: Person(name: nameController.text)
                                );
                              }, 
                              child: Text('Add', style: TextStyle(color: Colors.grey.shade200)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: ListView(
                          children: (snapshot.data as List<Person>).map((e) => Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(100)
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: TextButton(
                              onPressed: () {
                                ZRepository.removeEpecific<Person>(repositoryKey, item: e);
                              }, 
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Text(e.name),
                                    const Spacer(),
                                    IconButton(onPressed: () => ZRepository.removeEpecific<Person>(repositoryKey, item: e), icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ), 
                            ),
                          )).toList(),
                        ),
                      )
                    ],
                  );
                }
                return const Center(child: Text('Loading...'));
              },
            ),
          ),
        ),
      ),
    );
  }
}


class Person extends ZClass{
  final String name;
  Person({super.uuid, required this.name});

  @override
  List<Object?> get props => [name];

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uuid: map['uuid'] as String?,
      name: map['name'] as String,
    );
  }
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }
}