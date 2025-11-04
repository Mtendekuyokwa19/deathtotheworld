# Flutter Development Without Working USB Ports

## Your Current Situation

- PC: i5-4300 (4th gen), 8GB RAM, NixOS
- USB ports have hardware issues
- Using phone hotspot for internet
- Phone IP changes when hotspot restarts

## Quick Reference: Find Your Phone's IP

```bash
# Phone IP is always the gateway
ip route | grep default
```

The IP after "via" is your phone's current IP.

## Initial Setup (One-Time - Requires Brief USB/ADB Connection)

**Enable TCP mode on phone:**

```bash
adb tcpip 5555
```

**Note:** This requires an existing connection (USB or already-enabled wireless ADB). Once enabled, it persists until phone reboot.

## Daily Workflow: Connect to Phone

### Step 1: Get Phone's Current IP

```bash
ip route | grep default
# Example output: default via 10.93.110.247 dev wlp3s0 ...
# Your phone IP: 10.93.110.247
```

### Step 2: Connect ADB

```bash
# Replace with your actual phone IP
adb connect 10.93.110.247:5555

# Verify connection
adb devices
```

### Step 3: Run Flutter

```bash
flutter devices
flutter run
```

## When Connection is Lost

**Reconnect with current IP:**

```bash
# Get new IP
ip route | grep default

# Connect
adb connect YOUR_PHONE_IP:5555
```

## Permanent Solution: Install Wireless ADB App

To avoid losing connection after phone reboots:

1. While ADB is connected, download on phone:
   - "Wireless ADB" by Henry
   - "adb WiFi" by Schillaci
   - "WiFi ADB - Debug Over Air"

2. These apps let you enable TCP mode from the phone itself

3. After phone reboot:
   - Open wireless ADB app on phone
   - Tap "Enable" or "Start"
   - On PC: `adb connect PHONE_IP:5555`

## NixOS Configuration

**Add to `/etc/nixos/configuration.nix`:**

```nix
{
  # Enable ADB
  programs.adb.enable = true;

  # Add your user to adbusers group
  users.users.YOUR_USERNAME.extraGroups = [ "adbusers" ];

  # Development tools
  environment.systemPackages = with pkgs; [
    android-tools  # adb, fastboot
    flutter
  ];

  # Optional: Open ADB port in firewall
  networking.firewall.allowedTCPPorts = [ 5555 ];
}
```

**Rebuild and reboot:**

```bash
sudo nixos-rebuild switch
# Log out and back in for group changes
```

## Troubleshooting

### Connection Fails

```bash
# Kill and restart ADB server
adb kill-server
adb start-server

# Try connecting again
adb connect PHONE_IP:5555
```

### Phone Not Showing in Flutter

```bash
# Check ADB connection
adb devices

# Should show:
# PHONE_IP:5555    device

# If shows "unauthorized" - check phone for popup
# If shows "offline" - disconnect and reconnect
```

### IP Address Changed

```bash
# Always check current IP first
ip route | grep default

# Then connect with new IP
adb connect NEW_IP:5555
```

### After Phone Reboot

**Without wireless ADB app:**

- You need USB connection to run `adb tcpip 5555` again
- Or install wireless ADB app (see above)

**With wireless ADB app:**

1. Open app on phone
2. Enable ADB
3. On PC: `adb connect PHONE_IP:5555`

## Keep Connection Stable

**On Phone (Developer Options):**

- Enable "Stay awake" (screen stays on while charging)
- Keep USB debugging enabled
- Don't reboot phone unnecessarily

**On PC:**

- Keep hotspot connected
- Don't kill ADB server
- Connection can persist for days/weeks

## Alternative: Build APK Method (No ADB Needed)

If all else fails:

```bash
# Build debug APK
flutter build apk --debug

# APK location:
# build/app/outputs/flutter-apk/app-debug.apk

# Transfer to phone via:
# - Bluetooth file transfer
# - SD card (if available)
# - Keep hotspot on and use file sharing apps
```

Install APK manually on phone. Very slow iteration but works offline.

## Hardware Solutions (Recommended)

Spending $5-15 on hardware will save hours of frustration:

- **USB PCI card** (desktop): $5-10
- **Powered USB hub**: $10-15
- **USB-to-Bluetooth adapter**: $5-8

Even one working USB port solves everything permanently.

## Quick Commands Reference

```bash
# Find phone IP
ip route | grep default

# Connect to phone
adb connect PHONE_IP:5555

# Check devices
adb devices

# Run Flutter
flutter devices
flutter run

# Disconnect
adb disconnect PHONE_IP:5555

# Restart ADB
adb kill-server
adb start-server
```

## Notes

- Phone IP changes when hotspot restarts
- Always verify IP with `ip route | grep default` before connecting
- Install wireless ADB app ASAP to survive phone reboots
- Connection persists until phone reboot or hotspot restart
- Keep Developer Options and USB debugging enabled on phone
