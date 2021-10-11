#import "TenjinPlugin.h"
#if __has_include(<tenjin/tenjin-Swift.h>)
#import <tenjin/tenjin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tenjin-Swift.h"
#endif

@implementation TenjinPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTenjinPlugin registerWithRegistrar:registrar];
}
@end
