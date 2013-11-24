//
//  TangoMessaging.h
//  TangoSDK
//
// -*- ObjC -*-
// Copyright 2012-2013, TangoMe Inc ("Tango").  The SDK provided herein includes 
// software and other technology provided by Tango that is subject to copyright and 
// other intellectual property protections. All rights reserved.  Use only in 
// accordance with the Evaluation License Agreement provided to you by Tango.
// 
// Please read Tango_SDK_Evaluation_License_agreement_v1-2.docx
//

#import <Foundation/Foundation.h>
#import "TangoTypes.h"
#import "TangoMessageHandlers.h"
#import "TangoMessage.h"

// Keys for ContentUploadConversionHandler
extern NSString * kContentURLKey;
extern NSString * kContentThumbnailURLKey;
extern NSString * kContentMimeType;
extern NSString * kContentThumbnailMimeTypeKey;


// Keys for contentMetadata dictionary
extern NSString * kContentMetadataRotationKey;


/** TangoMessaging is the interface you use to send messages to Tango clients.
    */
@interface TangoMessaging : NSObject

/** Send a message to a list of recipients. You must specify at least either a thumbnail URL or text.
    @param message              The message object to send.
    @param accountIdentifiers   The array of account IDs that the message will be sent to.
 */
+ (void)sendMessage:(TangoMessage *)message toRecipients:(NSArray *)accountIdentifiers;

/** Send a message to a list of recipients. You must specify at least one of thumbnailURL or text.
    @param accountIdentifiers   An array of ciphered Tango Account IDs that identify the recipients
                                of the message. You must specify at least one.
    @param descriptionText      A required string that is shown to identify the message to the
                                recipient in push notifications sent to their device, and also in
                                the their conversation summary list.
    @param thumbnailUrlOrNil    An optional URL for a thumbnail to display in the message.
    @param actionsOrNil         An optional TangoActionMap, specifying message actions.
    @param messageTextOrNil     An optional string for text to display in the message.
    @param handlerOrNULL        An optional result handler to determine if the message was
                                sent successfully.
    */
+ (void)sendMessageToRecipients:(NSArray *)accountIdentifiers
                withDescription:(NSString *)descriptionText
                   thumbnailURL:(NSURL *)thumbnailURLOrNil
                        actions:(TangoActionMap *)actionsOrNil
                           text:(NSString *)messageTextOrNil
                  resultHandler:(MessageHandler)handlerOrNULL;

/** Send a message to a list of recipients, where you wish to upload a thumbnail to the Tango
    content servers, but specify custom actions for the message instead of "content" to open.
    If you do not need to upload any data, you should use
    sendMessageToRecipients:withDescription:thumbnailURL:actions:text:resultHandler.
    */
+ (void)sendMessageToRecipients:(NSArray *)accountIdentifiers
                withDescription:(NSString *)descriptionText
              thumbnailMimeType:(NSString *)thumbnailMimeType
                  thumbnailData:(NSData *)thumbnailDataOrNil
                        actions:(TangoActionMap *)actionsOrNil
                           text:(NSString *)messageTextOrNil
                progressHandler:(MessageProgressHandler)progressHandlerOrNULL
                  resultHandler:(MessageHandler)handlerOrNULL;

/** Send a message to a list of recipients, where you wish to upload "content", with an optional
    thumbnail, which you also may choose to upload. You cannot specify custom actions when you
    want to include "content". Use only one of contentData: or contentHandler:. Mime types are
    required for any case where you are uploading data.
    
    If you need to open uploaded content in your own application (instead of the browser or Tango
    itself), you can use conversion_handler to massage the URLs into a TangoActionMap that will be
    used instead of the auto-generated one.

    Support for contentHandler is not finished yet. See tango_sdk::message.h.
    */
+ (void)sendMessageToRecipients:(NSArray *)accountIdentifiers
                withDescription:(NSString *)descriptionText
                   thumbnailURL:(NSURL *)thumbnailURLOrNil
              thumbnailMimeType:(NSString *)thumbnailMimeTypeOrNil
                  thumbnailData:(NSData *)thumbnailDataOrNil
                contentMimeType:(NSString *)contentMimeTypeOrNil
                    contentData:(NSData *)contentDataOrNil
                 contentHandler:(AsyncUploadHandler)contentHandlerOrNil
              contentLengthHint:(NSUInteger)contentLengthHint
                contentMetadata:(NSDictionary *)contentMetadataOrNil
            contentActionPrompt:(NSString *)actionPrompt
 contentUploadConversionHandler:(ContentUploadConversionHandler)conversionHandler
                           text:(NSString *)messageTextOrNil
                progressHandler:(MessageProgressHandler)progressHandlerOrNULL
                  resultHandler:(MessageHandler)handlerOrNULL;

/** Compute rotation value (as a string) for a video at a given URL. Use this when specifying
    content metadata so that your video can be rotated properly for display.
    */
+ (NSString *)rotationForVideoAtURL:(NSURL *)url;

@end
