import 'package:a1_4/models/postal_codes.dart';
import 'package:a1_4/services/postal_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


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
                const SizedBox(height: 20),
                const Text('Escriu un codi postal i prem a "Buscar"', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20),
                TextFormField(
                  textAlign: TextAlign.center,
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
                const SizedBox(height: 40),
                FutureBuilder(
                  future: _buttonPressed ? PostalService().fetchData(myController.text) : null,
                  builder: (context, snapshot) {
                    if (!_buttonPressed) {
                      return const SizedBox.shrink(); // No mostrar res fins que l'usuari premi el botó
                    } else if (snapshot.hasError) {
                      return const Text('Aquest codi postal no està registrat');
                    } else if (snapshot.hasData) {
                      var codiPostal = snapshot.data as CodiPostals;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Codi Postal:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(codiPostal.postCode),
                          const SizedBox(height: 20),
                          const Text('Poblacions (clica a sobre per anar a Maps):', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...codiPostal.places.map((place) => InkWell(
                            onTap: () {
                              _launchUrl(place.latitude, place.longitude);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(place.placeName),
                                const SizedBox(width: 8),
                                const Icon(Icons.location_on),
                                const Text('(Google Maps)'),
                              ],
                            ),
                          )),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
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
  // Funció per obrir Google Maps amb les coordenades específiques.
  Future<void> _launchUrl(String latitude, String longitude) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}