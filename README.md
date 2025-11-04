# Swift Slots

Swift Slots is a SwiftUI iOS 16+ demo that showcases the end-to-end flow for discovering and booking discounted last-minute cancellation slots at gyms, salons, and clinics around Austin, Texas.

## Project Structure

```
SwiftSlots/
├── SwiftSlotsApp.swift
├── Core/
│   ├── Models/
│   ├── Services/
│   └── Store/
├── UI/
│   ├── Components/
│   ├── Screens/
│   └── Style/
├── Utils/
└── Assets.xcassets/
```

Open `SwiftSlots.xcodeproj` in Xcode 15 or newer. The app targets iOS 16 and uses SwiftUI with Combine and MapKit.

## Build & Run

1. Open the project in Xcode: `open SwiftSlots/SwiftSlots.xcodeproj`.
2. Select the **SwiftSlots** scheme and an iOS Simulator (iPhone 14 recommended).
3. Build and run (`⌘R`).

No external dependencies are required.

## Demo Test Plan

1. Complete onboarding by choosing categories (try toggling **Demo Mode**).
2. Accept location & notification permissions on the permissions screen.
3. Browse the feed, adjust filters, and pull to refresh.
4. Open a slot, review details, and tap **Book Now**.
5. Complete the checkout flow with the mock Apple Pay button to reach confirmation.
6. Add the reservation to calendar, share, and close the sheet.
7. Watch a slot and verify it appears in the Watchlist tab; use **Simulate Push**.
8. Visit the Debug Panel from the feed toolbar to spawn cancellations and trigger notifications.
