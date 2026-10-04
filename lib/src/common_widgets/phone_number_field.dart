import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../constants/country_codes.dart';
import '../constants/text.dart';

/// Shared validator for PhoneNumberField's combined value (e.g.
/// "+919876543210") — required, and exactly 10 digits after the dial code.
String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) return aPhoneNumberRequired;
  final country = kCountryCodes.firstWhere(
    (c) => value.startsWith(c.dialCode),
    orElse: () => kCountryCodes.first,
  );
  final digits = value.substring(country.dialCode.length);
  if (digits.length != 10) return aInvalidPhoneNumber;
  return null;
}

/// Converts an ISO 3166-1 alpha-2 code (e.g. "IN") to its flag emoji by
/// mapping each letter to its Unicode "regional indicator symbol".
String _flagEmoji(String iso2) {
  return iso2.toUpperCase().codeUnits
      .map((c) => String.fromCharCode(c + 0x1F1A5))
      .join();
}

/// A phone-number input: a country-code picker (defaulting to India, with
/// United States second and the rest of the world alphabetically — see
/// kCountryCodes) next to 10 individual single-digit boxes for the national
/// number, instead of one long text field.
///
/// Participates in a surrounding Form the same way TextFormField does —
/// formKey.currentState!.validate() triggers [validator] against the
/// combined value (e.g. "+919876543210"), and errors render under the row.
class PhoneNumberField extends FormField<String> {
  PhoneNumberField({
    super.key,
    String? initialValue,
    this.onChanged,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
  }) : super(
          initialValue: initialValue ?? '',
          builder: (field) => (field as PhoneNumberFieldState)._build(),
        );

  final ValueChanged<String>? onChanged;

  @override
  PhoneNumberFieldState createState() => PhoneNumberFieldState();
}

class PhoneNumberFieldState extends FormFieldState<String> {
  late CountryCode _country;
  String _digits = '';
  bool _prefilled = false;

  @override
  PhoneNumberField get widget => super.widget as PhoneNumberField;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue ?? '';
    if (initial.startsWith('+')) {
      _country = kCountryCodes.firstWhere(
        (c) => initial.startsWith(c.dialCode),
        orElse: () => kCountryCodes.first,
      );
      _digits = initial.substring(_country.dialCode.length);
    } else {
      // Legacy data predates country codes entirely — these were always a
      // plain national number with no prefix at all, collected back when
      // the signup form only ever assumed India. Treat the whole value as
      // the national digits rather than failing to match any dial code and
      // silently showing empty boxes.
      _country = kCountryCodes.first;
      _digits = initial;
    }
  }

  void _emitChange() {
    final combined = _digits.isEmpty ? '' : '${_country.dialCode}$_digits';
    didChange(combined);
    widget.onChanged?.call(combined);
  }

  void _onCountryChanged(CountryCode country) {
    setState(() => _country = country);
    _emitChange();
  }

  Future<void> _openCountryPicker() async {
    final selected = await showModalBottomSheet<CountryCode>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CountryPickerSheet(selected: _country),
    );
    if (selected != null) _onCountryChanged(selected);
  }

  Widget _build() {
    // flutter_otp_text_field has no initialValue of its own — handleControllers
    // is the only way in, but it fires on every one of OtpTextField's own
    // rebuilds (not just the first), so this has to guard itself to actually
    // run only once. Otherwise every keystroke would re-stamp _digits back
    // into the controllers right after OtpTextField's own backspace/advance
    // logic just changed them, fighting its internal state continuously.
    void handleControllers(List<TextEditingController?> controllers) {
      if (_prefilled || _digits.isEmpty) return;
      _prefilled = true;
      for (var i = 0; i < controllers.length && i < _digits.length; i++) {
        controllers[i]?.text = _digits[i];
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: _openCountryPicker,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_flagEmoji(_country.iso2),
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 2),
                    Text(_country.dialCode,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
            ),
            // OtpTextField lays out its fields at a fixed width regardless
            // of the space it's given — Expanded alone won't stop an
            // overflow if 10 boxes don't fit (confirmed live: they didn't,
            // at this screen's aDefaultSize=30 padding on each side). The
            // scroll view is a safety net for narrower screens/larger font
            // scales even after sizing the boxes down to fit comfortably.
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: OtpTextField(
                  numberOfFields: 10,
                  showFieldAsBox: true,
                  fieldWidth: 20,
                  margin: const EdgeInsets.only(right: 2),
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.start,
                  handleControllers: handleControllers,
                  onCodeChanged: (value) {
                    _digits = value;
                    _emitChange();
                  },
                ),
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selected});

  final CountryCode selected;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? kCountryCodes
        : kCountryCodes
            .where((c) =>
                c.name.toLowerCase().contains(_query.toLowerCase()) ||
                c.dialCode.contains(_query))
            .toList();

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search country or code',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final country = filtered[index];
                  final isSelected = country.iso2 == widget.selected.iso2;
                  return ListTile(
                    leading: Text(_flagEmoji(country.iso2),
                        style: const TextStyle(fontSize: 22)),
                    title: Text(country.name),
                    trailing: Text(country.dialCode),
                    selected: isSelected,
                    onTap: () => Navigator.of(context).pop(country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
