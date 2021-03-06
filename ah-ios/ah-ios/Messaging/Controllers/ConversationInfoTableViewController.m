//
//  ConversationInfoTableViewController.m
//  Video Player
//
//  Created by Avikant Saini on 5/30/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

@import Firebase;
@import FirebaseDatabase;

#import "ConversationInfoTableViewController.h"

#import "ConversationDetailViewController.h"

#import "MessagingListTableViewCell.h"
#import "PeopleList.h"

@interface ConversationInfoTableViewController () <UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *conversationBarButton;

@property (weak, nonatomic) IBOutlet UISwitch *onSwitch
;

@property (nonatomic) UISearchController *searchController;

@property (nonatomic) NSMutableArray<PeopleList *> *conversations;

@end

@implementation ConversationInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Edit mode
	self.conversations = [NSMutableArray new];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"MessagingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"messagingListCell"];
	
	[[self.ref child:@"user"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		NSLog(@"Snapshot: %@", snapshot.value);
		self.conversations = [PeopleList getListFromSnapshot:snapshot.value];
		[self.tableView reloadData];
	}];
	
	[self onSwitchAction:self.onSwitch];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
}

- (void)viewDidAppear:(BOOL)animated {
	
}

- (void)viewDidDisappear:(BOOL)animated {
	
}

- (IBAction)onSwitchAction:(id)sender {
	BOOL isOn = [sender isOn];
	self.shared_user.online = isOn;
//	[[[self.ref child:@"user"] child:self.shared_user.uid] setValue:[NSNumber numberWithBool:isOn] forKey:@"online"];
	
}

- (IBAction)moreAction:(id)sender {
	
}



#pragma mark - Bar button actions

- (IBAction)newConversationAction:(id)sender {
//	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.contactsInfoTVC];
//	[self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return self.conversations.count;
	else
		return MAX(0, self.conversations.count - 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessagingListTableViewCell *cell = (MessagingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"messagingListCell" forIndexPath:indexPath];
	PeopleList *ppl = [self.conversations objectAtIndex:indexPath.row];
	cell.contactNameLabel.text = ppl.name;
	cell.messagePreviewLabel.text = ppl.addiction;
	if (indexPath.section == 0) {
		cell.messageTimeStampLabel.text = @"Online now";
	} else {
		cell.messageTimeStampLabel.text = @"";
		cell.contactNameLabel.text = [ppl randomName];
	}
	cell.unreadLabel.text = @"1";
//	ConversationMessage *cmessage = [self.conversationMessages objectAtIndex:indexPath.row];
//	[cell fillUsingMessage:cmessage.lastMessage andDisplayName:cmessage.displayText isGroup:cmessage.isGroupChat];
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self performSegueWithIdentifier:@"conversationDetailSegue" sender:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return @"Online now";
	return @"Past connections";
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

#pragma mark - Search controller

- (void)setupSearchController {
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = YES;
	self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	
	UISearchBar *searchBar = searchController.searchBar;
	NSString *searchText = searchBar.text;
	
	if (searchText.length == 0) {
		
	}
	else {
//		NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:<#format#>];
//		<#filteredArray#> = [NSMutableArray arrayWithArray:[<#originalArray#> filteredArrayUsingPredicate:filterPredicate]];
	}
	[self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"conversationDetailSegue"]) {
		ConversationDetailViewController *cdvc = [segue destinationViewController];
		PeopleList *ppl = [self.conversations objectAtIndex:[sender row]];
		cdvc.person = ppl;
		cdvc.hidesBottomBarWhenPushed = YES;
	}
}

@end
