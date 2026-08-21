# Play Console "Data Safety" form — answers based on this app's actual code

Traced from the app's code and its merged Android manifest, not guessed.
Google's exact category names/wording in the console can shift over
time — treat this as a mapping to fill in the live form with, not a
copy-paste replacement for it.

## Does your app collect or share any of the required user data types?

**Yes.**

## Data types to declare

| Category | Type | Collected? | Shared? | Purpose | Required or optional |
|---|---|---|---|---|---|
| Personal info | Name | Yes | No | App functionality | Required |
| Personal info | Email address | Yes (agents only) | No | Account management, App functionality | Required |
| Personal info | Phone number | Yes | No | App functionality | Required |
| Personal info | Address | Yes (beneficiaries) | No | App functionality | Required |
| Personal info | User IDs | Yes (Firebase Auth UID) | No | Account management | Required |
| Personal info | Other personal info | Yes — government ID type/number (Aadhar/Voter/PAN/Ration) | No | App functionality | Required |
| Photos and videos | Photos | Yes — ID document photos, stove photo, handover photo, signed consent form photo | No | App functionality | Required |
| Location | Precise location | Yes — GPS-tags uploaded photos | No | App functionality | Required |
| Location | Approximate location | Not separately used | — | — | — |
| Financial info | (all) | No | — | — | — |
| Health and fitness | (all) | No | — | — | — |
| Messages | (all) | No | — | — | — |
| App activity | (all) | No — no analytics SDK in this app | — | — | — |
| Web browsing | (all) | No | — | — | — |
| App info and performance | Crash logs, diagnostics | No — no Crashlytics/analytics in this app | — | — | — |
| Device or other IDs | Device or other IDs | Possibly, via Firebase (App Check, Auth, Firestore SDKs) — see note below | No | Fraud prevention, security, and compliance | — |

**Why "no analytics"**: confirmed by checking `pubspec.yaml` and the
codebase — no `firebase_analytics` or `firebase_crashlytics` package is
used.

**Why "no camera permission" but photos are still collected**: the app
doesn't request `CAMERA` directly — it launches the system camera app
via `image_picker` and receives back a file path. Google still expects
"Photos" to be declared as collected, since the app uploads and stores
that photo afterward.

**Device or other IDs note**: Firebase's own SDKs (Firebase App Check,
Firebase Auth, Cloud Firestore, Cloud Storage) may collect
installation/instance identifiers as part of their own operation. Check
Google's published "Data collected by Firebase SDKs" reference in the
Play Console help center when filling this section in, since this is
Google-operated infrastructure with its own disclosed behavior, not
something this app's code controls directly.

## Is all of the user data collected by your app encrypted in transit?

**Yes** — Firebase/Firestore/Cloud Storage traffic is HTTPS/TLS by
default.

## Do you provide a way for users to request that their data be deleted?

Answer based on your actual process — see the "Data retention" and
"Your rights" sections in `PRIVACY_POLICY.md`. If you don't have a
deletion process yet, you'll need one before this can honestly be "Yes."

## Sensitive data flag

Google Play's review process will likely flag this app for handling
**government-issued ID documents** and **precise location** for a
population that isn't the app's own end user (beneficiaries don't
install the app — agents enter data about them). Be ready to explain
this relationship (consent process, program purpose) if Google's review
team asks follow-up questions — this is a known trigger for extra
scrutiny on Play, not a sign something is wrong with the app.
