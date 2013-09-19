//
//  DataBaseAccess.m
//  BTO
//
//  Created by ami on 2013/09/18.
//  Copyright (c) 2013年 AMI. All rights reserved.
//

#import "DataBaseAccess.h"

@implementation DataBaseAccess
@synthesize array;

-(NSMutableArray *) PicLocation{
    
    NSURL *URL = [NSURL URLWithString:@"http://49.212.200.39/techcamp/hello.php"];
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request addBody:@"test" forKey:@"TestKey"];
    [request setCompletionHandler:^(
                                    NSHTTPURLResponse *responseHeader, NSString *responseString){
        //NSLog(@"%@", responseString);
        // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
        NSData *jsonData = [responseString dataUsingEncoding:NSUnicodeStringEncoding];
        
        // JSON を NSArray に変換する
        NSError *error;
        array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
    }];
    [request startRequest];
//    // JSON 文字列
//    NSString *jsonString = @"[{\"title\":\"タイトル１\", \"content\":\"RDocを記述する\"}, {\"title\":\"タイトル２\", \"content\":\"組み込んで使えるようにする\"}]";
//    
//    // JSON 文字列をそのまま NSJSONSerialization に渡せないので、NSData に変換する
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
//    
//    // JSON を NSArray に変換する
//    NSError *error;
//    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:&error];
    
    // JSON のオブジェクトは NSDictionary に変換されている
//    NSMutableArray *results = [[NSMutableArray alloc] init];
//    for (NSDictionary *obj in array)
//    {
//        NSLog(@"%@",[obj objectForKey:@"title"]);
//        Entry *entry = [[Entry alloc] init];
//        entry.title = [obj objectForKey:@"title"];
//        entry.content = [obj objectForKey:@"content"];
//        [results addObject:issue];
//    }
    return array;
}

@end
