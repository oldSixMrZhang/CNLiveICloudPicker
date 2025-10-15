//
//  CNICloudManager.h
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/15.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CNICloudFileHelper.h"
#import "CNICloudDocumentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNICloudManager : NSObject

/**
 判断iCloud是否可用
 
 @return 是否可用
 */
+ (BOOL)iCloudEnable;

/**
 通过CNICloudDocument 打开关闭文件
 
 @param url url
 @param callBack 文件数据,文件大小
 */
+ (void)downloadWithDocumentURL:(NSURL *)url callBack:(void(^)(bool success ,NSData *data, float size)) callBack;

/**
 保存文件到本地 /Documents/iCloudBox 下
 
 @param url 文件路径
 @param maxSize 保存的最大尺寸 为 nil 忽略
 @param path 群聊为群 ID， 单聊为好友ID （即 会话ID）路径
 ([CNTools getChatFilesPathByUserId:conversationId])
 @param callBackContent 保存h的路径 url,是否保存成功,保存失败的描述
 */
+ (void)saveWithDocumentURL:(NSURL *)url maxSize:(float)maxSize path:(NSString *)path callBackContent:(void(^)(CNICloudDocumentModel *model, BOOL success, NSString * msg,NSInteger code))callBackContent;

/**
 文件是否在 iCloudBox 存在
 
 @param fileName 文件名(fileUrl.lastPathComponent) eg. doc.text
 @return 文件路径
 */
+ (NSURL *)documentIsExistsWithFileName:(NSString *)fileName;

/**
 清楚本地缓存
 
 @param filePath filePath 为空 清除所有缓存
 @return 是否成功
 */
+ (BOOL)clearICloudBoxCacheWhithFilePath:(NSURL *)filePath;

/**
 异步获取iCloudBox 缓存大小
 
 @param callBack 返回大小
 */
+ (void)asynciCloudBoxSizeCallBack:(void(^)(float size))callBack;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface CNICloudDocument : UIDocument

@property (nonatomic , strong) NSData *data;


@end

NS_ASSUME_NONNULL_END


