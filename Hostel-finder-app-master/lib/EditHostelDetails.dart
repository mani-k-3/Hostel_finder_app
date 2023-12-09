import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_app/logged_homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class EditHostelDetailsForm extends StatefulWidget {
  @override
  _EditHostelDetailsFormState createState() => _EditHostelDetailsFormState();
}

class _EditHostelDetailsFormState extends State<EditHostelDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController roomsAvailableController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController foodAvailabilityController =
  TextEditingController();
  final TextEditingController facilitiesController = TextEditingController();

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  List<File> _images = [];

  // Location
  LocationData? _currentLocation;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Fetch existing data and populate fields
    fetchHostelData();
  }

  Future<void> _pickImage() async {
    try {
      List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();

      if (pickedFiles != null) {
        setState(() {
          _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> fetchHostelData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot document =
        await _firestore.collection('hostels').doc(user.uid).get();

        if (document.exists) {
          // Populate fields with existing data
          setState(() {
            nameController.text = document['name'];
            areaController.text = document['area'];
            addressController.text = document['address'];
            contactNumberController.text = document['contactNumber'];
            capacityController.text = document['capacity'].toString();
            roomsAvailableController.text =
                document['roomsAvailable'].toString();
            priceController.text = document['price'].toString();
            foodAvailabilityController.text = document['foodAvailability'];
            facilitiesController.text =
                document['facilities'].join(', '); // Convert List to String
            // You can add more fields as needed

            // Image URLs and Geopoint (if available)
            // Assuming 'image_urls' and 'geopoint' are the field names in Firestore
            // Update these field names based on your Firestore schema
            _images = document['image_urls'] != null
                ? List<String>.from(document['image_urls'])
                .map((imageUrl) => File(imageUrl))
                .toList()
                : [];
            _currentLocation = document['geopoint'] != null
                ? LocationData.fromMap({
              'latitude': document['geopoint'].latitude,
              'longitude': document['geopoint'].longitude,
            })
                : null;
          });
        }
      }
    } catch (e) {
      print('Error fetching hostel data: $e');
    }
  }

  Future<void> _uploadImages() async {
    try {
      List<String> imageUrls = [];

      if (_images != null && _images!.isNotEmpty) {
        for (int i = 0; i < _images!.length; i++) {
          String imageFileName = DateTime.now().millisecondsSinceEpoch.toString() + '_$i';

          Reference storageReference = FirebaseStorage.instance.ref().child('$imageFileName.jpg');
          UploadTask uploadTask = storageReference.putFile(_images![i], SettableMetadata(contentType: "image/jpeg/png"));

          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();
            imageUrls.add(imageUrl);
          });
        }



      // Update the document in the 'hostel' collection with the image URLs
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('hostels').doc(user.uid).update({
            'image_urls': imageUrls,
          });
        }
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }


  Future<void> editHostelDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _uploadImages(); // Upload images before updating details

        CollectionReference hostels = _firestore.collection('hostels');

        // Convert data to Map<String, dynamic>
        Map<String, dynamic> updatedData = {
          'name': nameController.text,
          'area': areaController.text,
          'address': addressController.text,
          'contactNumber': contactNumberController.text,
          'capacity': int.parse(capacityController.text),
          'roomsAvailable': int.parse(roomsAvailableController.text),
          'price': double.parse(priceController.text),
          'foodAvailability': foodAvailabilityController.text,
          'facilities': facilitiesController.text.split(','),
          'image_urls': _images.map((image) => image.path).toList(),
          'geopoint': _currentLocation != null
              ? GeoPoint(
              _currentLocation!.latitude!, _currentLocation!.longitude!)
              : null,
          // Update other fields as needed
        };

        // Update the document in the 'hostel' collection
        await hostels.doc(user.uid).update(updatedData);

        // Show a success message or navigate to the next screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hostel details updated successfully!'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoggedHomePage(),
          ),
        );
      }
    } catch (e, stackTrace) {
      // Print detailed error information
      print('Error updating hostel details: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating hostel details. Please try again.'),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    _currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Hostel Details'),
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
                controller: contactNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Contact Number'),
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
              _images.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected Images:'),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _images
                        .map(
                          (image) => Image.file(
                        image,
                        height: 80,
                        width: 80, // Add this line to set the width
                      ),
                    )
                        .toList(),
                  ),
                ],
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
                  editHostelDetails();
                },
                child: Text('Update Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
