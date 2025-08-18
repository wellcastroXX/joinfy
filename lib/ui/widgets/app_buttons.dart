import 'package:flutter/material.dart';
import 'dart:math' as math; // para reservas dinâmicas

/// ==============================
/// Width factor responsivo (reutilizável)
/// ==============================
double appButtonWidthFactor(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  if (w >= 1200) return 0.55; // desktop grande
  if (w >= 900) return 0.70; // tablet
  if (w >= 600) return 0.85; // phone largo
  return 0.90; // phone comum
}

/// ==============================
/// PRESET — PRIMÁRIO (replica o tema do FilledButton)
/// ==============================
ButtonStyle appPrimaryButtonStyle(BuildContext context) {
  final base =
      Theme.of(context).filledButtonTheme.style ?? FilledButton.styleFrom();

  final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
  final minH = (70 * scale).clamp(50, 90).toDouble();

  return base.copyWith(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, minH)),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    ),
  );
}

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool fullWidth;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyleOverride;
  final double? iconSize;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.fullWidth = true,
    this.margin,
    this.textStyleOverride,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final style = appPrimaryButtonStyle(context);

    final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    final responsiveSize = (18 * scale).clamp(16.0, 26.0);

    final TextStyle effectiveTextStyle = (textStyleOverride ??
            Theme.of(context).textTheme.labelLarge ??
            const TextStyle())
        .copyWith(
      fontFamily: 'CodeProLC',
      fontWeight: FontWeight.w500,
      fontSize: responsiveSize,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    Widget? sizedLeading = leading;
    Widget? sizedTrailing = trailing;
    if (iconSize != null) {
      if (leading != null) {
        sizedLeading = SizedBox(
          width: iconSize,
          height: iconSize,
          child: FittedBox(child: leading),
        );
      }
      if (trailing != null) {
        sizedTrailing = SizedBox(
          width: iconSize,
          height: iconSize,
          child: FittedBox(child: trailing),
        );
      }
    }

    final content = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        if (sizedLeading != null) Positioned(left: 14, child: sizedLeading),
        Center(
          child: Text(
            label,
            style: effectiveTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            softWrap: false,
          ),
        ),
        if (sizedTrailing != null) Positioned(right: 14, child: sizedTrailing),
      ],
    );

    return Container(
      margin: margin,
      width: fullWidth
          ? MediaQuery.of(context).size.width * appButtonWidthFactor(context)
          : null,
      child: FilledButton(
        style: style,
        onPressed: onPressed,
        child: const SizedBox(width: double.infinity).withChild(content),
      ),
    );
  }
}

/// Helper pra anexar child em SizedBox de forma legível
extension _Child on SizedBox {
  Widget withChild(Widget child) =>
      SizedBox(width: width, height: height, child: child);
}

/// ==============================
/// PRESET — ALTERNATIVO (bg #F2F2F2, texto #222222, hover escurece)
/// ==============================
ButtonStyle appAltButtonStyle(BuildContext context) {
  const baseBg = Color(0xFFF2F2F2);
  const txt = Color(0xFF222222);

  Color darken(Color c, [double amt = 0.06]) {
    final f = 1 - amt;
    return Color.fromARGB(
      c.alpha,
      (c.red * f).round(),
      (c.green * f).round(),
      (c.blue * f).round(),
    );
  }

  // 🔻 Menor por padrão (global)
  final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.2);
  final minH = (52 * scale).clamp(44, 60).toDouble();

  return ButtonStyle(
    minimumSize: MaterialStateProperty.all(Size(double.infinity, minH)),
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed) ||
          states.contains(MaterialState.hovered)) {
        return darken(baseBg, 0.07);
      }
      if (states.contains(MaterialState.focused)) {
        return darken(baseBg, 0.04);
      }
      return baseBg;
    }),
    foregroundColor: MaterialStateProperty.all(txt),
    overlayColor: MaterialStateProperty.all(Colors.black12),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    elevation: MaterialStateProperty.all(0),
  );
}

/// Texto fallback (global menor)
const TextStyle kAppAltButtonText = TextStyle(
  fontFamily: 'CodeProLC',
  fontSize: 16, // 🔻 diminui fonte padrão dos botões sociais
  fontWeight: FontWeight.w500,
  height: 1.0,
  letterSpacing: 0.2,
  color: Color(0xFF222222),
);

/// Botão alternativo reutilizável (ex.: Google / Facebook)
class AppAltButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool fullWidth;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyleOverride;
  final double? gapAfterText;
  final ButtonStyle? style;
  final bool pinLeading;
  final bool pinTrailing;
  final double edgePadding;
  final double reservedLeadingWidth;
  final double reservedTrailingWidth;
  final double? iconSize;

  const AppAltButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.fullWidth = true,
    this.margin,
    this.textStyleOverride,
    this.gapAfterText,
    this.style,
    this.pinLeading = false,
    this.pinTrailing = false,
    this.edgePadding = 14,
    this.reservedLeadingWidth = 48,
    this.reservedTrailingWidth = 48,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final btnStyle = style ?? appAltButtonStyle(context);

    // Fonte responsiva (fallback global menor)
    final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    final fallbackSize = (16 * scale).clamp(14.0, 20.0);
    final textStyle = (textStyleOverride ?? kAppAltButtonText).copyWith(
      fontSize: textStyleOverride?.fontSize ?? fallbackSize,
    );

    // Aplica iconSize, se informado
    Widget? sizedLeading = leading;
    Widget? sizedTrailing = trailing;
    if (iconSize != null) {
      if (leading != null) {
        sizedLeading = SizedBox(
          width: iconSize,
          height: iconSize,
          child: FittedBox(child: leading),
        );
      }
      if (trailing != null) {
        sizedTrailing = SizedBox(
          width: iconSize,
          height: iconSize,
          child: FittedBox(child: trailing),
        );
      }
    }

    Widget child;
    if (pinLeading || pinTrailing) {
      final effLeadingReserve = pinLeading
          ? edgePadding + math.max(reservedLeadingWidth, (iconSize ?? 0) + 6)
          : 16.0;
      final effTrailingReserve = pinTrailing
          ? edgePadding + math.max(reservedTrailingWidth, (iconSize ?? 0) + 6)
          : 16.0;

      child = SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: effLeadingReserve,
                right: effTrailingReserve,
              ),
              child: Text(
                label,
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                softWrap: false,
              ),
            ),
            if (pinLeading && sizedLeading != null)
              Positioned(left: edgePadding, child: sizedLeading),
            if (pinTrailing && sizedTrailing != null)
              Positioned(right: edgePadding, child: sizedTrailing),
          ],
        ),
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (sizedLeading != null) ...[
            sizedLeading,
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              label,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (sizedTrailing != null) ...[
            SizedBox(width: gapAfterText ?? 24),
            sizedTrailing,
          ],
        ],
      );
    }

    return Container(
      margin: margin,
      width: fullWidth
          ? MediaQuery.of(context).size.width * appButtonWidthFactor(context)
          : null,
      child: FilledButton(style: btnStyle, onPressed: onPressed, child: child),
    );
  }
}

/// ==============================
/// Divisor “OU” reutilizável
/// ==============================
class AppOrTextDivider extends StatelessWidget {
  final double verticalMargin;
  const AppOrTextDivider({super.key, this.verticalMargin = 10});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3);
    final fontSize = (22 * scale).clamp(18.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalMargin),
      child: Center(
        child: Text(
          'OU',
          style: TextStyle(
            fontFamily: 'CodeProLC',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFA3A0A1).withOpacity(0.85),
            height: 1.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
