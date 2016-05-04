//
//  FaceBoard.m
//


#import "FaceBoard.h"

@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;


#define SIZEOFEMOJI   SCREEN_WIDTH/7
#define SIZEOFEMOJI5   SCREEN_WIDTH/5
#define SIZEOFEMOJIBIG   50
#define SIZEOFEMOJISMALL   35


- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 200)];
    if (self) {
        self.backgroundColor = UIColorFromRGB(KE6E6E6Color);
        _facebaseMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist"]];
        _facelaowangMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"laowangemoji" ofType:@"plist"]];
        _facexiaoxuanMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xiaoxuanemoji" ofType:@"plist"]];
        _facewangkaiMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"wangkaiemoji" ofType:@"plist"]];
        
        
        _facebasePageCount = (_facebaseMap.count/20+1);
        _facelaowangPageCount = (_facelaowangMap.count/10+1);
        _facexiaoxuanPageCount = (_facexiaoxuanMap.count/10+1);
        _facewangkaiPageCount = (_facewangkaiMap.count/10+1);
   
        
        int totalPage =_facebasePageCount+_facelaowangPageCount+_facewangkaiPageCount+_facexiaoxuanPageCount;
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake(totalPage*SCREEN_WIDTH, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        CGFloat scrollHeight = (self.frame).size.height-40;
        //
        //        //根据图片量来计算scrollView的Contain的宽度
        //        CGFloat width = (_faceMap.count/(scrollHeight/SIZEOFEMOJI))*SIZEOFEMOJI;
        //添加基础表情
        for (int i = 0; i< _facebaseMap.count; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            faceButton.frame = CGRectMake(((i%20)%7)*SIZEOFEMOJI+SIZEOFEMOJI/2-SIZEOFEMOJISMALL/2+ i/20*SCREEN_WIDTH, ((i%20)/7)*scrollHeight/4+12, SIZEOFEMOJISMALL, SIZEOFEMOJISMALL);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_facebaseMap.allValues[i]]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
            
            //删除键
            UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
            [back setTitle:@"删除" forState:UIControlStateNormal];
            [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
            [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
            [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
            back.frame = CGRectMake(SIZEOFEMOJI*6+SIZEOFEMOJI/2-19+i/20*SCREEN_WIDTH, scrollHeight/4*2+15, 38, 27);
            [faceView addSubview:back];
        }
        
        for (int i = 0; i< _facelaowangMap.count; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(facelaowangButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            faceButton.frame = CGRectMake(((i%10)%5)*SIZEOFEMOJI5+SIZEOFEMOJI5/2-SIZEOFEMOJIBIG/2 + i/10*SCREEN_WIDTH +(_facebasePageCount)*SCREEN_WIDTH, ((i%10)/5)*scrollHeight/3+5, SIZEOFEMOJIBIG, SIZEOFEMOJIBIG);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_facelaowangMap.allValues[i]]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        for (int i = 0; i< _facexiaoxuanMap.count; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(facexiaoxuanButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            faceButton.frame = CGRectMake(((i%10)%5)*SIZEOFEMOJI5+SIZEOFEMOJI5/2-SIZEOFEMOJIBIG/2 + i/10*SCREEN_WIDTH +(_facebasePageCount+_facelaowangPageCount)*SCREEN_WIDTH, ((i%10)/5)*scrollHeight/3+10, SIZEOFEMOJIBIG, SIZEOFEMOJIBIG);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_facexiaoxuanMap.allValues[i]]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }

        
        for (int i = 0; i< _facewangkaiMap.count; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(facewangkaiButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            faceButton.frame = CGRectMake(((i%10)%5)*SIZEOFEMOJI5+SIZEOFEMOJI5/2-SIZEOFEMOJIBIG/2 + i/10*SCREEN_WIDTH +(_facebasePageCount+_facelaowangPageCount+_facexiaoxuanPageCount)*SCREEN_WIDTH, ((i%10)/5)*scrollHeight/3+10, SIZEOFEMOJIBIG, SIZEOFEMOJIBIG);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_facewangkaiMap.allValues[i]]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 130, 100, 20)];
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = _facebaseMap.count/20+1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        _emoji = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, 44, 38)];
        [_emoji setImage:[UIImage imageNamed:@"def_face_normal"] forState:UIControlStateNormal];
        [_emoji setImage:[UIImage imageNamed:@"def_face_Highlight"] forState:UIControlStateSelected];
        _emoji.tag = 0;
        [_emoji addTarget:self action:@selector(pressedEmji:) forControlEvents:UIControlEventTouchUpInside];
//        _emoji.backgroundColor = [UIColor grayColor];
//        [_emoji setShowsTouchWhenHighlighted:YES];
        [self addSubview:_emoji];
        
        _emojixiaokai = [[UIButton alloc]initWithFrame:CGRectMake(45, 160, 44, 38)];
        [_emojixiaokai setImage:[UIImage imageNamed:@"wangka_face_normal"] forState:UIControlStateNormal];
        [_emojixiaokai setImage:[UIImage imageNamed:@"wangka_face_selected"] forState:UIControlStateSelected];
        _emojixiaokai.tag = 1;
        [_emojixiaokai addTarget:self action:@selector(pressedEmji:) forControlEvents:UIControlEventTouchUpInside];
//        _emojixiaokai.backgroundColor = [UIColor grayColor];
//        [_emojixiaokai setShowsTouchWhenHighlighted:YES];
        [self addSubview:_emojixiaokai];
        
        _emojixiaoxuan = [[UIButton alloc]initWithFrame:CGRectMake(90, 160, 44, 38)];
        [_emojixiaoxuan setImage:[UIImage imageNamed:@"xiaoxuan_face_normal"] forState:UIControlStateNormal];
        [_emojixiaoxuan setImage:[UIImage imageNamed:@"xiaoxuan_face_selected"] forState:UIControlStateSelected];
        _emojixiaoxuan.tag = 2;
        [_emojixiaoxuan addTarget:self action:@selector(pressedEmji:) forControlEvents:UIControlEventTouchUpInside];
//        _emojixiaoxuan.backgroundColor = [UIColor grayColor];
//        [_emojixiaoxuan setShowsTouchWhenHighlighted:YES];
        [self addSubview:_emojixiaoxuan];
        
        _emojilaowang = [[UIButton alloc]initWithFrame:CGRectMake(135, 160, 44, 38)];
        [_emojilaowang setImage:[UIImage imageNamed:@"laowang"] forState:UIControlStateNormal];
        [_emojilaowang setImage:[UIImage imageNamed:@"laowang_click"] forState:UIControlStateSelected];
        _emojilaowang.tag = 3;
        [_emojilaowang addTarget:self action:@selector(pressedEmji:) forControlEvents:UIControlEventTouchUpInside];
//        _emojilaowang.backgroundColor = [UIColor grayColor];
//        [_emojilaowang setShowsTouchWhenHighlighted:YES];
        [self addSubview:_emojilaowang];
        
        _emoji.selected = YES;
        _emojixiaokai.selected = NO;
        _emojixiaoxuan.selected = NO;
        _emojilaowang.selected = NO;
    }
    return self;
}

-(void)pressedEmji:(UIButton*)sender
{
    int  numberOfPages  = 0;
    switch (sender.tag) {
        case 0:
        {
            _emoji.selected = YES;
            _emojixiaokai.selected = NO;
            _emojixiaoxuan.selected = NO;
            _emojilaowang.selected = NO;
            numberOfPages =_facebasePageCount;
            [faceView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
            _emoji.selected = NO;
            _emojixiaokai.selected = YES;
            _emojixiaoxuan.selected = NO;
            _emojilaowang.selected = NO;
             numberOfPages =_facelaowangPageCount;
             [faceView setContentOffset:CGPointMake(_facebasePageCount*SCREEN_WIDTH, 0) animated:YES];
        }
            break;
        case 2:
        {
            _emoji.selected = NO;
            _emojixiaokai.selected = NO;
            _emojixiaoxuan.selected = YES;
            _emojilaowang.selected = NO;
             numberOfPages =_facexiaoxuanPageCount;
             [faceView setContentOffset:CGPointMake((_facelaowangPageCount+_facebasePageCount)*SCREEN_WIDTH, 0) animated:YES];
        }
            break;
        case 3:
        {
            _emoji.selected = NO;
            _emojixiaokai.selected = NO;
            _emojixiaoxuan.selected = NO;
            _emojilaowang.selected = YES;
            numberOfPages =_facewangkaiPageCount;
          [faceView setContentOffset:CGPointMake((_facexiaoxuanPageCount+_facelaowangPageCount+_facebasePageCount)*SCREEN_WIDTH, 0) animated:YES];
        }
            break;
        default:
            break;
    }
    
    facePageControl.numberOfPages = numberOfPages;
    facePageControl.currentPage = 0;
    [facePageControl updateCurrentPageDisplay];
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

     if (faceView.contentOffset.x/SCREEN_WIDTH >=_facebasePageCount+_facelaowangPageCount+_facexiaoxuanPageCount)
    {
        facePageControl.numberOfPages = _facewangkaiPageCount;
        facePageControl.currentPage = faceView.contentOffset.x/SCREEN_WIDTH-(_facebasePageCount+_facelaowangPageCount+_facexiaoxuanPageCount);
        _emoji.selected = NO;
        _emojixiaokai.selected = NO;
        _emojixiaoxuan.selected = NO;
        _emojilaowang.selected = YES;
    }
     else if (faceView.contentOffset.x/SCREEN_WIDTH >=_facebasePageCount+_facelaowangPageCount )     {
         facePageControl.numberOfPages = _facexiaoxuanPageCount;
         facePageControl.currentPage = faceView.contentOffset.x/SCREEN_WIDTH-(_facebasePageCount+_facelaowangPageCount);
         _emoji.selected = NO;
         _emojixiaokai.selected = NO;
         _emojixiaoxuan.selected = YES;
         _emojilaowang.selected = NO;
     }
     else if (faceView.contentOffset.x/SCREEN_WIDTH >=_facebasePageCount )
     {
         facePageControl.numberOfPages = _facelaowangPageCount;
         facePageControl.currentPage = faceView.contentOffset.x/SCREEN_WIDTH-_facebasePageCount;
         _emoji.selected = NO;
         _emojixiaokai.selected = YES;
         _emojixiaoxuan.selected = NO;
         _emojilaowang.selected = NO;

     }
     else if (faceView.contentOffset.x/SCREEN_WIDTH>=0 )//&& faceView.contentOffset.x/SCREEN_WIDTH <_facebasePageCount)
     {
         
         facePageControl.numberOfPages = _facebasePageCount;
         [facePageControl setCurrentPage:faceView.contentOffset.x/SCREEN_WIDTH];
         _emoji.selected = YES;
         _emojixiaokai.selected = NO;
         _emojixiaoxuan.selected = NO;
         _emojilaowang.selected = NO;
     }
    
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*SCREEN_WIDTH, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    int i = (int)((FaceButton*)sender).buttonIndex;
    NSString  * key = _facebaseMap.allKeys[i];
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString: key];
        self.inputTextField.text = faceString;
    }
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString: key];
        self.inputTextView.text = faceString;
        if (_textBlock) {
            _textBlock(YES,self.inputTextView.text);
        }
    }
    
    
}

- (void)facelaowangButton:(id)sender {
    int i = (int)((FaceButton*)sender).buttonIndex;
    NSString  * key = _facelaowangMap.allKeys[i];
    if (_textBlock) {
        _textBlock(NO, key);
    }
}
- (void)facewangkaiButton:(id)sender {
    int i = (int)((FaceButton*)sender).buttonIndex;
    NSString  * key = _facewangkaiMap.allKeys[i];
    if (_textBlock) {
        _textBlock(NO, key);
    }
}
- (void)facexiaoxuanButton:(id)sender {
    int i = (int)((FaceButton*)sender).buttonIndex;
    NSString  * key = _facexiaoxuanMap.allKeys[i];
    if (_textBlock) {
        _textBlock(NO, key);
    }
}


- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
      
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
    if (self.inputTextView) {
        if (_textBlock) {
            _textBlock(YES, string);
        }
    }
}

-(void) setBlock:(TextChangedBlock)textChanged
{
    _textBlock = textChanged;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_textBlock) {
        _textBlock(YES,textView.text);
    }
}

@end
