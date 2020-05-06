
class User {

  String _uid;
  bool _isEmailVerified;
  String _displayName;
  String _profilePictureURL;

  User(this._uid, this._isEmailVerified, this._displayName,
      this._profilePictureURL);

  String get profilePictureURL => _profilePictureURL;

  set profilePictureURL(String value) {
    _profilePictureURL = value;
  }

  String get displayName => _displayName;

  set displayName(String value) {
    _displayName = value;
  }

  bool get isEmailVerified => _isEmailVerified;

  set isEmailVerified(bool value) {
    _isEmailVerified = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }


}