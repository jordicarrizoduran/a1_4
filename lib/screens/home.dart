import 'package:a1_4/models/postal_codes.dart';
import 'package:a1_4/services/postal_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  late CodiPostals postalCodes = CodiPostals(postCode: '', country: '', countryAbbreviation: '', places: []);
  final _formKey = GlobalKey<FormState>();
  bool _buttonPressed = false; // Variable per indicar si s'ha premut el botó o no

  @override
  void dispose() {
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Escriu un codi postal i prem a "Buscar"'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: myController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introdueix un codi postal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Validar el formulari abans de continuar
                    if (_formKey.currentState?.validate() ?? false) {
                      // Només fer la crida a fetchData quan l'usuari prem el botó
                      setState(() {
                        _buttonPressed = true;
                      });
                    }
                  },
                  child: const Text('Buscar'),
                ),
                FutureBuilder(
                  future: _buttonPressed ? PostalService().fetchData(myController.text) : null,
                  builder: (context, snapshot) {
                    if (!_buttonPressed) {
                      return const SizedBox.shrink(); // No mostrar res fins que l'usuari premi el botó
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Carregant');
                    } else if (snapshot.hasError) {
                      return const Text('Aquest codi postal no està registrat');
                    } else if (snapshot.hasData) {
                      var codiPostal = snapshot.data as CodiPostals;

                      return Column(
                        children: [
                          Text(codiPostal.postCode),
                          Text(codiPostal.countryAbbreviation),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}