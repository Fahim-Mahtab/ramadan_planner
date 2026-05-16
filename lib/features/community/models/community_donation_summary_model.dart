class CommunityDonationSummaryModel {
  final double totalDonations;
  final double totalExpenses;

  const CommunityDonationSummaryModel({
    required this.totalDonations,
    required this.totalExpenses,
  });

  double get remaining => totalDonations - totalExpenses;
}
