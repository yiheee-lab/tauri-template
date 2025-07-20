# GitHub Actions Workflows

This directory contains the CI/CD workflows for the Tauri template project. The workflows are designed with automatic version management and comprehensive cross-platform building.

## 🏗️ Workflow Architecture

### Core Workflows

1. **[main.yml](./main.yml)** - Main CI/CD Pipeline
   - Orchestrates the entire build process
   - Includes automatic version checking and increment
   - Builds for all platforms (Windows, macOS, Linux, Android, iOS)

2. **[release.yml](./release.yml)** - Release Creation
   - Creates GitHub releases with artifacts
   - Handles release notes and asset uploads

### Utility Workflows

3. **[version-check.yml](./version-check.yml)** - Version Management
   - Compares current version with latest release
   - Auto-increments version if conflict detected
   - Updates both `package.json` and `src-tauri/Cargo.toml`

4. **[extract-metadata.yml](./extract-metadata.yml)** - Metadata Extraction
   - Extracts app name and version from `package.json`
   - Provides reusable metadata for other workflows

### Platform-Specific Build Workflows

5. **[build-windows.yml](./build-windows.yml)** - Windows builds (.msi, .exe)
6. **[build-macos.yml](./build-macos.yml)** - macOS builds (.dmg, .app.tar.gz)
7. **[build-linux.yml](./build-linux.yml)** - Linux builds (.deb, .rpm, .AppImage)
8. **[build-android.yml](./build-android.yml)** - Android builds (.apk, .aab)
9. **[build-ios.yml](./build-ios.yml)** - iOS builds (.ipa)

## 🔄 Automatic Version Management

### How It Works

1. **Version Check**: When code is pushed to `main`, the workflow compares the current `package.json` version with the latest GitHub release.

2. **Auto-Increment**: If versions match (indicating a duplicate), the workflow:
   - Increments the patch version (e.g., `1.0.0` → `1.0.1`)
   - Updates `package.json` and `src-tauri/Cargo.toml`
   - Commits changes with `[skip ci]` message
   - Pushes to repository, triggering a new CI/CD run

3. **Build Process**: If version is unique, proceeds with normal CI/CD pipeline.

### Version Format

- Uses semantic versioning: `MAJOR.MINOR.PATCH`
- Auto-increment only affects PATCH version
- Manual version changes (MAJOR/MINOR) are respected

### Triggering Conditions

| Event | Version Check | Build Process |
|-------|---------------|---------------|
| Push to `main` | ✅ Yes | Only if version is unique |
| Pull Request | ❌ No | ✅ Yes (always) |
| Manual Dispatch | 🔧 Optional | ✅ Yes |

## 🚀 Usage

### Automatic Builds

Simply push to `main` branch:
```bash
git push origin main
```

The workflow will:
1. Check if your version conflicts with existing releases
2. Auto-increment if needed, or proceed with build
3. Build for all platforms
4. Generate build summary

### Manual Builds

Use GitHub Actions UI to trigger manually:
1. Go to **Actions** tab
2. Select **CI/CD Pipeline**
3. Click **Run workflow**
4. Optionally skip version check

### Creating Releases

After successful builds:
1. Go to **Actions** tab
2. Select **Release** workflow
3. Click **Run workflow**
4. Specify version tag (e.g., `v1.0.0`)

## 📋 Build Outputs

### Artifact Naming Convention

All artifacts follow the pattern:
```
{app-name}-{version}-{platform}-{architecture}.{extension}
```

Examples:
- `tauri-template-1.0.0-windows-x64.msi`
- `tauri-template-1.0.0-macos-universal.dmg`
- `tauri-template-1.0.0-linux-x64.AppImage`
- `tauri-template-1.0.0-android-universal.apk`
- `tauri-template-1.0.0-ios-universal.ipa`

### Platform Support

| Platform | Architectures | Formats |
|----------|---------------|---------|
| Windows | x64, x86, ARM64 | `.msi`, `.exe` |
| macOS | Universal, Intel, Apple Silicon | `.dmg`, `.app.tar.gz` |
| Linux | x64, ARM64 | `.deb`, `.rpm`, `.AppImage` |
| Android | Universal, ARM64, ARMv7, x86_64 | `.apk`, `.aab` |
| iOS | Universal | `.ipa` |

## 🔧 Configuration

### Required Secrets

For signing and publishing (see [SECRETS.md](../SECRETS.md)):
- `APPLE_CERTIFICATE_*` - macOS/iOS code signing
- `ANDROID_KEYSTORE_*` - Android app signing
- `WINDOWS_CERTIFICATE_*` - Windows code signing

### Customization

#### Skip Version Check
```yaml
# In workflow_dispatch input
skip-version-check: true
```

#### Modify Build Platforms
Edit `main.yml` to include/exclude platform builds:
```yaml
# Comment out unwanted platforms
# build-ios:
#   name: 'Build iOS'
#   ...
```

#### Change Version Increment Logic
Modify `version-check.yml` to change increment behavior:
```bash
# Current: increments patch (1.0.0 → 1.0.1)
NEW_PATCH=$((PATCH + 1))

# Alternative: increment minor (1.0.0 → 1.1.0)
NEW_MINOR=$((MINOR + 1))
NEW_VERSION="${MAJOR}.${NEW_MINOR}.0"
```

## 🛠️ Troubleshooting

### Common Issues

1. **Version Increment Loop**
   - Check for `[skip ci]` in commit messages
   - Verify git configuration in workflow

2. **Build Failures**
   - Check individual platform workflow logs
   - Verify dependencies and signing certificates

3. **Missing Artifacts**
   - Ensure build completed successfully
   - Check artifact retention settings

### Debug Mode

Enable debug logging by setting repository secret:
```
ACTIONS_STEP_DEBUG = true
```

## 📚 Related Documentation

- [Secrets Configuration](../SECRETS.md)
- [Tauri Documentation](https://tauri.app/v1/guides/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🔄 Workflow Dependencies

```mermaid
graph TD
    A[Push to main] --> B[version-check.yml]
    B --> C{Version Conflict?}
    C -->|Yes| D[Auto-increment & Push]
    C -->|No| E[extract-metadata.yml]
    D --> F[New CI/CD Run]
    E --> G[build-windows.yml]
    E --> H[build-macos.yml]
    E --> I[build-linux.yml]
    E --> J[build-android.yml]
    E --> K[build-ios.yml]
    G --> L[build-summary]
    H --> L
    I --> L
    J --> L
    K --> L
```

This architecture ensures reliable, automated builds with intelligent version management and comprehensive platform support.
