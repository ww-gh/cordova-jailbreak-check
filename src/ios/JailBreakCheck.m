/********* JailBreakCheck.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface JailBreakCheck : CDVPlugin {
  // Member variables go here.
}

- (void)isJailBreak:(CDVInvokedUrlCommand*)command;
@end

@implementation JailBreakCheck

- (void)isJailBreak:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    //NSString* echo = [command.arguments objectAtIndex:0];

    if([self isJailBreakByURLScheme] ||
        [self isJailBreakByCydiaFiles] ||
        [self isJailBreakByAPPName] ||
         [self isJailBreakByEnvVar]){
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"false"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//1. 判断cydia的URL scheme
//这个方法也就是在判定是否存在cydia这个应用
- (BOOL)isJailBreakByURLScheme
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
//        NSLog(@"The device is jail broken!");
        return YES;
    }
//    NSLog(@"The device is NOT jail broken!");
    return NO;
}


//2、判定常见的越狱文件是否存在
#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
//这个表可以尽可能的列出来，然后判定是否存在，只要有存在的就可以认为机器是越狱了。
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};

- (BOOL)isJailBreakByCydiaFiles
{
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
//            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
//    NSLog(@"The device is NOT jail broken!");
    return NO;
}

//3. 读取系统所有应用的名称
//这个是利用不越狱的机器没有这个权限来判定的。
#define USER_APP_PATH       @"/User/Applications/"
- (BOOL)isJailBreakByAPPName
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
//        NSLog(@"The device is jail broken!");
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
//        NSLog(@"applist = %@", applist);
        return YES;
    }
//    NSLog(@"The device is NOT jail broken!");
    return NO;
}

//5. 读取环境变量
//这个DYLD_INSERT_LIBRARIES环境变量，在非越狱的机器上应该是空，
//越狱的机器上基本都会有Library/MobileSubstrate/MobileSubstrate.dylib
char* printEnv(void)
{
    char *env = getenv("DYLD_INSERT_LIBRARIES");
//    NSLog(@"%s", env);
    return env;
}

- (BOOL)isJailBreakByEnvVar
{
    if (printEnv()) {
//        NSLog(@"The device is jail broken!");
        return YES;
    }
//    NSLog(@"The device is NOT jail broken!");
    return NO;
}

@end
