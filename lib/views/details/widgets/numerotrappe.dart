import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'package:trappe_orange/service/getid.dart';
import 'package:trappe_orange/views/details/widgets/PhotoFormImagePicker.dart';
import 'package:trappe_orange/views/details/widgets/Photo_After.dart';
import 'package:trappe_orange/views/details/widgets/google_maps_page.dart';

final Logger logger = Logger('NumeroTrappe');

class NumeroTrappe extends StatefulWidget {
  final String login;
  final EnregistrerDetails enregistrerDetails;

  const NumeroTrappe({
    Key? key,
    required this.login,
    required this.enregistrerDetails,
  }) : super(key: key);

  @override
  NumeroTrappeState createState() => NumeroTrappeState();
}

class NumeroTrappeState extends State<NumeroTrappe> {
  final GlobalKey<FormState> _cleForm = GlobalKey<FormState>();
  TextEditingController _locationController = TextEditingController();
  TextEditingController numController = TextEditingController();
  String? _motifInterventionSelectionne;
  List<String> motifsInyervention = [
    'Déploiement FTTH',
    'Déploiement Backbone',
    'Déploiement FTTM',
    'Déploiement OSM',
    'Extension FTTH, OSM, FTTM, Backbone……….',
    'ATP Curative, Préventive ……',
    'Maintenance Préventive FTTH',
    'Maintenance Préventive FTTM',
    'Maintenance Préventive Backbone',
    'Maintenance Préventive OSM',
    'Maintenance Curative FTTH, OSM, FTTM, Backbone………..',
    'Survey FTTH, OSM, FTTM, Backbone………..',
    'Recette FTTH, OSM, FTTM, Backbone………..',
    
  ];
  File? selectedImage;
  void updateImageUrl(File? image) async {
    setState(() {
      selectedImage =
          image; // Met à jour l'image sélectionnée dans l'état du widget
    });
    if (image != null && numController.text.isNotEmpty) {
      bool success = await widget.enregistrerDetails
          .uploadImage(image, numController.text, "Avant_Intervention");
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Image envoyé avec succes',
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "echec de l'envoi",
          ),
        ));
      }
    }
    // Ici, vous pouvez également effectuer d'autres actions avec l'image, comme la télécharger  // ou mettre à jour des données sur un serveur
  }

  void updateImageUrl_1(File? image) async {
    setState(() {
      selectedImage =
          image; // Met à jour l'image sélectionnée dans l'état du widget
    });
    if (image != null && numController.text.isNotEmpty) {
      bool success = await widget.enregistrerDetails
          .uploadImage_1(image, numController.text, "Apres_Intervention");
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Image 2 envoyé avec succes',
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "echec de l'envoi",
          ),
        ));
      }
    }
    // Ici, vous pouvez également effectuer d'autres actions avec l'image, comme la télécharger
    // ou mettre à jour des données sur un serveur
  }

  void updateUrlImage() {}
  void updateUrlImage_1() {}

  void getCurrentLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      final LocationData userLocation = await location.getLocation();
      final String address = await getAddressFromLatLng(
        lat: userLocation.latitude!,
        lng: userLocation.longitude!,
      );
      setState(() {
        _locationController.text =
            address; // Utilisez le controller pour afficher l'adresse dans un TextField.
      });
    } catch (e) {
      logger.severe("Failed to get current location: $e");
    }
  }

  @override
  void dispose() {
    numController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _cleForm,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                  hintText: 'Localisation',
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange, width: 2)),
                  prefixIcon: Icon(
                    Icons.maps_home_work_sharp,
                    color: Colors.black54,
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplisser une localisation valide';
                }
                return null;
              },
            ),
            SizedBox(
              height: 5,
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.gps_fixed,
                color: Colors.orange,
              ),
              onPressed: getCurrentLocation,
              label: const Text(
                'Utiliser Ma position actuelle',
                style: TextStyle(color: Colors.orange),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _motifInterventionSelectionne,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Colors.orangeAccent, width: 2)),
                hintText: 'Selectionnez un motif',
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
                prefixIcon: Icon(
                  Icons.work_history_sharp,
                  color: Colors.black54,
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  _motifInterventionSelectionne = newValue;
                });
              },
              items: motifsInyervention
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: numController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange, width: 2)),
                hintText: 'Numero de trappe',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                prefixIcon: Icon(
                  Icons.numbers,
                  color: Colors.black54,
                ),
              ),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Veuillez entrer le numéro de trappe';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remmplissez l\'url';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: 'photo de la chambre',
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  prefixIcon: const Icon(
                    Icons.image,
                    color: Colors.grey,
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            PhotoFormImagePicker(updateUrl: updateImageUrl),
            const SizedBox(height: 10),
            Photo_After(updateUrl: updateImageUrl_1),
            const SizedBox(height: 10),
            Container(
                width: 250,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                  highlightColor: Colors.green,
                  splashColor: Colors.green,
                  radius: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      print('Button pressed');
                      // Assurez-vous que _motifInterventionSelectionne n'est pas nul
                      if (_motifInterventionSelectionne == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Veuillez sélectionner un motif d\'intervention'),
                        ));
                        return;
                      }

                      String? technicienId = await widget.enregistrerDetails
                          .getIdByLogin(widget.login);
                      print('Technicien ID: $technicienId');
                      if (technicienId != null) {
                        widget.enregistrerDetails.setTechnicienId(technicienId);
                        // conversion de l'image en base 64
                        // Utilisez _motifInterventionSelectionne pour l'envoi
                        bool success = await widget.enregistrerDetails
                            .enregistrer(_motifInterventionSelectionne!,
                                numController.text, _locationController.text);
                        print('Enregistrement réussi: $success');
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Motif intervention et numéro de trappe ajoutés avec succès',
                            ),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Échec de l\'enregistrement des détails',
                            ),
                          ));
                        }
                      }
                      ;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
