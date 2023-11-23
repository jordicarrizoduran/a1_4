import 'package:a1_4/models/postal_codes.dart';
import 'package:a1_4/services/postal_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();

  @override
  void dispose(){
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codi Postals"),
      ),
      body: SingleChildScrollView(
        child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                      'Escriu un codi postal i prem a "Buscar"'),
                  const SizedBox(height: 20),
                  TextField(
                  controller: myController,
                ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        var postalCodes = await PostalService().fetchData(myController.value);
                        debugPrint(postalCodes.countryAbbreviation);
                      },
                      child: const Text('Buscar')),
                  const SizedBox(height: 40),
                ],
              )

          ),
      ),
    );
  }
}
