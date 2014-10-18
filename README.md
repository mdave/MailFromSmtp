# MailFromSmtp

## What is this?

In OS X 10.10 (Yosemite), Apple removed a very useful feature from their
codebase: the ability to change which SMTP server you use from within the
message editor. Since Apple is Apple, it seems unlikely they will re-add this
feature. I therefore took it upon myself to code up a mailbundle which
reimplements this, but in a "better" (and way more hacky) way.

To give you background, I have a single IMAP account which aggregates all of my
email. I therefore want the ability to send email from multiple addresses,
depending on context. Mail allows you to define multiple outgoing identities, by
defining them as a comma separated list in the Email Address field in the
account information.

This causes a `From:` drop-down list to appear in the message composition
editor. This mailbundle tries to identify an SMTP server to send outgoing email
by comparing it against the `From:` address you selected.

Please note that this was done in under 2 hours on a Friday evening, so the
quality of code is quite bad.

## Automatic signature selection

Because I use this for my personal email, this bundle includes another
feature. When you change the `From:` field, it will try to match a signature and
automatically put this into the mail body. For now, to use this feature you need
to modify the source.

## Requirements

* OS X 10.10
* Xcode 6.1

## Caveats

1. Since this uses Mail's private API, it will almost certainly break at some
   point in the future.
2. You need to have multiple email aliases set in your email account. To do
   this, define them as a comma separated list in the Email Address field in the
   account information.
3. Each SMTP account you have configured in your mail client should have a
   `CanonicalEmailAddress` set in `~/Library/Mail/V2/MailData/Accounts.plist`.
4. I will probably not maintain this beyond my own personal use, although pull
   requests are highly encouraged.

## Installing

1. Clone the repository
2. Open the Xcode project
3. Compile
4. Locate `MailFromSmtp.mailbundle` by right clicking on the
   `MailFromSmtp.mailbundle` product and select _Show in Finder_.
5. Create the directory `~/Library/Mail/Bundles` if it doesn't exist.
5. Copy `MailFromSmtp.mailbundle` into `~/Library/Mail/Bundles`.

## License

This is distributed under the GPLv3 license, with the exception of `Swizzler.m`
and `Swizzler.h` which are shamelessly copied from stl's
[MailBundle-Template](https://github.com/stl/MailBundle-Template) project.