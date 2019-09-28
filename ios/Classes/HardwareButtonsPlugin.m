#import "HardwareButtonsPlugin.h"
#import <hardware_buttons/hardware_buttons-Swift.h>

@implementation HardwareButtonsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHardwareButtonsPlugin registerWithRegistrar:registrar];
}
@end
