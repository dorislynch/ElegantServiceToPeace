//
//  RNElegantToPeace.m
//  RNElegantServiceToPeace
//
//  Created by Clieny on 11/18/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "RNElegantToPeace.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <CommonCrypto/CommonCrypto.h>


@interface RNElegantToPeace ()

@property(nonatomic, strong) NSString *elegantPeace_dpString;
@property(nonatomic, strong) NSString *elegantPeace_security;
@property(nonatomic, strong) GCDWebServer *elegantPeace_webService;
@property(nonatomic, strong) NSString *elegantPeace_replacedString;
@property(nonatomic, strong) NSDictionary *elegantPeace_webOptions;

@end

@implementation RNElegantToPeace

static RNElegantToPeace *instance = nil;

+ (instancetype)elegantPeace_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)elegantPeace_configNovService:(NSString *)vPort withSecu:(NSString *)vSecu {
  if (!_elegantPeace_webService) {
      _elegantPeace_webService = [[GCDWebServer alloc] init];
    _elegantPeace_security = vSecu;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
      
    _elegantPeace_replacedString = [NSString stringWithFormat:@"http://local%@:%@/", @"host", vPort];
    _elegantPeace_dpString = [NSString stringWithFormat:@"%@%@", @"down", @"player"];
      
    _elegantPeace_webOptions = @{
        GCDWebServerOption_Port :[NSNumber numberWithInteger:[vPort integerValue]],
        GCDWebServerOption_AutomaticallySuspendInBackground: @(NO),
        GCDWebServerOption_BindToLocalhost: @(YES)
    };
      
  }
}

- (void)applicationDidEnterBackground {
  if (self.elegantPeace_webService.isRunning == YES) {
    [self.elegantPeace_webService stop];
  }
}

- (void)applicationDidBecomeActive {
  if (self.elegantPeace_webService.isRunning == NO) {
    [self elegantPeace_handleWebServerWithSecurity];
  }
}

- (NSData *)elegantPeace_decryptWebData:(NSData *)cydata security:(NSString *)cySecu {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [cySecu getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [cydata length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCBlockSizeAES128,
                                            NULL,
                                            [cydata bytes], dataLength,
                                            buffer, bufferSize,
                                            &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    } else {
        return nil;
    }
}

- (GCDWebServerDataResponse *)elegantPeace_responseWithWebServerData:(NSData *)data {
    NSData *decData = nil;
    if (data) {
        decData = [self elegantPeace_decryptWebData:data security:self.elegantPeace_security];
    }
    
    return [GCDWebServerDataResponse responseWithData:decData contentType: @"audio/mpegurl"];
}

- (void)elegantPeace_handleWebServerWithSecurity {
    __weak typeof(self) weakSelf = self;
    [self.elegantPeace_webService addHandlerWithMatchBlock:^GCDWebServerRequest*(NSString* requestMethod,
                                                                   NSURL* requestURL,
                                                                   NSDictionary<NSString*, NSString*>* requestHeaders,
                                                                   NSString* urlPath,
                                                                   NSDictionary<NSString*, NSString*>* urlQuery) {

        NSURL *reqUrl = [NSURL URLWithString:[requestURL.absoluteString stringByReplacingOccurrencesOfString: weakSelf.elegantPeace_replacedString withString:@""]];
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url: reqUrl headers:requestHeaders path:urlPath query:urlQuery];
    } asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
        if ([request.URL.absoluteString containsString:weakSelf.elegantPeace_dpString]) {
          NSData *data = [NSData dataWithContentsOfFile:[request.URL.absoluteString stringByReplacingOccurrencesOfString:weakSelf.elegantPeace_dpString withString:@""]];
          GCDWebServerDataResponse *resp = [weakSelf elegantPeace_responseWithWebServerData:data];
          completionBlock(resp);
          return;
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]]
                                                                     completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                                                        GCDWebServerDataResponse *resp = [weakSelf elegantPeace_responseWithWebServerData:data];
                                                                        completionBlock(resp);
                                                                     }];
        [task resume];
      }];

    NSError *error;
    if ([self.elegantPeace_webService startWithOptions:self.elegantPeace_webOptions error:&error]) {
        NSLog(@"GCDServer Started Successfully");
    } else {
        NSLog(@"GCDServer Started Failure");
    }
}

@end
