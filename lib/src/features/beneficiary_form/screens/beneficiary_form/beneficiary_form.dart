import 'package:flutter/material.dart';

class BeneficiaryFormWidget extends StatefulWidget {
  const BeneficiaryFormWidget({super.key});

  @override
  _BeneficiaryFormWidgetState createState() => _BeneficiaryFormWidgetState();
}

class _BeneficiaryFormWidgetState extends State<BeneficiaryFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName,
      _middleName,
      _surname,
      _address1,
      _address2,
      _town,
      _zip,
      _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beneficiary Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PersonalDetailsForm(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Identification Details',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container()),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Do something with the form data
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column PersonalDetailsForm(BuildContext context) {
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
                child: Text('Personal Details',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline_outlined),
                      labelText: 'Full Name',
                      hintText: 'FIRST MIDDLE LAST',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter beneficiary name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Address Line 1',
                      prefixIcon: const Icon(Icons.home),
                      hintText: 'House No/ Street/ Locality',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter beneficiary address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address1 = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Address Line 2',
                      prefixIcon: const Icon(Icons.home_outlined),
                      hintText: 'Area/ Town',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter beneficiary address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address2 = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Zip Code',
                      prefixIcon: const Icon(Icons.numbers_outlined),
                      hintText: 'Zip Code',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: const OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid Zip Code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _zip = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = value!;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
