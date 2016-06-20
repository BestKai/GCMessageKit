//
//  GCAddressBookHelper.m
//  purchasingManager
//
//  Created by BestKai on 16/5/19.
//  Copyright © 2016年 郑州悉知. All rights reserved.
//

#import "GCAddressBookHelper.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@implementation GCPerson

@end

@interface GCAddressBookHelper()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

@end

@implementation GCAddressBookHelper

- (void)showSystemAddressBookAtViewController:(UIViewController *)viewController
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)) {
        CNContactPickerViewController *contactViewController = [[CNContactPickerViewController alloc] init];
        contactViewController.delegate = self;
        [viewController.navigationController presentViewController:contactViewController animated:YES completion:nil];
    }else
    {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [viewController.navigationController presentViewController:peoplePicker animated:YES completion:nil];
    }
}
#pragma mark ----- ABPeoplePickerNavigationControllerDelegate
// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    GCPerson *temPerson = [[GCPerson alloc] init];
        //读取firstname
    NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        //读取lastname
    NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
         // 电话多值
    ABMutableMultiValueRef temphones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *temPh;
    if (ABMultiValueGetCount(temphones)) {
       temPh = (__bridge NSString *)ABMultiValueCopyValueAtIndex(temphones, 0);
        temPh = [temPh stringByReplacingOccurrencesOfString:@"-" withString:@""];
        temPh = [temPh stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([temPh length] == 14 && [[temPh substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"+86"]){
            temPh = [temPh substringWithRange:NSMakeRange(3, 11)];                                  }
    }else
    {
        temPh = @"";
    }
    temPerson.name = [NSString stringWithFormat:@"%@%@",personName?:@"",lastname];
    temPerson.phoneNumber = temPh;
    
    BOOL hasImage = ABPersonHasImageData(person);
    if (hasImage) {
        temPerson.headerImage = [UIImage imageWithData:(__bridge NSData * _Nonnull)(ABPersonCopyImageData(person))];
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemAddressBookDidSelectPerson:)]) {
        [self.delegate systemAddressBookDidSelectPerson:temPerson];
    }
}

#pragma mark ----- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    GCPerson *temPerson = [[GCPerson alloc] init];

    temPerson.name = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
    
    if (!temPerson.name.length) {
        temPerson.name = contact.organizationName;
    }
    
    if (contact.phoneNumbers.count) {
        CNLabeledValue *aaa = contact.phoneNumbers[0];
        CNPhoneNumber *labelV = aaa.value;
        temPerson.phoneNumber = labelV.stringValue;
    }else
    {
        temPerson.phoneNumber = @"";
    }
    
    // 头像
    if (contact.imageData) {
        temPerson.headerImage = [UIImage imageWithData:contact.imageData];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(systemAddressBookDidSelectPerson:)]) {
        [self.delegate systemAddressBookDidSelectPerson:temPerson];
    }
}

@end
