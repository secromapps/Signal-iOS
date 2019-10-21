//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "SignalAccount.h"
#import "Contact.h"
#import "SignalRecipient.h"
#import <SignalCoreKit/NSString+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

NSUInteger const SignalAccountSchemaVersion = 1;

@interface SignalAccount ()

@property (nonatomic, readonly) NSUInteger accountSchemaVersion;

@end

#pragma mark -

@implementation SignalAccount

+ (BOOL)shouldBeIndexedForFTS
{
    return YES;
}

- (instancetype)initWithSignalRecipient:(SignalRecipient *)signalRecipient
{
    OWSAssertDebug(signalRecipient);
    OWSAssertDebug(signalRecipient.address.isValid);
    return [self initWithSignalServiceAddress:signalRecipient.address];
}

- (instancetype)initWithSignalServiceAddress:(SignalServiceAddress *)serviceAddress
{
    if (self = [super init]) {
        _recipientUUID = serviceAddress.uuidString;
        _recipientPhoneNumber = serviceAddress.phoneNumber;
        _accountSchemaVersion = SignalAccountSchemaVersion;
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    // Migrating from an everyone has a phone number world to a
    // world in which we have UUIDs
    if (_accountSchemaVersion == 0) {
        // Rename recipientId to recipientPhoneNumber
        _recipientPhoneNumber = [coder decodeObjectForKey:@"recipientId"];

        OWSAssert(_recipientPhoneNumber != nil);
    }

    _accountSchemaVersion = SignalAccountSchemaVersion;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
                         contact:(nullable Contact *)contact
        multipleAccountLabelText:(NSString *)multipleAccountLabelText
            recipientPhoneNumber:(nullable NSString *)recipientPhoneNumber
                   recipientUUID:(nullable NSString *)recipientUUID
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId];

    if (!self) {
        return self;
    }

    _contact = contact;
    _multipleAccountLabelText = multipleAccountLabelText;
    _recipientPhoneNumber = recipientPhoneNumber;
    _recipientUUID = recipientUUID;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (nullable NSString *)contactFullName
{
    return self.contact.fullName.filterStringForDisplay;
}

- (NSString *)multipleAccountLabelText
{
    NSString *_Nullable result = _multipleAccountLabelText.filterStringForDisplay;
    return result != nil ? result : @"";
}

- (SignalServiceAddress *)recipientAddress
{
    return [[SignalServiceAddress alloc] initWithUuidString:self.recipientUUID phoneNumber:self.recipientPhoneNumber];
}

- (BOOL)isEqual:(id)other
{
    if (![other isKindOfClass:[SignalAccount class]]) {
        return NO;
    }

    SignalAccount *otherSignalAccount = (SignalAccount *)other;
    return ([NSObject isNullableObject:self.recipientPhoneNumber equalTo:otherSignalAccount.recipientPhoneNumber] &&
        [NSObject isNullableObject:self.recipientUUID equalTo:otherSignalAccount.recipientUUID] &&
        [NSObject isNullableObject:self.contact equalTo:otherSignalAccount.contact] &&
        [NSObject isNullableObject:self.multipleAccountLabelText equalTo:otherSignalAccount.multipleAccountLabelText]);
}

- (NSUInteger)hash
{
    OWSFailDebug(@"We should never hash instances of this class.");

    return (self.recipientPhoneNumber.hash ^ self.recipientUUID.hash ^ self.contact.hash
        ^ self.multipleAccountLabelText.hash);
}

@end

NS_ASSUME_NONNULL_END
