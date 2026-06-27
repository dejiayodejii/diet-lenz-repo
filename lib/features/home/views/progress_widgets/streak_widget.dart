part of '../progress.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({
    super.key,
    this.streak,
    this.isLoading = false,
  });

  final dynamic streak;
  final bool isLoading;

  Widget _buildShimmerValue() {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(30, 30, 30, 1),
      highlightColor: const Color.fromRGBO(50, 50, 50, 1),
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStreakValue(int? value) {
    if (isLoading) {
      return _buildShimmerValue();
    }
    return Text(
      '${value ?? 0}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _buildStreakValue(streak?.longestBasicStreak),
                      const SizedBox(width: 4),
                      const Text(
                        'Days',
                        style: TextStyle(
                          color: Color.fromRGBO(158, 160, 165, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.fire),
                      const Text(" Longest Streak",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const Text("Keep it going - you are building \nmomentum",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      _buildStreakValue(streak?.currentBasicStreak),
                      const SizedBox(width: 4),
                      const Text(
                        'Days',
                        style: TextStyle(
                          color: Color.fromRGBO(158, 160, 165, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(AppImages.fire),
                      const Text(" Consistency king",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const Text("Keep it going - you are building \nmomentum",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakValue(streak?.totalDaysLogged),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset(AppImages.fire),
                const Text(" Goals completed",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            const Text("Keep it going - you are building momentum",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
