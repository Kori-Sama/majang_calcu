import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_cv_method_channel.dart';

abstract class NativeCvPlatform extends PlatformInterface {
  /// Constructs a NativeCvPlatform.
  NativeCvPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeCvPlatform _instance = MethodChannelNativeCv();

  /// The default instance of [NativeCvPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeCv].
  static NativeCvPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeCvPlatform] when
  /// they register themselves.
  static set instance(NativeCvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
