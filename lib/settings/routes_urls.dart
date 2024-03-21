class RoutesUrls {
  static final Map<String, String> _routes = {
    'login_page': '/login',
    'home_page': '/home',
    'services_page': '/services',
    'service_details': '/service/details',
  };

  static String get loginPage => _routes['login_page']!;
  static String get homePage => _routes['home_page']!;
  static String get servicesPage => _routes['services_page']!;
  static String get serviceDetails => _routes['service_details']!;
}
