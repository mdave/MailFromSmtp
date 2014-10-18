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

/**
 * @brief Extensions to the Mail.app HeadersEditor class.
 *
 * HeadersEditor in Mail.app provides the interface routines inside the
 * composition window, and has controls for the From field, as well as To, Cc,
 * etc. Here we are just interested in overriding the functionality which
 * determines which SMTP server is used.
 */
@interface MSF_HeadersEditor : NSObject

/// Which delivery account to use
- (id)   MSF_deliveryAccount;
/// Called when the "From:" dropdown box is changed.
- (void) MSF_changeFromHeader:(id)arg1;
/// Called when the "Signature" dropdown box is changed.
- (void) MSF_changeSignature:(id)arg1;

@end
