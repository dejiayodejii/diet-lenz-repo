import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetttingsScreenState();
}

class _SetttingsScreenState extends ConsumerState<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelTextFormField(
                      isProfile: true,
                      controller:
                          TextEditingController(text: "Michael bernando"),
                      labelText: "Name",
                      hintText: "",
                      onChanged: (val) {},
                    ),
                    LabelTextFormField(
                      isProfile: true,
                      controller:
                          TextEditingController(text: "ayodeji@yopmail.com"),
                      labelText: "Email",
                      hintText: "",
                      onChanged: (val) {},
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LabelTextFormField(
                            isProfile: true,
                            controller:
                                TextEditingController(text: "12/08/1998"),
                            labelText: "DOB",
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            hintText: "",
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: LabelTextFormField(
                            isProfile: true,
                            controller: TextEditingController(text: "22"),
                            labelText: "Age",
                            hintText: "",
                            onChanged: (val) {},
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LabelTextFormField(
                            isProfile: true,
                            controller: TextEditingController(text: "5.3ft"),
                            labelText: "Height",
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            hintText: "",
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: LabelTextFormField(
                            isProfile: true,
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                            controller: TextEditingController(text: "56kg"),
                            labelText: "Weight",
                            hintText: "",
                            onChanged: (val) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CustomYafButton(
              text: "Save",
              onPressed: () {},
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget settingTile({required String title, Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: AppFonts.lato),
          ),
          icon ??
              const Icon(Icons.arrow_forward_ios,
                  weight: 40, size: 25, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
