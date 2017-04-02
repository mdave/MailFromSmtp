# MailFromSmtp

**IMPORTANT NOTE:** MailFromSMTP is now _deprecated_ and will no longer be
maintained. Here are some highlights as to why:

- In macOS 10.12 (Sierra), Mail.app restructured the way that outgoing accounts
  are assigned to the compose windows. This means that selecting the SMTP server
  dynamically has now become much more challenging.
- There is a more maintainable solution to this problem if you are running your
  own mailserver, which is to use SMTP forwarding when emails are sent from
  certain addresses (see below).
- If you did happen to be using this plugin on macOS 10.10 or 10.11, then this
  should continue to work fine.

## Postfix-based solution

If you are running `postfix`, then you can set up the
`sender_dependent_default_transport_maps` option to define relays that will
forward mail to remote servers based on the `From` header in your email. First,
create a directory `/etc/postfix/header-relays` to keep configuration files
related to this in (and also keep everything neat), then set up a hash
`/etc/postfix/header-relays/sender_transport_map` which defines the email
addresses that should be filtered:

```
email1@gmail.com          smtp1:[smtp.gmail.com]
email2@otherserver.com    smtp2:[smtp.otherserver.com]
```

Then, run `postmap` on this file to generate a `.db` file, and enable this in
your `main.cf` configuration with:

```
sender_dependent_default_transport_maps = hash:/etc/postfix/header-relays/sender_transport_map
```

Each SMTP relay requires a configuration with your authentication details. For
example, my configuration file for `smtp1` lives in
`/etc/postfix/header-relays/smtp1.relay` and looks like:

```
[smtp.gmail.com] email1@gmail.com:password
```

Again, you should run `postmap` on these files to generate the `.db`. Finally,
you need to update your `master.cf` to define each transport `smtp?` that's
defined in the sender transport map. For example, mine look like:

```
smtp1      unix  -       -       y       -       3       smtp
    -o smtp_use_tls=yes
    -o smtp_sasl_auth_enable=yes
    -o smtp_sasl_security_options=noanonymous
    -o smtp_sasl_password_maps=hash:/etc/postfix/header-relays/smtp1.relay
```

You can then restart postfix, and send an email with the appropriate `From:`
header set using the addresses dropdown in Mail.app. If you monitor your logs,
you should hopefully see that these email is forwarded to the appropriate SMTP
relay.

------

## What is (was) this?

In OS X 10.10 (Yosemite), Apple removed a useful feature from their Mail.app
client: the ability to change which SMTP server you use from within the message
editor. After some communication with Apple via their bug tracker, they claim
that such a feature is not useful/required and therefore will not be re-added in
future versions of Mail.app.

Since Mail.app supports 'bundles', which can extend the functionality of the
client (albeit in an unsupported manner), this project reimplements this
functionality, using the SMTP servers that you have set up and an email address
that is associated with each one. It is therefore 'better' in the sense that you
don't have to select which email server you'd like to use -- MailFromSMTP will
figure that out for itself.

### Why would I want this?

If you are not sure this is useful for you and your setup, this is mine: I have
a single IMAP account which aggregates all of my email using fetchmail. I
therefore want the ability to send email from multiple addresses, depending on
context.

Mail.app allows you to define multiple outgoing identities, by defining them as
a comma separated list in the Email Address field in the account
information. This causes a `From:` drop-down list to appear in the message
composition editor. 

MailFromSMTP tries to identify an SMTP server to send outgoing email by
comparing it against the `From:` address you selected, and will automagically
send via this server if it finds a match. If not, then it will use your default
SMTP server.

### Bonus feature -- automatic signature selection

Because I use this for my personal email, this bundle includes another, rather
unrelated feature. When you change the `From:` field, it will try to match a
signature and automatically put this into the mail body. For now, to use this
feature you need to modify the source, so I leave this as an exercise for the
interested user.

## Requirements

* OS X 10.10
* Xcode 6.1

## Caveats

1. Since this uses Mail's private API, it will almost certainly break at some
   point in the future. However, I do plan on updating as new OS versions come
   out.
2. You need to have multiple email aliases set in your email account. To do
   this, define them as a comma separated list in the Email Address field in the
   account information. See e.g. http://bit.ly/1hfR1DQ for instructions.
3. Each SMTP account you have configured in your mail client should have a
   `CanonicalEmailAddress` set in
   `~/Library/Mail/V2/MailData/Accounts.plist`. To do this, open up this file in
   e.g. TextEdit, find the `DeliveryAccounts` key, and for each email account,
   make sure you have an entry such as
   ```xml
   <key>CanonicalEmailAddress</key>
   <string>my@email.address</string>
   ```
4. I will probably not maintain this beyond my own personal use, although pull
   requests are highly encouraged.

## Installing

1. Clone the repository
2. Open the Xcode project
3. Compile
4. Locate `MailFromSmtp.mailbundle` by right clicking on the
   `MailFromSmtp.mailbundle` product and select _Show in Finder_.
5. Create the directory `~/Library/Mail/Bundles` if it doesn't exist.
6. Copy `MailFromSmtp.mailbundle` into `~/Library/Mail/Bundles`.
7. Enable Mail bundles by issuing the command `defaults write com.apple.mail
   EnableBundles 1` at a terminal.
8. (Re)start Mail.

## License

This is distributed under the GPLv3 license, with the exception of `Swizzler.m`
and `Swizzler.h` which are shamelessly copied from stl's
[MailBundle-Template](https://github.com/stl/MailBundle-Template) project.
