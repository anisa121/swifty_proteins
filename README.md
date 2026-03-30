# Swifty Proteins

**Swifty Proteins** is a specialized iOS application designed for 3D visualization of chemical molecules (ligands). Built as part of the 42 School curriculum, it combines advanced graphics, network communication, and secure authentication to provide an immersive educational experience.

## Features

-   🔐 **Secure Access:** 
    -   Biometric authentication (FaceID/TouchID) using `LocalAuthentication`.
    -   Keychain-backed password management for persistent and secure login.
-   🧪 **Molecular Exploration:**
    -   Interactive list of ligands with real-time search functionality.
    -   Automated fetching of molecular data (SDF format) from the [RCSB Protein Data Bank](https://www.rcsb.org/).
-   🎨 **3D Visualization:**
    -   High-fidelity 3D rendering using **SceneKit**.
    -   **Ball-and-Stick Model:** Atoms are represented as spheres and bonds as cylinders.
    -   **CPK Coloring:** Atoms are automatically colored according to their chemical element (Carbon is black, Oxygen is red, etc.).
    -   **Complex Bonds:** Support for single, double, and triple bonds with proper spatial orientation using vector geometry and custom plane calculations.
-   📱 **Interactive UI:**
    -   Rotate, zoom, and pan gestures for 3D models.
    -   Tap-to-identify: View the name of specific atoms upon selection.
    -   Integrated sharing capabilities for molecular visualizations.

## Technical Stack

-   **Framework:** SwiftUI (Modern, declarative UI).
-   **Graphics:** SceneKit (Hardware-accelerated 3D rendering).
-   **Concurrency:** Combine (Reactive network handling) and Async/Await.
-   **Security:** LocalAuthentication & Keychain (Apple's security standards).
-   **Networking:** URLSession for fetching data from remote PDB repositories.

## How it works

1.  **Authentication:** The app starts with a secure login screen requiring a password or biometric verification.
2.  **Selection:** Users browse a comprehensive list of ligands (defined in `ligands.txt`).
3.  **Data Processing:** Upon selection, the app fetches the `.sdf` file, parses the atom coordinates and bond structures.
4.  **Rendering:** The `SceneKitBuilder` dynamically constructs a 3D scene, calculating the exact position, scale, and orientation for every atom and bond in the molecule.
