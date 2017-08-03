//
// Created by aironik on 02/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFTextFieldCell.h"


@interface ASFTextFieldCell()<UITextFieldDelegate>
@end


#pragma mark - Implementation

@implementation ASFTextFieldCell


- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSParameterAssert(self.textField == textField);
    [self valueDidChanged:textField.text];
}


@end
