// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<List<String>> readFromFB() async {
    List<dynamic> hotels = [];
    List<String> hots = [];

    var ss = await getSS();
    hotels = ss.docs;

    for (int i = 0; i < hotels.length; i++) {
      hots.add(hotels[i].data()['name']);
    }
    return hots;
}

dynamic getSS() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return firestore.collection('users')
    .doc("ZYMQe3EzTPGsFmNBo7dd")
    .collection("hotels")
    .get();
}

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  dynamic hotelNames = await readFromFB();
    for (int i = 0; i < hotelNames.length; i++) {
      print(hotelNames[i]);
    }

  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(future: readFromFB(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
              // everything is okay
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  String? name = snapshot.data?[index];

                  return Text(name!);
                });
            } else if (snapshot.hasError) {
              return const Text("Failed");
            } else {
              return const Text("Loading");
            }
          }),
        ),
      ),
    );
  }
}