class ApiRoutes {
  //Job Order routes
  static const String getJobOrders = '/joborders/';
  static const String createJobOrder = '/joborders/';
  static String updateJobOrder(int jobId) {
    return '/joborders/$jobId/';
  }

  static String addJobOrderImage(int jobId) {
    return '/joborders/image/$jobId/';
  }

  static String addJobOrderComment(int jobId) {
    return '/joborders/comment/$jobId/';
  }

  //Customer routes
  static const String getCustomers = '/customers/';
  static const String createCustomer = '/customers/';
  static String updateCustomer(int customerId) {
    return '/customers/$customerId/';
  }

  static String getCustomerById(int customerId) {
    return '/customers/$customerId/';
  }

  static String deleteCustomerById(int customerId) {
    return '/customers/$customerId/';
  }

  static String addServiceToCustomer(int customerId, int serviceId) {
    return '/customers/$customerId/add-service/$serviceId/';
  }

  static String removeServiceFromCustomer(int customerId, int serviceId) {
    return '/customers/$customerId/remove-service/$serviceId/';
  }

  //Services routes
  static const String getServices = '/services/';
  static const String createService = '/services/';
  static String updateService(int serviceId) {
    return '/services/$serviceId/';
  }

  static String getServiceById(int serviceId) {
    return '/services/$serviceId/';
  }

  static String deleteServiceById(int serviceId) {
    return '/services/$serviceId/';
  }

  //User routes
  static const String logout = '/token/logout/';
  static const String login = '/token/login/';
  static const String userMe = '/user/me/';
}
