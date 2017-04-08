//
//  AppDelegate.m
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

@import Firebase;
@import GoogleSignIn;
#import "AppDelegate.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>

#import <Google/SignIn.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	UIStoryboard *storyboard;
	// If no user
	storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
	// else
//	storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UINavigationController *navc = [storyboard instantiateInitialViewController];
	self.window.rootViewController = navc;
	
	[FIRApp configure];
	
	[GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
	[GIDSignIn sharedInstance].delegate = self;
	
	[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
	
	[[IQKeyboardManager sharedManager] setEnable:YES];
	
	[self customizeColors];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	BOOL fb_handle = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
	BOOL gg_handle = [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
	return fb_handle || gg_handle;
}

#pragma mark - GIDSignIn delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	// ...
	if (error == nil) {
		GIDAuthentication *authentication = user.authentication;
		FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
		NSLog(@"Login success for provider %@", credential.provider);
		// Do something with credential
	} else {
		// ...
	}
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
	 withError:(NSError *)error {
	// Perform any operations when the user disconnects from app here.
	// ...
}

- (void)customizeColors {
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
	[SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
	[SVProgressHUD setForegroundColor:COLOR_DARK_RED];
	
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]} forState:UIControlStateNormal];
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]} forState:UIControlStateHighlighted];
	[[UISegmentedControl appearance] setTintColor:COLOR_PRIMARY_RED];
	
	[[UITextField appearance] setTextColor:COLOR_PRIMARY_RED];
	[[UITextField appearance] setTintColor:COLOR_PRIMARY_RED];
	
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setBarTintColor:COLOR_PRIMARY_RED];
	
	[[UITabBar appearance] setTintColor:[UIColor whiteColor]];
	[[UITabBar appearance] setBarTintColor:COLOR_PRIMARY_RED];
	
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_LIGHT_RED } forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
	
	[[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:COLOR_LIGHT_RED];
	
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ah_ios"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
