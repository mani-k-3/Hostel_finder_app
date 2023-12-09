import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:hostel_app/HostelDetails.dart';

class HostelSearch extends StatefulWidget {
  final String searchQuery;

  HostelSearch({required this.searchQuery});

  @override
  _HostelSearchState createState() => _HostelSearchState();
}

class _HostelSearchState extends State<HostelSearch> {
  final TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  List<DocumentSnapshot> filteredResults = [];
  List<String> selectedFacilities = [];
  String selectedSort = 'Name'; // Default sort option

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Perform the initial search when the widget is created
    searchHostels(widget.searchQuery);
  }

  Future<void> searchHostels(String area) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('hostels')
          .where('area', isEqualTo: area)
          .get();

      setState(() {
        searchResults = querySnapshot.docs;
        applyFilterAndSort();
      });
    } catch (e) {
      print('Error searching hostels: $e');
    }
  }

  void applyFilterAndSort() {
    // Apply filter
    filteredResults = searchResults
        .where((hostel) {
      // Check if the hostel has all selected facilities
      return selectedFacilities.every(
              (facility) => hostel['facilities'] != null && hostel['facilities'].contains(facility));
    })
        .toList();

    // Apply sort
    filteredResults.sort((a, b) {
      if (selectedSort == 'Name') {
        return a['name'].compareTo(b['name']);
      } else if (selectedSort == 'Price') {
        return a['price'].compareTo(b['price']);
      }
      // Add more sort options as needed
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Show a dialog to input search query
              showSearchDialog();
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                if (selectedFacilities.contains(value)) {
                  selectedFacilities.remove(value);
                } else {
                  selectedFacilities.add(value);
                }
                applyFilterAndSort();
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                // ... (unchanged)
              ];
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                selectedSort = value!;
                applyFilterAndSort();
              });
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                // ... (unchanged)
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the details screen or perform an action
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Image
                      Image.network(
                        'https://lh5.googleusercontent.com/p/AF1QipPEiKy1JF9kE3eCQ2lIuhsDXnJ_XSieCDM5oQ1k=w260-h175-n-k-no',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // Favorite icon
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0), // Adjust as needed
                  // Data below the image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sai Vigneswara',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Price: 5000',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Available rooms 8',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        // Add other data fields as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the details screen or perform an action
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Image
                      Image.network(
                        'https://images.jdmagicbox.com/comp/vijayawada/i2/0866px866.x866.181031200630.z6i2/catalogue/spoorthi-ladies-and-working-womens-hostel-benz-circle-vijayawada-hostels-for-women-1idbd6wzt3.jpg',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      // Favorite icon
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0), // Adjust as needed
                  // Data below the image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sri bhavani',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Price: 5000',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Available rooms 12',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        // Add other data fields as needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),




          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> hostelData =
                filteredResults[index].data() as Map<String, dynamic>;

                return ListTile(
                  title: Text(hostelData['name']),
                  subtitle: Row(
                    children: [
                      Text('Price: \$${hostelData['price']}'),
                      Spacer(),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  leading: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: hostelData['image_url'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    // Navigate to the details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostelDetailsScreen(
                          hostelData: hostelData,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String query = '';

        return AlertDialog(
          title: Text('Search Hostels'),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter search query',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (query.isNotEmpty) {
                  // Perform search with the entered query
                  searchHostels(query);
                  Navigator.pop(context);
                }
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }
}