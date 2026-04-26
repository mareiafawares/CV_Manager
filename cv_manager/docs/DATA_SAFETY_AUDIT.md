# CV Manager — Data fields & Google Play Data safety (code audit)

Codebase snapshot: `cv_manager/`. This matches **what the app actually does**; answer the Play **Data safety** form to match (update if you change the app).

---

## 1. Third parties & SDKs (must match Play + policies)

| Component | In project | Effect on data |
|-----------|------------|------------------|
| **Firebase Auth** | `firebase_auth` | Account email, Firebase UID; passwords handled by Google (not stored in your app code). |
| **Cloud Firestore** | `cloud_firestore` | All structured fields in tables below. |
| **Firebase Analytics (Android)** | `com.google.firebase:firebase-analytics` in `android/app/build.gradle.kts` | **Declare** analytics / app activity in Data safety (see §4). Analytics has user-level controls; follow current Play guidance. |
| **Google Fonts** | `google_fonts` | Fetches font files (e.g. Poppins) at runtime; requests go to **Google**; typically declare only if the form requires “network” / provider disclosure—often bundled under “service provider” or not personal data, but be transparent. |
| **PDF / printing / screenshot** | `pdf`, `printing`, `screenshot` | **Local** generation/sharing; no server upload in code. |
| **path_provider** | `path_provider` | Local paths only. |
| **firebase_storage (pubspec)** | Listed in `pubspec.yaml` | **No `FirebaseStorage` usage in `.dart` files** — you are not uploading user files to Storage in the current app. You can **remove** the dependency later to avoid confusion, or keep and still **not** declare file uploads if you never use it. |

---

## 2. All Firestore fields (by collection)

### `users` (`auth_service.dart` on email/password sign-up)

| Field | Type / notes |
|-------|----------------|
| `uid` | `String` — same as Firebase Auth user id |
| `name` | `String` |
| `email` | `String` |
| `createdAt` | `DateTime` / server timestamp style |

> **Note:** `signUp` (email/password) writes this document. If a `users/{uid}` doc is missing, align support and data deletion with the account data that actually exists in **Auth** + **cvs** collections.

### `cvs` (`cv_preview_screen.dart`, `home.dart`, `community_screen.dart`)

Stored at document root as spread `userData` plus:

| Field | Type / notes |
|-------|----------------|
| `name` | Full name (CV) |
| `jobTitle` | String |
| `summary` | String (professional summary) |
| `phone` | String |
| `email` | String (can duplicate account email) |
| `address` | String (may contain city/country) |
| `skills` | `List` of skill strings |
| `experience` | `List` of maps: `company`, `role`, `years` |
| `templateId` | `int` |
| `isPublic` | `bool` — if `true`, CV is visible in community query |
| `userId` | `String` — owner’s Firebase uid |
| `createdAt` | `FieldValue.serverTimestamp()` on create |

**Community / engagement (same collection):**

| Field | Type / notes |
|-------|----------------|
| `likesCount` | `int` (updated via `increment`) |

**Legacy:** Older docs may nest fields under `userData` (see `home.dart` — `_existingCvDataForEditor`).

### `notifications` (`community_screen.dart`, `notifications_screen.dart`, `main_wrapper.dart`)

| Field | Type / notes |
|-------|----------------|
| `receiverId` | `String` — user uid |
| `senderId` | `String` — user uid |
| `senderName` | `String` — from `currentUser.displayName` or `"User"` |
| `message` | `String` (e.g. "liked your CV (…)") |
| `createdAt` | server timestamp |
| `isRead` | `bool` |

---

## 3. Data not in Firestore (local / OS)

- **Search** in community (`searchQuery`): stays **in memory** on device; not written to Firestore in code.
- **“Remember me”** on login: UI state only in snippet; if you use `shared_preferences` elsewhere, say so in a future audit.
- **Passwords** (email sign-in): handled by **Firebase Auth**, not stored in Firestore in plaintext.

---

## 4. Google Play Data safety — practical mapping

Answer **“Does your app collect or share any of the required data types?”** with **Yes** for at least: **Personal info** (name, email, address, phone), **User IDs** (Firebase UID, sender/receiver ids in notifications if you treat as identifiers), **Other** or **User-generated content** (CV text, work history, skills, public/private flag, likes, notification messages as applicable).

| Play category (use exact labels from the form) | What to include for CV Manager |
|------------------------------------------------|---------------------------------|
| **Name** | `users.name`, `cvs.name`, `notifications.senderName` (where present). |
| **Email** | `users.email`, `cvs.email`, Auth email. |
| **Address** | `cvs.address`. |
| **Phone number** | `cvs.phone`. |
| **User IDs** | Auth UID, `cvs.userId`, `receiverId` / `senderId`. |
| **Other user-generated content** (or file/docs if the form offers it) | Bio/summary, job title, experience, skills, public CV text, like counts, in-app notification text. |
| **App activity** (if Analytics is on) | e.g. interactions / sessions — per Firebase Analytics’ actual collection. |
| **App info and performance** | Crashes or diagnostics if Analytics/Play delivers them. |

- **Data shared:** Firebase/Google as **infrastructure** for auth and database.  
- **Encryption in transit:** **Yes** (HTTPS to Google).  
- **Ephemeral / optional** handling: mark required vs optional per Play’s definitions (core account and CV are typically **required** for main features).

After any code change, **re-run this audit** and update the form.

---

## 5. Gaps to fix for policy vs reality

1. **No full “delete account”** in app code (only sign-out, CV delete, notification handling). **Data safety** and your **`data-deletion.html` / support process** should still describe **email support** for full erasure, and you should be able to execute that operation in Firebase.  
2. If some accounts lack a `users` Firestore document, align your **support** and Data safety declarations with the data that exists in **Auth** and `cvs`.  
3. **`firebase_storage`:** Unused in Dart; remove from `pubspec.yaml` when convenient or document if you add uploads later.

---

*This file is a technical mapping, not legal advice.*
