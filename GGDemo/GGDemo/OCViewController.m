//
//  OCViewController.m
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

#import "OCViewController.h"

@import GGNetwork;

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TokenApi *api = [[TokenApi alloc] initWithType:OAuthGrantTypeCredentials];
    api.success = ^(OAuthResult *result) {
        NSString *token = result.token;
    };
    [api start];
    
    
}



@end
