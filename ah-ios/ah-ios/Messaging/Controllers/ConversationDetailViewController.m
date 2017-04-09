//
//  ConversationDetailViewController.m
//  Video Player
//
//  Created by Avikant Saini on 5/31/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

@import Firebase;
@import FirebaseDatabase;

#import "Message.h"

#import "ConversationDetailViewController.h"

#import "ConversationBaseTableViewCell.h"
#import "ConversationVideoTableViewCell.h"
#import "TimeReusableHeaderFooterView.h"

@interface ConversationDetailViewController ()

@property (strong, nonatomic) NSMutableArray <Message *> *messages;

@property (nonatomic) BUser *user;
@property (nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) AFURLSessionManager *manager;

@property (nonatomic) NSArray <NSString *> *negative_intents;
@property (nonatomic) NSArray <NSString *> *negative_words;

@property (nonatomic) NSTimeInterval loginTimeStamp;

@end

@implementation ConversationDetailViewController

- (instancetype)init {
	// Protocols like UITableViewDelegate and UITableViewDataSource are already setup for you. You will be able to call whatever delegate and data source methods you need for customising your control.
	// Calling [super init] will call [super initWithTableViewStyle:UITableViewStylePlain] by default.
	self = [super initWithTableViewStyle:UITableViewStylePlain];
	if (self) {
//		self.inverted = NO; // If inversion is not needed
		self.shakeToClearEnabled = YES;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self.leftButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
	[self.leftButton setTintColor:[UIColor grayColor]];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ConversationBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellOutgoing"];
	[self.tableView registerNib:[UINib nibWithNibName:@"ConversationBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIncoming"];
	[self.tableView registerNib:[UINib nibWithNibName:@"ConversationBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellStatus"];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ConversationVideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoOutgoing"];
	[self.tableView registerNib:[UINib nibWithNibName:@"ConversationVideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"videoIncoming"];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"TimeReusableHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"dateFooter"];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.user = [BUser sharedUser];
	self.ref = [[FIRDatabase database] referenceWithPath:@"message"];
	
	self.messages = [NSMutableArray new];
	[self observeMessages];
	
	self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	
	self.negative_intents = @[@"kill yourself", @"commit suicide", @"fuck you", @"want to die", @"jump off a bridge", @"kill myself"];
	self.negative_words = @[@"do not", @"never", @"noooooo", @"stop"];
	
	self.loginTimeStamp = [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
	
	self.navigationItem.title = self.person.name;

	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"More"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
	self.navigationItem.rightBarButtonItem = moreButton;
	
	UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleDone target:self action:@selector(exitAction:)];
	self.navigationItem.leftBarButtonItem = exitButton;
}

- (void)moreAction:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	UIAlertAction *rateAction = [UIAlertAction actionWithTitle:@"Rate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		// Rating something
		[self rateAction:sender];
	}];
	[alertController addAction:rateAction];
	UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Report Person" message:@"If you feel the conversation is going in a negative way, you can report the person." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:cancelAction];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
		[alertController addAction:okAction];
		[self presentViewController:alertController animated:YES completion:nil];
	}];
	[alertController addAction:reportAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)rateAction:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Rate your chat" message:nil preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"Very Satisfying" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self setRating:5];
	}];
	[alertController addAction:okAction1];
	UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"Satisfying" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self setRating:4];
	}];
	[alertController addAction:okAction2];
	UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:@"Okay-ish" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self setRating:3];
	}];
	[alertController addAction:okAction3];
	UIAlertAction *okAction4 = [UIAlertAction actionWithTitle:@"Not Satisfying" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self setRating:2];
	}];
	[alertController addAction:okAction4];
	UIAlertAction *okAction5 = [UIAlertAction actionWithTitle:@"I am more depressed now." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self setRating:1];
	}];
	[alertController addAction:okAction5];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)setRating:(NSInteger)rating {
	// Call to set the rating
	NSLog(@"Rating: %li", rating);
	NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://45.55.246.90/saveuserrating" parameters:@{@"user_name": self.user.uid, @"rate": [NSNumber numberWithInteger:rating]} error:nil];
	[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		PRINT_ERROR_OR_RESPONSE;
	}];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)exitAction:(id)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Exit chat" message:@"This will terminate your current session. Are you sure you want to exit." preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[self.navigationController popViewControllerAnimated:YES];
	}];
	[alertController addAction:okAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)observeMessages {
	FIRDatabaseQuery *query = [self.ref queryLimitedToLast:100];
	[query observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSDictionary *dict = snapshot.value;
		NSString *to = self.user.uid;
		NSString *from = self.person.uid;
		Message *m = [[Message alloc] initWithTo:[dict objectForKey:@"to"] from:[dict objectForKey:@"from"] text:[dict objectForKey:@"text"]];
		m.time_stamp = [NSString stringWithFormat:@"%@", [dict objectForKey:@"time_stamp"]];
		NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://45.55.246.90/postmessage" parameters:@{@"from_user": m.from, @"to_user": m.to, @"message": m.text} error:nil];
		[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
			PRINT_ERROR_OR_RESPONSE;
		}];
		if (([m.to isEqualToString:to] && [m.from isEqualToString:from]) || ([m.to isEqualToString:from] && [m.from isEqualToString:to])) {
			NSLog(@"Message = %@", dict);
			[self.messages addObject:m];
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.messages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time_stamp" ascending:NO]]];
				[self.tableView reloadData];
				[self checkForNegativeIntents];
			});
		}
	}];
}

- (void)checkForNegativeIntents {
	NSInteger len = self.messages.count;
	NSInteger max = MIN(len/2, 6);
	CGFloat score = 0;
	for (NSInteger i = 0; i < max; ++i) {
		Message *m = [self.messages objectAtIndex:i];
		if (m.time_stamp.doubleValue > self.loginTimeStamp) {
			for (NSString *neg in self.negative_intents) {
				if ([m.text containsString:neg])
					score++;
			}
			for (NSString *neg in self.negative_words) {
				if ([m.text containsString:neg])
					score--;
			}
		}
	}
	score /= max;
	if (score >= 0.8) {
		// Trigger warning
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"This conversation does not appear to be going too well. Would you like to continue or exit and report person?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleCancel handler:nil];
		[alertController addAction:cancelAction];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Exit and Report" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Information" message:@"The person has been reported." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[self.navigationController popViewControllerAnimated:YES];
			}];
			[alertController addAction:okAction];
			[self presentViewController:alertController animated:YES completion:nil];
		}];
		[alertController addAction:okAction];
		[self presentViewController:alertController animated:YES completion:nil];
	}
}

- (void)messageReceived:(NSNotification *)notification {
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)textInputBarLeftButtonPressed:(id)sender {
	
}

#pragma mark - Send message

- (void)didPressRightButton:(id)sender {
	
	NSLog(@"");
	
	NSString *text = [[self.textInputbar.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if (text.length > 0) {
		
		// Append the text or something
		
		Message *message = [[Message alloc] initWithTo:self.person.uid from:self.user.uid text:text];
		message.time_stamp = [NSString stringWithFormat:@"%lf", [NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970];
		
		FIRDatabaseReference *newRef = [self.ref childByAutoId];
		[newRef setValue:@{
						   @"to": message.to,
						   @"from": message.from,
						   @"text": message.text,
						   @"time_stamp": message.time_stamp
						   }];
		
		NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://45.55.246.90/postmessage" parameters:@{@"from": message.from, @"to": message.to, @"text": message.text} error:nil];
		[self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
			PRINT_ERROR_OR_RESPONSE;
		}];
	
	}
	
	[super didPressRightButton:sender];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Customize the cell for types!
	
	ConversationBaseTableViewCell *cell = nil;

	Message *message = [self.messages objectAtIndex:indexPath.row];
	
	if ([message.to isEqualToString:self.user.uid]) {
		cell = (ConversationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellOutgoing" forIndexPath:indexPath];
		cell.messageDirection = INCOMING;
	} else  {
		cell = (ConversationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIncoming" forIndexPath:indexPath];
		cell.messageDirection = OUTGOING;
	}
	
	NSTimeInterval times = message.time_stamp.doubleValue;
	[cell setDate:[NSDate dateWithTimeIntervalSince1970:times]];
	
	cell.senderDisplayText = @"";
	cell.isMediaItem = NO;
	
	[cell setMessageText:message.text];
	
	cell.transform = self.tableView.transform; // IMPORTANT: Set cell's transform to the table view's transform
	
	return cell;
}

#pragma mark - Table view delelgate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	Message *message = [self.omessages[self.omkeys[indexPath.section]] objectAtIndex:indexPath.row];
//	// TODO: Modify height for various message kinds?
//	return [ConversationBaseTableViewCell getEstimatedHeightForText:message.text] + (message.messageDirection == INCOMING) * isGroupChat * 18;
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return (tableView == self.autoCompletionView);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	TimeReusableHeaderFooterView *timeView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"dateFooter"];
	timeView.transform = self.tableView.transform;
	return timeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	 return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

#pragma mark - Navigation

- (void)groupInfoAction:(id)sender {
}

@end
