import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // If not web, or if the screen is too narrow to be considered "desktop web",
    // just return the child normally.
    if (!kIsWeb) return child;
    
    // You can also use MediaQuery.sizeOf(context).width if preferred,
    // but a LayoutBuilder handles parent constraints elegantly.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop web view: Center a mobile-sized container
          final mediaQueryData = MediaQuery.of(context);
          return Container(
            color: const Color(0xFFE5E7EB), // A subtle gray background for the desktop
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: MediaQuery(
                  data: mediaQueryData.copyWith(
                    size: Size(430, mediaQueryData.size.height),
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        }

        // Mobile web view: Full width
        return child;
      },
    );
  }
}
