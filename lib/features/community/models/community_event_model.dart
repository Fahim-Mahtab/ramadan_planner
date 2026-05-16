enum CommunityEventStatus { pending, approved, rejected, rescheduled, completed, cancelled }

CommunityEventStatus parseCommunityEventStatus(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'approved':
      return CommunityEventStatus.approved;
    case 'rejected':
      return CommunityEventStatus.rejected;
    case 'rescheduled':
      return CommunityEventStatus.rescheduled;
    case 'completed':
      return CommunityEventStatus.completed;
    case 'cancelled':
      return CommunityEventStatus.cancelled;
    default:
      return CommunityEventStatus.pending;
  }
}

class CommunityEventModel {
  final String id;
  final String title;
  final String description;
  final DateTime? eventDate;
  final String? startTime;
  final String? endTime;
  final bool donationEnabled;
  final double donationTarget;
  final int expectedAttendance;
  final CommunityEventStatus status;
  final String? categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final String? organizerId;
  final String? organizerName;
  final String? organizerPhoto;
  final DateTime? createdAt;

  const CommunityEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    required this.donationEnabled,
    this.donationTarget = 0,
    required this.expectedAttendance,
    required this.status,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    required this.organizerId,
    required this.organizerName,
    this.organizerPhoto,
    required this.createdAt,
  });

  factory CommunityEventModel.fromMap(Map<String, dynamic> map) {
    final category = map['event_categories'];
    final profile = map['profiles'];
    
    return CommunityEventModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      eventDate: map['requested_date'] != null
          ? DateTime.tryParse(map['requested_date'].toString())
          : null,
      startTime: map['start_time']?.toString(),
      endTime: map['end_time']?.toString(),
      donationEnabled: map['donation_enabled'] == true,
      donationTarget: (map['donation_target'] is num) 
          ? (map['donation_target'] as num).toDouble() 
          : 0.0,
      expectedAttendance: (map['expected_attendance'] is num)
          ? (map['expected_attendance'] as num).toInt()
          : 0,
      status: parseCommunityEventStatus(map['status']?.toString()),
      categoryId: map['category_id']?.toString(),
      categoryName: category is Map<String, dynamic>
          ? category['name']?.toString()
          : null,
      categoryIcon: category is Map<String, dynamic>
          ? category['icon']?.toString()
          : null,
      organizerId: map['user_id']?.toString(),
      organizerName: profile is Map<String, dynamic>
          ? profile['full_name']?.toString()
          : null,
      organizerPhoto: profile is Map<String, dynamic>
          ? profile['photo_url']?.toString()
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}
