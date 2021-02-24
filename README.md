# TOPL-Android-TorBinary
Tor Binary build for Android

Installs the Tor executable file in your Android Application's
native library directory (`/data/app/...`) with the file name `libTor.so`.  

Used primarily for the <a href="https://topl-android.matthewnelson.io/" target="_blank">TorOnionProxyLibrary-Android</a> project.  

## Implementation

- In your Application module's `build.gradle` file, add the following to the `dependencies` block:
```groovy
implementation "io.matthewnelson.topl-android:tor-binary:0.4.5.6"
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

Binaries are reproducably built from The Tor Project's <a href="https://gitweb.torproject.org/builders/tor-browser-build.git/" target="_blank">tor-browser-build</a>.

See <a href="https://github.com/05nelsonm/TOPL-Android-TorBinary/blob/master/scripts/build_binaries.sh" target="_blank">here</a> for more information.

## Building Yourself

Clone the repo and initialize submodules:
```
git clone https://github.com/05nelsonm/TOPL-Android-TorBinary.git
cd TOPL-Android-TorBinary/
git submodule update --init
```

Install dependencies
```
# See tor-browser-build's README for needed dependencies and install them
cd external/tor-browser-build
nano README
```

Initialize tor-browser-build's rbm submodule
```
make submodule-update

# Change directories back to root project location
cd ../..
```

Run the build script
```
# From project's root directory
scripts/build_binaries.sh
```
