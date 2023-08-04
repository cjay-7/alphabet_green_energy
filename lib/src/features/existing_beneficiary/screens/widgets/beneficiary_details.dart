import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';
import '../../../beneficiary_form/models/beneficiary_model.dart';
import '../../controllers/get_beneficiary_details_controller.dart';

class BeneficiaryDetails extends StatelessWidget {
  const BeneficiaryDetails({
    super.key,
    required this.size,
    required BeneficiaryController beneficiaryController,
  }) : _beneficiaryController = beneficiaryController;

  final Size size;
  final BeneficiaryController _beneficiaryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 0),
          child: Text(
            "Please match the Beneficiary Details below:",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Container(
          width: size.width * .9,
          height: size.height * .35,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: aAccentColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            child: ListView.builder(
              itemCount: _beneficiaryController.beneficiaryList.length,
              itemBuilder: (context, index) {
                BeneficiaryModel beneficiary =
                    _beneficiaryController.beneficiaryList[index];
                return ListTile(
                  title: Table(columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  }, children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Text(
                            "Name:",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        TableCell(
                          child: Text(
                            beneficiary.fullName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ]),
                  subtitle: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              "${beneficiary.idType}:",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TableCell(
                            child: Text(
                              beneficiary.idNumber,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("ID Photo: "),
                          ),
                          TableCell(
                            child: GestureDetector(
                              child: const Text(
                                "View ID Photo",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () => launch(beneficiary.idImage),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Address: "),
                          ),
                          TableCell(
                            child: Text(
                                "${beneficiary.address1}, ${beneficiary.address2}"),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Town: "),
                          ),
                          TableCell(
                            child: Text(
                              beneficiary.town,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Zip: "),
                          ),
                          TableCell(
                            child: Text(
                              beneficiary.zip,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Phone Number: "),
                          ),
                          TableCell(
                            child: Text(
                              beneficiary.phoneNumber,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text("Stove ID: "),
                          ),
                          TableCell(
                            child: Text(
                              beneficiary.stoveID,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
