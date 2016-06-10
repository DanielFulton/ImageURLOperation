//
//  ImageURLOperation.m
//  imageOpObjC
//
//  Created by Daniel Fulton on 6/7/16.
//

#import "ImageURLOperation.h"
#import <ImageIO/ImageIO.h>
@interface ImageURLOperation ()
@property (copy, nonatomic)ImageURLCompletion completion;
@property (strong, nonatomic) NSURL * imageURL;
@end
@implementation ImageURLOperation

-(instancetype)initWithImageUrl:(NSURL *)imageUrl completion:(ImageURLCompletion)completion {
    if (self = [super init]) {
        if (!imageUrl) {
            return nil;
        }
        if (!completion) {
            return nil;
        }
        self.imageURL = imageUrl;
        self.completion = completion;
    }
    return self;
}

-(void)main {
    if (self.isCancelled) {
        self.completion(nil, [NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationCancelled userInfo:nil]);
        return;
    }
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)self.imageURL, NULL);
    if (!source) {
        self.completion(nil, [NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationSourceCreationFailure userInfo:nil]);
        return;
    }
    if (self.isCancelled) {
        self.completion(nil, [NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationCancelled userInfo:nil]);
        return;
    }
    NSUInteger count = CGImageSourceGetCount(source);
    if (count == 0) {
        self.completion(nil, [NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationSourceNoImages userInfo:nil]);
        return;
    }
    CGImageSourceStatus status = CGImageSourceGetStatus(source);
    if (status != kCGImageStatusComplete) {
        self.completion(nil, [NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationSourceIncompleteImage userInfo:nil]);
        return;
    }
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)@{(NSString*)kCGImageSourceShouldCache:@(YES), (NSString*)kCGImageSourceTypeIdentifierHint:(NSString*)CGImageSourceGetType(source)});
    if (!imageRef) {
        self.completion(nil,[NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationImageCreationFailure userInfo:nil]);
        return;
    }
    UIImage * image = [UIImage imageWithCGImage:imageRef];
    if (!image) {
        self.completion(nil,[NSError errorWithDomain:@"ImageOpErrorDomain" code:ImageURLOperationImageCreationFailure userInfo:nil]);
        return;
    }
    self.completion(image, nil);
    // create disk writing op if necessary
}

@end