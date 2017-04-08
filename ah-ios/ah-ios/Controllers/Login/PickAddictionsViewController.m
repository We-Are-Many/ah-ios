//
//  PickAddictionsViewController.m
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "PickAddictionsViewController.h"

@interface PickAddictionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray <NSString *> *addictions;

@end

@implementation PickAddictionsViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.addictions = @[@"Alcohol"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
