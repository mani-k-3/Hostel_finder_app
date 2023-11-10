import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHostelPage(searchArea: 'Kanuru',),
    );
  }
}

class MyHostelPage extends StatefulWidget {
  final String searchArea;

  MyHostelPage({required this.searchArea});

  @override
  _MyHostelPageState createState() => _MyHostelPageState();
}

class _MyHostelPageState extends State<MyHostelPage> {
  List<Hostel> hostels = [];
  List<Hostel> favoriteHostels = [];
  List<String> selectedFilters = [];
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    fetchHostelData();
  }

  void fetchHostelData() {
    // Simulate fetching data from a database based on the search area
    // Replace this with actual database fetching logic
    List<Hostel> dummyData = [
      Hostel(name: 'Hostel A', address: '123 Main St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
      Hostel(name: 'Hostel B', address: '456 Side St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
      Hostel(name: 'Hostel C', address: '789 Back St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
      Hostel(name: 'Hostel D', address: '101 New St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
      Hostel(name: 'Hostel E', address: '202 Side St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
      Hostel(name: 'Hostel F', address: '303 Front St', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTM9cS2rAmSrIWu4WwKO_T0im4LhZLfC4PRvBfr4v0zJOA7JecR22j7Ukls2HBG2wvWb2w&usqp=CAU', isFavorite: false),
    ];

    setState(() {
      hostels = dummyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostels in ${widget.searchArea}'),
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
                itemCount: hostels.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HostelDetailsPage(hostel: hostels[index]),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            hostels[index].imageUrl,
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
                                    hostels[index].name,
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                  ),
                                  Text(hostels[index].address),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  hostels[index].isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hostels[index].isFavorite = !hostels[index].isFavorite;

                                    if (hostels[index].isFavorite) {
                                      favoriteHostels.add(hostels[index]);
                                    } else {
                                      favoriteHostels.remove(hostels[index]);
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

  // ...

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

// ...


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
