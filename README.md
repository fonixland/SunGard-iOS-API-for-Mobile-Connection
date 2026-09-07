# SunGard Connect

**A native iOS client for the SunGard Banner Mobile Connection Server REST API.**

[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Language](https://img.shields.io/badge/language-Objective--C-438eff.svg)](https://developer.apple.com/documentation/objectivec)
[![Deployment Target](https://img.shields.io/badge/iOS-3.1.3%2B-blue.svg)]()
[![Memory](https://img.shields.io/badge/memory-MRR%20(pre--ARC)-orange.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#license)

SunGard Connect puts a student's academic record in their pocket: log in with campus
credentials, see the grades for every term on file, pull up the current week's class
schedule, and find the building on a campus map — all served from the university's own
Banner Mobile Connection Server, with no third-party backend in between.

It is also something rarer than a student app: **a complete, readable reference
implementation of the Banner Mobile Connection REST API on iOS.** Institutions running
Banner (SunGard Higher Education, later Ellucian) got the server; what they generally did
*not* get was a worked example of a native client talking to it. This project is that
example — small enough to read in one sitting, structured well enough to fork into a
campus-branded app.

---

## Table of contents

- [Features](#features)
- [Screens](#screens)
- [Architecture](#architecture)
- [The Banner REST API surface](#the-banner-rest-api-surface)
- [Authentication and credential storage](#authentication-and-credential-storage)
- [Project layout](#project-layout)
- [Getting started](#getting-started)
- [Adapting it to your campus](#adapting-it-to-your-campus)
- [Requirements](#requirements)
- [Notes for modern builds](#notes-for-modern-builds)
- [Third-party components](#third-party-components)
- [License](#license)

---

## Features

| | Feature | Detail |
|---|---|---|
| 🔐 | **Credentialed login** | Validates against `security/getUserInfo` and resolves the caller's Banner user ID before any student data is requested. |
| 🔑 | **Keychain-backed sessions** | The password never touches `NSUserDefaults` or a plist. It goes into the iOS Keychain under the `SunGard` service and is wiped on logout. |
| 📊 | **Full grade history** | Not just this term. The grades view walks the `previousTermId` chain recursively, so every term the server exposes arrives as its own table section, oldest to newest, without the user paging anything. |
| 🗓 | **Current-week schedule** | Computes Monday–Friday from today's date, formats the window the way the Banner API expects, and renders each day as a section with course, start time, and room. |
| 🗺 | **Annotated campus map** | 21 `MKAnnotation` pins — residence halls, the gym, admissions, public safety, visitor parking, the Green Line stop — over a MapKit region framed on campus. |
| ✉️ | **In-app support mail** | `MFMailComposeViewController` with a graceful fallback when no mail account is configured. |
| 🐦 | **Embedded campus feed** | A reusable `UIWebView` controller with a loading spinner, failure handling, and an "Open in Safari" action sheet. |
| ⚙️ | **One-line deployment config** | A single constant points the whole app at your institution's server; a compile-time `#error` guarantees nobody ships an unconfigured build. |

## Screens

```
┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│  Authentication  │      │  Student Center  │      │      Grades      │
│                  │      │                  │      │ ───────────────  │
│  [ username    ] │ ──▶  │  🧾 Grades     ›  │ ──▶  │  Fall 2011       │
│  [ password    ] │      │  📅 Schedule   ›  │      │   Physics II  A  │
│                  │      │  🗺  Campus Map › │      │   Calculus    B+ │
│     ( Login )    │      │  🎧 Support    ›  │      │  Spring 2011     │
│                  │      │  💬 Twitter    ›  │      │   Chemistry   A− │
└──────────────────┘      └──────────────────┘      └──────────────────┘
                                   │
                        ┌──────────┴───────────┐
                        ▼                      ▼
                 ┌──────────────┐      ┌──────────────┐
                 │   Schedule   │      │  Campus Map  │
                 │  Monday      │      │      📍  📍   │
                 │   CS 101     │      │   📍     📍   │
                 │   09:00 Rm 3 │      │      📍  📍   │
                 │  Tuesday …   │      │              │
                 └──────────────┘      └──────────────┘
```

## Architecture

The app is deliberately thin: UIKit view controllers on top of `AFNetworking` operations,
with a `Student` model object as the only shared state passed down the navigation stack.

```mermaid
flowchart TD
    A["SunGardConnectAppDelegate<br/><i>MainWindow.xib</i>"] --> B["AuthenticationController<br/><i>login form</i>"]
    B -->|"POST-authenticated GET<br/>security/getUserInfo"| C["AFSunGardAPIClient<br/><i>AFHTTPClient singleton</i>"]
    C -->|"status: success"| D["Student<br/><i>username · studentID · Keychain password</i>"]
    D --> E["StudentCenterController<br/><i>UITableViewController menu</i>"]
    E --> F["GradesController<br/><i>recursive term walk</i>"]
    E --> G["ScheduleViewer<br/><i>Mon–Fri window</i>"]
    E --> H["MapView<br/><i>MapKit + DisplayMap annotations</i>"]
    E --> I["MFMailComposeViewController"]
    E --> J["Web<br/><i>UIWebView + share sheet</i>"]
    F -->|AFJSONRequestOperation| K[("Banner Mobile<br/>Connection Server<br/><i>/rest/</i>")]
    G -->|AFJSONRequestOperation| K
    C --> K
    D <-->|SFHFKeychainUtils| L[("iOS Keychain<br/><i>service: SunGard</i>")]
```

**Design notes worth stealing**

- **A single API client.** `AFSunGardAPIClient` is a `dispatch_once` singleton subclass of
  `AFHTTPClient` built from two constants (`urlPrefix` + `baseURLofServer`). Switching an
  entire campus deployment from HTTP to HTTPS is a one-token change.
- **Recursion instead of pagination state.** `GradesController -networkRequest:` calls
  itself with `term/<previousTermId>` from inside its own success block, appending each
  term to `gradesDatabase` and reloading the table as results stream in. No page counters,
  no "load more" button — the table simply grows as history arrives.
- **`NSNull` discipline.** Every value read out of the decoded JSON is checked against
  `[NSNull null]` before it reaches a label. JSON `null` is a first-class citizen in Banner
  responses, and an unguarded `objectForKey:` is the classic crash in clients like this.
- **Typed HTTP failure handling.** The grades view distinguishes `500` (server
  unavailable), `401` (invalid credentials), and everything else, renders the message into
  a table header view, and installs a refresh button so the user can retry in place.
- **Model objects that own their secrets.** `Student` exposes `storePassword:`,
  `findPassword`, and `removePassword` — the Keychain is an implementation detail the view
  controllers never see.

## The Banner REST API surface

All paths are relative to your Mobile Connection Server's `/rest/` root.

| Purpose | Method & path | Consumed by |
|---|---|---|
| Authenticate, resolve user ID | `GET security/getUserInfo` → `{ status, userId }` | `AuthenticationController` |
| Current-term grades | `GET grade/student/<studentID>/` | `GradesController` |
| Prior-term grades | `GET grade/student/<studentID>/term/<previousTermId>` | `GradesController` (recursive) |
| Weekly schedule | `GET schedule/student/<studentID>/start/<YYYY-MM-DD>/end/<YYYY-MM-DD>/` | `ScheduleViewer` |

Response shapes the client relies on:

```jsonc
// grade/student/<id>
{
  "term": { "name": "Fall 2011" },
  "previousTermId": "201110",          // null terminates the recursive walk
  "grades": [
    { "courseDescription": "Physics II", "grade": "A", "instructorName": "…" }
  ]
}

// schedule/student/<id>/start/<date>/end/<date>
{
  "dates": [
    { "courses": [ { "description": "CS 101", "startTime": "09:00", "location": "Rm 3" } ] }
  ]
}
```

> The date format matters: Banner expects `YYYY-MM-DD`, which is why `ScheduleViewer`
> pins `NSDateFormatter` to `yyy-MM-dd` rather than trusting a locale-derived style.

## Authentication and credential storage

1. The user types credentials into `AuthenticationController`.
2. `AFHTTPClient -setAuthorizationHeaderWithUsername:password:` attaches HTTP Basic auth
   and the client calls `security/getUserInfo`.
3. On `status == "success"`, a `Student` is built with the returned `userId`, and the
   password is written to the Keychain via `SFHFKeychainUtils` under service `SunGard`.
4. Feature controllers read the password back out of the Keychain when they need to
   authenticate a request.
5. **Logout deletes the Keychain item** and dismisses the session — no stale credential is
   left behind on the device.

⚠️ **Security note, stated plainly.** `GradesController` and `ScheduleViewer` authenticate
by embedding credentials in the URL (`http://user:pass@host/…`) rather than by setting an
`Authorization` header, and `urlPrefix` ships as `http://`. That was defensible on a
trusted campus network in 2011; it is not defensible today. Before any modern deployment:
set `urlPrefix` to `https://`, and move those two call sites onto the shared
`AFSunGardAPIClient` so credentials travel in a header rather than in a URL that can land
in server logs, proxy logs, and `NSURLCache`. See [Notes for modern builds](#notes-for-modern-builds).

## Project layout

```
SunGardConnect.xcodeproj
SunGardConnect/
├── SunGardConnectAppDelegate.{h,m}   # Window + root navigation controller
├── AuthenticationController.{h,m}    # Login, credential validation, session hand-off
├── StudentCenterController.{h,m}     # Root menu; owns the Student and routes to features
├── GradesController.{h,m}            # Recursive multi-term grade fetch + table rendering
├── ScheduleViewer.{h,m}              # Mon–Fri schedule window
├── MapView.{h,m}                     # MapKit campus map
├── DisplayMap.{h,m}                  # Lightweight MKAnnotation model
├── Web.{h,m}                         # Reusable UIWebView controller w/ share sheet
├── AboutViewController.{h,m}         # Credits and contact links
├── Student.{h,m}                     # Session model; Keychain façade
├── Schedule.{h,m}                    # Schedule value object
├── AFSunGardAPIClient.{h,m}          # ⚙️ Server configuration lives here
├── AFNetworking/                     # Vendored HTTP stack (MIT)
├── JSONKit/                          # Vendored JSON parser (BSD/Apache)
├── Keychain/SFHFKeychainUtils.{h,m}  # Keychain wrapper (MIT)
├── TTT/TTTLocationFormatter.{h,m}    # Human-readable coordinate/distance formatting (MIT)
├── en.lproj/                         # MainWindow.xib, AuthenticationController.xib, strings
└── *.png / *@2x.png                  # Retina-ready menu iconography
```

Dependencies are **vendored, not managed** — this predates CocoaPods being the default, so
the tree clones and builds with no package step at all.

## Getting started

```bash
git clone https://github.com/<your-org>/SunGard-iOS-API-for-Mobile-Connection.git
cd SunGard-iOS-API-for-Mobile-Connection
open SunGardConnect.xcodeproj
```

**Configure your server.** Open `SunGardConnect/AFSunGardAPIClient.m`. It will not compile
until you do — that is intentional:

```objc
#error Enter URL
// Base URL of the Mobile Connection Server, without a scheme.
// Must end with /rest/
// Example: mobilebanner.school.edu:8041/mobileserver/rest/
NSString * const baseURLofServer = @"";
// Use http:// for non-SSL or https:// for SSL
NSString * const urlPrefix = @"http://";
```

Fill in `baseURLofServer`, set `urlPrefix` to `https://`, delete the `#error` line, and
build. Sign in with any valid Banner account for that institution.

## Adapting it to your campus

Four edits turn this into a different school's app:

1. **Server** — `AFSunGardAPIClient.m`, as above.
2. **Map** — `MapView.m` builds its pins inline. Replace the region center/span and the
   `DisplayMap` annotation list with your own buildings. (A worthwhile first refactor:
   move the 21 hard-coded annotations into a bundled plist and loop over it.)
3. **Support address & links** — `StudentCenterController.m` (mail recipient),
   `AboutViewController.m` (web/Twitter), and the Twitter URL in the menu's row 4.
4. **Branding** — the icons in `SunGardConnect/` and the two XIBs in `en.lproj/`.

The campus coordinates shipped in this repo (≈ 42.336, −71.095) frame Wentworth Institute
of Technology in Boston, which is where the app was originally targeted.

## Requirements

| | |
|---|---|
| **Language** | Objective-C, manual retain/release (pre-ARC) |
| **Deployment target** | iOS 3.1.3+ |
| **Architectures** | `$(ARCHS_STANDARD_32_BIT)` (armv6/armv7) |
| **Project format** | Xcode 3.2 compatible, `objectVersion = 46` |
| **System frameworks** | UIKit, Foundation, CoreGraphics, MapKit, CoreLocation, MessageUI, Security, SystemConfiguration |
| **Backend** | SunGard Higher Education Banner **Mobile Connection Server** with the REST endpoints above enabled |

## Notes for modern builds

This is a preserved 2011 codebase, and it reads like one — in a useful way, if you want to
see how iOS apps were written before ARC, storyboards, and `NSURLSession`. To bring it
forward on a current toolchain:

- **Memory management.** The project is MRR throughout. Either keep
  `-fno-objc-arc` on these files or convert with Xcode's ARC migrator. (Watch for the
  `dealloc` implementations in `Schedule.m` and `ScheduleViewer.m` that call
  `[super dealloc]` *before* releasing ivars — an ordering bug the migrator will happily
  erase for you.)
- **Networking.** The vendored AFNetworking predates the 1.0 API. Migrating to a current
  release, or to `NSURLSession` directly, replaces `AFJSONRequestOperation` +
  `NSOperationQueue` with async/await-friendly calls — and lets JSONKit go away entirely
  in favour of `NSJSONSerialization`.
- **Transport security.** ATS will reject the default `http://` configuration outright.
  Move to `https://` rather than adding an ATS exception.
- **Deprecated UIKit.** `presentModalViewController:animated:`, `UIWebView`,
  `UITextAlignmentCenter`, and `shouldAutorotateToInterfaceOrientation:` all have modern
  replacements (`presentViewController:animated:completion:`, `WKWebView`,
  `NSTextAlignmentCenter`, `supportedInterfaceOrientations`).
- **MapKit.** `MKPinAnnotationView` still works; `MKMarkerAnnotationView` looks like this
  decade. Also note `-mapView:viewForAnnotation:` compares titles with `==` rather than
  `isEqualToString:` — a pointer comparison that happens to work only for literals.

None of these block reading the code, and the API contract it documents is unchanged.

## Third-party components

| Component | Purpose | License |
|---|---|---|
| [AFNetworking](https://github.com/AFNetworking/AFNetworking) (pre-1.0) | HTTP client, JSON request operations, image cache, network activity indicator | MIT |
| [JSONKit](https://github.com/johnezang/JSONKit) | JSON parsing | BSD / Apache 2.0 |
| [SFHFKeychainUtils](https://github.com/ldandersen/scifihifi-iphone) | Keychain read/write/delete wrapper | MIT |
| [TTTLocationFormatter](https://github.com/mattt/FormatterKit) | Human-readable coordinates and distances | MIT |

`AFSunGardAPIClient` is adapted from AFNetworking's `AFGowallaAPIClient` sample and retains
its original MIT header.

## License

Released under the **MIT License**. The source is provided "as is", without express or
implied warranty.

Originally written by **Sonny Fazio** (2011). *SunGard* and *Banner* are trademarks of
their respective owners; this project is not affiliated with or endorsed by SunGard Higher
Education or Ellucian.
