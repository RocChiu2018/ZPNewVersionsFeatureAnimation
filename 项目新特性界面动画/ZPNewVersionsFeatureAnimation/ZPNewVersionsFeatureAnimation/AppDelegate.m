//
//  AppDelegate.m
//  ZPNewVersionsFeatureAnimation
//
//  Created by 赵鹏 on 2019/1/22.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 这个Demo有storyboard文件，但是在项目的TARGETS中的General中的Deployment Info中的Main Interface后面填空，代表不用项目提供的storyboard文件。自己在AppDelegate.m文件中恰当的地方用代码写出系统是如何调用storyboard文件里面的视图控制器的。
 */
#import "AppDelegate.h"
#import "ZPNewVersionsFeatureCollectionViewController.h"

#define kAPPVersions @"Versions"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     1、创建程序的窗口（UIWindow的实例化对象）：
     */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /**
     2、每次程序开启的时候都要先判断当前开启的版本是不是新版本：
     */
    
    //（1）从"Info.plist"文件中获取当前开启的程序的版本号：
    NSString *currentVersions = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //（2）从沙盒中获取之前的版本号：
    NSString *oldVersions = [[NSUserDefaults standardUserDefaults] objectForKey:kAPPVersions];
    
    //（3）把两个版本进行比较：
    UIViewController *rootVC = nil;
    if ([currentVersions isEqualToString:oldVersions])  //如果两个版本号相同，则说明当前开启的版本不是新版本，程序直接进入核心界面。
    {
        /**
         3、加载storyboard文件：
         */
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        /**
         4、创建storyboard文件中箭头所指向的视图控制器：
         */
        rootVC = [storyBoard instantiateInitialViewController];
    }else  //如果两个版本号不同，则说明当前开启的版本是新版本，需要先把新的版本号存储到沙盒中然后再进入到新版本特性界面。
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersions forKey:kAPPVersions];
        
        rootVC = [[ZPNewVersionsFeatureCollectionViewController alloc] init];
    }
    
    /**
     5、设置窗口的根视图控制器：
     */
    self.window.rootViewController = rootVC;
    
    /**
     6、使window成为主窗口并显示出来：
     */
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
