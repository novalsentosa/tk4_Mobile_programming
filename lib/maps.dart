import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tk4/authentication.dart';
import 'package:tk4/login.dart';

class MapsWidget extends StatefulWidget {
  User user;
  MapsWidget({super.key, required this.user});

  @override
  State<MapsWidget> createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  bool _isSigningOut = false;
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();

    const CameraPosition _yutakanaFarmCoordinate = CameraPosition(
      target: LatLng(0, 0),
      zoom: 0,
    );

    final Uri _url = Uri.parse(
        'https://www.google.com/maps/place/Yutakana+Farm/@-6.5474536,106.938068,17z/data=!3m1!4b1!4m6!3m5!1s0x2e69b94e6c126405:0x96267b70ebfbe9a6!8m2!3d-6.5474589!4d106.9406429!16s%2Fg%2F11kq5lrfqb?entry=ttu');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome " + widget.user.displayName.toString(),
        ),
        actions: [
          CircleAvatar(
            child: ClipOval(
              child: Material(
                child: Image.network(
                  widget.user.photoURL!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: ColorConstants.darkGreen,
            child: GoogleMap(
              onTap: (latLng) async {},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: _yutakanaFarmCoordinate,
            ),
          ),
          Positioned(
            bottom: 50,
            child: _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.redAccent,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await Authentication.signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
