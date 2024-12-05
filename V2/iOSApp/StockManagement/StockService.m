//
//  StockService.m
//  StockManagement
//
//  Created by Guillaume Rager on 07/11/2017.
//  Copyright © 2017 CAST. All rights reserved.
//

#import "StockService.h"
#import "StockModel.h"

@implementation StockService

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (void) getAllStocks
{
    NSString *baseURL = @"http://mystockmanagement.com/";
    NSURL *suppliersURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,@"rest/commarea/getPart"]];
    
    //Structuring the URL request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:suppliersURL];
    [urlRequest setHTTPMethod:@"GET"];
    
    // Start NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                      completionHandler:^(NSData *data,
                                                                          NSURLResponse *response,
                                                                          NSError *error){
                                                          
          // Handle response
          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
          NSInteger statusCode = [httpResponse statusCode];
          if(error == nil)
          {
              if (statusCode == 200)
              {
                  NSLog (@"statuscode 200");
                  
                  @try
                  {
                      NSError *jsonParsingError;
                      NSDictionary *stockAsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];

                      [[StockModel sharedInstance] createStocksFromDictionary:stockAsDictionary];
                  }
                  @catch(NSException *exception)
                  {
                      // we might do something...
                  }
              }
          }
                                                  
  }];
    
    [dataTask resume];
}

@end
