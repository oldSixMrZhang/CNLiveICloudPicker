//
//  CNICloudFileHelper.m
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/12.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import "CNICloudFileHelper.h"

@implementation CNICloudFileHelper



/**
 创建文件目录,如果不存在目录会创建目录
 
 @param path 文件目录
 @return 是否创建成功
 */
+ (Boolean)createDirectoryAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Boolean result = [fileManager fileExistsAtPath:path];
    if (result == NO) {
        BOOL isCreate = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return isCreate;
        
    }else {
        return YES;
    }
    
}

/**
 获取单个文件大小
 
 @param path 文件路径
 @return 文件大小
 */
+ (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        return  0.0;
    }
    
    NSDictionary *attributesDic = [fileManager attributesOfItemAtPath:path error:nil];
    if (attributesDic) {
        return [attributesDic[NSFileSize] floatValue];
    }else {
        return 0.0;
    }
    
}

/**
 获取文件属性

 @param path 文件路径
 @return 文件属性
 */
+ (NSDictionary *)fileAttrAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        return nil;
    }
    
    NSDictionary *attributesDic = [fileManager attributesOfItemAtPath:path error:nil];
    if (attributesDic > 0) {
        return attributesDic;
    }else {
        return nil;
    }
    
}


/**
 获取子文件夹的总大小
 
 @param path 文件夹路径
 @return 文件夹大小
 */
+ (float)forderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        return 0.0;
    }
    
    NSArray *subpaths = [fileManager subpathsAtPath:path];
    if (subpaths.count <= 0) {
        return 0.0;
    }else {
        float fileSize  = 0;
        
        for (NSString *subPath in subpaths) {
            NSString *fileAbsoluePath = [NSString stringWithFormat:@"%@/%@",path,subPath];
            if ([CNICloudFileHelper isDirectoryAtPath:fileAbsoluePath]) {
                 fileSize += 0.0;
            } else {
                fileSize += [self fileSizeAtPath:fileAbsoluePath];
                
            }
        }
        return fileSize;
    }
}


/**
 是否是文件夹

 @param path 目录路径
 @return 是否
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    return isExists && isDirectory;
}



@end
