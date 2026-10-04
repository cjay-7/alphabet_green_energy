import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

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
  String _digits = '';
  bool _prefilled = false;
  List<TextEditingController?> _digitControllers = const [];

  @override
  PhoneNumberField get widget => super.widget as PhoneNumberField;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue ?? '';
    if (initial.startsWith('+')) {
      _country = _matchDialCode(initial);
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
      // Same controller instances every call (OtpTextField creates them
      // once, not per build), so just keeping a live reference here is
      // enough to read each box's current text later from onCodeChanged —
      // no need to re-fetch it there.
      _digitControllers = controllers;
      if (_prefilled || _digits.isEmpty) return;
      _prefilled = true;
      for (var i = 0; i < controllers.length && i < _digits.length; i++) {
        controllers[i]?.text = _digits[i];
      }
    }

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
        // OtpTextField lays out its fields at a fixed width regardless of
        // the space it's given — a plain Row would overflow if 10 boxes at
        // this size don't quite fit (confirmed live at the smaller size
        // this replaced). The scroll view is a safety net for narrower
        // screens/larger font scales rather than relying on getting the
        // exact fit right for every device.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: OtpTextField(
            numberOfFields: 10,
            showFieldAsBox: true,
            // Sized to comfortably fit the digit without clipping, not to
            // fit all 10 on screen at once — reported live as still too
            // small/cut off at 28x48. This is wider than most screens can
            // show unscrolled, which is what the horizontal scroll wrapper
            // above is for.
            fieldWidth: 44,
            fieldHeight: 64,
            contentPadding: EdgeInsets.zero,
            margin: const EdgeInsets.only(right: 6),
            keyboardType: TextInputType.number,
            mainAxisAlignment: MainAxisAlignment.start,
            // OtpTextField sets maxLength on each individual box's
            // TextFormField to numberOfFields (10) instead of 1, relying
            // entirely on its onChanged logic to redistribute any
            // multi-character input across the other boxes as a "paste".
            // Confirmed live: something (predictive text, a key-repeat,
            // the Samsung keyboard) delivered more than one character to a
            // single box, and every box ended up with the same digit as a
            // result. Enforcing a hard 1-character limit here, at the
            // Flutter level, stops that regardless of what the IME sends.
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            // OtpTextField's own default text style doesn't pick up this
            // app's dark theme — confirmed live, digits typed were
            // invisible (black-on-black) against the box. Every other
            // color here was already explicit in the package's defaults
            // (hence the borders being visible); only the digit text
            // itself needed one.
            textStyle: const TextStyle(
                color: aPrimaryColor,
                fontSize: 26,
                fontWeight: FontWeight.w600),
            cursorColor: aAccentColor,
            enabledBorderColor: aPrimaryColor,
            focusedBorderColor: aAccentColor,
            handleControllers: handleControllers,
            // OtpTextField's onCodeChanged passes only the single digit
            // just typed (see _onDigitEntered in its source), not the
            // accumulated code — confirmed live: using it directly left
            // _digits as just the last keystroke typed (e.g. "7" instead
            // of "9594204097"), always failing validation. Read the real
            // combined value straight from the controllers instead of
            // trusting that parameter.
            onCodeChanged: (_) {
              _digits = _digitControllers.map((c) => c?.text ?? '').join();
              _emitChange();
            },
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
