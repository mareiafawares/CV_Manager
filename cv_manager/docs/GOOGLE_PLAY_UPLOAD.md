# Google Play: Upload CV Pro and complete Data Safety & policies

This guide is for the **CV Pro** Flutter app (`com.digitalfrontier.app`) using **Firebase Authentication** and **Cloud Firestore**, published under:

| Field | Value |
|--------|--------|
| **Developer / company (store listing)** | Digital Frontier Applications Studio |
| **Support & privacy contact email** | jaeereyreedeso@gmail.com |

> **Clarify app name in Play Console:** The `applicationId` is `com.digitalfrontier.app`. The public name on the store (e.g. **"CV Pro"**) is set in **Store listing** and can differ from the application id.

---

## Part 1 — Before you start

1. **Google Play Console account**  
   - One-time registration fee (as set by Google in your country).  
   - Use: [https://play.google.com/console](https://play.google.com/console)

2. **You need**  
   - A unique **app name** and **default language** (e.g. English).  
   - **App signing**: Your project is already set up for **release signing** with `key.properties` and a keystore. **Back up the keystore file and passwords**; you cannot change the signing key for the same app listing without a controlled process in Play Console.

3. **Build an Android App Bundle (AAB)**  
   From the `cv_manager` folder (where `pubspec.yaml` is):

   ```bash
   flutter pub get
   flutter build appbundle
   ```

   - Output: `build/app/outputs/bundle/release/app-release.aab`  
   - Ensure `android/key.properties` (not committed to public repos) points to your keystore and the **release** build type uses that signing config (already configured in `android/app/build.gradle.kts`).

4. **Versioning**  
   - Bump `version` in `pubspec.yaml` (`1.0.0+1` = versionName 1.0.0, versionCode 1).  
   - Every new upload to Play must have a **higher `versionCode`** than the last one.

---

## Part 2 — Create the app in Play Console

1. **Create app**  
   - Play Console → **Create app** → set name, default language, type (app), free/paid, declarations.

2. **Dashboard**  
   - Complete the **required** sections: **App access**, **Ads** (if any), **Content rating questionnaire**, **Target audience**, **News app** (if applicable), **COVID-19** (if applicable), **Data safety** (Part 4 below), **Store listing** (Part 3).

3. **Release**  
   - Recommended: start with **Internal testing** or **Closed testing** track, upload the `.aab`, add testers, verify install.  
   - When ready, promote to **Production** (or start with a small **staged rollout** %).

4. **Signing in Play (optional but common)**  
   - Play App Signing: Google re-signs your AAB. Upload your first AAB; keep your **upload key** and keystore safe.

---

## Part 3 — Store listing (depends on your application)

Prepare these (exact sizes may change; check [Play Console help](https://support.google.com/googleplay/android-developer) for current limits):

| Asset | Notes |
|--------|--------|
| **Short description** | Up to 80 characters — one line value proposition. |
| **Full description** | Longer text for features, Firebase benefits, etc. |
| **App icon** | 512×512 px, PNG, 32-bit, max 1 MB. |
| **Feature graphic** | 1024×500 px, JPG/PNG, used on store. |
| **Phone screenshots** | At least 2; typically 4–8, PNG or JPEG. |
| **(Optional)** Tablet, 7" / 10" screenshots, promo video. |

- **Email / website:** Use **jaeereyreedeso@gmail.com** and, if you have a site, your company or product URL.  
- **Privacy policy URL (required in practice for apps handling personal data):** Upload the HTML files in **`docs/privacy-policy.html`** and **`docs/data-deletion.html`** to an **HTTPS** host, then paste the **https** link to the privacy page in the store listing.

---

## Part 4 — Data safety (aligned with this Firebase app)

**Authoritative list of all fields, collections, and SDKs:** see **[`docs/DATA_SAFETY_AUDIT.md`](./DATA_SAFETY_AUDIT.md)** (kept in sync with the code).

Complete **App content → Data safety** in Play Console. Answers must **match** what the app and backend actually do. The following is a **starting point** for an app with **email/password (or similar) sign-in** and **Firestore-stored user CVs**; adjust if you add more SDKs, ads, or third parties.

### Data collection & security (typical for Auth + Firestore)

- **Does your app collect or share any of the required user data types?**  
  - Usually **Yes**, if you store account and CV/profile data in Firebase.

**Examples of data types to declare (verify against your app):**

| Category (Play) | What it often maps to in CV Pro + Firebase |
|-----------------|-----------------------------------------------|
| **Personal info** | Name, email (account / profile) |
| **User IDs** | Firebase UID linked to the account |
| **Other user content** | CVs, profile fields, text saved in Firestore (not listed under a narrower category) |

- **Data usage:** App functionality, account management (this project does not ship Firebase Analytics in `app/build.gradle.kts`).

- **Data sharing / third parties:**  
  - Firebase/Google as **service provider** for auth and database. Declare according to the form (often “Data is transferred to a third party” for cloud backend — follow Google’s wording in the form for your situation).

- **Collection optional / required:** mark fields as **required** where the user **cannot** use the core feature without them (e.g. sign-up email), **optional** only if you truly do not need them for core use.

- **Encryption:** Data in transit: **Yes** (TLS for Firebase). Data at rest: per Firebase; follow Play’s guidance when selecting options.

- **Data deletion / account management:**  
  - If users can delete CVs in-app, say users can request deletion of some data in the app.  
  - If **full account deletion** is not in the app yet, you must still describe how users can request data deletion (e.g. **email to jaeereyreedeso@gmail.com**) and comply with your policy. Google’s policies also expect a path for users to **delete** their data or account; consider adding **in-app “Delete my account”** in a future update to align with best practice.

**Revisit Data safety** whenever you change: Firebase config, new SDKs, or ads.

---

## Part 5 — HTML pages: privacy & data deletion

**Source of truth (edit these files, not duplicates):**

| File | Use |
|------|-----|
| [`docs/privacy-policy.html`](./privacy-policy.html) | Privacy policy — use its **https** URL in Google Play. |
| [`docs/data-deletion.html`](./data-deletion.html) | Data deletion page with a form that **opens a pre-filled email** to the support address. |

Host the folder (or the two files) on **HTTPS** (e.g. GitHub Pages, Netlify, Google Sites, or your own server). Keep `privacy-policy.html` and `data-deletion.html` in the same directory so the links between them work, or update the `href`s after upload.

**Note:** If you are subject to the GDPR or other strict regimes, consider having a lawyer review the pages.

---

## Part 6 — Quick checklist before production

- [ ] `flutter build appbundle` succeeds; tested on a device from **Internal/Closed** track.  
- [ ] **Data safety** completed and consistent with Firebase (no separate Analytics SDK in the app).  
- [ ] **Privacy policy URL** live and points to the correct content.  
- [ ] **Support email** **jaeereyreedeso@gmail.com** is monitored.  
- [ ] **Content rating** and **target audience** completed.  
- [ ] **App icon, feature graphic, screenshots** uploaded.  
- [ ] **“Digital Frontier Applications Studio”** and contact details are consistent with account settings and the store listing.

---

*This document is operational guidance, not legal advice. Google Play requirements change; always follow the in-console prompts and the latest [Android Developer](https://developer.android.com/distribute) documentation.*
