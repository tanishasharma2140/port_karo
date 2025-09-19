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

  final List<Map<String, dynamic>> _dateItems = [
    {'day': '19', 'weekDay': 'Today', 'price': '₹1,564', 'selected': true},
    {'day': '20', 'weekDay': 'Sat', 'price': '₹1,864', 'selected': false},
    {'day': '21', 'weekDay': 'Sun', 'price': '₹1,864', 'selected': false},
    {'day': '22', 'weekDay': 'Mon', 'price': '₹1,564', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PortColor.bg,
      body: Column(
        children: [
          // Steps indicator
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
                  const SizedBox(height: 16),

                  Center(
                    child: TextConst(title: 'SEP 2025',fontFamily: AppFonts.poppinsReg,color: PortColor.button,fontWeight: FontWeight.w600,)
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: PortColor.button,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: TextConst(title:
                          "Select Pickup Slot",
                            fontFamily: AppFonts.kanitReg,
                          color: PortColor.white,
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 24),

                ],
              ),
            ),
          ),
        ],
      ),
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
          color: isSelected ? const Color(0xFFE8F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7DF6) : Colors.grey.shade300,
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
                    color: isSelected ? const Color(0xFF2E7DF6) : Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  weekDay,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFF2E7DF6) : Colors.grey,
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
                color: isSelected ? const Color(0xFF2E7DF6) : const Color(0xFF2E7DF6),
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