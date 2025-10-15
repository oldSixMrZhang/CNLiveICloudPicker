//
//  ICloudDocumentModel.m
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/12.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import "CNICloudDocumentModel.h"
#import "CNICloudFileHelper.h"

@implementation NSString (iCloud)

+ (BOOL)isEmpty:(NSString *)string
{
    return string == nil || string.length == 0;
}

@end

@implementation CNICloudDocumentModel

+ (CNICloudDocumentModel *)modelWithPath:(NSString *)path {
    
    CNICloudDocumentModel *iCloudDocumentModel = [[CNICloudDocumentModel alloc]init];
    
    if ([NSString isEmpty:path]) {
        return iCloudDocumentModel;
    }
    
    iCloudDocumentModel.fileURL = [[NSURL alloc]initFileURLWithPath:path];
    
    // 读取文件名
    if (iCloudDocumentModel.fileURL) {
        NSString *pathString = [[NSString alloc]initWithString:iCloudDocumentModel.fileURL.lastPathComponent];
        iCloudDocumentModel.fileName = [pathString stringByDeletingPathExtension];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    iCloudDocumentModel.fileIsExist = [fileManager fileExistsAtPath:path];
    // 获取文件相关属性
    NSDictionary *fileAttributes = [CNICloudFileHelper fileAttrAtPath:path];
    if (fileAttributes.count < 0) {
        return iCloudDocumentModel;
    }
    iCloudDocumentModel.fileAttributes = fileAttributes;
    
    return iCloudDocumentModel;
    
}


@end
