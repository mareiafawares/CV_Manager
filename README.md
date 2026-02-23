CV Manager App 
"Your Gateway to Professional CVs in Minutes"

A sophisticated mobile application built with Flutter and Firebase, designed to empower users to create, manage, and store professional resumes in the cloud with a seamless and modern experience.

 Key Features
 Secure Authentication: Full sign-up and login functionality powered by Firebase Authentication.

 Real-time Cloud Sync: All user profiles and CV data are instantly synced with Cloud Firestore, ensuring data is never lost.

 Premium UI/UX: A sleek, modern design featuring a stunning Dark Mode, smooth transitions, and intuitive navigation.

 Dynamic Dashboard: A clean overview of created CVs with full CRUD (Create, Read, Update, Delete) capabilities.

 Optimized Performance: Leveraging Provider for state management to ensure a lightning-fast and responsive user interface.

 Tech Stack
Frontend: Flutter SDK (Dart Language).

Backend: Firebase (Auth & Firestore).

State Management: Provider Pattern.

Tools: VS Code, Git, Firebase Console.

 Project Structure
The project follows a modular and clean directory structure:

 Models: Data Blueprints (e.g., UserModel, CVModel).

 Providers: Business logic and UI state handling (e.g., isLoading states).

 Services: Direct API/Firebase interactions (AuthService, DatabaseService).

 Screens: UI layers (Login, SignUp, MainWrapper, HomeScreen).

 Application Workflow
Auth Guard: The app automatically detects the user's session status.

Smart Routing: Users are redirected to either the Login or MainWrapper based on their auth state.

Data Hydration: Upon entry, the Provider fetches the user's profile from Firestore to personalize the experience.

Creation: Users can start building their professional CVs through a step-by-step interactive form.

 Future Roadmap
[ ] PDF Export: Generate and download resumes as high-quality PDF files.

[ ] Templates: Offer multiple professional design templates.

[ ] Profile Pictures: Integrate Firebase Storage for user avatars.

 Developed By
Developed with passion, focusing on clean code and exceptional user experience
