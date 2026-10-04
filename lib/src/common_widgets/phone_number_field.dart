import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../constants/colors.dart';
import '../constants/country_codes.dart';
import '../constants/text.dart';

/// Matches [value] against kCountryCodes by the LONGEST matching dial-code
/// prefix, not just the first list match — several dial codes are prefixes
/// of other, longer ones (e.g. US "+1" vs. Bahamas "+1242"), and with India
/// listed first/United States second for the picker's sake, a plain
/// firstWhere would misidentify a Bahamas number as a US one.
CountryCode _matchDialCode(String value) {
  CountryCode? best;
  for (final country in kCountryCodes) {
    if (value.startsWith(country.dialCode) &&
        (best == null || country.dialCode.length > best.dialCode.length)) {
      best = country;
    }
  }
  return best ?? kCountryCodes.first;
}

/// Shared validator for PhoneNumberField's combined value (e.g.
/// "+919876543210") — required, and exactly 10 digits after the dial code.
String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) return aPhoneNumberRequired;
  final country = _matchDialCode(value);
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
  late final TextEditingController _digitsController;

  @override
  PhoneNumberField get widget => super.widget as PhoneNumberField;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue ?? '';
    String digits;
    if (initial.startsWith('+')) {
      _country = _matchDialCode(initial);
      digits = initial.substring(_country.dialCode.length);
    } else {
      // Legacy data predates country codes entirely — these were always a
      // plain national number with no prefix at all, collected back when
      // the signup form only ever assumed India. Treat the whole value as
      // the national digits rather than failing to match any dial code and
      // silently showing empty boxes.
      _country = kCountryCodes.first;
      digits = initial;
    }
    _digitsController = TextEditingController(text: digits);
  }

  @override
  void dispose() {
    _digitsController.dispose();
    super.dispose();
  }

  void _emitChange() {
    final digits = _digitsController.text;
    final combined = digits.isEmpty ? '' : '${_country.dialCode}$digits';
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
    const boxTheme = PinTheme(
      width: 30,
      height: 48,
      textStyle: TextStyle(
          color: aPrimaryColor, fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: aPrimaryColor, width: 2)),
      ),
    );
    final focusedBoxTheme = boxTheme.copyDecorationWith(
      border: const Border(
          bottom: BorderSide(color: aAccentColor, width: 2)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country picker gets its own row rather than sitting beside the 10
        // boxes — fitting both side by side (tried first) forced the boxes
        // down to 20dp wide, which read as barely-visible even after fixing
        // their text color. Full width here lets them be comfortably larger.
        InkWell(
          onTap: _openCountryPicker,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_flagEmoji(_country.iso2),
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(_country.dialCode,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: aPrimaryColor)),
                const Icon(Icons.arrow_drop_down, color: aPrimaryColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Switched from flutter_otp_text_field to pinput: the former builds
        // one real TextFormField per digit box and synchronizes them by
        // hand, which is what caused three separate bugs here (invisible
        // text, a callback that only ever passed the latest keystroke
        // instead of the accumulated code, and a maxLength quirk that let
        // one box's input spill into every other box). pinput renders all
        // boxes from a single underlying TextEditingController, so there's
        // nothing to keep in sync and no separate per-box focus/maxLength
        // logic to go wrong. 10 boxes at this size fit this screen's
        // available width directly; the scroll view is a safety net for
        // narrower screens/larger font scales, not the primary fit strategy.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // Pinput's underlying TextField needs a Material ancestor to find
          // (standard Flutter requirement for text selection/cursor
          // rendering) — confirmed live, this screen's Scaffold wasn't
          // close enough through the ScrollView/gesture-detector layers in
          // between. A transparent Material satisfies that directly rather
          // than depending on exactly how the surrounding tree is shaped.
          child: Material(
            type: MaterialType.transparency,
            child: Pinput(
              length: 10,
              controller: _digitsController,
              defaultPinTheme: boxTheme,
              focusedPinTheme: focusedBoxTheme,
              submittedPinTheme: boxTheme,
              separatorBuilder: (index) => const SizedBox(width: 4),
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.start,
              onChanged: (_) => _emitChange(),
            ),
          ),
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
