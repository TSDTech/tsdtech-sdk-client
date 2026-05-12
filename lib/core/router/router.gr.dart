// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [CheckoutScreen]
class CheckoutRoute extends PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({Key? key, List<PageRouteInfo>? children})
      : super(
          CheckoutRoute.name,
          args: CheckoutRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>(
        orElse: () => const CheckoutRouteArgs(),
      );
      return CheckoutScreen(key: args.key);
    },
  );
}

class CheckoutRouteArgs {
  const CheckoutRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key}';
  }
}

/// generated route for
/// [EmptyRouterPage]
class EmptyRouterRoute extends PageRouteInfo<void> {
  const EmptyRouterRoute({List<PageRouteInfo>? children})
      : super(EmptyRouterRoute.name, initialChildren: children);

  static const String name = 'EmptyRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EmptyRouterPage();
    },
  );
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({Key? key, String? termsToken, List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          args: LoginRouteArgs(key: key, termsToken: termsToken),
          rawQueryParams: {'termsToken': termsToken},
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () =>
            LoginRouteArgs(termsToken: queryParams.optString('termsToken')),
      );
      return LoginScreen(key: args.key, termsToken: args.termsToken);
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.termsToken});

  final Key? key;

  final String? termsToken;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, termsToken: $termsToken}';
  }
}

/// generated route for
/// [MyVouchersFormScreen]
class MyVouchersFormRoute extends PageRouteInfo<MyVouchersFormRouteArgs> {
  MyVouchersFormRoute({
    Key? key,
    required String serviceId,
    required String formId,
    required String administratorId,
    List<PageRouteInfo>? children,
  }) : super(
          MyVouchersFormRoute.name,
          args: MyVouchersFormRouteArgs(
            key: key,
            serviceId: serviceId,
            formId: formId,
            administratorId: administratorId,
          ),
          initialChildren: children,
        );

  static const String name = 'MyVouchersFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyVouchersFormRouteArgs>();
      return MyVouchersFormScreen(
        key: args.key,
        serviceId: args.serviceId,
        formId: args.formId,
        administratorId: args.administratorId,
      );
    },
  );
}

class MyVouchersFormRouteArgs {
  const MyVouchersFormRouteArgs({
    this.key,
    required this.serviceId,
    required this.formId,
    required this.administratorId,
  });

  final Key? key;

  final String serviceId;

  final String formId;

  final String administratorId;

  @override
  String toString() {
    return 'MyVouchersFormRouteArgs{key: $key, serviceId: $serviceId, formId: $formId, administratorId: $administratorId}';
  }
}

/// generated route for
/// [MyVouchersScreen]
class MyVouchersRoute extends PageRouteInfo<void> {
  const MyVouchersRoute({List<PageRouteInfo>? children})
      : super(MyVouchersRoute.name, initialChildren: children);

  static const String name = 'MyVouchersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyVouchersScreen();
    },
  );
}

/// generated route for
/// [ProfileMenuScreen]
class ProfileMenuRoute extends PageRouteInfo<void> {
  const ProfileMenuRoute({List<PageRouteInfo>? children})
      : super(ProfileMenuRoute.name, initialChildren: children);

  static const String name = 'ProfileMenuRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileMenuScreen();
    },
  );
}

/// generated route for
/// [ProviderRequestFinishedScreen]
class ProviderRequestFinishedRoute
    extends PageRouteInfo<ProviderRequestFinishedRouteArgs> {
  ProviderRequestFinishedRoute({
    Key? key,
    required String providerRequestId,
    List<PageRouteInfo>? children,
  }) : super(
          ProviderRequestFinishedRoute.name,
          args: ProviderRequestFinishedRouteArgs(
            key: key,
            providerRequestId: providerRequestId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProviderRequestFinishedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProviderRequestFinishedRouteArgs>();
      return ProviderRequestFinishedScreen(
        key: args.key,
        providerRequestId: args.providerRequestId,
      );
    },
  );
}

class ProviderRequestFinishedRouteArgs {
  const ProviderRequestFinishedRouteArgs({
    this.key,
    required this.providerRequestId,
  });

  final Key? key;

  final String providerRequestId;

  @override
  String toString() {
    return 'ProviderRequestFinishedRouteArgs{key: $key, providerRequestId: $providerRequestId}';
  }
}

/// generated route for
/// [ProviderRequestFormScreen]
class ProviderRequestFormRoute
    extends PageRouteInfo<ProviderRequestFormRouteArgs> {
  ProviderRequestFormRoute({
    Key? key,
    required String providerRequestId,
    required String serviceId,
    required String administratorId,
    List<PageRouteInfo>? children,
  }) : super(
          ProviderRequestFormRoute.name,
          args: ProviderRequestFormRouteArgs(
            key: key,
            providerRequestId: providerRequestId,
            serviceId: serviceId,
            administratorId: administratorId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProviderRequestFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProviderRequestFormRouteArgs>();
      return ProviderRequestFormScreen(
        key: args.key,
        providerRequestId: args.providerRequestId,
        serviceId: args.serviceId,
        administratorId: args.administratorId,
      );
    },
  );
}

class ProviderRequestFormRouteArgs {
  const ProviderRequestFormRouteArgs({
    this.key,
    required this.providerRequestId,
    required this.serviceId,
    required this.administratorId,
  });

  final Key? key;

  final String providerRequestId;

  final String serviceId;

  final String administratorId;

  @override
  String toString() {
    return 'ProviderRequestFormRouteArgs{key: $key, providerRequestId: $providerRequestId, serviceId: $serviceId, administratorId: $administratorId}';
  }
}

/// generated route for
/// [ProviderRequestQRCodeScreen]
class ProviderRequestQRCodeRoute
    extends PageRouteInfo<ProviderRequestQRCodeRouteArgs> {
  ProviderRequestQRCodeRoute({
    Key? key,
    required String providerRequestId,
    required String serviceId,
    required String administratorId,
    List<PageRouteInfo>? children,
  }) : super(
          ProviderRequestQRCodeRoute.name,
          args: ProviderRequestQRCodeRouteArgs(
            key: key,
            providerRequestId: providerRequestId,
            serviceId: serviceId,
            administratorId: administratorId,
          ),
          initialChildren: children,
        );

  static const String name = 'ProviderRequestQRCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProviderRequestQRCodeRouteArgs>();
      return ProviderRequestQRCodeScreen(
        key: args.key,
        providerRequestId: args.providerRequestId,
        serviceId: args.serviceId,
        administratorId: args.administratorId,
      );
    },
  );
}

class ProviderRequestQRCodeRouteArgs {
  const ProviderRequestQRCodeRouteArgs({
    this.key,
    required this.providerRequestId,
    required this.serviceId,
    required this.administratorId,
  });

  final Key? key;

  final String providerRequestId;

  final String serviceId;

  final String administratorId;

  @override
  String toString() {
    return 'ProviderRequestQRCodeRouteArgs{key: $key, providerRequestId: $providerRequestId, serviceId: $serviceId, administratorId: $administratorId}';
  }
}

/// generated route for
/// [PurchaseHistoryScreen]
class PurchaseHistoryRoute extends PageRouteInfo<void> {
  const PurchaseHistoryRoute({List<PageRouteInfo>? children})
      : super(PurchaseHistoryRoute.name, initialChildren: children);

  static const String name = 'PurchaseHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PurchaseHistoryScreen();
    },
  );
}

/// generated route for
/// [SettingsMenuScreen]
class SettingsMenuRoute extends PageRouteInfo<void> {
  const SettingsMenuRoute({List<PageRouteInfo>? children})
      : super(SettingsMenuRoute.name, initialChildren: children);

  static const String name = 'SettingsMenuRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsMenuScreen();
    },
  );
}

/// generated route for
/// [SignupPersonScreen]
class SignupPersonRoute extends PageRouteInfo<void> {
  const SignupPersonRoute({List<PageRouteInfo>? children})
      : super(SignupPersonRoute.name, initialChildren: children);

  static const String name = 'SignupPersonRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupPersonScreen();
    },
  );
}

/// generated route for
/// [VoucherQRCodeScreen]
class VoucherQRCodeRoute extends PageRouteInfo<VoucherQRCodeRouteArgs> {
  VoucherQRCodeRoute({
    Key? key,
    required String voucherId,
    required String serviceId,
    required String code,
    List<PageRouteInfo>? children,
  }) : super(
          VoucherQRCodeRoute.name,
          args: VoucherQRCodeRouteArgs(
            key: key,
            voucherId: voucherId,
            serviceId: serviceId,
            code: code,
          ),
          initialChildren: children,
        );

  static const String name = 'VoucherQRCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VoucherQRCodeRouteArgs>();
      return VoucherQRCodeScreen(
        key: args.key,
        voucherId: args.voucherId,
        serviceId: args.serviceId,
        code: args.code,
      );
    },
  );
}

class VoucherQRCodeRouteArgs {
  const VoucherQRCodeRouteArgs({
    this.key,
    required this.voucherId,
    required this.serviceId,
    required this.code,
  });

  final Key? key;

  final String voucherId;

  final String serviceId;

  final String code;

  @override
  String toString() {
    return 'VoucherQRCodeRouteArgs{key: $key, voucherId: $voucherId, serviceId: $serviceId, code: $code}';
  }
}
