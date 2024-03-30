class RoutesUrls {
  static final Map<String, String> _routes = {
    'login_page': '/login',
    'home_page': '/home',
    'services_page': '/services',
    'service_details': '/service/details',
    'customers_page': '/customers',
    'customers_details': '/customers/details',
    'create_customer': '/create/customer',
    'update_customer': '/update/customer',
    'create_service': '/create/service',
    'update_service': '/update/service',
    'splash_screen': '/splash_screen',
    'display_map': '/display_map',
    'job_camera': '/job_camera'
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
  static String get updateCustomer => _routes['update_customer']!;
  static String get updateService => _routes['update_service']!;
  static String get displayMap => _routes['display_map']!;
  static String get jobCamera => _routes['job_camera']!;
}
