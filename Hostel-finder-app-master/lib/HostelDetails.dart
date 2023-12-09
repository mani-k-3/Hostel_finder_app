import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:map_launcher/map_launcher.dart';


class HostelDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> hostelData;

  HostelDetailsScreen({required this.hostelData});

  @override
  _HostelDetailsScreenState createState() => _HostelDetailsScreenState();
}

class _HostelDetailsScreenState extends State<HostelDetailsScreen> {
  late List<String> imageUrls;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    imageUrls = List<String>.from(widget.hostelData['image_urls'] ?? []);
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              pageController: pageController,
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
              enableRotation: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hostelData['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Address: ${widget.hostelData['address']}'),
                SizedBox(height: 8),
                Text('Capacity: ${widget.hostelData['capacity']}'),
                SizedBox(height: 8),
                Text('Price: \$${widget.hostelData['price']}'),
                SizedBox(height: 8),
                Text('Food Availability: ${widget.hostelData['foodAvailability']}'),
                SizedBox(height: 8),
                Text('Facilities: ${widget.hostelData['facilities'].join(', ')}'),
                SizedBox(height: 8),
                if (widget.hostelData['geopoint'] != null)
                  ElevatedButton(
                    onPressed: () {
                      openMaps(widget.hostelData['geopoint']['latitude'], widget.hostelData['geopoint']['longitude']);
                    },
                    child: Text('Open in Maps'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openMaps(double latitude, double longitude) {
    MapLauncher.showDirections(
      mapType: MapType.google,
      destination: Coords(latitude, longitude),
    );
  }

}