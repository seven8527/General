//
//  UASearchBarDelegate.h
//  Talentcove
//
//  Created by Umair Aamir on 5/21/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UASearchBar;

@protocol UASearchBarDelegate <NSObject>


@optional

- (BOOL)searchBarShouldBeginEditing:(UASearchBar *)searchBar;                      // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UASearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UASearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UASearchBar *)searchBar;                       // called when text ends editing
- (void)searchBar:(UASearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)searchBar:(UASearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)searchBarSearchButtonClicked:(UASearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UASearchBar *)searchBar;                   // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UASearchBar *) searchBar;                    // called when cancel button pressed

@end
