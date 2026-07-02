import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/book_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final BookModel book;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const OrderSummaryCard({
    super.key,
    required this.book,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final totalPrice = book.price * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.emerald50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: book.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      book.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.primary.withAlpha(60),
                      ),
                    ),
                  )
                : Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary.withAlpha(60),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${book.price.toStringAsFixed(2)} ${AppLocale.format(AppLocale.bookStoreQuantity)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.slate400 : AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuantityButton(
                icon: Icons.remove_rounded,
                onTap: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
              ),
              const SizedBox(width: 8),
              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.slate800,
                ),
              ),
              const SizedBox(width: 8),
              _QuantityButton(
                icon: Icons.add_rounded,
                onTap: () => onQuantityChanged(quantity + 1),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            '\$${totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primary.withAlpha(20)
              : AppColors.slate200.withAlpha(80),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : AppColors.slate400,
        ),
      ),
    );
  }
}
