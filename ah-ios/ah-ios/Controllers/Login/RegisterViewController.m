//
//  RegisterViewController.m
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//
@import Firebase;
@import FirebaseAuth;

#import <VLRTextField/VLRTextField.h>
#import <VLRTextField/VLRFormService.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <IQDropDownTextField/IQDropDownTextField.h>

#import <Google/SignIn.h>

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet VLRTextField *fullNameField;
@property (weak, nonatomic) IBOutlet VLRTextField *emailIDField;
@property (weak, nonatomic) IBOutlet VLRTextField *talkAboutField;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *problemsField;
@property (weak, nonatomic) IBOutlet VLRTextField *passwordField;
@property (weak, nonatomic) IBOutlet VLRTextField *passwordField2;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleButton;

@property (nonatomic) VLRFormService *registerTextFieldManager;

@property (nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookSignIn:) name:FBSDKAccessTokenDidChangeNotification object:nil];
	
	[self setupViews];
}

- (void)setupViews {
//	self.firstNameField.placeholder = @"First name";
//	self.lastNameField.placeholder = @"Last name";
	
	self.fullNameField.formKeyPath	= @"full_name";
	self.emailIDField.formKeyPath	= @"emailid";
	self.talkAboutField.formKeyPath	= @"talk_about";
	self.passwordField.formKeyPath	= @"password";
	self.passwordField2.formKeyPath	= @"reenterpass";
	
	self.problemsField.itemList = @[@"Alcohol", @"Depression", @"Anxiety", @"Relationship", @"Loneliness", @"Stress", @"Divorce"];
	self.problemsField.textColor = [UIColor whiteColor];
	
	self.registerTextFieldManager = [VLRFormService new];
	
	for (VLRTextField *textField in @[self.fullNameField, self.emailIDField, self.talkAboutField, self.passwordField, self.passwordField2]) {
		textField.messageRequired = @"This field is required";
		textField.placeholderColor = COLOR_GRAY_1;
		textField.floatingLabelActiveValidTextColor = COLOR_SUCCESS;
		textField.floatingLabelActiveUnvalidTextColor = COLOR_FAILURE;
		textField.floatingLabelTextColor = COLOR_GRAY_1;
		textField.floatingLabelActiveTextColor = COLOR_YELLOW;
		textField.textColor = [UIColor whiteColor];
		textField.validateBlock = ^BOOL(VLRTextField *textField) {
			return (textField.text.length > 0);
		};
		[self.registerTextFieldManager addTextField:textField];
	}
	
	self.passwordField.secureTextEntry = YES;
	self.passwordField2.secureTextEntry = YES;

	self.passwordField.messageRequired = @"The password should atleast be 8 characters long.";
	self.passwordField.minimumNumberOfCharacters = 8;
	
	self.passwordField2.messageInvalid = @"The two passwords should match";
	self.passwordField2.messageRequired = @"Please enter a password";
	self.passwordField2.validateBlock = ^BOOL(VLRTextField *textField) {
		return [self.passwordField.text isEqualToString:self.passwordField2.text];
	};
	
	self.facebookButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
	
}

- (void)presentMainController {
	dispatch_async(dispatch_get_main_queue(), ^{
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		UITabBarController *tabBarVC = [storyboard instantiateInitialViewController];
		tabBarVC.transitioningDelegate = self;
		self.transistion.style = KWTransitionStylePushUp;
		[self presentViewController:tabBarVC animated:YES completion:^{
			self.view.window.rootViewController = tabBarVC;
		}];
	});
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
	
	BOOL formValid = [self.registerTextFieldManager checkForm];
	[self.registerTextFieldManager.activeField resignFirstResponder];
	if (!formValid) {
		SHOW_ALERT(@"Fill in all the details to continue.");
		return;
	}
	
	SVHUD_SHOW;
	
	// Registration code here

	[[FIRAuth auth] createUserWithEmail:self.emailIDField.text
							   password:self.passwordField.text
							 completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
								 if (error == nil) {
									 NSLog(@"Registration success.");
									 if ([FIRAuth auth].currentUser) {
										 FIRUserProfileChangeRequest *changeRequest =
										 [[FIRAuth auth].currentUser profileChangeRequest];
										 changeRequest.displayName = [NSString stringWithFormat:@"%@", self.fullNameField.text];
										 [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
											 // ...
											 if (error == nil) {
												 NSLog(@"Name updated successfully.");
											 } else {
												 NSLog(@"Error: %@", error.localizedDescription);
											 }
										 }];
									 }
									 [[FIRAuth auth] .currentUser sendEmailVerificationWithCompletion:^(NSError *_Nullable error) {
										  // ...
										 NSString *message = [NSString stringWithFormat:@"An email is sent to your email address \'%@\'. Click the link to verify your email address.", self.emailIDField.text];
										 SHOW_ALERT_2(@"Confirm Email", message);
										 [self loginToAccountAction:nil];
									  }];
								 } else {
									 SHOW_ALERT_2(@"Error", error.localizedDescription);
								 }
							 }];
	
}

- (IBAction)pickAddictionsAction:(id)sender {
	
}


#pragma mark - Social connect

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
										  [self presentMainController];
									  }
								  }];
	}
}


#pragma mark - Navigation

- (IBAction)loginToAccountAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
