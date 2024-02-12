class API {
  static const hostConnect = "https://enye.com.ph/enyecontrols_app_test";
  //static const hostConnect = "http://192.168.0.137/adminenye";

  //login and registration
  static const login = "$hostConnect/enye/login.php";
  static const register = "$hostConnect/enye/signup.php";
  static const clientsImages = "$hostConnect/enye/clients_img/"; //clients images
  static const editClientInfo = "$hostConnect/enye/editClientInfo.php"; //edit clients info
  static const deleteClientInfo = "$hostConnect/enye/deleteClientInfo.php"; //edit clients info

  //file catalogs pdf
  static const fileCatalogsPdf = "$hostConnect/admin/system_catalog_pdf/";

  //projects
  static const projCategImage = "$hostConnect/enye/projects/projCategories_img/";
  static const projectsImage = "$hostConnect/enye/projects/projects_img/";
  static const projects = "$hostConnect/enye/projects/projects.php";

  //systems
  static const sysDetailsImg = "$hostConnect/enye/systems/systems_details_img/";
  static const sysTechImg = "$hostConnect/enye/systems/systems_tech_img/";
  static const systemsImg = "$hostConnect/enye/systems/systems_img/";
  static const systems = "$hostConnect/enye/systems/systems.php";

  //projects
  static const prodCategIcon = "$hostConnect/enye/products/product_category_icon/";
  static const prodImg = "$hostConnect/enye/products/products_img/";
  static const prodPdf = "$hostConnect/enye/products/products_pdf/";
  static const prodDetailsImg = "$hostConnect/enye/products/product_details/";
  static const products = "$hostConnect/enye/products/products.php";

  //home
  static const dashboard = "$hostConnect/enye/home/dashboard/";

  //booking
  static const booking = "$hostConnect/enye/booking/booking.php";
  static const ec_calendar = "$hostConnect/ec_calendar.php"; //calendar disable holidays and events
  static const position = "$hostConnect/admin/features/position.php"; //position data's
  static const usersImages = "$hostConnect/admin/users_img/"; //handlers images

  //push notif
  static const pushNotif = "$hostConnect/enye/pushNotif.php";

  //token table
  static const token = "$hostConnect/enye/token.php";

  //reset password
  static const resetPassword = "$hostConnect/enye/resetPassword.php";
}