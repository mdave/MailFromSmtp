/*
 * File: HeadersEditor+Extensions.h
 * Author: David Moxey <dave@xyloid.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "HeadersEditor+Extensions.h"

@implementation MSF_HeadersEditor

/**
 * @brief Override deliveryAccount accessor method depending on what SMTP
 * address is defined in the "From:" dropdown.
 */
- (id) MSF_deliveryAccount
{
    // First determine what delivery address to use from original
    // implementation.
    id ret = [self MSF_deliveryAccount];

    // The _deliveryASDS member variable is a AccountStatusDataSource object,
    // which contains all the delivery accounts that we have set up.
    //
    // See e.g. http://bit.ly/10708mb for a full dump of what's needed.
    id deliveryASDS = [self valueForKey:@"_deliveryASDS"];

    // This is an array of all of delivery accounts.
    NSArray *accounts = [deliveryASDS valueForKey:@"_accounts"];

    // The NSPopUpButton for the "From:" field
    NSPopUpButton *fromField = [self valueForKey:@"_fromPopup"];

    // This is very hacky: determine the email address from the From text by
    // splitting it by spaces and extracting the last value.
    NSString *emailFrom =
        [[[[fromField selectedItem] title] componentsSeparatedByString:@" "]
            lastObject];
    
    for (id account in accounts)
    {
        // Get dictionary of account information. This is the same as stored in
        // ~/Library/Mail/V2/MailData/Accounts.plist
        NSDictionary *dict = [account valueForKey:@"_info"];

        // Use the CanonicalEmailAddress field to compare against email
        // address in the From field.
        NSString *email = [dict objectForKey:@"CanonicalEmailAddress"];

        // We found a match.
        if ([email isEqualToString:emailFrom])
        {
            return account;
        }
    }

    // Otherwise return whatever the default gives.
    return ret;
}

/**
 * @brief Overridden changeSignature delegate. This method doesn't do anything
 * differently -- it is just here so that we don't need to include the private
 * headers from the Mail application.
 */
- (void) MSF_changeSignature:(id)arg1
{
    [self MSF_changeSignature:arg1];
}

/**
 * @brief Overridden changeFromHeader delegate.
 *
 * The purpose of this is to implement the signature functionality: when I
 * select an email from the dropdown list, it should choose a signature
 * automatically for me. Currently hardcoded to my settings because I'm too lazy
 * to put a preference pane into the code.
 */
- (void) MSF_changeFromHeader:(id)arg1
{
    [self MSF_changeFromHeader:arg1];

    // Obtain email address in a hacky way from the From field, as in the
    // previous method.
    NSString *last =
        [[[[arg1 selectedItem] title] componentsSeparatedByString:@" "]
            lastObject];

    // Email address to search for. lazy++ for hardcoding
    if ([last isEqualToString:@"d.moxey@imperial.ac.uk"])
    {
        int i;

        // NSPopUpButton containing signature list.
        NSPopUpButton *sigs = [self valueForKey:@"_signaturePopup"];

        // Iterate over list, and match the one which corresponds to "Imperial"
        // in this case. (Again, I'm lazy, sorry).
        for (i = 0; i < [sigs numberOfItems]; ++i)
        {
            NSString *sigName = [[sigs itemAtIndex:i] title];
            if ([sigName isEqualToString:@"Imperial"])
            {
                break;
            }
        }

        // Found a match.
        if (i != [sigs numberOfItems])
        {
            // Update the signature menu
            [sigs selectItemAtIndex:i];

            // Fire off a change of signature request to put it into the message
            // body.
            [self MSF_changeSignature:sigs];
        }
    }
}

@end
