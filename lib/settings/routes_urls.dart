class RoutesUrls {
  static final Map<String, String> _routes = {
    'login_page': '/login',
    'home_page': '/home',
    'services_page': '/services',
    'service_details': '/service/details',
    'customers_page': '/customers',
    'customers_details': '/customers/details',
    'create_customer': '/create/customer',
    'create_service': '/create/service',
    'splash_screen': '/splash_screen',
  };

  static String get loginPage => _routes['login_page']!;
  static String get homePage => _routes['home_page']!;
  static String get servicesPage => _routes['services_page']!;
  static String get serviceDetails => _routes['service_details']!;
  static String get customersPage => _routes['customers_page']!;
  static String get customerDetails => _routes['customers_details']!;
  static String get createCustomer => _routes['create_customer']!;
  static String get createService => _routes['create_service']!;
  static String get splashScreen => _routes['splash_screen']!;
}
