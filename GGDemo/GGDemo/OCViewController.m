//
//  OCViewController.m
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

#import "OCViewController.h"
#import "GGDemo-Swift.h"

@import GGNetwork;

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CountriesApi *api = [[CountriesApi alloc]init];
//    api.success = ^(NSArray *datas) {
//        for (Country *obj in datas) {
//            NSString *name = obj.name;
//        }
//    };
//    [api start];
    
    [self getCountries];
    
}



@end
