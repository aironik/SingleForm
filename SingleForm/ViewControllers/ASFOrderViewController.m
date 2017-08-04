//
//  ASFOrderViewController.m
//  SingleForm
//
//  Created by aironik on 02/08/2017.
//  Copyright © 2017 aironik. All rights reserved.
//

#import "ASFOrderViewController.h"

#import "ASFCellObserver.h"
#import "ASFNetworkActivityViewController.h"
#import "ASFOptionsCell.h"
#import "ASFOptionsViewController.h"
#import "ASFOrder.h"
#import "ASFTextFieldCell.h"


static NSString *const Pos = @"pos";
static NSString *const CellClassName = @"cellClassName";
static NSString *const Title = @"title";
static NSString *const Placeholder = @"placeholder";
static NSString *const TargetKeyPath = @"targetKeyPath";
static NSString *const Options = @"Options";
static NSString *const Validator = @"Validator";
static NSString *const ErrorString = @"ErrorString";

static NSString *const ActionCell = @"ActionCell";
typedef enum {
    SectionData = 0,
    SectionAction,
    SectionsCount
} Sections;


@interface ASFOrderViewController()<ASFCellObserver>

@property (nonatomic, strong, nonnull) ASFOrder *order;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *actions;

@end


#pragma mark - Implementation

@implementation ASFOrderViewController

@synthesize actions = _actions;


- (ASFOrder *)order {
    if (_order == nil) {
        _order = [[ASFOrder alloc] init];
    }
    return _order;
}

- (NSMutableArray *)actions {
    if (_actions == nil) {
        _actions = [@[
                [@{ Pos: @1, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Имя", @""), Placeholder: NSLocalizedString(@"Евгений Лукашин", @""), TargetKeyPath: @"data.sender.name" } mutableCopy],
                [@{ Pos: @2, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Email", @""), Placeholder: NSLocalizedString(@"ivan@example.com", @""), TargetKeyPath: @"", Validator: @"validateEmail:" } mutableCopy],
                [@{ Pos: @3, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Телефон", @""), Placeholder: NSLocalizedString(@"+7(555)555-55-55", @""), TargetKeyPath: @"data.sender.phone", Validator: @"validatePhone:" } mutableCopy],
                [@{ Pos: @4, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Улица", @""), Placeholder: NSLocalizedString(@"3-я Строителей", @""), TargetKeyPath: @"data.deliveryAddress.street" } mutableCopy],
                [@{ Pos: @5, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Дом", @""), Placeholder: NSLocalizedString(@"25", @""), TargetKeyPath: @"data.deliveryAddress.house" } mutableCopy],
                [@{ Pos: @6, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Квартира", @""), Placeholder: NSLocalizedString(@"12", @""), TargetKeyPath: @"data.deliveryAddress.apartment" } mutableCopy],
                [@{ Pos: @7, CellClassName: @"ASFOptionsCell", Title: NSLocalizedString(@"Способ оплаты", @""), TargetKeyPath: @"data.paymentMethod",
                        Options: @[
                            @{ @"value": @"payment_encash", @"title": @"Наличными" },
                            @{ @"value": @"payment_card_restaurant", @"title": @"Картой курьеру" }
                        ]
                } mutableCopy],
                [@{ Pos: @8, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Комментарий", @""), Placeholder: NSLocalizedString(@"Ваша пицца самая вкусная!", @""), TargetKeyPath: @"data.comments" } mutableCopy],
                [@{ Pos: @9, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Количество персон", @""), Placeholder: NSLocalizedString(@"1", @""), TargetKeyPath: @"data.persons", Validator: @"validatePersons:" } mutableCopy],
                [@{ Pos: @10, CellClassName: @"ASFTextFieldCell", Title: NSLocalizedString(@"Количество товаров", @""), Placeholder: NSLocalizedString(@"1", @""), TargetKeyPath: @"data.orderItems[0].amount", Validator: @"validateItemsAmount:" } mutableCopy]
        ] mutableCopy];
    }
    return _actions;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionData:
            return self.actions.count;
        case SectionAction:
            return 1;
        default:
        break;
    }
    NSAssert(NO, @"Unknown section");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionData:
            return [self tableView:tableView dataCellForRowAtIndex:indexPath.row];
        case SectionAction:
            return [self tableView:tableView actionCellForRowAtIndex:indexPath.row];
        default:
            break;
    }
    NSAssert(NO, @"Unknown section");
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dataCellForRowAtIndex:(NSInteger)row {
    NSAssert(row < self.actions.count, @"Unknown row");
    NSDictionary *action = self.actions[row];

    NSString *cellClassName = action[CellClassName];
    ASFCell *result = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    result.observer = self;
    result.context = action;

    [self setupDataCell:result];

    return result;
}

- (void)setupDataCell:(ASFCell *)cell {
    NSDictionary *action = cell.context;
    NSString *cellClassName = action[CellClassName];
    
    cell.titleLabel.text = action[Title];
    cell.errorView.alpha = (action[ErrorString] != nil ? 1.f : 0.f);

    if ([@"ASFTextFieldCell" isEqualToString:cellClassName]) {
        ASFTextFieldCell *textFieldCell = (ASFTextFieldCell *)cell;
        textFieldCell.textField.text = [self.order stringForKeyPath:action[TargetKeyPath]];
        textFieldCell.textField.placeholder = action[Placeholder];
    }
    else if ([@"ASFOptionsCell" isEqualToString:cellClassName]) {
        ASFOptionsCell *optionsCell = (ASFOptionsCell *)cell;
        NSString *value = [self.order stringForKeyPath:action[TargetKeyPath]];
        NSArray<NSDictionary<NSString *, NSString *> *> *options = action[Options];
        optionsCell.valueLabel.text = nil;
        [options enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSString *> *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if ([value isEqualToString:obj[@"value"]]) {
                optionsCell.valueLabel.text = obj[@"title"];
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView actionCellForRowAtIndex:(NSInteger)row {
    NSAssert(row == 0, @"Unknown row");
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:ActionCell];
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case SectionData:
            [self tableView:tableView didSelectDataCellAtIndex:indexPath.row];
            break;
        case SectionAction:
            [self.view endEditing:YES];
            [self sendData];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectDataCellAtIndex:(NSInteger)row {
    NSAssert(row < self.actions.count, @"Unknown row");
    NSDictionary *action = self.actions[row];
    NSString *cellClassName = action[CellClassName];
    if ([@"ASFTextFieldCell" isEqualToString:cellClassName]) {
        // do nothing
    }
    else if ([@"ASFOptionsCell" isEqualToString:cellClassName]) {
        ASFOptionsViewController *childViewController = [[ASFOptionsViewController alloc] initWithNibName:nil bundle:nil];
        childViewController.options = action[Options];
        childViewController.currentValue = [self.order stringForKeyPath:action[TargetKeyPath]];
        __weak typeof(self) weakSelf = self;
        childViewController.selectAction = ^(NSString *value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.order setString:value forKeyPath:action[TargetKeyPath]];
            [strongSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:childViewController animated:YES];
    }
}

- (void)sendData {
    const BOOL dataValid = [self validateData];
    if (dataValid) {
        ASFNetworkActivityViewController *vc = [[ASFNetworkActivityViewController alloc] initWithNibName:nil bundle:nil];
        [vc sendOrder:self.order];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navCtrl animated:YES completion:^{ }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Ошибка заполнения", @"")
                                                                       message:NSLocalizedString(@"Некоторые данные формы заполнены с ошибками", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {}];

        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView reloadData];
}

- (void)cell:(ASFCell *)cell didChangeValue:(NSString *)value context:(NSDictionary *)context {
    [self.order setString:value forKeyPath:context[TargetKeyPath]];
}


#pragma mark - Validators

- (BOOL)validateData {
    BOOL result = YES;
    for (NSMutableDictionary *action in self.actions) {
        NSString *validatorString = action[Validator];
        if ([validatorString length] > 0) {
            SEL validatorSelector = NSSelectorFromString(validatorString);
            NSParameterAssert([self respondsToSelector:validatorSelector]);
            if ([self respondsToSelector:validatorSelector]) {
                NSString *value = [self.order stringForKeyPath:action[TargetKeyPath]];
                const BOOL res = [self performSelector:validatorSelector withObject:value];
                if (res) {
                    [action removeObjectForKey:ErrorString];
                }
                else {
                    action[ErrorString] = NSLocalizedString(@"Неправильный формат поля", @"");
                }
                result = result && res;
            }
        }
    }
    return result;
}

- (BOOL)validateEmail:(NSString *)value {
    return YES;
}

- (BOOL)validatePhone:(NSString *)value {
    // +7 (555) 555-55-55
    NSString *pattern = @"(^)(\\+7)(\\s*)(\\(\\d{3}\\))(\\s*)(\\d{3}\\-\\d{2}\\-\\d{2})($)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    return ([regex numberOfMatchesInString:value options:NSMatchingAnchored range:NSMakeRange(0, value.length)] > 0);
}

- (BOOL)validatePersons:(NSString *)value {
    int v = [value intValue];
    return (v > 0 && v <= 10);
}

- (BOOL)validateItemsAmount:(NSString *)value {
    int v = [value intValue];
    return (v > 0);
}


@end
