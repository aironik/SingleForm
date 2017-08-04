//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFCell.h"

#import "ASFCellObserver.h"


@implementation ASFCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.errorView.layer.borderColor = [[UIColor redColor] CGColor];
    self.errorView.layer.borderWidth = 2.f;
    self.errorView.layer.cornerRadius = CGRectGetHeight(self.errorView.bounds) / 2.f;
}

- (void)valueDidChanged:(NSString *)value {
    [self.observer cell:self didChangeValue:value context:self.context];
}


@end
