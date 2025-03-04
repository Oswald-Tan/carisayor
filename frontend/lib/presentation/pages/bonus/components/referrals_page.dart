import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:intl/intl.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Referrals',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2131),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: userProvider.referrals.isEmpty
            ? Center(
                child: Text(
                  "No referrals yet",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: userProvider.referrals.length,
                itemBuilder: (context, index) {
                  final referral = userProvider.referrals[index];
                  final referralUsedAt = referral['referralUsedAt'];

                  return ListTile(
                    title: Text(referral['fullname'] ?? 'Unknown'),
                    subtitle: Text(
                      referralUsedAt != null
                          ? DateFormat.yMMMEd()
                              .format(DateTime.parse(referralUsedAt))
                          : 'No date available',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
