//
// Created by aironik on 02/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ASFCell.h"


@interface ASFTextFieldCell : ASFCell
    
@property (nonatomic, weak, nullable) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak, nullable) IBOutlet UITextField *textField;


@end
