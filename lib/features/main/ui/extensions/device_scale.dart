
class DeviceScale {
  static const double _referenceHeight = 812.0;
  static final DeviceScale _instance = DeviceScale._privateConstructor();

  double currentDeviceHeight = 0;

  DeviceScale._privateConstructor();

  factory DeviceScale() => _instance;

  double scaled(double referenceSize) {
    return ((currentDeviceHeight / _referenceHeight) * referenceSize)
      .ceilToDouble();
  }

}

extension DeviceScaler on num {
  double get dp => DeviceScale().scaled(toDouble());
}