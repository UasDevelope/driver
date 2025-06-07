class AppImages {
  static get _basePath => "asset/image";
  static get logo => "logo".png;
  static get email => "email".png;
  static get password => "password".png;
  static get loginSucess => "loginSucess".png;
  static get person => "person".png;
  static get driving => "driving".png;
  static get profile => "profile".png;
  static get drive => "drive".png;
  static get eye => "eye".png;
  static get location => "location".png;
  static get home => "home".png;
  static get calendar => "calendar".png;
  static get chat => "chat".png;
  static get setting => "setting".png;
}

extension ImagePathExtension on String {
  String get png => "asset/image/$this.png";
}
