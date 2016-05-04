//
//  UASearchBar.m
//  UASearchBar
//
//  Created by Umair Aamir on 5/21/14.
//  Copyright (c) 2014 Confiz Limited. All rights reserved.
//

#import "UASearchBar.h"

@interface UASearchBar () {
    
}


//@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation UASearchBar

@synthesize textField=_textField, cancelButton=_cancelButton, delegate, placeHolder=_placeHolder, text=_text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setPlaceHolder:@"search something"];
        [self setSearchIcon:@"magnifier"];
        //[self setCancelButtonTitle:@"Cancel" forState:UIControlStateNormal];
    }
    return self;
}

-(UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:self.bounds];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.textField];
        [_textField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textField;
}

-(UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.frame.size.width, 0, 50, self.frame.size.height);
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_cancelButton];
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonHandler)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}

-(void)setCancelButtonTitle:(NSString *)title forState:(UIControlState)state
{
    [self.cancelButton setTitle:title forState:state];
}

-(void)setCancelButtonTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [self.cancelButton setTitleColor:color forState:state];
}

-(void)setCancelButtonTintColor:(UIColor *)color
{
    [self.cancelButton setTintColor:color];
}

-(void)setCancelButtonBackgroundColor:(UIColor *)color
{
    [self.cancelButton setBackgroundColor:color];
}

-(void)setText:(NSString *)text
{
    self.textField.text = text;
}

-(NSString *)text
{
    return self.textField.text;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textField.placeholder = placeHolder;
}

-(void)setPlaceHolderColor:(UIColor*)color
{
    NSAssert(!self.placeHolder, @"Please set placeholder before setting placeholdercolor");
    [self.textField setPlaceholderColor:color];
}

-(NSString *)placeHolder
{
    return _placeHolder;
}

-(void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type
{
    self.textField.autocapitalizationType = type;
}

-(void)setSearchIcon:(NSString *)icon
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37/2, 37/2)];
    
    [imageView setImage:[UIImage imageNamed:icon]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.textField.leftView = imageView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setShowsCancelButton:(BOOL)show animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.4f animations:^{
            [self setShowsCancelButton:show];
        }];
    } else {
        [self setShowsCancelButton:show];
    }
}

-(void)setShowsCancelButton:(BOOL)show
{
    if (show)
    {
        CGRect frame = self.cancelButton.frame;
        frame.origin.x = self.frame.size.width - 40;
        self.cancelButton.frame = frame;
        
        frame = self.textField.frame;
        frame.size.width = self.bounds.size.width - 45;
        self.textField.frame = frame;
    } else {
        CGRect frame = self.cancelButton.frame;
        frame.origin.x = self.frame.size.width;
        self.cancelButton.frame = frame;
        
        frame = self.textField.frame;
        frame.size.width = self.bounds.size.width;
        self.textField.frame = frame;
    }
}

-(void)cancelButtonHandler
{
//    self.textField.text = @"";
//    [self setShowsCancelButton:NO animated:YES];
    [self.textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    [self setShowsCancelButton:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}

@end
