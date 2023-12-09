import 'package:flutter/material.dart';
import 'package:hostel_app/login_page.dart';
import 'package:hostel_app/HostelSearch.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
 // String _searchResult = '';

  void performSearch(String query) {
    // Navigate to HostelSearch screen with the search query
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HostelSearch(searchQuery: query),
      ),
    );
  }

  void navigateToLoginPage() {
    // Use Navigator to push the login page onto the screen.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back arrow
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            performSearch(value);
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search for Hostels',
            hintStyle: TextStyle(color: Colors.white),
          ),
        )
            : const Text('Hostel Finder'),
        actions: <Widget>[
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                // Handle the sign-in action here.
                navigateToLoginPage(); // Redirect to the login page.

              },
            ),

        ],
      ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for Hostels',
                ),
                onSubmitted: (value) {
                  performSearch(value);
                },
              ),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login prompt'),
                            content: Text('Please login for further'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan, // Change the background color here
                    ),
                    icon: Icon(Icons.favorite,color: Colors.redAccent,),
                    label: Text('Favourite',style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),),
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Recent Viewed Hostels button press
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyanAccent, // Change the background color here
                    ),
                    icon: Icon(Icons.remove_red_eye,color: Colors.black,),
                    label: Text('Recent Views ',style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:Column(
                  children: <Widget>[
                    ImageSlider(),
                    // Image slider added within the Column
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0), // Adjust padding
          child:Container(
            height: 50.0, // Adjust the height
            width: 100.0, // Adjust the width
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Login prompt'),
                      content: Text('Please login for further'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              label: const Text('Upload'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.blue, // Change the color as needed
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Container(
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                    border: Border.all(
                      color: Colors.blueAccent, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.home),
                      onPressed: () {

                      },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                    border: Border.all(
                      color: Colors.blueAccent, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login prompt'),
                            content: Text('Please login for further'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Container( decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                  border: Border.all(
                    color: Colors.blueAccent, // Set the border color
                    width: 2.0, // Set the border width
                  ),
                ),
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      // Handle Settings button press
                    },
                  ),
                ),
                Container( decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                  border: Border.all(
                    color: Colors.blueAccent, // Set the border color
                    width: 2.0, // Set the border width
                  ),
                ),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {

                    },
                  ),
                ),
              ],
            ),
          ),
        )

    );
  }
}


class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeVG9ImXui80ezNeVduchR9GQOuPflAi3dhlzbbEzAuU_MLIgqm6OOzYbBBZISoa-4GmQ&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOXrAMV74AUrRPOxN6RGyRXSmIeDCfRt7FEA&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRZLdm-CBRPdijIXQG1ZGwtPtKWSzfMWF29VVLhbidZuh0wyS2yIvRaCfeY1BznOqZzTk&usqp=CAU',
    // Add your image URLs or local paths here
  ];

  @override
  void initState() {
    super.initState();
    _startSlider();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSlider() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentPage =
          (_currentPage < _imageList.length - 1) ? _currentPage + 1 : 0;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        });
        _startSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        itemCount: _imageList.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            _imageList[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text('Error loading image'),
              );
            },
          );
        },
      ),
    );
  }
}