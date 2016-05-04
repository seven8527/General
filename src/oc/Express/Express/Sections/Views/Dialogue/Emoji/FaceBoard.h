//
//  FaceBoard.h
//


#import <UIKit/UIKit.h>
#import "FaceButton.h"
#import "GrayPageControl.h"
typedef void (^TextChangedBlock) (BOOL isbaseEmoji, NSString* key);

@interface FaceBoard : UIView<UIScrollViewDelegate, UITextViewDelegate>{
    UIScrollView *faceView;
    GrayPageControl *facePageControl;
    NSDictionary *_faceMap;
}
@property (nonatomic, retain) UITextField *inputTextField;
@property (nonatomic, retain) UITextView *inputTextView;

@property (nonatomic, retain) UIButton *emojilaowang;
@property (nonatomic, retain) UIButton *emojixiaokai;
@property (nonatomic, retain) UIButton *emoji;
@property (nonatomic, retain) UIButton *emojixiaoxuan;
@property (nonatomic, copy) TextChangedBlock textBlock;

@property (nonatomic, retain) NSDictionary* facebaseMap;
@property (nonatomic, assign) int  facebasePageCount;
@property (nonatomic, retain) NSDictionary* facelaowangMap;
@property (nonatomic, assign) int  facelaowangPageCount;
@property (nonatomic, retain) NSDictionary* facewangkaiMap;
@property (nonatomic, assign) int  facewangkaiPageCount;
@property (nonatomic, retain) NSDictionary* facexiaoxuanMap;
@property (nonatomic, assign) int  facexiaoxuanPageCount;


-(void) setBlock:(TextChangedBlock)textChanged;
@end
