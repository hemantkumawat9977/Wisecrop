import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:wisecrop/app/theme/app_colors.dart';


// ignore: must_be_immutable
class CommonTextFieldWidget extends StatefulWidget {
  final String aboveText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function onChanged;
  TextInputType? keyboardType;
  int? maxLine;
  int? maxLength;
  final TextEditingController controller;


  CommonTextFieldWidget({
    Key? key,
    this.maxLine,
    this.maxLength,
    this.keyboardType,
    required this.obscureText,
    required this.aboveText,
     this.suffixIcon,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CommonTextFieldWidget> createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  @override
  bool hasFocus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Focus(
        onFocusChange: (bool focus) {
          setState(() {
            hasFocus = focus; // Update the focus state
          });
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        widget.aboveText,
                        style: TextStyle(color:  AppColors.grey, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: widget.controller,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLine ?? 1,
                      maxLength: widget.maxLength??100,
                      cursorColor: Colors.white,
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),
                      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50 * 4),
                      decoration: InputDecoration(
                        hintText: "",
                        counterText: "",
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.only(right: 0, left: 0, bottom: 10),
                        errorStyle: const TextStyle(height: 0),
                        isDense: true,
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.onChanged(value.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),
              widget.suffixIcon??const SizedBox(),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
