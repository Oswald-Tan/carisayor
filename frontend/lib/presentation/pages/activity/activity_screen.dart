import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/pending/pending_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/presentation/pages/cancelled/cancelled_screen.dart';
import 'package:frontend/presentation/pages/complete/complete_screen.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  ActivityState createState() => ActivityState();
}

class ActivityState extends State<Activity>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with a length of 3 (number of tabs)
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Activity',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2131),
                fontSize: 16,
              ),
            ),
            // Add TabBar under the title 'Activity'
            TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2131),
              ),
              splashFactory: NoSplash.splashFactory,
              unselectedLabelColor: Colors.grey,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              indicatorColor: const Color(0xFF74B11A),
              dividerColor: Colors.white,
              tabs: const [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Complete',
                ),
                Tab(
                  text: 'Cancelled',
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 89,
      ),
      // Add TabBarView to display tab content
      body: TabBarView(
        controller: _tabController,
        // physics: const NeverScrollableScrollPhysics(),
        children: const [
          PendingScreen(),
          CompleteScreen(),
          CancelledScreen(),
        ],
      ),
    );
  }
}
