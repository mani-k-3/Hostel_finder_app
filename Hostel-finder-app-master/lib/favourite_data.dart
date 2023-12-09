import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FavouritePage extends StatefulWidget {

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<FavouritePage> {

  List<Hostel> favoriteHostels = [];
  List<String> selectedFilters = [];
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    fetchHostelData();
  }

  void fetchHostelData() {
    FirebaseFirestore.instance
        .collection('favoriteHostels')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        favoriteHostels = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Hostel(
            name: data['name'] ?? '',
            address: data['address'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            isFavorite: false, // You can fetch this from Firebase if needed
          );
        }).toList();
      });
    }).catchError((error) {
      print("Error fetching hostels: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite hostels'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showFilterDialog();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.sort),
                    onPressed: () {
                      showSortDialog();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteHostels.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HostelDetailsPage(hostel: favoriteHostels[index]),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            favoriteHostels[index].imageUrl,
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoriteHostels[index].name,
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                  Text(favoriteHostels[index].address),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  favoriteHostels[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    favoriteHostels[index].isFavorite = !favoriteHostels[index].isFavorite;

                                    if (favoriteHostels[index].isFavorite) {
                                      favoriteHostels.add(favoriteHostels[index]);
                                    } else {
                                      favoriteHostels.remove(favoriteHostels[index]);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            children: [
              CheckboxListTile(
                title: Text('Filter 1'),
                value: selectedFilters.contains('Filter 1'),
                onChanged: (value) {
                  handleFilterChange('Filter 1', value);
                },
              ),
              CheckboxListTile(
                title: Text('Filter 2'),
                value: selectedFilters.contains('Filter 2'),
                onChanged: (value) {
                  handleFilterChange('Filter 2', value);
                },
              ),

              // Add more filters as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Apply filters and fetch data again
                applyFilters();
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sort Options'),
          content: Column(
            children: [
              ListTile(
                title: Text('Sort by Name'),
                onTap: () {
                  handleSortChange('Name');
                },
              ),
              ListTile(
                title: Text('Sort by Price'),
                onTap: () {
                  handleSortChange('Price');
                },
              ),
              // Add more sort options as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Apply sort and fetch data again
                applySort();
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void handleFilterChange(String filter, bool? value) {
    setState(() {
      if (value != null) {
        if (value) {
          selectedFilters.add(filter);
        } else {
          selectedFilters.remove(filter);
        }
      }
    });
  }

  void applyFilters() {
    // Implement logic to apply filters and fetch data from the database
    fetchHostelData();
  }

  void handleSortChange(String sortOption) {
    setState(() {
      selectedSort = sortOption;
    });
  }

  void applySort() {
    // Implement logic to apply sort and fetch data from the database
    fetchHostelData();
  }
}

class HostelDetailsPage extends StatelessWidget {
  final Hostel hostel;

  HostelDetailsPage({required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hostel.name),
      ),
      body: Center(
        child: Text(
          'Details about ${hostel.name} will go here.',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class Hostel {
  final String name;
  final String address;
  final String imageUrl;
  bool isFavorite;

  Hostel({required this.name, required this.address, required this.imageUrl, this.isFavorite = false});
}
