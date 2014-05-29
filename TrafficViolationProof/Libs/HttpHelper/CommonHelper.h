//
//  CommonHelper.h


#import <Foundation/Foundation.h>
@class FileModel;


#define Decl_Singleton(className) +(className*)sharedInstance;

#define Impl_Singleton(className) static className* s##className;\
+(className*)sharedInstance\
{\
if(!s##className)\
{\
s##className = [[className alloc]init];\
}\
return s##className;\
}


@interface CommonHelper : NSObject {
    
}


////将字节转化成M单位，不附带M
//+(NSString *)transformToM:(NSString *)size;
////将不M的字符串转化成字节
//+(float)transformToBytes:(NSString *)size;
//将文件大小转化成M单位或者B单位
+(NSString *)getFileSizeString:(NSString *)size;
+(NSString *)getFileSizeStringWithFileName:(NSString *)fileName;
//经文件大小转化成不带单位ied数字
+(float)getFileSizeNumber:(NSString *)size;

+(void)makesureDirExist:(NSString*)directory;

+(NSString *)getDocumentPath;
+(NSString *)getTargetFolderPath;//得到实际文件存储文件夹的路径
+(NSString *)getTempFolderPath;//得到临时文件存储文件夹的路径
+(NSString*) getTargetBookPath:(NSString*)bookName;//得到当前书籍的保存目录
+(BOOL)isExistFile:(NSString *)fileName;//检查文件名是否存在

//传入文件总大小和当前大小，得到文件的下载进度
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;

//extract packaged file to desFile
//zip,rar are supported right now
+(void)extractFile:(NSString*)srcFile toFile:(NSString*)desFilePath fileType:(NSString*)fileType;

+(NSStringEncoding)dataEncoding:(const Byte*) header;

+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion;
+(id)performSelector:(NSObject*)obj selector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
+ (UIViewController *)getCurrentRootViewController;
+(NSString*)appStoreUrl;
+(NSString*)xor_string:(NSString*)stream key:(int)key;
+(NSDictionary*)getAdPostReqParams;
+ (NSString *)cachePathForKey:(NSString *)key;

//ads utils
+(void)bas;

//gold management
+(void)setGold:(NSInteger)amount;
+(NSInteger)gold;

+(void)earnGold:(NSInteger)amount;
+(NSInteger)latestGoldEarned;

//init launch
+(void)setInitLaunch;
+(void)setNotInitLaunch;
+(BOOL)initLaunch;

+(BOOL)sameApp:(NSString*)bundleID;

+(NSString*)sqliteEscape:(NSString*) keyWord;

+(NSString*)defaultsForString:(NSString*)key;
+(BOOL)saveDefaultsForString:(NSString*)key withValue:(NSString*)value;
+(BOOL)saveDefaultsForInt:(NSString*)key withValue:(NSInteger)value;
+(NSInteger)defaultsForInt:(NSString*)key;

+(UIImage *)imageFromText:(NSArray*) arrContent withFont: (CGFloat)fontSize withMaxWidth:(CGFloat)width;
+(NSString*)displayName;
//获取当前屏幕内容
+ (UIImage *)imageFromView:(UIView *)view;
@end
