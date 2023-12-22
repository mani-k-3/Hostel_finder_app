import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/settings_page.dart';
import 'package:hostel_app/HostelDetailsForm.dart';
import 'package:hostel_app/favourite_data.dart';
import 'package:hostel_app/HostelSearch.dart';
import 'package:hostel_app/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LoggedHomePage extends StatefulWidget {
  const LoggedHomePage({Key? key}) : super(key: key);

  @override
  _LoggedHomePageState createState() => _LoggedHomePageState();
}

class _LoggedHomePageState extends State<LoggedHomePage> {
  final TextEditingController _searchController = TextEditingController();

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double $lat = 0.0;
  double $long = 0.0;


  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocuments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('hostels').get();
    return snapshot.docs;
  }

  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      $lat = position.latitude;
      $long = position.longitude;
    });
  }
  void performSearch(String query) {
    // Navigate to HostelSearch screen with the search query
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HostelSearch(searchQuery: query),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User logged out successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(), // Pass the actual username
        ),
      );
      // You may want to navigate to the login screen or perform other actions after logout.
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void navigateToUploadPage() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HostelDetailsForm()),
    );
  }
  Widget build1(BuildContext context) {
    return FutureBuilder(
      future: getDocuments(),
      builder: (context, AsyncSnapshot<
          List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _buildMap(context, snapshot.data!, $lat, $long);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hostel Finder', style: TextStyle(fontSize: 18.0)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchTextField(),
            const SizedBox(height: 16),
            _buildFeatureButtons(),
            const SizedBox(height: 16),
            build1(context),
          ],
        ),
      ),
      floatingActionButton: _buildUploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }


  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search for Hostels',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              performSearch(_searchController.text);
            },
          ),
        ),
        onSubmitted: (value) {
          performSearch(value);
        },
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeatureButton(
          onPressed: () {
            // Handle Favourite Hostels button press
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavouritePage()),
            );
          },
          icon: Icons.favorite_border,
          label: 'Favourite',
          backgroundColor: Colors.deepPurpleAccent, // Change the background color
          labelColor: Colors.white, // Change the label color
        ),
        _buildFeatureButton(
          onPressed: () {
            // Handle Recent Viewed Hostels button press
          },
          icon: Icons.remove_red_eye,
          label: 'Recent Views',
          backgroundColor: Colors.lightBlueAccent, // Change the background color
          labelColor: Colors.white, // Change the label color
        ),
      ],
    );
  }

  Widget _buildFeatureButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return SizedBox(
      width: 150,
      height: 100,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded edges
          ),
          backgroundColor: backgroundColor,
        ),
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: SizedBox(
        height: 50.0,
        width: 100.0,
        child: FloatingActionButton.extended(
          onPressed: () {


            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HostelDetailsForm()),
            );
          },
          label: const Text('Upload'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarIcon(Icons.home),
            _buildNavBarIcon(Icons.account_circle),
            _buildNavBarIcon(Icons.settings),
            _buildNavBarIcon(Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {
          if (icon == Icons.account_circle) {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (icon == Icons.logout) {
            signOut();
          }
          else if (icon == Icons.settings) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }

        },
      ),
    );
  }

  Widget _buildMap(context,List<QueryDocumentSnapshot<Map<String, dynamic>>> documents, double lat,double long) {
    double lat0 = lat;
    double long0 = long;
    return Container(
      height: 500,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, long), // Remove the 'const' keyword here
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(lat0, long0),
                child: const Icon(
                  Icons.person_pin,
                  color: Colors.blue,
                  size: 35.0,
                ),
              ),
            ],
          ),
          MarkerLayer(
            markers: _buildMarkers(context, documents),
          ),
        ],
      ),
    );
  }
  List<Marker> _buildMarkers(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    return documents.map((document) {
      var geoTag = document['geopoint'];
      if (geoTag is GeoPoint) {
        var latitude = geoTag.latitude;
        var longitude = geoTag.longitude;

        return Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(latitude, longitude),
          child: IconButton(
            icon: const Icon(Icons.location_pin),
            color: Colors.red,
            onPressed: () {
              _showDocumentDetails(context, document.data());
            },
          ),
        );
      } else {
        return const Marker(
          width: 0.0,
          height: 0.0,
          point: LatLng(0, 0),
          child: Icon(
            Icons.wrong_location_outlined,
            color: Colors.blue,
            size: 35.0,
          ),
        );
      }
    }).toList();
  }
  void _showDocumentDetails(BuildContext context,
      Map<String, dynamic> documentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hostel Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hostel Name: ${documentData['name']}'),
              Text('Phone Number: ${documentData['contactNumber']}'),
              Text('For: ${documentData['for']}'),
              Text('Address: ${documentData['address']}'),
              Text('Price: ${documentData['price']}'),
              Text('Room Available: ${documentData['roomAvailable']}'),
              Text('GeoTag: ${documentData['geopoint']}'),
              Text('Facilities: ${documentData['facilities']}'),
              Text('Food Available: ${documentData['foodAvailability']}'),
              SizedBox(height: 10.0),
              Text('Note:'),
              Text('For more details search the Hostel name or Area in search bar'),


            ],

          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}


