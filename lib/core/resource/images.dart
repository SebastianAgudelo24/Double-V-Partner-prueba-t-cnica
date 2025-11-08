class AppImages {
  static final AppImages _singleton = AppImages._internal();

  factory AppImages() {
    return _singleton;
  }

  AppImages._internal();

  static const _kPath = 'assets/images/';

  //MetPay
  static const logoBlack = '${_kPath}splash_logo_black.png';
}
