import 'package:flutter/material.dart';
import '../../../../core/widgets/select/custom_select_form.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart' as entities;
import '../../domain/entities/city.dart';

class AddressSelectionForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final bool isLoadingStates;
  final bool isLoadingCities;
  final List<Country> countries;
  final List<entities.AddressState> states;
  final List<City> cities;
  final Country? selectedCountry;
  final entities.AddressState? selectedState;
  final City? selectedCity;
  final Function(Country?)? onCountryChanged;
  final Function(entities.AddressState?)? onStateChanged;
  final Function(City?)? onCityChanged;

  const AddressSelectionForm({
    super.key,
    required this.formKey,
    required this.isLoading,
    required this.isLoadingStates,
    required this.isLoadingCities,
    required this.countries,
    required this.states,
    required this.cities,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona tu ubicación',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 32),

            // Selector de País
            CustomSelectForm<Country>.formField(
              label: 'País',
              hintText: isLoading ? 'Cargando países...' : 'Selecciona un país',
              value: selectedCountry,
              items: countries,
              itemLabel: (country) => '${country.flag} ${country.name}',
              onChanged: isLoading ? null : onCountryChanged,
              validator: (value) {
                if (value == null) {
                  return 'Selecciona un país';
                }
                return null;
              },
              enabled: !isLoading && countries.isNotEmpty,
            ),

            const SizedBox(height: 20),

            // Selector de Departamento/Estado
            CustomSelectForm<entities.AddressState>.formField(
              label: 'Departamento/Estado',
              hintText:
                  isLoadingStates
                      ? 'Cargando departamentos...'
                      : selectedCountry == null
                      ? 'Primero selecciona un país'
                      : 'Selecciona un departamento',
              value: selectedState,
              items: states,
              itemLabel: (state) => state.name,
              onChanged:
                  (isLoadingStates || selectedCountry == null)
                      ? null
                      : onStateChanged,
              validator: (value) {
                if (selectedCountry != null && value == null) {
                  return 'Selecciona un departamento';
                }
                return null;
              },
              enabled:
                  !isLoadingStates &&
                  selectedCountry != null &&
                  states.isNotEmpty,
            ),

            const SizedBox(height: 20),

            // Selector de Ciudad
            CustomSelectForm<City>.formField(
              label: 'Ciudad/Municipio',
              hintText:
                  isLoadingCities
                      ? 'Cargando ciudades...'
                      : selectedState == null
                      ? 'Primero selecciona un departamento'
                      : 'Selecciona una ciudad',
              value: selectedCity,
              items: cities,
              itemLabel: (city) => city.name,
              onChanged:
                  (isLoadingCities || selectedState == null)
                      ? null
                      : onCityChanged,
              validator: (value) {
                if (selectedState != null && value == null) {
                  return 'Selecciona una ciudad';
                }
                return null;
              },
              enabled:
                  !isLoadingCities &&
                  selectedState != null &&
                  cities.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
