//
//  TableViewController.m
//  BaseCell
//
//  Created by Mariusz Spiewak on 24/10/2017.
//  Copyright © 2017 MS. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[GenericBaseCell class] forCellReuseIdentifier:@"baseCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell" forIndexPath:indexPath];
 
    GenericBaseCell *baseCell = (GenericBaseCell *)cell;
    [baseCell populateWithOriginalCell:[GenericBaseCell doubleLineBaseCellWithReuseIdentifier:@"baseCell"]];
    [baseCell setLayoutDefinition:[[BaseCellTwoLineLayout alloc] init] error:nil];
    BaseCellTwoLineModel *model = (BaseCellTwoLineModel *)baseCell.cellModel;
 
    model.leftIcon.image = [UIImage imageNamed:@"test.png"];
    model.primaryLabel.text = @"trolololo";
    model.bottomLabel.text = @"gjirah lijghriuagir ea";
    model.valueLabel.text = @"--YEEY";
    model.rightIcon.image = [UIImage imageNamed:@"test.png"];
    
    return cell;
}

@end
