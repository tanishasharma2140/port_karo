import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/utils/routes/routes.dart';
import 'package:port_karo/utils/utils.dart';

class CaptainMatchingScreen extends StatefulWidget {
  const CaptainMatchingScreen({super.key});

  @override
  State<CaptainMatchingScreen> createState() => _CaptainMatchingScreenState();
}

class _CaptainMatchingScreenState extends State<CaptainMatchingScreen> {
  bool _isMatching = true;
  bool _captainAssigned = false;
  bool _otpShared = false;
  bool _rideStarted = false;
  final String _otpCode = "7658";

  // Simulate matching process
  @override
  void initState() {
    super.initState();
    _simulateMatching();
  }

  void _simulateMatching() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isMatching = false;
        _captainAssigned = true;
      });
    });
  }




  void _sendSOSAlert() {

      Utils.showSuccessMessage(context, "SOS Alert sent to admin and emergency contacts!");

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          children: [
            SizedBox(height: topPadding),

            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: PortColor.white,
                border: Border(
                  bottom: BorderSide(
                    color: PortColor.gray,
                    width: screenWidth * 0.002,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: PortColor.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: PortColor.black,
                      size: screenHeight * 0.02,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  TextConst(
                    title: "Captain Matching",
                    color: PortColor.black,
                    fontFamily: AppFonts.kanitReg,
                    fontWeight: FontWeight.w600,
                    size: 16,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Matching Status
                    _buildMatchingStatus(),

                    SizedBox(height: screenHeight * 0.03),

                    // Auto-assign Info
                    _buildAutoAssignInfo(),

                    if (_captainAssigned) ...[
                      SizedBox(height: screenHeight * 0.04),

                      // Captain Details
                      _buildCaptainDetails(),

                      SizedBox(height: screenHeight * 0.04),

                      // Ride Details
                      _buildRideDetails(),

                      SizedBox(height: screenHeight * 0.04),

                      // OTP Section
                      _buildOTPSection(),

                      SizedBox(height: screenHeight * 0.04),

                      // Safety & Support Section
                      _buildSafetySupportSection(),

                      SizedBox(height: screenHeight * 0.04),

                      // Contact Options
                      _buildContactOptions(),
                    ],

                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchingStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_isMatching) ...[
            // Matching Animation
            SizedBox(
              height: screenHeight * 0.08,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: screenHeight * 0.06,
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                      color: PortColor.gold.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_search,
                      color: PortColor.gold,
                      size: screenHeight * 0.03,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextConst(
              title: "Finding Nearest Captain",
              fontFamily: AppFonts.kanitReg,
              fontWeight: FontWeight.w600,
              size: 18,
              color: PortColor.black,
            ),
            SizedBox(height: screenHeight * 0.01),
            TextConst(
              title: "Searching within 5KM radius...",
              fontFamily: AppFonts.kanitReg,
              color: Colors.grey.shade600,
              size: 14,
            ),
          ] else if (_captainAssigned) ...[
            Icon(
              Icons.verified,
              color: Colors.green,
              size: screenHeight * 0.05,
            ),
            SizedBox(height: screenHeight * 0.02),
            TextConst(
              title: "Captain Assigned!",
              fontFamily: AppFonts.kanitReg,
              fontWeight: FontWeight.w600,
              size: 18,
              color: Colors.green,
            ),
            SizedBox(height: screenHeight * 0.01),
            TextConst(
              title: "Your captain is on the way",
              fontFamily: AppFonts.kanitReg,
              color: Colors.grey.shade600,
              size: 14,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAutoAssignInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: PortColor.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PortColor.blue.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: PortColor.blue,
            size: screenHeight * 0.025,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: "Auto-assign Nearest Captain",
                  fontFamily: AppFonts.kanitReg,
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: PortColor.blue,
                ),
                SizedBox(height: screenHeight * 0.005),
                TextConst(
                  title: "• Automatically assigns nearest available captain within 5KM radius",
                  fontFamily: AppFonts.kanitReg,
                  color: PortColor.blue.withOpacity(0.8),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(
            title: "Captain Details",
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w600,
            size: 16,
            color: PortColor.black,
          ),
          SizedBox(height: screenHeight * 0.02),

          Row(
            children: [
              // Captain Photo
              Container(
                width: screenHeight * 0.08,
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PortColor.gold,
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),

              // Captain Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: "Rajesh Kumar",
                      fontFamily: AppFonts.kanitReg,
                      fontWeight: FontWeight.w600,
                      size: 16,
                      color: PortColor.black,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: screenHeight * 0.02,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        TextConst(
                          title: "4.8 (256 rides)",
                          fontFamily: AppFonts.kanitReg,
                          color: Colors.grey.shade600,
                          size: 12,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    TextConst(
                      title: "DL 01 AB 1234",
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.grey.shade600,
                      size: 12,
                    ),
                  ],
                ),
              ),

              // Verification Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: screenHeight * 0.015,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    TextConst(
                      title: "Verified",
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.green,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),
          Divider(color: PortColor.gray.withOpacity(0.3)),
          SizedBox(height: screenHeight * 0.02),

          // Vehicle Details
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: PortColor.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: PortColor.gold,
                  size: screenHeight * 0.025,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: "Tata Ace",
                      fontFamily: AppFonts.kanitReg,
                      fontWeight: FontWeight.w600,
                      size: 14,
                      color: PortColor.black,
                    ),
                    SizedBox(height: screenHeight * 0.002),
                    TextConst(
                      title: "White • DL 01 AB 1234",
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.grey.shade600,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(
            title: "Ride Details",
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w600,
            size: 16,
            color: PortColor.black,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Pickup Location
          _buildRideDetailItem(
            Icons.arrow_upward_rounded,
            Colors.green,
            "Pickup Location",
            "123, MG Road, Connaught Place, New Delhi",
          ),

          SizedBox(height: screenHeight * 0.02),

          // Drop Location
          _buildRideDetailItem(
            Icons.arrow_downward_rounded,
            PortColor.red,
            "Drop Location",
            "456, Saket, South Delhi, New Delhi",
          ),

          SizedBox(height: screenHeight * 0.02),
          Divider(color: PortColor.gray.withOpacity(0.3)),
          SizedBox(height: screenHeight * 0.02),

          // ETA and Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRideInfoItem(
                Icons.access_time,
                "ETA",
                "15-20 mins",
              ),
              _buildRideInfoItem(
                Icons.location_on,
                "Distance",
                "8.2 KM",
              ),
              _buildRideInfoItem(
                Icons.schedule,
                "Vehicle",
                "Tata Ace",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRideDetailItem(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: screenHeight * 0.02,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextConst(
                title: title,
                fontFamily: AppFonts.kanitReg,
                color: Colors.grey.shade600,
                size: 12,
              ),
              SizedBox(height: screenHeight * 0.002),
              TextConst(
                title: subtitle,
                fontFamily: AppFonts.kanitReg,
                fontWeight: FontWeight.w600,
                size: 14,
                color: PortColor.black,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRideInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: PortColor.gold,
          size: screenHeight * 0.025,
        ),
        SizedBox(height: screenHeight * 0.005),
        TextConst(
          title: title,
          fontFamily: AppFonts.kanitReg,
          color: Colors.grey.shade600,
          size: 10,
        ),
        SizedBox(height: screenHeight * 0.002),
        TextConst(
          title: value,
          fontFamily: AppFonts.kanitReg,
          fontWeight: FontWeight.w600,
          size: 12,
          color: PortColor.black,
        ),
      ],
    );
  }

  Widget _buildOTPSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(
            title: "Ride OTP Verification",
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w600,
            size: 16,
            color: PortColor.black,
          ),
          SizedBox(height: screenHeight * 0.02),

          // OTP Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.025,
            ),
            decoration: BoxDecoration(
              color: PortColor.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PortColor.gold,
              ),
            ),
            child: Column(
              children: [
                TextConst(
                  title: "Your Ride OTP",
                  fontFamily: AppFonts.kanitReg,
                  color: Colors.grey.shade600,
                  size: 14,
                ),
                SizedBox(height: screenHeight * 0.01),
                TextConst(
                  title: _otpCode,
                  fontFamily: AppFonts.kanitReg,
                  fontWeight: FontWeight.w700,
                  size: 32,
                  color: PortColor.black,
                ),
                SizedBox(height: screenHeight * 0.01),
                TextConst(
                  title: "Share this OTP with captain to start the ride",
                  fontFamily: AppFonts.kanitReg,
                  color: Colors.grey.shade600,
                  size: 12,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          ],

      ),
    );
  }

  Widget _buildSafetySupportSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(
            title: "Safety & Support",
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w600,
            size: 16,
            color: PortColor.black,
          ),
          SizedBox(height: screenHeight * 0.02),

          // SOS Emergency Button - Simplified
          GestureDetector(
            onTap: _sendSOSAlert,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.025,
              ),
              decoration: BoxDecoration(
                color: PortColor.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: PortColor.red,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // SOS Icon
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: PortColor.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emergency,
                      color: PortColor.white,
                      size: screenHeight * 0.025,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),

                  // SOS Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title: "Emergency SOS",
                          fontFamily: AppFonts.kanitReg,
                          fontWeight: FontWeight.w700,
                          size: 16,
                          color: PortColor.red,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        TextConst(
                          title: "Tap to send immediate alert to admin",
                          fontFamily: AppFonts.kanitReg,
                          color: Colors.grey.shade600,
                          size: 12,
                        ),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: PortColor.red,
                    size: screenHeight * 0.02,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Emergency Contact
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.02,
            ),
            decoration: BoxDecoration(
              color: PortColor.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: PortColor.blue.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: PortColor.blue,
                  size: screenHeight * 0.02,
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: "24/7 Support",
                        fontFamily: AppFonts.kanitReg,
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: PortColor.blue,
                      ),
                      SizedBox(height: screenHeight * 0.002),
                      TextConst(
                        title: "Emergency contact: 1800-123-4567",
                        fontFamily: AppFonts.kanitReg,
                        color: Colors.grey.shade600,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOptions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(
            title: "Contact Captain",
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w600,
            size: 16,
            color: PortColor.black,
          ),
          SizedBox(height: screenHeight * 0.02),

          GestureDetector(
            onTap:(){
              Navigator.pushNamed(context, RoutesName.ratingFeedback);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call,
                    color: PortColor.white,
                    size: screenHeight * 0.02,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  TextConst(
                    title: "Call Captain",
                    fontFamily: AppFonts.kanitReg,
                    color: PortColor.white,
                    fontWeight: FontWeight.w600,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}