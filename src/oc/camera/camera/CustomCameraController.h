

#import <UIKit/UIKit.h>


@protocol CustomCameraControllerDelegate <NSObject>

@optional
- (void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithImage:(UIImage *)image;

@end
@interface CustomCameraController : UIViewController

@property(nonatomic,weak)id<CustomCameraControllerDelegate> delegate;

@end
