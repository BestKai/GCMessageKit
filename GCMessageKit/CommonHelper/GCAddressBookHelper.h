//
//  GCAddressBookHelper.h
//  purchasingManager
//
//  Created by BestKai on 16/5/19.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPerson : NSObject

@property (copy  ,nonatomic) NSString *name;
@property (copy  ,nonatomic) NSString *phoneNumber;
@property (strong,nonatomic) UIImage *headerImage;


@end

@protocol GCSystemAddressBookViewControllerDelegate <NSObject>

- (void)systemAddressBookDidSelectPerson:(GCPerson *)person;

@end

@interface GCAddressBookHelper : NSObject

@property (assign,nonatomic) id <GCSystemAddressBookViewControllerDelegate> delegate;


- (void)showSystemAddressBookAtViewController:(UIViewController *)viewController;

@end
