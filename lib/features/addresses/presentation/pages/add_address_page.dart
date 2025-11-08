import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/button/custom_button.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/state.dart' as entities;
import '../../domain/entities/city.dart';
import '../providers/location_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../widgets/widgets.dart';

class AddAddressPage extends ConsumerStatefulWidget {
  const AddAddressPage({super.key});

  @override
  ConsumerState<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends ConsumerState<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  List<Country> _countries = [];
  List<entities.AddressState> _states = [];
  List<City> _cities = [];

  Country? _selectedCountry;
  entities.AddressState? _selectedState;
  City? _selectedCity;

  /// Método para quitar el enfoque de todos los campos de texto
  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _loadCountries();
    // Inicializar los providers si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initializeAuth();
      ref.read(profileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header modular
                  const AddressPageHeader(
                    title: '¿Dónde te encuentras?',
                    subtitle: 'Agrega tu dirección para completar tu perfil',
                  ),

                  const SizedBox(height: 32),

                  // Formulario de selección modular
                  AddressSelectionForm(
                    formKey: _formKey,
                    isLoading: _isLoading,
                    isLoadingStates: _isLoadingStates,
                    isLoadingCities: _isLoadingCities,
                    countries: _countries,
                    states: _states,
                    cities: _cities,
                    selectedCountry: _selectedCountry,
                    selectedState: _selectedState,
                    selectedCity: _selectedCity,
                    onCountryChanged: _onCountryChanged,
                    onStateChanged: _onStateChanged,
                    onCityChanged: _onCityChanged,
                  ),

                  const SizedBox(height: 40),

                  // Botones de acción
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton.primary(
                          onPressed: _canSaveAddress() ? _saveAddress : null,
                          text: 'Guardar Dirección',
                          isLoading: false,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton.secondary(
                          onPressed:
                              () => context.go(AppRoutes.userProfilePath),
                          text: 'Omitir por ahora',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(locationRepositoryProvider);
      final countries = await repository.getCountries();

      if (mounted) {
        setState(() {
          _countries = countries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar países: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadStates(String countryCode) async {
    setState(() {
      _isLoadingStates = true;
    });

    try {
      final repository = ref.read(locationRepositoryProvider);
      final states = await repository.getStatesByCountry(countryCode);

      if (mounted) {
        setState(() {
          _states = states;
          _isLoadingStates = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStates = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar departamentos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCities(String countryCode, String stateCode) async {
    setState(() {
      _isLoadingCities = true;
    });

    try {
      final repository = ref.read(locationRepositoryProvider);
      final cities = await repository.getCitiesByState(countryCode, stateCode);

      if (mounted) {
        setState(() {
          _cities = cities;
          _isLoadingCities = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCities = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar ciudades: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onCountryChanged(Country? country) {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedCity = null;
      _states.clear();
      _cities.clear();
    });
    if (country != null) {
      _loadStates(country.code);
    }
  }

  void _onStateChanged(entities.AddressState? state) {
    setState(() {
      _selectedState = state;
      _selectedCity = null;
      _cities.clear();
    });
    if (state != null && _selectedCountry != null) {
      _loadCities(_selectedCountry!.code, state.code);
    }
  }

  void _onCityChanged(City? city) {
    setState(() {
      _selectedCity = city;
    });
  }

  bool _canSaveAddress() {
    return _selectedCountry != null &&
        _selectedState != null &&
        _selectedCity != null &&
        !_isLoading &&
        !_isLoadingStates &&
        !_isLoadingCities;
  }

  Future<void> _saveAddress() async {
    try {
      // Verificar si se seleccionaron país, estado y ciudad
      if (_selectedCountry == null ||
          _selectedState == null ||
          _selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecciona país, estado y ciudad'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Agregar la dirección al usuario usando el profile provider
      await ref
          .read(profileProvider.notifier)
          .addAddress(
            country: _selectedCountry!.name,
            state: _selectedState!.name,
            city: _selectedCity!.name,
          );

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dirección guardada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Pequeño delay para asegurar que el estado se propague
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          context.go(AppRoutes.userProfilePath);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar dirección: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
