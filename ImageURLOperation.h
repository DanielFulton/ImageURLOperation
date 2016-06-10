//
//  ImageURLOperation.h
//  imageOpObjC
//
//  Created by Daniel Fulton on 6/7/16.
//

#import <UIKit/UIKit.h>
typedef void (^ImageURLCompletion)(UIImage * image, NSError * error);
typedef NS_ENUM(NSUInteger, kGLSImageURLOperationError) {
    ImageURLOperationSourceCreationFailure,
    ImageURLOperationSourceNoImages,
    ImageURLOperationSourceIncompleteImage,
    ImageURLOperationCancelled,
    ImageURLOperationImageCreationFailure
};
@interface ImageURLOperation : NSOperation
-(instancetype)initWithImageUrl:(NSURL*)imageUrl completion:(ImageURLCompletion)completion;
@property (readonly, nonatomic) NSURL * imageURL;
@end
