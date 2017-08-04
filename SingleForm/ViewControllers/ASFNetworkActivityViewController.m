//
// Created by aironik on 03/08/2017.
// Copyright (c) 2017 aironik. All rights reserved.
//

#import "ASFNetworkActivityViewController.h"

#import "ASFOrder.h"


@interface ASFNetworkActivityViewController()

@property (nonatomic, strong, readwrite, nullable) ASFOrder *order;
@property (nonatomic, strong, nullable) NSURLSessionDataTask *task;

@end


#pragma mark - Implementation

@implementation ASFNetworkActivityViewController


- (void)sendOrder:(ASFOrder *)order {
    self.order = order;
    if ([self isViewLoaded]) {
        [self startSendOrder];
    }
}
- (void)viewDidLoad {
    [self startSendOrder];
}

- (void)startSendOrder {
    [self.activityIndicator startAnimating];
    self.statusLabel.text = NSLocalizedString(@"Отправка запроса", @"");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancel)];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self.order dictionaryValue] options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *bodyString = [NSString stringWithFormat:@"jsonData=%@", jsonString];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"PREPARING REQUEST: Body data:\n%@", bodyString);
    
    NSDictionary *headers = @{
            @"Content-Type": @"application/x-www-form-urlencoded",
            @"User-Agent": @"Tanuki/Test_app"
    };
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://dev.tanuki.ru/iphone/services/json/"]];
    request.HTTPMethod = @"POST";
    request.allHTTPHeaderFields = headers;
    request.HTTPBody = bodyData;

    __weak typeof(self) weakSelf = self;
    NSAssert(self.task == nil, @"start send data twice");
    self.task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        __strong typeof(weakSelf) stringSelf = weakSelf;
        [stringSelf handleResultData:data response:response error:error];
    }];
    NSLog(@"PREPARING REQUEST: request:\n%@", self.task);
    
    [self.task resume];
}

- (void)handleResultData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    NSLog(@"Handling result %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

    BOOL success = NO;
    NSString *message = nil;
    NSString *orderId = nil;
    if ([responseDictionary isKindOfClass:[NSDictionary class]]) {
        orderId = [responseDictionary valueForKeyPath:@"ResponseBody.orderNumber"];
        success = ([orderId isKindOfClass:[NSString class]] || [orderId isKindOfClass:[NSNumber class]]);
    }
    if (success) {
        message = [NSString stringWithFormat:NSLocalizedString(@"Номер заказа %@", @""), orderId];
    }
    else {
        NSString *errorMessage = NSLocalizedString(@"Неизвестная ошибка", @"");
        NSArray *errorsArray = [responseDictionary valueForKeyPath:@"ResponseBody.ValidationResults.Errors"];
        if ([errorsArray isKindOfClass:[NSArray class]] && errorsArray.count > 0) {
            NSDictionary *errorObj = errorsArray[0];
            NSString *errorMsg = errorObj[@"Message"];
            if ([errorMsg isKindOfClass:[NSString class]]) {
                errorMessage = errorMsg;
            }
        }
        message = errorMessage;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отправть другой заказ", @"")
                                                                                       style:UIBarButtonItemStyleDone
                                                                                      target:strongSelf
                                                                                      action:@selector(cancel)];
        [strongSelf.activityIndicator stopAnimating];
        strongSelf.statusLabel.text = message;
    });
}

- (void)cancelSendOrder {
    [self.task cancel];
    self.task = nil;
}

- (IBAction)cancel {
    [self cancelSendOrder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{ }];
}


@end
