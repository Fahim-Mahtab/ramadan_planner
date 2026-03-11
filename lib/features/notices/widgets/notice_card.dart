import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import 'package:intl/intl.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const NoticeCard({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    // Format date like: "15 Mar 2024"
    final formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(notice.createdAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Optional Image Header
            if (notice.imageUrl != null && notice.imageUrl!.isNotEmpty)
              Image.network(
                notice.imageUrl!,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 140,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white24,
                      size: 40,
                    ),
                  ),
                ),
              ),

            // Text Content Area
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notice.title,
                    style: const TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey.shade400,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // Optional Message
                  if (notice.message != null && notice.message!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      notice.message!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
