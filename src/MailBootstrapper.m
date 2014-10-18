/*
 * File: MailBootstrapper.m
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

#import "MailBootstrapper.h"
#import "HeadersEditor+Extensions.h"
#import "Swizzler.h"

@implementation MailBootstrapper

/**
 * @brief Method called when bootstrapper loaded.
 */
+ (void)load
{
    // Extend HeadersEditor with custom methods.
    [Swizzler extendClass: @"HeadersEditor"
                withClass: @"MSF_HeadersEditor"];
}

/**
 * @brief Defines whether we have a preference pane.
 */
+(BOOL)hasPreferencesPanel
{
    return NO;
}

/**
 * @brief Name of preferences owner class
 */
+(NSString*)preferencesOwnerClassName
{
    return nil;
}

/**
 * @brief Name of preferences panel
 */
+(NSString*)preferencesPanelName
{
    return nil;
}

@end
