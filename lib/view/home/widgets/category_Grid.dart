import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/shimmer_loader.dart';
import 'package:port_karo/view/home/widgets/pickup/deliver_all_india_parcel.dart';
import 'package:port_karo/view/home/widgets/pickup/deliver_by_packer_mover.dart';
import 'package:port_karo/view/home/widgets/pickup/deliver_by_truck.dart';
import 'package:port_karo/view_model/service_type_view_model.dart';
import 'package:provider/provider.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceTypeViewModel =
      Provider.of<ServiceTypeViewModel>(context, listen: false);
      serviceTypeViewModel.serviceTypeApi();
    });
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty_rounded,
                size: 40, color: Colors.deepOrangeAccent),
            const SizedBox(height: 12),
            const Text(
              "Coming Soon",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "This feature is under development.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: PortColor.buttonBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Got it",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final serviceTypeViewModel = Provider.of<ServiceTypeViewModel>(context);

    return serviceTypeViewModel.loading
        ? GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const ShimmerLoader(
          width: double.infinity,
          height: 140,
          borderRadius: 16,
        );
      },
    )
        : serviceTypeViewModel.serviceTypeModel?.data?.isNotEmpty == true
        ? GridView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 7,
        childAspectRatio: 1.1
      ),
      itemCount:
      serviceTypeViewModel.serviceTypeModel!.data!.length,
      itemBuilder: (context, index) {
        final services =
        serviceTypeViewModel.serviceTypeModel!.data![index];
        return GestureDetector(
          onTap: () {
            if (index == 0 || index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliverByTruck(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliverByPackerMover(),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliverAllIndiaParcel(),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                // Stronger shadow for floating effect
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // darker shadow
                  blurRadius: 12, // more blur for soft edges
                  spreadRadius: 2, // expand a bit
                  offset: const Offset(0, 6), // vertical lift
                ),
                // Subtle secondary shadow for depth
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.03),
                //   blurRadius: 20,
                //   offset: const Offset(0, 12),
                // ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.03,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          services.name ?? "",
                          style:  TextStyle(
                              fontSize: 14,
                              fontFamily: AppFonts.kanitReg,
                              fontWeight: FontWeight.w400),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: PortColor.grayLight,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.006),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.network(
                      services.images ?? "",
                      height: 90,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    )
        : const Center(child: Text("No vehicles Available"));
  }
}
