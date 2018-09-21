# Timesheets

_Create Harvest timesheet entries in bulk, right from your pocket computer_

<img src="https://raw.githubusercontent.com/rhysforyou/Timesheets/master/Media/Screenshot.png" width="430" />

---

Timesheets is a tiny, barely functional iOS app for entering Harvest timesheet entries in bulk.

## Building

You'll need a few things to build this app:

- An Apple developer account
- Xcode 10
- [Carthage](https://github.com/Carthage/Carthage)

With those dependencies satisfied, building it should be mostly straightforward:

1. Install [Carthage](https://github.com/Carthage/Carthage) if you don't have it, and then run `carthage bootstrap --platform ios` from the project root.
2. Open the [Developers](https://id.getharvest.com/developers) section of your Harvest ID and create a new Personal Access Token. Make a note of this token and the Account ID for the organisation you want to use Timesheets with.
3. Duplicate the _APIKeys.sample.plist_ file in the _Timesheets_ directory and rename it to _APIKeys.plist_, then edit it and replace the placeholder Personal Access Token and Account ID values with the ones you got in step 2.
4. Open _Timesheets.xcodeproj_ and change the developer team for the _Timesheets_, _TimesheetsTests_, and _TimesheetsUITests_ targets to your own
