//
//  TangoSDKBridge.m
//  ThirdPartySDKLib
//
//  Created by MeYouGames on 13-10-13.
//  Copyright (c) 2013年 MeYouGames. All rights reserved.
//

#import "TangoSDKBridge.h"
#import "TangoManager.h"
#import "NSData+MBBase64.h"


TangoSDKBridge::TangoSDKBridge() {
    
}

TangoSDKBridge::~TangoSDKBridge() {
    
}

void TangoSDKBridge::initSDK() {
    [[TangoManager sharedInstance] initSDK];
}

void TangoSDKBridge::Authenticate() {
    [[TangoManager sharedInstance] authenticate:nil];
}

bool TangoSDKBridge::uImage2cTexture(void* uiImage, CCTexture2D* tex)
{
    CGImageRef imageRef = [(UIImage*)uiImage CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char* rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    return tex->initWithData(rawData, kCCTexture2DPixelFormat_RGBA8888, width, height, CCSizeMake(width, height));
}

CCTexture2D * TangoSDKBridge::CCString2CCTexture2D(CCString * str) {
    NSString * nsStr = [NSString stringWithUTF8String:str->getCString()];
    NSData * data = [NSData dataWithBase64EncodedString:nsStr];
    UIImage * image = [UIImage imageWithData:data];
    CCTexture2D * tex = new CCTexture2D();
    uImage2cTexture(image, tex);
    return tex;
}