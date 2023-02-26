# zrepository

[![pub package](https://img.shields.io/pub/v/zrepository.svg)](https://pub.dartlang.org/packages/zrepository)

A reactive key-value store for Flutter projects.

**zrepository** simplify your class store and adds reactive functionality on top of [shared_preferences](https://pub.dartlang.org/packages/shared_preferences). It does everything that regular `SharedPreferences` does, but it also allows _listening to changes in values_. This makes it super easy to keep your widgets in sync with persisted values.

## Getting started

First, add zrepository into your pubspec.yaml.

```yaml
dependencies:
  zrepository: ^0.0.2
```

firsts create your class extending a ZClass from this package:


```dart
import 'package:zrepository/zrepository.dart';
...
class Person extends ZClass{
  final String name;

  Person({super.uuid, required this.name});
  
  @override
  List<Object?> get props => [name];
  
  @override
  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }
}
```

Note that it is mandatory to reference the **UUID** in the constructor, for reasons of having a unique identification in each class.

For everything to be working we need to add a factory **fromMap()**:

```dart
class Person extends ZClass{
  ...
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      uuid: map['uuid'] as String?,
      name: map['name'] as String,
    );
  }
  ...
}
```

As the last configuration requirement we need to set instances of this new class inside your main:


```dart
void main() async {
  ZRepository.setInstances({
    Person: Person.fromMap,
  });

  runApp(const App());
}
```

Configuration has finished.
check example from use:

```dart
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
      home: Scaffold(
        body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Center(
                child: Column(
                  children: [
                    ...(snapshot.data as List<Person>).map((e) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextButton(onPressed: () {
                        ZRepository.removeEpecific<Person>(repositoryKey, item: e);}, child: Text(e.name), ),
                    )).toList(),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: nameController,
                      )
                    ),
                    FilledButton(onPressed: () => ZRepository.addInList(key: repositoryKey, object: Person(name: nameController.text)), child: const Text('Add'))
                  ],
                ),
              );
            }
            return const Center(child: Text('Loading...'));
          },
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
```

