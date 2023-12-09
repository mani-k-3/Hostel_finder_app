import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
class HostelDetailsForm extends StatefulWidget {
  @override
  _HostelDetailsFormState createState() => _HostelDetailsFormState();
}

class _HostelDetailsFormState extends State<HostelDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController roomsAvailableController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController foodAvailabilityController =
  TextEditingController();
  final TextEditingController facilitiesController = TextEditingController();

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  // Location
  LocationData? _currentLocation;
  List<File>? _images;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get a non-default Storage bucket
  final storage = FirebaseStorage.instanceFor(bucket: "gs://hostel-finder-b9a3f.appspot.com/Hostel Images");


  bool hasHostelDetails = false;

  @override
  void initState() {
    super.initState();
    // Check if the user has already entered hostel details
    checkHostelDetails();
  }

  Future<void> checkHostelDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if "Hostels" collection exists, and create it if not
        CollectionReference hostels = _firestore.collection('hostels');
        await hostels.doc(user.uid).get();
      }

      DocumentSnapshot document =
      await _firestore.collection('hostels').doc(user?.uid).get();

      if (document.exists) {
        // Hostel details already exist
        setState(() {
          hasHostelDetails = true;
        });
        // Populate the fields with existing data if needed
        // Example:
        // nameController.text = document['name'];
        // addressController.text = document['address'];
        // capacityController.text = document['capacity'].toString();
        // priceController.text = document['price'].toString();
        // foodAvailabilityController.text = document['foodAvailability'];
        // facilitiesController.text = document['facilities'];
      }
    } catch (e) {
      print('Error checking hostel details: $e');
    }
  }

  Future<void> addHostelDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if "Hostels" collection exists, and create it if not
        CollectionReference hostels = _firestore.collection('hostels');

        List<String> imageUrls = [];

        if (_images != null && _images!.isNotEmpty) {
          for (int i = 0; i < _images!.length; i++) {
            String imageFileName = DateTime.now().millisecondsSinceEpoch.toString() + '_$i';

            Reference storageReference =
            storage.ref().child('Hostel Images/$imageFileName.jpg');
            UploadTask uploadTask = storageReference.putFile(_images![i]);

            await uploadTask.whenComplete(() async {
              String imageUrl = await storageReference.getDownloadURL();
              imageUrls.add(imageUrl);
            });
          }
        }

        // Convert data to Map<String, dynamic>
        Map<String, dynamic> hostelData = {
          'name': nameController.text,
          'area': areaController.text,
          'address': addressController.text,
          'capacity': int.parse(capacityController.text),
          'roomsAvailable': int.parse(roomsAvailableController.text),
          'price': double.parse(priceController.text),
          'foodAvailability': foodAvailabilityController.text,
          'facilities': facilitiesController.text.split(','),
          'image_urls': imageUrls, // Set the list of image URLs in Firestore
          'geopoint': _currentLocation != null
              ? GeoPoint(
              _currentLocation!.latitude!, _currentLocation!.longitude!)
              : null,
        };

        // Add the document in the 'hostel' collection
        await hostels.doc(user.uid).set(hostelData);

        // Show a success message or navigate to the next screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hostel details added successfully!'),
          ),
        );
      }
    } catch (e, stackTrace) {
      // Print detailed error information
      print('Error adding hostel details: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding hostel details. Please try again.'),
        ),
      );
    }
  }



  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    _currentLocation = await location.getLocation();
  }

  @override
  // Existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Hostel Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: areaController,
                decoration: InputDecoration(labelText: 'Area'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Hostel Address'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Capacity'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: roomsAvailableController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Rooms Available'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Hostel Price'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: foodAvailabilityController,
                decoration: InputDecoration(labelText: 'Food Availability'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: facilitiesController,
                decoration: InputDecoration(labelText: 'Facilities (Comma Separated)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              _image != null
                  ? Image.file(
                _image!,
                height: 100,
              )
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _getCurrentLocation();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Current location acquired successfully!'),
                    ),
                  );
                },
                child: Text('Get Current Location'),
              ),
              _currentLocation != null
                  ? Text(
                  'Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}')
                  : Container(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  hasHostelDetails ? editHostelDetails() : addHostelDetails();
                },
                child: Text(hasHostelDetails ? 'Edit Details' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }


// Rest of your existing code...


  Future<void> editHostelDetails() async {
    // You can implement the logic to edit existing hostel details here
    // For example, navigate to a new screen with pre-filled form fields
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHostelDetailsForm(),
      ),
    );
  }
}

class EditHostelDetailsForm extends StatefulWidget {
  @override
  _EditHostelDetailsFormState createState() => _EditHostelDetailsFormState();
}

class _EditHostelDetailsFormState extends State<EditHostelDetailsForm> {
  // You can use a similar approach as _HostelDetailsFormState to edit details
  // Add necessary controllers, methods, and UI elements
  // Ensure to fetch existing data and populate the fields

  @override
  Widget build(BuildContext context) {
    // Implement the UI for editing hostel details
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Hostel Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Implement UI elements for editing details
          ],
        ),
      ),
    );
  }
}