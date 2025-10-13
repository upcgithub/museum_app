import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? assetPath;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.label,
    this.icon,
    this.assetPath,
    this.onPressed,
  }) : assert(icon != null || assetPath != null,
            'Provide either an icon or an assetPath');

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: BorderSide(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (assetPath != null)
            Image.asset(
              assetPath!,
              width: 20,
              height: 20,
            )
          else if (icon != null)
            Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
