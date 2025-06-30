class AppImages {
  static get _basePath => "asset/image";
  static get logo => "logo".png;
  static get email => "email".png;
  static get password => "password".png;
  static get loginSucess => "loginSucess".png;
  static get person => "person".png;
  static get person1=> "person1".png;
  static get  edit => "edit".png;
  static get send => "send".png;

  static get driving => "driving".png;
  static get profile => "profile".png;
  static get drive => "drive".png;
  static get eye => "eye".png;
  static get location => "location".png;
  static get home => "home".png;
  static get calendar => "calendar".png;
  static get chat => "chat".png;
  static get setting => "setting".png;
  static get clock => "clock".png;
  static get earning => "earning".png;
  static get notification => "notification".png;
  static get help => "help".png;
  static get start => "start".png;
  static get end => "end".png;
  static get mylocation => "mylocation".png;
  static get menuicon => "menuicon".png;
  static get notificationimg => "notificationicon".png;
  static get orderlisticon => "orderlisticon".png;
  static get cancellationimg => "cancellationimg".png;
  static get reviewimg => "reviewimg".png;
  static get satisfactionimg => "satisfactionimg".png;
  static get userimg => "userimg".png;

  static get resetImage => "reset".png;
  static get coin => "coin".png;
  static get time => "time".png;
}

extension ImagePathExtension on String {
  String get png => "asset/image/$this.png";
}
