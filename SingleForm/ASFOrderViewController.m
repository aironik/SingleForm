//
//  ASFOrderViewController.m
//  SingleForm
//
//  Created by aironik on 02/08/2017.
//  Copyright © 2017 aironik. All rights reserved.
//

#import "ASFOrderViewController.h"

#import "ASFTextFieldCell.h"

static NSString *const Pos = @"pos";
static NSString *const CellClassName = @"cellClassName";
static NSString *const Title = @"title";
static NSString *const Placeholder = @"placeholder";
static NSString *const TargetKeyPath = @"targetKeyPath";


@interface ASFOrderViewController ()

@property (nonatomic, strong, nonnull, readonly) NSArray *actions;

@end


#pragma mark - Implementation

@implementation ASFOrderViewController

@synthesize actions = _actions;


- (NSArray *)actions {
    if (_actions == nil) {
        _actions = @[
                @{ Pos: @1, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Имя", @""), Placeholder: NSLocalizedString(@"Евгений Лукашин", @""), TargetKeyPath: @"data.sender.name" },
                @{ Pos: @2, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Email", @""), Placeholder: NSLocalizedString(@"ivan@example.com", @""), TargetKeyPath: @"" },
                @{ Pos: @3, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Телефон", @""), Placeholder: NSLocalizedString(@"+7(555)555-55-55", @""), TargetKeyPath: @"data.sender.phone" },
                @{ Pos: @4, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Улица", @""), Placeholder: NSLocalizedString(@"3-я Строителей", @""), TargetKeyPath: @"data.deliveryAddress.street" },
                @{ Pos: @5, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Дом", @""), Placeholder: NSLocalizedString(@"25", @""), TargetKeyPath: @"data.deliveryAddress.house" },
                @{ Pos: @6, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Квартира", @""), Placeholder: NSLocalizedString(@"12", @""), TargetKeyPath: @"data.deliveryAddress.apartment" },
                // TODO: picker
                @{ Pos: @7, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Способ оплаты", @""), Placeholder: NSLocalizedString(@"Наличными", @""), TargetKeyPath: @"data.paymentMethod" },
                @{ Pos: @8, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Комментарий", @""), Placeholder: NSLocalizedString(@"Ваша пицца самая вкусная!", @""), TargetKeyPath: @"data.comments" },
                @{ Pos: @9, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Количество персон", @""), Placeholder: NSLocalizedString(@"1", @""), TargetKeyPath: @"data.persons" },
                @{ Pos: @10, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Количество товаров", @""), Placeholder: NSLocalizedString(@"1", @""), TargetKeyPath: @"data.orderItems[0].amount" },
                // TODO: action
                @{ Pos: @11, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Отправить заказ", @""), Placeholder: NSLocalizedString(@"Отправить заказ", @""), TargetKeyPath: @"send_action" }
        ];
    }
    return _actions;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section == 0 && indexPath.row < self.actions.count, @"Unknown row");
    NSDictionary *action = self.actions[indexPath.row];

    NSString *cellClassName = action[CellClassName];
//    Class cellClass = NSClassFromString(cellClassName);
    ASFTextFieldCell *result = [self.tableView dequeueReusableCellWithIdentifier:cellClassName];

    result.titleLabel.text = action[Title];
    result.textField.text = nil;
    result.textField.placeholder = action[Placeholder];

    return result;
}


@end
