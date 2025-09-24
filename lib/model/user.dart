class User {
  String _username;
  String _password;

  User(this._username, this._password);

  String get username => _username;

  set password(String newPassword) {
    if (newPassword.length >= 6) {
      _password = newPassword;
    } else {
      throw Exception("Password minimal 6 karakter!");
    }
  }

  bool authenticate(String email, String password) {
    return _username == email && _password == password;
  }

  void login() {
    print("$username berhasil login.");
  }

  void regis() {
    print("$username berhasil registrasi");
  }
}

class Admin extends User {
  Admin(String username, String password) : super(username, password);

  @override
  void login() {
    print("Admin $username masuk dengan hak akses penuh.");
  }

  void regis() {
    print("Admin $username berhasil registrasi");
  }
}

class Kasir extends User {
  Kasir(String username, String password) : super(username, password);

  @override
  void login() {
    print("Kasir $username masuk ke sistem penjualan.");
  }

  void regis() {
    print("Kasir $username berhasil registrasi");
  }
}
