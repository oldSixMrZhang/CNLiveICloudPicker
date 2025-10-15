//
//  CNICloudFileHelper.h
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/12.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNICloudFileHelper : NSObject

/**
 创建文件目录,如果不存在目录会创建目录
 
 @param path 文件目录
 @return 是否创建成功
 */
+ (Boolean)createDirectoryAtPath:(NSString *)path;

/**
 获取单个文件大小
 
 @param path 文件路径
 @return 文件大小
 */
+ (float)fileSizeAtPath:(NSString *)path;

/**
 获取文件属性
 
 @param path 文件路径
 @return 文件属性
 */
+ (NSDictionary *)fileAttrAtPath:(NSString *)path;


/**
 获取子文件夹的总大小
 
 @param path 文件夹路径
 @return 文件夹大小
 */
+ (float)forderSizeAtPath:(NSString *)path;

/**
 是否是文件夹
 
 @param path 目录路径
 @return 是否
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path;



@end

NS_ASSUME_NONNULL_END
