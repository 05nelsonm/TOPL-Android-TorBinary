<!-- Thanks Square for providing great documentation that I only had to tweak -->
<!-- https://raw.githubusercontent.com/square/leakcanary/master/docs/releasing.md -->

# Releasing TOPL-Android-TorBinary

- Create a local release branch from `master`
```
git checkout master
git pull
git checkout -b release_<TOR_VERSION>
```

- Build Tor binaries & copy them to tor-binary/src/main/jniLibs/ directory
```
./gradlew tor-binary:updateTorBinaries
```

- Update `VERSION_NAME` (remove `-SNAPSHOT`) in `tor-binary/gradle.properties`
```gradle
VERSION_NAME=<TOR_VERSION>
```

- Update Version in README.md

- Take one last look
```
git diff
```

- Commit all local changes and PGP sign
```
git commit -S -am "Prepare <TOR_VERSION> release"
```

- Perform a clean build
```
./gradlew clean
./gradlew build
```

- Create a PGP signed tag, and push it
```
git tag -s <TOR_VERSION> -m "Release v<TOR_VERSION>"
git push origin <TOR_VERSION>
```

- Make sure you have valid credentials in `~/.gradle/gradle.properties` to sign and upload the artifacts
```
SONATYPE_NEXUS_USERNAME=<Your Username>
SONATYPE_NEXUS_PASSWORD=<Your Password>

signing.gnupg.homeDir=/home/matthew/.gnupg/
signing.gnupg.optionsFile=/home/matthew/.gnupg/gpg.conf
signing.gnupg.keyName=0x61471B8AB3890961
```

- Upload the artifacts to Sonatype OSS Nexus
```
./gradlew uploadArchives --no-daemon --no-parallel
```

- Release to Maven Central
    - Login to Sonatype OSS Nexus: <a href="https://oss.sonatype.org/#stagingRepositories" target="_blank">oss.sonatype.org</a>
    - Click on **Staging Repositories**
    - Scroll to the bottom, you should see an entry named `iomatthewnelson-XXXX`
    - Check the box next to the `iomatthewnelson-XXXX` entry, click **Close** then **Confirm**
    - Wait a bit, hit **Refresh**, until the *Status* for that column changes to *Closed*.
    - Check the box next to the `iomatthewnelson-XXXX` entry, click **Release** then **Confirm**

- Merge the release branch to master
```
git checkout master
git pull
git merge --no-ff -S release_<TOR_VERSION>
```

- Update `VERSION_NAME` (increase version and add `-SNAPSHOT`)  and `VERSION_CODE` in `gradle.properties`
```gradle
VERSION_NAME=REPLACE_WITH_NEXT_VERSION_NUMBER-SNAPSHOT
VERSION_CODE=INCREMENT
```

- Commit your changes and sign with PGP keys
```
git commit -S -am "Prepare for next development iteration"
```

- Push your changes
```
git push
```

- Wait for the release to become available on <a href="https://repo1.maven.org/maven2/io/matthewnelson/topl-android/" target="_blank">Maven Central</a>, then:
    - Go to the <a href="https://github.com/05nelsonm/TOPL-Android-TorBinary/releases/new" target="_blank">Draft a new release</a> page,
      enter the release name ({{ topl_android.next_release }}) as tag and title, and have the description
      point to the changelog. You can find the direct anchor URL from the
      <a href="https://topl-android.matthewnelson.io/changelog/" target="_blank">Change Log</a>
      page on the doc site.