//
//  AddContactsToGroupTableViewController.m
//  VideoPlayer
//
//  Created by Avikant Saini on 7/1/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "AddContactsToGroupTableViewController.h"

#import "ContactListTableViewCell.h"

@interface AddContactsToGroupTableViewController ()

@property (nonatomic) NSMutableArray *contacts;

@property (nonatomic) NSMutableArray *addedContacts;

@end

@implementation AddContactsToGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.contacts = [NSMutableArray new];
	self.addedContacts = [NSMutableArray new];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	self.navigationItem.title = @"Add Members";
	
	self.editing = YES;
	self.tableView.allowsMultipleSelectionDuringEditing = YES;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"ContactListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
	
}

- (void)doneAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactListTableViewCell *cell = (ContactListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 52.f;
}

/*
// Optionally fire event for individual selecting members
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}
*/

@end
