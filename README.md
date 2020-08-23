# TOPL-Android-TorBinary
Tor Binary build for Android

Installs the Tor executable file in your Android Application's
native library directory (`/data/app/...`) with the file name `libTor.so`.  

Used primarily for the <a href="https://topl-android.matthewnelson.io/" target="_blank">TorOnionProxyLibrary-Android</a> project.  

This is a temporary work-around while I build a gradle plugin to more easily distribute binaries.
## Implementation

- In your Application module's `build.gradle` file, add the following to the `dependencies` block:
```groovy
implementation "io.matthewnelson.topl-android:tor-binary:0.4.3.6"
```

- In your Application module's `build.gradle` file, add the following to the `android` block:
```groovy
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
```

- Celebrate, nothing more is needed.

## More Info  

This would be the file if you need it in your app:
```kotlin
val torExecutable = File(context.applicationInfo.nativeLibraryDir, "libTor.so")
```  

## Where do the binaries come from?  

They are built using The GuardianProject's <a href="https://github.com/guardianproject/tor-android" target="_blank">tor-android</a>
project, then copied to  
the `tor-binary` module. Doesn't come with anything but the executables.

See `RELEASING.md`, `scripts/update_tor_binaries.sh` and `external/tor-android/` for more info.
