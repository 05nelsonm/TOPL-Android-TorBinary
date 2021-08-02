# Changelog

## Version 0.4.6.5 (2021-08-02)
 - Remove previous git patch (RMB container for build was fixed upstream)
 - Tor Binaries for v0.4.6.5

## Version 0.4.6.2-alpha (2021-05-06)
 - Add git patch file to fix RBM container dependencies needed for OpenJdk8 and update build script
 - Tor Binaries for v0.4.6.2-alpha

## Version 0.4.5.6 (2021-02-24)
 - Tor Binaries for v0.4.5.6

## Version 0.4.5.4 (2021-01-28)
 - Adds reproducably built work flow using The Tor Project's tor-browser-build 
 and removes direct reliance on Guardian Project's tor-android project.
 - Bumps Gradle, AndroidGradle plugin, and Gradle Maven Publish versions
 - Tor Binaries for v0.4.5.4-rc

## Version 0.4.4.0 (2020-10-17)
 - Adds to BuildConfig the following values
     + `TOR_BINARY_VERSION_CODE`
     + `TOR_BINARY_VERSION_NAME`
 - Bumps Gradle and AndroidGradle plugin versions
 - Removes re-building of the binaries and simply copies the latest over from `tor-android`
     + Updates README with steps for verifying the sha256sums of all binaries supplied to prove no alteration was had between those generated and supplied by The Guardian Project, and those supplied by this repositor.

## Version 0.4.3.6 (2020-08-23)
 - Updated script to account for new branch naming convention of `tor-android`
 - Tor Binaries for v0.4.3.6

## Version 0.4.3.5a (2020-07-08)
 - Fixes NDK_BIT value used when building binaries for specific ABIs
    - 32 bit for x86/armeabi-v7a & 64 bit for x86_64/arm64-v8a
 - Tor Binaries for v0.4.3.5
 
## Version 0.4.3.5 (2020-07-07)
 - Initial Release
 - Tor Binaries for v0.4.3.5
 
