import 'package:flutter/cupertino.dart';
import 'package:sofie_ui/blocs/theme_bloc.dart';
import 'package:sofie_ui/components/animated/mounting.dart';
import 'package:sofie_ui/components/layout.dart';
import 'package:sofie_ui/components/text.dart';
import 'package:sofie_ui/components/user_input/my_cupertino_search_text_field.dart';
import 'package:sofie_ui/model/country.dart';
import 'package:sofie_ui/extensions/context_extensions.dart';

class SelectedCountryDisplay extends StatelessWidget {
  final String isoCode;
  const SelectedCountryDisplay(this.isoCode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountryFlag(isoCode, 26),
        const SizedBox(
          width: 10,
        ),
        MyText(CountryRepo.fromIsoCode(isoCode).name),
      ],
    );
  }
}

class CountrySelector extends StatefulWidget {
  final void Function(Country country) selectCountry;
  final Country? selectedCountry;
  const CountrySelector(
      {Key? key, required this.selectCountry, this.selectedCountry})
      : super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  List<Country> _filteredCountries = CountryRepo.countries;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.selectedCountry;
  }

  void _handleTextFilterUpdate(String newFilterString) {
    setState(() => {
          _filteredCountries = CountryRepo.countries
              .where((e) =>
                  e.name
                      .toLowerCase()
                      .contains(newFilterString.toLowerCase()) ||
                  e.isoCode
                      .toLowerCase()
                      .contains(newFilterString.toLowerCase()) ||
                  e.iso3Code
                      .toLowerCase()
                      .contains(newFilterString.toLowerCase()))
              .toList()
        });
  }

  void _handleCountrySelect(Country country) {
    setState(() => _selectedCountry = country);
    widget.selectCountry(country);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = context.theme.primary.withOpacity(0.1);

    return CupertinoPageScaffold(
      navigationBar: const MyNavBar(
        middle: NavBarTitle('Select Country'),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: MyCupertinoSearchTextField(
              placeholder: 'Search countries',
              onChanged: (text) => _handleTextFilterUpdate(text),
              autofocus: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () =>
                          _handleCountrySelect(_filteredCountries[index]),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: borderColor))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CountryFlag(
                                    _filteredCountries[index].isoCode, 40),
                                const SizedBox(width: 12),
                                MyText(
                                  _filteredCountries[index].name,
                                ),
                              ],
                            ),
                            if (_filteredCountries[index] == _selectedCountry)
                              const FadeIn(
                                  child: Icon(CupertinoIcons.checkmark_alt,
                                      color: Styles.secondaryAccent)),
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
