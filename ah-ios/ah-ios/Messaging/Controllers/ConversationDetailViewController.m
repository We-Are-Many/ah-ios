//
//  ConversationDetailViewController.m
//  Video Player
//
//  Created by Avikant Saini on 5/31/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "ConversationDetailViewController.h"

#import "ConversationBaseTableViewCell.h"
#import "ConversationVideoTableViewCell.h"
#import "TimeReusableHeaderFooterView.h"

@interface ConversationDetailViewController ()

@property (strong, nonatomic) NSMutableArray *messages;

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
	
	self.navigationItem.title = @"LOL";

	self.tableView.rowHeight = UITableViewAutomaticDimension;
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
	
	}
	
	[super didPressRightButton:sender];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Customize the cell for types!
	
	ConversationBaseTableViewCell *cell = nil;
	
	if (indexPath.row % 2 == 0) {
		cell = (ConversationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellOutgoing" forIndexPath:indexPath];
		cell.messageDirection = INCOMING;
	} else if (indexPath.row % 2 != 0) {
		cell = (ConversationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellIncoming" forIndexPath:indexPath];
		cell.messageDirection = OUTGOING;
	} else {
		cell = [[ConversationBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellStatus"];
		cell.messageDirection = STATUS;
	}
	
	cell.senderDisplayText = @"";
	cell.isMediaItem = NO;
	
	[cell setMessageText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor labore et dolore magna aliqua."];
	
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
