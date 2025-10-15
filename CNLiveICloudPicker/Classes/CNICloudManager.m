//
//  CNICloudManager.m
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/15.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import "CNICloudManager.h"
#import "CNICloudFileHelper.h"
#import "CNICloudDocumentModel.h"


/** 存放的默认路径 */
#define kICloudBoxPath [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/iCloudBox/Doc/"]

/** 存放下载路径 */
#define kICloudBoxDownLoadPath [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents/iCloudBox/Download/"]

#define code100  100  //写入文件成功
#define code101  101  //没有开启权限
#define code102  102  //文件下载失败
#define code103  103  //文件不能太大
#define code104  104  //文件夹无文件
#define code105  105  //文件写入失败
#define code106  106  //无数据
#define code107  107  //文件大小为0KB
@implementation NSString (CNICloudManager)

+ (BOOL)isEmpty:(NSString *)string
{
    return string == nil || string.length == 0;
}

@end

@implementation CNICloudManager

/**
 判断iCloud是否可用

 @return 是否可用
 */
+ (BOOL)iCloudEnable {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [fileManager URLForUbiquityContainerIdentifier:nil];
    if (url) {
        return true;
    }else {
        return false;
    }
    
}


/**
 通过CNICloudDocument 打开关闭文件

 @param url url
 @param callBack 文件数据,文件大小
 */
+ (void)downloadWithDocumentURL:(NSURL *)url callBack:(void(^)(bool success ,NSData *data, float size)) callBack{
    
    CNICloudDocument *iCloudDoc = [[CNICloudDocument alloc]initWithFileURL:url];
    [iCloudDoc openWithCompletionHandler:^(BOOL success) {
        if (success) {
            
            __block float size = [CNICloudFileHelper fileSizeAtPath:url.path];
            [iCloudDoc closeWithCompletionHandler:^(BOOL success) {
                !callBack ?: callBack( success,iCloudDoc.data,size);
            }];
            
        }else {
            !callBack ?: callBack( success,nil,0.0);
        }
        
    }];
    
}


/**
 保存文件到本地 /Documents/iCloudBox 下

 @param url 文件路径
 @param maxSize 保存的最大尺寸 为 nil 忽略
 @param path 群聊为群 ID， 单聊为好友ID （即 会话ID）路径
 ([CNTools getChatFilesPathByUserId:conversationId])
 @param callBackContent 保存h的路径 url,是否保存成功,保存失败的描述
 */

+ (void)saveWithDocumentURL:(NSURL *)url maxSize:(float)maxSize path:(NSString *)path callBackContent:(void(^)(CNICloudDocumentModel *model, BOOL success, NSString * msg, NSInteger code))callBackContent {
    
    if (![CNICloudManager iCloudEnable]) {
        callBackContent(nil, false, @"请在设置->AppleID、iCloud->iCloud中打开访问权限",code101);
        return;
    }
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    
    [CNICloudManager downloadWithDocumentURL:url callBack:^(bool success ,NSData *data, float size) {
        
        if (!success) {
            callBackContent(nil,false,[NSString stringWithFormat:@"文件下载失败"],code102);
            return;
        }
        
        if (size > maxSize) {
            callBackContent(nil,false,[NSString stringWithFormat:@"文件不能大于%f",maxSize],code103);
            return;
        }
        
        if ([NSString isEmpty:url.lastPathComponent]) {
            callBackContent(nil,false,[NSString stringWithFormat:@"文件夹无文件"],code104);
            return;
        }

        if (size == 0) {
            callBackContent(nil,false,[NSString stringWithFormat:@"文件大小为0KB"],code107);
            return;
        }
        
        if (data) {
    
            NSString *dataPath = [[NSString stringWithFormat:@"%@",path] stringByAppendingPathComponent:fileName];
            NSURL *writeUrl = [[NSURL alloc]initFileURLWithPath:dataPath];
            [CNICloudFileHelper createDirectoryAtPath:kICloudBoxPath];
            
            BOOL isWrite = [data writeToURL:writeUrl options:NSDataWritingAtomic error:nil];
            
            if (isWrite) {
                callBackContent([CNICloudDocumentModel modelWithPath:writeUrl.path],YES,@"文件写入成功",code100);
            }else {
                callBackContent(nil, false,@"文件写入失败",code105);
            }
            
        }else {
            callBackContent(nil, false, @"无数据",code106);
            return;
        }
        
    }];
}


/**
 文件是否在 iCloudBox 存在

 @param fileName 文件名(fileUrl.lastPathComponent) eg. doc.text
 @return 文件路径
 */
+ (NSURL *)documentIsExistsWithFileName:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *childFilePaths = [fileManager subpathsAtPath:kICloudBoxDownLoadPath];
    if (childFilePaths.count <= 0) {
        return nil;
    }
    
    for (NSURL *path in childFilePaths) {
        //读取文件名
        NSString *filePath = [NSString stringWithFormat:@"%@%@",kICloudBoxDownLoadPath,path];
        NSURL *fileUrl = [[NSURL alloc]initFileURLWithPath:filePath];
        if ([fileName isEqualToString:fileUrl.lastPathComponent]) {
            return fileUrl;
        }
    }
    
    return nil;
    
}


/**
 清楚本地缓存

 @param filePath filePath 为空 清除所有缓存
 @return 是否成功
 */
+ (BOOL)clearICloudBoxCacheWhithFilePath:(NSURL *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (!filePath) {
        NSURL *defultUrl = [NSURL fileURLWithPath:kICloudBoxPath];
        return [fileManager removeItemAtURL:defultUrl error:nil];
    }
    BOOL isRemove = [fileManager removeItemAtURL:filePath error:nil];
    return isRemove;
}



/**
 异步获取iCloudBox 缓存大小

 @param callBack 返回大小
 */
+ (void)asynciCloudBoxSizeCallBack:(void(^)(float size))callBack {
    
    dispatch_queue_t global =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(global, ^{
        float dataSize = [CNICloudFileHelper forderSizeAtPath:kICloudBoxPath];
        callBack(dataSize);
    });
    
    
}


@end


@implementation CNICloudDocument : UIDocument


- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    
    if ([contents isKindOfClass:[NSData class]]) {
        NSData *userContent = (NSData *)contents;
        self.data = userContent;
    }
    return YES;
    
}

@end


