import 'package:buddy_guardian/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputDecorationWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? margin;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final String? initialValue;
  final bool obscureText;
  final bool autofocus;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool? showCursor;
  final bool? enabled;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final int? maxLines;
  final Color color;
  final BorderRadius borderRadius;

  const InputDecorationWidget({
    super.key,
    this.controller,
    this.validator,
    required this.hintText,
    this.labelText,
    this.margin,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.initialValue,
    this.obscureText = false,
    this.autofocus = false,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.enabled,
    this.onSaved,
    this.maxLines,
    this.color = AppColors.darkColor,
    this.showCursor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextFormField(
        autocorrect: true,
        onTap: onTap,
        onSaved: onSaved,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        initialValue: initialValue,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autofocus: autofocus,
        validator: validator,
        controller: controller,
        maxLines: maxLines,
        scrollPadding: EdgeInsets.zero,
        style: TextStyle(
          fontSize: 15,
          color: color,
          fontFamily: "IM",
        ),
        textAlign: TextAlign.justify,
        cursorColor: color,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: AppColors.red,
            fontSize: 13,
            fontFamily: "IM",
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
              color: color.withOpacity(0.5), fontSize: 15, fontFamily: "IM"),
          labelStyle: TextStyle(color: color, fontSize: 15, fontFamily: "IM"),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            //AQUI LE CAMBIO EL COLOR DEL BORDE DONDE ESTA EL CALENDARIO
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR CUANDO EL ENABLED ESTA EN FALSE
          disabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(
              color: AppColors.blueColors,
              width: 2,
            ),
          ),
          //MANTIENE BORDE CUANDO NO SE ESCRIBE NADA
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          //COLOR DEL BORDE EN GENERAL
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
          //MANTIENE EL COLOR DEL BORDE
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
