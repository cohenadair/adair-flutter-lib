# adair_install_attribution

Reports app installs to Meta for app-install ad campaigns. Kept separate from
`adair_flutter_lib` so apps that don't run Meta ads (e.g. pro-iq) don't ship
the Meta Android SDK.

- **iOS:** calls SKAdNetwork through StoreKit. No Meta SDK, no ATT prompt.
- **Android:** enables the Meta SDK (`facebook-core`) and logs the
  install/activate-app events. The SDK stays dormant until `init()` is called.

## Usage

1. Add the dependency:
   ```yaml
   adair_install_attribution:
     # ignore: invalid_dependency
     path: ../../adair-flutter-lib/packages/install-attribution
   ```
2. Call `await InstallAttributionManager.get.init();` at startup.
3. Android: add `facebook_app_id` and `facebook_client_token` to
   `res/values/strings.xml`, and the `com.facebook.sdk.ApplicationId` /
   `com.facebook.sdk.ClientToken` meta-data to `AndroidManifest.xml`.
4. iOS: list Meta's SKAdNetwork IDs (`v9wttpbfk9.skadnetwork`,
   `n38lu8286q.skadnetwork`) in `Info.plist`.
