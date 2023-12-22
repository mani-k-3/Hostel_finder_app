import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_app/HostelDetails.dart';

class HostelSearch extends StatefulWidget {
  final String searchQuery;

  HostelSearch({required this.searchQuery});

  @override
  _HostelSearchState createState() => _HostelSearchState();
}
class _FilterCheckboxTile extends StatefulWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _FilterCheckboxTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FilterCheckboxTileState createState() => _FilterCheckboxTileState();
}
class _FilterCheckboxTileState extends State<_FilterCheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.value,
      onChanged: (bool? value) {
        setState(() {
          if (value != null) {
            widget.onChanged(value);
          }
        });
      },
    );
  }
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

  Future<void> searchHostels(String query) async {
    try {
      // Convert the search criteria to lowercase and trim trailing spaces
      String lowercaseQuery = query.toLowerCase().trim();

      QuerySnapshot querySnapshot = await _firestore
          .collection('hostels')
          .where('name', isGreaterThanOrEqualTo: lowercaseQuery)
          .where('name', isLessThan: lowercaseQuery + 'z')
          .get();

      List<DocumentSnapshot> nameMatches = querySnapshot.docs;

      // If no matches were found by name, try searching by area
      if (nameMatches.isEmpty) {
        querySnapshot = await _firestore
            .collection('hostels')
            .where('area', isGreaterThanOrEqualTo: lowercaseQuery)
            .where('area', isLessThan: lowercaseQuery + 'z')
            .get();

        nameMatches = querySnapshot.docs;
      }

      // If no matches were found by area, try searching by address
      if (nameMatches.isEmpty) {
        querySnapshot = await _firestore
            .collection('hostels')
            .where('address', isGreaterThanOrEqualTo: lowercaseQuery)
            .where('address', isLessThan: lowercaseQuery + 'z')
            .get();

        // Filter the results to include only those with a substring match
        nameMatches = querySnapshot.docs
            .where((doc) =>
        doc['address'] != null &&
            doc['address'].toString().toLowerCase().contains(lowercaseQuery))
            .toList();
      }

      setState(() {
        searchResults = nameMatches;
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
          _buildFilterDropdown(),
          _buildSortDropdown(),
        ],
      ),
      body: Column(
        children: [
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

  Widget _buildFilterDropdown() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.filter_list),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'WiFi',
            child: _FilterCheckboxTile(
              title: 'WiFi',
              value: selectedFacilities.contains('WiFi'),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedFacilities.add('WiFi');
                    } else {
                      selectedFacilities.remove('WiFi');
                    }
                    applyFilterAndSort();
                  }
                });
              },
            ),
          ),
          PopupMenuItem<String>(
            value: 'Food',
            child: _FilterCheckboxTile(
              title: 'Food',
              value: selectedFacilities.contains('Food'),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedFacilities.add('Food');
                    } else {
                      selectedFacilities.remove('Food');
                    }
                    applyFilterAndSort();
                  }
                });
              },
            ),
          ),
          PopupMenuItem<String>(
            value: 'AC',
            child: _FilterCheckboxTile(
              title: 'AC',
              value: selectedFacilities.contains('AC'),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedFacilities.add('AC');
                    } else {
                      selectedFacilities.remove('AC');
                    }
                    applyFilterAndSort();
                  }
                });
              },
            ),
          ),
          PopupMenuItem<String>(
            value: 'Boys',
            child: _FilterCheckboxTile(
              title: 'Boys',
              value: selectedFacilities.contains('Boys'),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedFacilities.add('Boys');
                    } else {
                      selectedFacilities.remove('Boys');
                    }
                    applyFilterAndSort();
                  }
                });
              },
            ),
          ),
          PopupMenuItem<String>(
            value: 'Girls',
            child: _FilterCheckboxTile(
              title: 'Girls',
              value: selectedFacilities.contains('Girls'),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedFacilities.add('Girls');
                    } else {
                      selectedFacilities.remove('Girls');
                    }
                    applyFilterAndSort();
                  }
                });
              },
            ),
          ),
          // Add more filter options as needed
        ];
      },
    );
  }

  Widget _buildSortDropdown() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Name',
            child: Text('Sort by Name'),
          ),
          PopupMenuItem<String>(
            value: 'Price',
            child: Text('Sort by Price'),
          ),
          // Add more sort options as needed
        ];
      },
      onSelected: (value) {
        setState(() {
          selectedSort = value;
          applyFilterAndSort();
        });
      },
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