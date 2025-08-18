import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';

class PageIndicatorWidget extends HookWidget {
  final int pageIndex;
  final int currentPage;
  final String label;
  final VoidCallback onTap;

  const PageIndicatorWidget({
    super.key,
    required this.pageIndex,
    required this.currentPage,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = pageIndex == currentPage;

    // Create hover state
    final isHovered = useState(false);

    // Create animation for hover effect
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    final colorAnimation = useAnimation(
      ColorTween(
        begin: isActive ? accentColor : textSecondaryColor,
        end: accentColor,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Update animation based on hover state
    useEffect(() {
      if (isHovered.value && !isActive) {
        animationController.forward();
      } else if (!isHovered.value && !isActive) {
        animationController.reverse();
      }
      return null;
    }, [isHovered.value, isActive]);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // width: 120,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive
                    ? accentColor
                    : (isHovered.value
                        ? accentColor.withOpacity(0.5)
                        : Colors.transparent),
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge.copyWith(
              color: isActive
                  ? accentColor
                  : (colorAnimation ?? textSecondaryColor),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
