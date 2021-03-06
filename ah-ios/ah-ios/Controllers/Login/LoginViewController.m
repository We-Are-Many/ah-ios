//
//  LoginViewController.m
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

@import Firebase;
@import FirebaseAuth;
@import FirebaseDatabase;

#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>

#import <VLRTextField/VLRTextField.h>
#import <VLRTextField/VLRFormService.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <Google/SignIn.h>

#import "LoginViewController.h"

@interface LoginViewController () <GIDSignInUIDelegate, GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIView *tabbarView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet VLRTextField *emailField;
@property (weak, nonatomic) IBOutlet VLRTextField *passwordField;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *AllViews;


@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleButton;

@property (nonatomic) VLRFormService *registerTextFieldManager;

@property (nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@property (nonatomic) GMSPlacesClient *placesClient;
@property (nonatomic) GMSPlacePicker *placePicker;
@property (nonatomic) GMSPlace *place;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) NSString *locationx;

@end

@implementation LoginViewController {
	CLGeocoder *geocoder;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self setupViews];
	
	if ([FIRAuth auth].currentUser != nil) {
		// User is logged in, do work such as go to next view controller.
		self.transistion.style = KWTransitionStyleFall;
		self.transistion.settings = KWTransitionSettingDirectionRight;
		for (UIView *view in self.AllViews) {
			view.hidden = YES;
		}
		NSLog(@"User already logged in.");
		[self updateUserDetailsInDatabaseForUser:[FIRAuth auth].currentUser];
//		[self presentMainController];
	} else {
		self.transistion.style = KWTransitionStylePushUp;
		self.tabbarView.hidden = YES;
		self.navBarView.hidden = YES;
	}
	
	self.placesClient = [GMSPlacesClient sharedClient];
	
	self.locationManager = [[CLLocationManager alloc] init];
	
	if ([CLLocationManager authorizationStatus] < 3) {
		[self.locationManager requestAlwaysAuthorization];
	}
	
	self.locationx = @"Manipal";
	[self geocodeLocation:[self.locationManager location]];
	
	
	
	// If we want to default google sign in.
//	[[GIDSignIn sharedInstance] signIn];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGoogleSignIn:) name:kGoogleSignInNotificationName object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookSignIn:) name:FBSDKAccessTokenDidChangeNotification object:nil];
}

- (void)geocodeLocation:(CLLocation*)location {
	if (!geocoder)
		geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:location completionHandler:
	 ^(NSArray* placemarks, NSError* error){
		 if ([placemarks count] > 0) {
			 CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
			 self.locationx = aPlacemark.name;
		 }
	 }];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.handle = [[FIRAuth auth]
				   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
					   // ...
				   }];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[FIRAuth auth] removeAuthStateDidChangeListener:self.handle];
}

- (void)setupViews {
	
	for (VLRTextField *textField in @[self.emailField, self.passwordField]) {
		textField.messageRequired = @"This field is required";
		textField.placeholderColor = COLOR_GRAY_1;
		textField.floatingLabelActiveValidTextColor = COLOR_SUCCESS;
		textField.floatingLabelActiveUnvalidTextColor = COLOR_FAILURE;
		textField.floatingLabelTextColor = COLOR_GRAY_1;
		textField.floatingLabelActiveTextColor = COLOR_YELLOW;
		textField.textColor = [UIColor whiteColor];
		[self.registerTextFieldManager addTextField:textField];
	}
	
	self.facebookButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
	
	self.passwordField.secureTextEntry = YES;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgotPasswordAction:(id)sender {
}

- (void)presentMainController {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.tabbarView.hidden = YES;
		self.navBarView.hidden = YES;
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		UINavigationController *navC = [storyboard instantiateInitialViewController];
		navC.transitioningDelegate = self;
		[self presentViewController:navC animated:YES completion:^{
			self.view.window.rootViewController = navC;
		}];
	});
}

- (void)updateUserDetailsInDatabaseForUser:(FIRUser *)user {
	// Find the user in the database
	BUser *shared_user = [BUser sharedUser];
	NSString *userID = user.uid;
	shared_user.uid = user.uid;
	[[[self.ref child:@"user"] child:userID]
	 observeSingleEventOfType:FIRDataEventTypeValue
	 withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		 NSLog(@"Snapshot: %@", snapshot.value);
		 // Updating the user info
		 FIRDatabaseReference *userRef = [[self.ref child:@"user"] child:userID];
		 [[userRef child:@"full_name"] setValue:user.displayName];
		 [[userRef child:@"email"] setValue:user.email];
		 [[userRef child:@"date_modified"] setValue:[NSNumber numberWithDouble:[NSDate unixTimeStamp]]];
		 [[userRef child:@"date_created"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
			 if ([snapshot.value isKindOfClass:[NSNull class]]) {
				 [[userRef child:@"date_created"] setValue:[NSNumber numberWithDouble:[NSDate unixTimeStamp]]];
			 }
		 }];
		 [[userRef child:@"profile_pic_url"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
			 if ([snapshot.value isKindOfClass:[NSNull class]]) {
				 [[userRef child:@"profile_pic_url"] setValue:user.photoURL.absoluteString];
			 }
		 }];
		 if ([FBSDKAccessToken currentAccessToken]) {
			 [[userRef child:@"facebook_id"] setValue:[FBSDKAccessToken currentAccessToken].userID];
		 }
		 [shared_user setPropertiesFromDict:snapshot.value];
		 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
										 requestWithMethod:@"POST"
										 URLString:@"http://45.55.246.90/newuser"
										 parameters:@{@"user_name": shared_user.uid, @"name": shared_user.full_name, @"email": shared_user.email, @"location": self.locationx, @"talk_points": shared_user.help_needed, @"problem": shared_user.addiction} error:nil];
		 [[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
			 PRINT_ERROR_OR_RESPONSE;
		 }] resume];
	 }
	 withCancelBlock:^(NSError * _Nonnull error) {
		 NSLog(@"Error: %@", error.description);
	 }
	 ];
	[self presentMainController];
}

- (IBAction)loginAction:(id)sender {
	
	/*
	if (self.emailField.text.length > 0) {
		[[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
			if (user) {
				NSLog(@"Login success.")
				[self updateUserDetailsInDatabaseForUser:user];
			} else {
				SHOW_ALERT_2(@"Error", error.localizedDescription);
			}
		}];
	}
	 */
	
	
	if (self.emailField.text.length < 2) {
		SHOW_ALERT(@"Enter your email to continue.");
		return;
	}
	
	if (self.passwordField.text.length < 2) {
		SHOW_ALERT(@"Enter your password to continue.");
		return;
	}
	
//	SVHUD_SHOW;
	
	[[FIRAuth auth] signInWithEmail:self.emailField.text
						   password:self.passwordField.text
						 completion:^(FIRUser *user, NSError *error) {
							 // ...
							 if (user) {
								 NSLog(@"Login success.")
								 [self updateUserDetailsInDatabaseForUser:user];
							 } else {
								 SHOW_ALERT_2(@"Error", error.localizedDescription);
							 }
						 }];
	
}



#pragma mark - Social connect

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
	// ...
	if (error == nil) {
		NSLog(@"GIDSignIn success.");
		GIDAuthentication *authentication = user.authentication;
		FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
		NSLog(@"Signing in success for provider %@", credential.provider);
		[[FIRAuth auth] signInWithCredential:credential
								  completion:^(FIRUser *user, NSError *error) {
									  // ...
									  if (error) {
										  // ...
										  NSLog(@"Firebase auth failed with error: %@", error.localizedDescription);
										  return;
									  } else {
										  NSLog(@"Firebase auth successful for user: %@", [user.providerData.firstObject displayName]);
										  [self updateUserDetailsInDatabaseForUser:user];
									  }
								  }];

		// ...
	} else {
		// ...
		NSLog(@"Error: %@", error);
	}
}

- (void)handleGoogleSignIn:(NSNotification *)notification {
	// Insert code...
	NSLog(@"Google sign in...");
}

- (void)handleFacebookSignIn:(NSNotification *)notification {
	// Insert code...
	NSLog(@"Facebook sign in...");
	if ([FBSDKAccessToken currentAccessToken]) {
		FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
		NSLog(@"Signing in success for provider %@", credential.provider);
		[[FIRAuth auth] signInWithCredential:credential
								  completion:^(FIRUser *user, NSError *error) {
									  // ...
									  if (error) {
										  // ...
										  NSLog(@"Firebase auth failed with error: %@", error.localizedDescription);
										  SHOW_ALERT_2(@"Error", error.localizedDescription);
										  return;
									  } else {
										  NSLog(@"Firebase auth successful for user: %@", [user.providerData.firstObject displayName]);
										  [self updateUserDetailsInDatabaseForUser:user];
									  }
								  }];
	}
}

#pragma mark - Navigation

- (IBAction)registerAction:(id)sender {
	UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCNav"];
	navc.transitioningDelegate = self;
	[self presentViewController:navc animated:YES completion:nil];
}

@end
