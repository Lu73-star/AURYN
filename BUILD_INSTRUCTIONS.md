# Build Instructions for AURYN

This document provides step-by-step instructions to build the AURYN Flutter app after the migration from AURYN-offline-.

## Prerequisites

✅ All prerequisites are already satisfied in this repository:
- Flutter SDK 3.24.5+ installed
- Dart SDK 3.5.4+ installed
- Android SDK with API level 21+ (minSdk)
- All source code and assets migrated
- Android configuration updated

## Build Commands

### Option 1: Standard Build (Requires Network Access)

If you have network access to `storage.googleapis.com` and `pub.dev`:

```bash
# Navigate to project directory
cd /home/runner/work/AURYN/AURYN

# Add Flutter to PATH (if using snap installation)
export PATH="/snap/bin:$PATH"

# Clean any previous build artifacts
flutter clean

# Download all dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Or build release APK (requires signing configuration)
flutter build apk --release
```

The APK will be generated at:
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`
- Release: `build/app/outputs/flutter-apk/app-release.apk`

### Option 2: Offline Build (Network Restricted)

If network access is restricted, you need to pre-download and cache Flutter dependencies:

#### Step 1: Download Required Packages

On a machine with network access:

```bash
# Create a temporary Flutter project with same dependencies
flutter create temp_project
cd temp_project

# Copy the pubspec.yaml from AURYN project
# Then download dependencies
flutter pub get

# Copy the entire .pub-cache to transfer
tar czf pub-cache.tar.gz ~/.pub-cache/
```

#### Step 2: Download Flutter Engine Artifacts

```bash
# Download sky_engine (replace ENGINE_HASH with actual version)
ENGINE_HASH="a18df97ca57a249df5d8d68cd0820600223ce262"
wget "https://storage.googleapis.com/flutter_infra_release/flutter/${ENGINE_HASH}/sky_engine.zip"

# Download other required artifacts as needed
```

#### Step 3: Transfer and Extract

Transfer the archives to your build environment and extract:

```bash
# Extract pub cache
mkdir -p ~/.pub-cache
tar xzf pub-cache.tar.gz -C ~/

# Extract sky_engine to Flutter SDK
unzip sky_engine.zip -d $FLUTTER_ROOT/bin/cache/pkg/
```

#### Step 4: Build

```bash
cd /home/runner/work/AURYN/AURYN
export PATH="/snap/bin:$PATH"

# Build without attempting network downloads
flutter build apk --debug --offline
```

## Troubleshooting

### Issue: "Failed to download sky_engine"

**Solution:** Follow Option 2 above to pre-download the package.

### Issue: "Package not found"

**Solution:** Verify all dependencies in `pubspec.yaml` are cached:

```bash
flutter pub cache list
```

### Issue: "Gradle build failed"

**Solution:** Check Android SDK installation:

```bash
flutter doctor -v
```

Ensure Android SDK, Android SDK Platform, and Android SDK Build-Tools are installed.

### Issue: "SDK version conflict"

**Solution:** Verify SDK constraints in `pubspec.yaml`:

```yaml
environment:
  sdk: '>=3.5.0 <4.0.0'
```

## Build Configuration

### Debug Build
- Faster build time
- Includes debug symbols
- Larger APK size
- Suitable for testing

### Release Build
- Optimized for performance
- Minified code
- Smaller APK size
- Requires signing configuration

To configure release signing, edit `android/app/build.gradle`:

```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias 'your-key-alias'
            keyPassword 'your-key-password'
            storeFile file('path/to/your/keystore.jks')
            storePassword 'your-store-password'
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## Verify Build

After successful build:

```bash
# List generated APKs
ls -lh build/app/outputs/flutter-apk/

# Get APK info
apkanalyzer apk summary build/app/outputs/flutter-apk/app-debug.apk

# Install on connected device
flutter install
```

## Expected Output

Successful build output should look like:

```
✓ Built build/app/outputs/flutter-apk/app-debug.apk (XX.XMB)
```

## Next Steps After Build

1. **Test the APK**
   ```bash
   flutter install
   flutter run
   ```

2. **Analyze the build**
   ```bash
   flutter build apk --analyze-size
   ```

3. **Generate release for distribution**
   ```bash
   flutter build apk --release --split-per-abi
   ```

## Build Performance

Typical build times:
- First build (cold): 5-10 minutes
- Incremental builds: 30-60 seconds
- Clean rebuild: 3-5 minutes

Build artifacts use approximately:
- Debug APK: 40-60 MB
- Release APK: 15-25 MB
- Build cache: 200-500 MB

## Support

For build issues:
- Check Flutter doctor: `flutter doctor -v`
- Check Flutter version: `flutter --version`
- Check project config: `flutter analyze`
- View detailed logs: `flutter build apk --debug --verbose`

## Migration Notes

This project was migrated from `AURYN-offline-` to the new Flutter 3.24.5+ structure.

**Key Changes:**
- Package name: `auryn_offline` → `auryn`
- All imports updated
- Android configuration modernized
- All 61 Dart files migrated
- All assets preserved

See `MIGRATION_STATUS.md` for complete migration details.
