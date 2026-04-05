import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ReferalScreen extends ConsumerStatefulWidget {
  const ReferalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<ReferalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionViewModelProvider.notifier).getMySubscription();
    });
  }

  String _getReferralCode() {
    final mySubscription =
        ref.read(subscriptionViewModelProvider).mySubscription;
    if (mySubscription is Map) {
      return (mySubscription['referralCode'] as String?) ?? '';
    }
    return '';
  }

  void _showEarningsDashboard() {
    final notifier = ref.read(subscriptionViewModelProvider.notifier);
    notifier.getReferralEarnings();
    notifier.getReferralHistory();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _ReferralDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionViewModelProvider);
    final referralCode = () {
      final sub = subscriptionState.mySubscription;
      if (sub is Map) {
        return (sub['referralCode'] as String?) ?? '';
      }
      return '';
    }();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Referal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 226,
              width: 0.8 * MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invite your friends to join the train",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.spaceGrotesk),
                  ),
                  subscriptionState.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          referralCode.isNotEmpty ? referralCode : '---',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              fontFamily: AppFonts.spaceGrotesk),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Your friends should not \nmiss out on the fun",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.lato),
              ),
            ),
            const SizedBox(height: 20),
            CustomYafButton(
              borderColor: Colors.white,
              color: Color.fromRGBO(0, 0, 0, 1),
              textColor: Colors.white,
              iconPositionLeft: false,
              text: "Copy Referral Code",
              iconWidget: Icon(Icons.file_copy_outlined, color: Colors.white),
              onPressed: () {
                final code = _getReferralCode();
                if (code.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Referral code copied!')),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            CustomYafButton(
              color: Colors.white,
              textColor: Color.fromRGBO(0, 0, 0, 1),
              iconPositionLeft: false,
              text: "Share Referral Code",
              iconWidget: Icon(Icons.share, color: Color.fromRGBO(0, 0, 0, 1)),
              onPressed: () {
                final code = _getReferralCode();
                if (code.isNotEmpty) {
                  SharePlus.instance.share(
                    ShareParams(
                      text: 'Join me on Diet Lenz! Use my referral code: $code',
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            // Earnings dashboard button
            GestureDetector(
              onTap: _showEarningsDashboard,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceGrey),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.bar_chart_rounded,
                          color: AppColors.primaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Earnings & History',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.spaceGrotesk,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'View your referral earnings and activity',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                              fontFamily: AppFonts.lato,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.textGrey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget settingTile({required String title, Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.lato),
          ),
          icon ??
              const Icon(Icons.arrow_forward_ios,
                  weight: 40, size: 25, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full-screen Referral Dashboard
// ─────────────────────────────────────────────────────────────────────────────

class _ReferralDashboardScreen extends ConsumerStatefulWidget {
  const _ReferralDashboardScreen();

  @override
  ConsumerState<_ReferralDashboardScreen> createState() =>
      _ReferralDashboardScreenState();
}

class _ReferralDashboardScreenState
    extends ConsumerState<_ReferralDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(subscriptionViewModelProvider.notifier);
      notifier.getReferralEarnings();
      notifier.getReferralHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionViewModelProvider);
    final earnings = state.referralEarnings;
    final history = state.referralHistory;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Referral Dashboard'),
      ),
      body: state.isLoading && earnings == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Earnings summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _buildEarningsSummary(earnings),
                  ),
                ),
                // Section header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: Text(
                      'Referral History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.spaceGrotesk,
                      ),
                    ),
                  ),
                ),
                // History list
                if (history == null || history.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.group_add_outlined,
                              size: 48,
                              color: AppColors.textGrey.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No referrals yet',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textGrey,
                              fontFamily: AppFonts.lato,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Share your code to start earning!',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey.withValues(alpha: 0.7),
                              fontFamily: AppFonts.lato,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isOdd) {
                          return Divider(
                              color: AppColors.surfaceGrey,
                              height: 1,
                              indent: 20,
                              endIndent: 20);
                        }
                        final itemIndex = index ~/ 2;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _historyTile(history[itemIndex]),
                        );
                      },
                      childCount: history.length * 2 - 1,
                    ),
                  ),
                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            ),
    );
  }

  Widget _buildEarningsSummary(ReferralEarningsResponse? earnings) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _earningsCard(
                icon: Icons.monetization_on_outlined,
                label: 'Total Earnings',
                value:
                    '\$${(earnings?.totalEarningsUsd ?? 0).toStringAsFixed(2)}',
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _earningsCard(
                icon: Icons.people_outline,
                label: 'Total Referrals',
                value: '${earnings?.totalReferrals ?? 0}',
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _earningsCard(
                icon: Icons.hourglass_bottom_rounded,
                label: 'Pending',
                value:
                    '\$${(earnings?.pendingEarningsUsd ?? 0).toStringAsFixed(2)}',
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _earningsCard(
                icon: Icons.emoji_events_outlined,
                label: 'Lifetime',
                value:
                    '\$${(earnings?.lifetimeEarningsUsd ?? 0).toStringAsFixed(2)}',
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _earningsCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: AppFonts.spaceGrotesk,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey,
              fontFamily: AppFonts.lato,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyTile(ReferralHistoryResponse item) {
    final isPaid = item.isPaid ?? false;
    final status = item.status ?? 'pending';
    final statusColor = isPaid
        ? Colors.greenAccent
        : status.toLowerCase() == 'completed'
            ? Colors.blueAccent
            : Colors.amber;
    final statusLabel = isPaid ? 'Paid' : status;

    String formattedDate = '';
    if (item.createdAt != null && item.createdAt!.isNotEmpty) {
      try {
        final date = DateTime.parse(item.createdAt!);
        formattedDate = DateFormat('MMM d, yyyy').format(date);
      } catch (_) {
        formattedDate = item.createdAt!;
      }
    }

    final email = item.refereeEmail ?? 'Unknown';
    final maskedEmail = _maskEmail(email);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
            child: Text(
              email.isNotEmpty ? email[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.spaceGrotesk,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maskedEmail,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.lato,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                    fontFamily: AppFonts.lato,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (item.rewardAmount != null)
                Text(
                  '${item.rewardCurrency ?? '\$'}${item.rewardAmount!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppFonts.spaceGrotesk,
                  ),
                ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontFamily: AppFonts.lato,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    if (name.length <= 2) return email;
    return '${name.substring(0, 2)}***@${parts[1]}';
  }
}
