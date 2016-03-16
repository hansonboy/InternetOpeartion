//
//  ViewController.m
//  POST_JSON
//
//  Created by wangjianwei on 15/10/22.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self postFile];
    
}
static NSString *boundray = @"thisisaboundray";
-(void)postFile{
    NSString * str = [NSString stringWithFormat:@"http://127.0.0.1/post/upload.php"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str] cachePolicy:1 timeoutInterval:10];
    
    request.HTTPMethod = @"POST";
   
    
    NSString *str1 = [NSString stringWithFormat:@"\r\n--%@\r\nContent-Disposition: form-data; name=\"userfile\"; filename=\"demo.json\"\r\nContent-Type:application/octet-stream\r\n\r\n",boundray];
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[str1 dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demo.json" ofType:nil]]];
    NSString *str2 = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundray];
    [dataM appendData:[str2 dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPBody = dataM;
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundray] forHTTPHeaderField:@"Content-Type"];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length == 0 || connectionError != nil) {
            NSLog(@"服务器暂时故障");
        }
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",obj);
    }];
}
-(void)postJSON{
    NSString * str = [NSString stringWithFormat:@"http://127.0.0.1/post/postjson.php"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str] cachePolicy:1 timeoutInterval:10];
    request.HTTPMethod = @"POST";
    NSDictionary * dic1 = @{@"name":@"zhangshan",@"age":@"11"};
    NSDictionary * dic2 = @{@"name":@"zhangshan",@"age":@"11"};
    NSArray * array = @[dic1,dic2];
    if ([NSJSONSerialization isValidJSONObject:array]) {
        NSLog(@"不能被json序列化的对象");
        return;
    }
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:array options:0 error:NULL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length == 0 || connectionError != nil) {
            NSLog(@"服务器暂时故障");
        }
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
    }];
}
-(void)getRequest{
    NSString * str = [NSString stringWithFormat:@"http://127.0.0.1/demo.json"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:str] cachePolicy:1 timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length == 0 || connectionError != nil) {
            NSLog(@"服务器暂时故障");
        }
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@",obj);
    }];
}
@end
