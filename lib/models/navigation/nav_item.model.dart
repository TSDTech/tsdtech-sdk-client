/// Navigation items enum with integer values.
enum NavItem {
  home(0),
  myVouchers(1),
  payments(2),
  profile(3),
  settings(4),
  logout(5),
  cart(6),
  login(7);

  final int value;
  const NavItem(this.value);
}

extension NavItemExt on NavItem {
  /// Optional: return a debug-friendly name
  String get key => toString().split('.').last;
}
