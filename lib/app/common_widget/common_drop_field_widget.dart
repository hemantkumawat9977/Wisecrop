import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisecrop/app/theme/app_colors.dart';
import 'package:wisecrop/gen/assets.gen.dart';


class CommonDropDownWidget extends StatefulWidget {
  final String hint;
  final String aboveText;
  final Widget? suffixIcon;
  final bool? showOnlyActiveWorker;
  final bool? showWorkerIdentification;
  final bool? showWorkerCode;
  final Function onChanged;
  final Function? onTap;

  final TextEditingController? controller;
  final List<dynamic> itemList;

  const CommonDropDownWidget({
    Key? key,
    required this.hint,
    required this.aboveText,
    this.suffixIcon,
    this.onTap,
    this.showOnlyActiveWorker,
    this.showWorkerIdentification,
    this.showWorkerCode,
    required this.itemList,
    required this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  State<CommonDropDownWidget> createState() => _CommonDropDownWidgetState();
}

class _CommonDropDownWidgetState extends State<CommonDropDownWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          if(widget.onTap != null){
            widget.onTap!();
          }
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
                    TextField(
                      controller: widget.controller,
                      obscureText: false,
                      onTap: () {
                        if(widget.onTap != null){
                          widget.onTap!();
                        }
                        },
                      maxLines: 1,
                      readOnly: true,
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.only(right: 0, left: 0, bottom: 10),
                        errorStyle: const TextStyle(height: 0),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        isDense: true,
                      ),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              widget.suffixIcon ?? SizedBox(),
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
