import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_text.dart';
import '../../../../res/constant_color.dart' show PortColor;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _installationSelected = false;
  bool _singleLayerPacking = false;
  bool _multiLayerPacking = false;
  bool _coverSelected = false;
  String? _selectedTimeSlot;
  String? _selectedSession = "Morning";
  bool _slotConfirmed = false;

  final List<Map<String, dynamic>> _dateItems = [
    {'day': '19', 'weekDay': 'Today', 'price': '₹1,564', 'selected': true},
    {'day': '20', 'weekDay': 'Sat', 'price': '₹1,864', 'selected': false},
    {'day': '21', 'weekDay': 'Sun', 'price': '₹1,864', 'selected': false},
    {'day': '22', 'weekDay': 'Mon', 'price': '₹1,564', 'selected': false},
  ];

  List<String> _getTimeSlotsForSession() {
    switch (_selectedSession) {
      case "Morning":
        return [
          "8:00 AM - 9:00 AM",
          "9:00 AM - 10:00 AM",
          "10:00 AM - 11:00 AM",
          "11:00 AM - 12:00 PM",
        ];
      case "Afternoon":
        return [
          "12:00 PM - 1:00 PM",
          "1:00 PM - 2:00 PM",
          "2:00 PM - 3:00 PM",
          "3:00 PM - 4:00 PM",
        ];
      case "Evening":
        return [
          "4:00 PM - 5:00 PM",
          "5:00 PM - 6:00 PM",
          "6:00 PM - 7:00 PM",
        ];
      default:
        return [];
    }
  }

  void _showPickupSlotModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: PortColor.bg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: PortColor.black,
                          size: screenHeight * 0.025,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      TextConst(
                        title: "Select Pickup Slot",
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
                        // Date Section
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: PortColor.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: PortColor.button),
                            ),
                            child: TextConst(
                              title: '03 OCT 2025',
                              fontFamily: AppFonts.poppinsReg,
                              color: PortColor.button,
                              fontWeight: FontWeight.w600,
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Time Slot Sections in Row
                        Row(
                          children: [
                            // Morning Section
                            Expanded(
                              child: _buildTimeSlotCard(
                                "Morning",
                                "8AM - 12PM",
                                Icons.wb_sunny_outlined,
                                _selectedSession == "Morning",
                                    () {
                                  setModalState(() {
                                    _selectedSession = "Morning";
                                    _selectedTimeSlot = null;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),

                            // Afternoon Section
                            Expanded(
                              child: _buildTimeSlotCard(
                                "Afternoon",
                                "12PM - 4PM",
                                Icons.light_mode_outlined,
                                _selectedSession == "Afternoon",
                                    () {
                                  setModalState(() {
                                    _selectedSession = "Afternoon";
                                    _selectedTimeSlot = null;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),

                            // Evening Section
                            Expanded(
                              child: _buildTimeSlotCard(
                                "Evening",
                                "4PM - 7PM",
                                Icons.nights_stay_outlined,
                                _selectedSession == "Evening",
                                    () {
                                  setModalState(() {
                                    _selectedSession = "Evening";
                                    _selectedTimeSlot = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Individual Time Slots based on selected session
                        if (_selectedSession != null) ...[
                          TextConst(
                            title: "Available Time Slots",
                            fontFamily: AppFonts.kanitReg,
                            fontWeight: FontWeight.w600,
                            size: 16,
                            color: PortColor.black,
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          Column(
                            children: _getTimeSlotsForSession().map((slot) => _buildTimeSlotItem(slot, setModalState)).toList(),
                          ),
                        ],

                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),

                // Confirm Button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: _selectedTimeSlot != null ? () {
                      Navigator.pop(context);
                      setState(() {
                        _slotConfirmed = true;
                      });
                    } : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                      decoration: BoxDecoration(
                        color: _selectedTimeSlot != null ? PortColor.button : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TextConst(
                          title: "Confirm Slot",
                          fontFamily: AppFonts.kanitReg,
                          color: _selectedTimeSlot != null ? PortColor.black : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPaymentSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: PortColor.bg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: PortColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: PortColor.black,
                      size: screenHeight * 0.025,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  TextConst(
                    title: "Payment Summary",
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
                  children: [
                    // Shifting Date & Time
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: PortColor.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: PortColor.gray.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: PortColor.gold.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today,
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
                                  title: "Shifting on:",
                                  fontFamily: AppFonts.kanitReg,
                                  color: Colors.grey.shade600,
                                  size: 12,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                TextConst(
                                  title: "04 Oct · $_selectedTimeSlot",
                                  fontFamily: AppFonts.kanitReg,
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: PortColor.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Total Amount & Payment Summary
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total Amount
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: PortColor.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: PortColor.gray.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextConst(
                                  title: "Total amount",
                                  fontFamily: AppFonts.kanitReg,
                                  color: Colors.grey.shade600,
                                  size: 12,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                TextConst(
                                  title: "₹1,763",
                                  fontFamily: AppFonts.kanitReg,
                                  fontWeight: FontWeight.w600,
                                  size: 18,
                                  color: PortColor.black,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: screenWidth * 0.03),

                        // Payment Summary
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: PortColor.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: PortColor.gray.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextConst(
                                  title: "Payment summary",
                                  fontFamily: AppFonts.kanitReg,
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: PortColor.black,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                TextConst(
                                  title: "Pay booking amount ₹500",
                                  fontFamily: AppFonts.kanitReg,
                                  color: Colors.grey.shade600,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Terms & Conditions
                    TextConst(
                      title: "By proceeding, you agree to our Terms & Conditions",
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.grey.shade600,
                      size: 12,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),

            // Pay Booking Amount Button
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: PortColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle payment logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment initiated for ₹500'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  decoration: BoxDecoration(
                    color: PortColor.button,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TextConst(
                      title: "Pay booking amount ₹500",
                      fontFamily: AppFonts.kanitReg,
                      color: PortColor.black,
                      fontWeight: FontWeight.w600,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(String title, String timeRange, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: isSelected ? PortColor.gold.withOpacity(0.2) : PortColor.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? PortColor.gold : PortColor.gray.withOpacity(0.3),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: isSelected ? PortColor.gold : PortColor.gold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? PortColor.white : PortColor.gold,
                size: screenHeight * 0.025,
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Title
            TextConst(
              title: title,
              fontFamily: AppFonts.kanitReg,
              fontWeight: FontWeight.w600,
              size: 14,
              color: isSelected ? PortColor.black : Colors.grey.shade700,
            ),

            SizedBox(height: screenHeight * 0.005),

            // Time Range
            TextConst(
              title: timeRange,
              fontFamily: AppFonts.poppinsReg,
              color: isSelected ? PortColor.black : Colors.grey.shade600,
              size: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotItem(String timeSlot, StateSetter setModalState) {
    bool isSelected = _selectedTimeSlot == timeSlot;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            _selectedTimeSlot = timeSlot;
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: isSelected ? PortColor.gold.withOpacity(0.2) : PortColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? PortColor.gold : PortColor.gray.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: PortColor.gold.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Selection indicator
              Container(
                width: screenWidth * 0.04,
                height: screenWidth * 0.04,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? PortColor.gold : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected ? PortColor.gold : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(
                  Icons.check,
                  color: PortColor.white,
                  size: screenWidth * 0.03,
                )
                    : null,
              ),

              SizedBox(width: screenWidth * 0.03),

              // Time slot text
              TextConst(
                title: timeSlot,
                fontFamily: AppFonts.kanitReg,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? PortColor.black : Colors.grey.shade700,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          children: [
            SizedBox(height: topPadding,),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02),
              height: screenHeight * 0.17,
              decoration: BoxDecoration(
                color: PortColor.white,
                border: Border(
                  bottom: BorderSide(
                      color: PortColor.gray, width: screenWidth * 0.002),
                ),
                boxShadow: [
                  BoxShadow(
                    color: PortColor.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
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
                          title: "Packer and Mover",
                          color: PortColor.black),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StepWidget(
                        icon: Icons.check,
                        text: 'Moving details',
                        isActive: true,
                        isCompleted: true,
                      ),
                      DottedLine(),
                      StepWidget(
                        icon: Icons.inventory,
                        text: 'Add items',
                        isActive: true,
                        isCompleted: true,
                      ),
                      DottedLine(),
                      StepWidget(
                        icon: Icons.receipt,
                        text: 'Schedule',
                        isActive: true,
                        isCompleted: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(title: "Select shifting date",fontFamily: AppFonts.kanitReg,size: 15,fontWeight: FontWeight.w400,),
                    const SizedBox(height: 10),

                    Center(
                        child: TextConst(title: 'SEP 2025',fontFamily: AppFonts.poppinsReg,color: PortColor.button,fontWeight: FontWeight.w600,)
                    ),

                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dateItems.length,
                      itemBuilder: (context, index) {
                        return _buildDateItem(
                          _dateItems[index]['day'],
                          _dateItems[index]['weekDay'],
                          _dateItems[index]['price'],
                          _dateItems[index]['selected'],
                          index,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Recommended add-ons
                    TextConst(title: 'Recommended add-ons',fontFamily: AppFonts.kanitReg,size: 15,),
                    const SizedBox(height: 16),

                    // Installation/Un-installation
                    _buildAddonItem(
                      'Installation / Un-installation',
                      'Starts @₹300\nFor electronic appliances',
                      _installationSelected,
                          (value) {
                        setState(() {
                          _installationSelected = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Single-layer packing
                    _buildAddonItem(
                      'Single-layer packing',
                      '₹199\nIncl. single layer of protective material like foam or corrugated sheets for essential protection',
                      _singleLayerPacking,
                          (value) {
                        setState(() {
                          _singleLayerPacking = value!;
                          if (value) _multiLayerPacking = false;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Multi-layer packing
                    _buildAddonItem(
                      'Multi-layer packing',
                      '₹399\nIncl. extra layer of bubble wrap + (foam sheets or film rolls) for superior protection',
                      _multiLayerPacking,
                          (value) {
                        setState(() {
                          _multiLayerPacking = value!;
                          if (value) _singleLayerPacking = false;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // COVER
                    _buildAddonItem(
                      'COVER',
                      'With COVER claim up to ₹50,000 in case of damage / loss',
                      _coverSelected,
                          (value) {
                        setState(() {
                          _coverSelected = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _slotConfirmed ? _buildPaymentBottomSheet() : _buildSelectSlotBottomSheet(),
      ),
    );
  }

  Widget _buildSelectSlotBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Left side - Total Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextConst(title:
                  "Total Amount",
                    fontFamily: AppFonts.kanitReg,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  TextConst(title:
                  "₹ 2500",
                    fontFamily: AppFonts.kanitReg,
                    size: 13,
                    color: PortColor.blackLight,
                  ),
                ],
              ),

              const Spacer(),

              /// Right side - Select Pickup Slot Button
              GestureDetector(
                onTap: _showPickupSlotModal,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.button,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextConst(
                    title: "Select Pickup Slot",
                    fontFamily: AppFonts.kanitReg,
                    color: PortColor.black,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Left side - Total Amount
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: "Total Amount",
                      fontFamily: AppFonts.kanitReg,
                      size: 12,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    TextConst(
                      title: "₹1,763",
                      fontFamily: AppFonts.kanitReg,
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: PortColor.black,
                    ),
                  ],
                ),
              ),

              /// Right side - Pay Booking Amount Button
              GestureDetector(
                onTap: _showPaymentSummary,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.button,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextConst(
                    title: "Pay Booking Amount",
                    fontFamily: AppFonts.kanitReg,
                    color: PortColor.black,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateItem(String day, String weekDay, String price, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var i = 0; i < _dateItems.length; i++) {
            _dateItems[i]['selected'] = (i == index);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? PortColor.gold.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? PortColor.gold: Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  weekDay,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? PortColor.gray : PortColor.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddonItem(String title, String description, bool isSelected, ValueChanged<bool?> onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? PortColor.button : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: PortColor.button,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(title:
                title,
                  color: isSelected ? PortColor.button : Colors.black,
                  fontFamily: AppFonts.kanitReg,
                  fontWeight: FontWeight.w500,
                ),
                TextConst(title:
                description,
                  color: Colors.grey,
                  fontFamily: AppFonts.poppinsReg,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final bool isCompleted;

  const StepWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.isActive,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? PortColor.button : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : Colors.grey,
            size: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
              fontFamily: AppFonts.kanitReg
          ),
        ),
      ],
    );
  }
}

/// DottedLine
class DottedLine extends StatelessWidget {
  final int dotCount;
  final double dotWidth;
  final double dotHeight;
  final double spacing;

  const DottedLine({
    super.key,
    this.dotCount = 16,
    this.dotWidth = 2,
    this.dotHeight = 1,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        return Container(
          width: dotWidth,
          height: dotHeight,
          color: PortColor.gray,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
        );
      }),
    );
  }
}