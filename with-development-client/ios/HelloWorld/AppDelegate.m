#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTLinkingManager.h>

#import <UMCore/UMModuleRegistry.h>
#import <UMReactNativeAdapter/UMNativeModulesProxy.h>
#import <UMReactNativeAdapter/UMModuleRegistryAdapter.h>
#import <EXSplashScreen/EXSplashScreenService.h>
#import <UMCore/UMModuleRegistryProvider.h>

#if __has_include(<EXDevMenu/EXDevMenu.h>)
@import EXDevMenu;
#endif

#if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
#include <EXDevLauncher/EXDevLauncherController.h>
#endif

#ifdef FB_SONARKIT_ENABLED
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitLayoutPlugin/FlipperKitLayoutPlugin.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>
#import <FlipperKitReactPlugin/FlipperKitReactPlugin.h>

static void InitializeFlipper(UIApplication *application) {
  FlipperClient *client = [FlipperClient sharedClient];
  SKDescriptorMapper *layoutDescriptorMapper = [[SKDescriptorMapper alloc] initWithDefaults];
  [client addPlugin:[[FlipperKitLayoutPlugin alloc] initWithRootNode:application withDescriptorMapper:layoutDescriptorMapper]];
  [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];
  [client addPlugin:[FlipperKitReactPlugin new]];
  [client addPlugin:[[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
  [client start];
}
#endif

@interface AppDelegate () <RCTBridgeDelegate>

@property (nonatomic, strong) UMModuleRegistryAdapter *moduleRegistryAdapter;
@property (nonatomic, strong) NSDictionary *launchOptions;
@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef FB_SONARKIT_ENABLED
  InitializeFlipper(application);
#endif

  self.moduleRegistryAdapter = [[UMModuleRegistryAdapter alloc] initWithModuleRegistryProvider:[[UMModuleRegistryProvider alloc] init]];  
  self.launchOptions = launchOptions;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  #ifdef DEBUG
    #if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
      EXDevLauncherController *contoller = [EXDevLauncherController sharedInstance];
      [contoller startWithWindow:self.window delegate:self launchOptions:launchOptions];
    #else
      [self initializeReactNativeApp];
    #endif
  #else
    EXUpdatesAppController *controller = [EXUpdatesAppController sharedInstance];
    controller.delegate = self;
    [controller startAndShowLaunchScreen:self.window];
  #endif

  [super application:application didFinishLaunchingWithOptions:launchOptions];

  return YES;
}

- (RCTBridge *)initializeReactNativeApp
{
#if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
  NSDictionary *launchOptions = [EXDevLauncherController.sharedInstance getLaunchOptions];
#else
  NSDictionary *launchOptions = self.launchOptions;
#endif
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:@"main" initialProperties:nil];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
#if __has_include(<EXDevMenu/EXDevMenu.h>)
  [DevMenuManager configureWithBridge:bridge];
#endif
  
  self.rootViewController = [UIViewController new];
  self.rootViewController.view = rootView;
  self.window.rootViewController = self.rootViewController;
  [self.window makeKeyAndVisible];
 
  return bridge;
 }

- (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge
{
  NSArray<id<RCTBridgeModule>> *extraModules = [_moduleRegistryAdapter extraModulesForBridge:bridge];
  // If you'd like to export some custom RCTBridgeModules that are not Expo modules, add them here!
  return extraModules;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
#ifdef DEBUG
  #if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
    return [[EXDevLauncherController sharedInstance] sourceUrl];
  #else
    return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
  #endif
#else
  return [[EXUpdatesAppController sharedInstance] launchAssetUrl];
#endif
}

- (void)appController:(EXUpdatesAppController *)appController didStartWithSuccess:(BOOL)success {
  appController.bridge = [self initializeReactNativeApp];
  EXSplashScreenService *splashScreenService = (EXSplashScreenService *)[UMModuleRegistryProvider getSingletonModuleForClass:[EXSplashScreenService class]];
  [splashScreenService showSplashScreenFor:self.window.rootViewController];
}

- (BOOL)application:(UIApplication *)application
   openURL:(NSURL *)url
   options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
#if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
  if ([EXDevLauncherController.sharedInstance onDeepLink:url options:options]) {
    return true;
  }
#endif
  return [RCTLinkingManager application:application openURL:url options:options];
}

@end

#if __has_include(<EXDevLauncher/EXDevLauncherController.h>)
@implementation AppDelegate (EXDevLauncherControllerDelegate)

- (void)devLauncherController:(EXDevLauncherController *)devLauncherController
          didStartWithSuccess:(BOOL)success
{
  devLauncherController.appBridge = [self initializeReactNativeApp];
  EXSplashScreenService *splashScreenService = (EXSplashScreenService *)[UMModuleRegistryProvider getSingletonModuleForClass:[EXSplashScreenService class]];
  [splashScreenService showSplashScreenFor:self.window.rootViewController];
}

@end
#endif
