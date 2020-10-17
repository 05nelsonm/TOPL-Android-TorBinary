# TOPL-Android-TorBinary
Tor Binary build for Android

Installs the Tor executable file in your Android Application's
native library directory (`/data/app/...`) with the file name `libTor.so`.  

Used primarily for the <a href="https://topl-android.matthewnelson.io/" target="_blank">TorOnionProxyLibrary-Android</a> project.  

## Implementation

- In your Application module's `build.gradle` file, add the following to the `dependencies` block:
```groovy
implementation "io.matthewnelson.topl-android:tor-binary:0.4.4.0"
```

- In your Application module's `build.gradle` file, add the following to the `android` block:
```groovy
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
```

- If your application's `minSdkVersion` is 23 or greater, add to the `AndroidManifest.xml`, within 
the `application` tag:
```
android:extractNativeLibs="true"
```

- Celebrate, nothing more is needed.

## More Info  

This would be the file if you need it in your app:
```kotlin
val torExecutable = File(context.applicationInfo.nativeLibraryDir, "libTor.so")
```

## Where do the binaries come from?  

Binaries are copied from The GuardianProject's <a href="https://github.com/guardianproject/tor-android" target="_blank">tor-android</a>
project and renamed to libTor.so, then moved to properly named directories for the respective ABI output. No unnecessary classes are included, only the binaries.  

See <a href="https://github.com/guardianproject/tor-android/issues/28#issuecomment-661845483" target="_blank">here</a> for more information on why.

## Checksum Verification of binaries

Clone the repo and initialize submodules:
```
git clone https://github.com/05nelsonm/TOPL-Android-TorBinary.git
cd TOPL-Android-TorBinary/
git submodule update --init
```

Verify the sha256sum of all binaries simply by running:
```
./gradlew build
```

And then verifying that no changes were made to the binaries in master branch by running:
```
git status
```
