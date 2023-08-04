import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/survey_add_controller.dart';

import 'package:dropdown_search/dropdown_search.dart';

class FuelType extends StatefulWidget {
  const FuelType({super.key});
  @override
  State<FuelType> createState() => _FuelTypeState();
}

class _FuelTypeState extends State<FuelType> {
  final controller = Get.put(SurveyAddController());

  _FuelTypeState() {
    fuelType1 = _fuelList1[0];
  }

  final _fuelList1 = ["Wood", "LPG/Gas", "Kerosene", "Coal"];
  String? fuelType1 = "";
  final _fuelList2 = [" ", "Wood", "LPG/Gas", "Kerosene", "Coal"];
  String? fuelType2 = " ";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Primary Fuel Type",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownSearch(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        selectedItem: fuelType1,
                        items: _fuelList1,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Fuel",
                            prefixIcon: Icon(Icons.add_card_rounded),
                          ),
                        ),
                        onChanged: (val) {
                          controller.fuelType1 = val as String;
                        },
                        validator: (item) {
                          if (item == null) {
                            return "Please select fuel";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.fuelType1amount,
                  decoration: InputDecoration(
                      labelText: "Monthly Consumption",
                      prefixIcon: const Icon(Icons.monitor_weight),
                      hintText: "in Kg",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Amount of Fuel Consumed per Month in Kg";
                    } else if (int.tryParse(value) == null) {
                      return 'Only numbers are allowed';
                    } else if (int.tryParse(value)! < 0) {
                      return "Please enter valid Number";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Secondary Fuel Type",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: DropdownSearch(
                        popupProps: const PopupProps.menu(
                          showSearchBox: true,
                        ),
                        selectedItem: fuelType2,
                        items: _fuelList2,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Fuel",
                            prefixIcon: Icon(Icons.add_card_rounded),
                          ),
                        ),
                        onChanged: (val) {
                          controller.fuelType2 = val as String;
                        },
                        validator: (item) {
                          if (item == null) {
                            return "Please select fuel";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller.fuelType2amount,
                  decoration: InputDecoration(
                      labelText: "Monthly Consumption",
                      prefixIcon: const Icon(Icons.monitor_weight),
                      hintText: "in Kg",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
