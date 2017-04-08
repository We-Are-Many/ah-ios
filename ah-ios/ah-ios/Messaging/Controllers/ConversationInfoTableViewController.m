//
//  ConversationInfoTableViewController.m
//  Video Player
//
//  Created by Avikant Saini on 5/30/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//


#import "ConversationInfoTableViewController.h"

#import "ConversationDetailViewController.h"

#import "MessagingListTableViewCell.h"

@interface ConversationInfoTableViewController () <UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *conversationBarButton;

@property (weak, nonatomic) IBOutlet UISwitch *onSwitch
;

@property (nonatomic) UISearchController *searchController;

@property (nonatomic) NSMutableArray *conversations;

@end

@implementation ConversationInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Edit mode
	self.conversations = [NSMutableArray new];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"MessagingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"messagingListCell"];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
}

- (void)viewDidAppear:(BOOL)animated {
	
}

- (void)viewDidDisappear:(BOOL)animated {
	
}

- (IBAction)onSwitchAction:(id)sender {
	
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessagingListTableViewCell *cell = (MessagingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"messagingListCell" forIndexPath:indexPath];
	cell.contactNameLabel.text = @"John Reese";
	cell.messagePreviewLabel.text = @"Sierra Tango Oscar Papa";
	cell.messageTimeStampLabel.text = @"Yesterday";
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
		cdvc.hidesBottomBarWhenPushed = YES;
	}
}

@end
