//
//  ICloudDocumentModel.h
//  iCloud_测试
//
//  Created by 梁星国 on 2018/10/12.
//  Copyright © 2018年 梁星国. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface CNICloudDocumentModel : NSObject

/** 路径 */
@property (strong, nonatomic) NSURL *fileURL;
/** 文件的名称
eg. “/tmp/scratch.tiff” -> “/tmp/scratch”
eg. “/tmp/” -> “/tmp”
eg. “scratch..tiff” -> “scratch.”
 */
@property (copy, nonatomic) NSString *fileName;
/** 是否有路径 */
@property (assign, nonatomic) Boolean fileIsExist;
/** 文件的相关属性. Use: fileAttributes.fileSize() */
@property (copy, nonatomic) NSDictionary *fileAttributes;

+ (CNICloudDocumentModel *)modelWithPath:(NSString *)path;

@end

//NS_ASSUME_NONNULL_END
