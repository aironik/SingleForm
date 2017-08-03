//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFOptionsViewController.h"


@implementation ASFOptionsViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *value = self.options[indexPath.row][@"value"];
    NSString *title = self.options[indexPath.row][@"title"];
    cell.textLabel.text = title;
    if ([self.currentValue isEqualToString:value]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray<NSIndexPath *> *visibleRows = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *row in visibleRows) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:row];
        if ([row isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    NSString *value = self.options[indexPath.row][@"value"];
    self.selectAction(value);
}


@end