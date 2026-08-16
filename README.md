# 🥽 GodotXR: VR Learning Aid for Children with Speech Delay (Client Application)

> **Project Code:** GSU26SE18
> **Component:** Virtual Reality Client Application (Godot Engine)

## 📖 Overview
This repository contains the **Virtual Reality (VR) Client Application** for the GodotXR project. Designed for children aged 7 to 11 with speech delays, this immersive application provides a safe, engaging, and interactive environment for pronunciation practice, oral motor training, and language development. 

This VR app operates in tandem with a Web Dashboard (managed by Parents, Teachers, and Therapists) and acts as the primary interactive medium for the child. By transforming repetitive speech therapy exercises into captivating 3D gameplay, GodotXR helps children improve their communication reflexes and confidence.

---

## ⚠️ Medical Disclaimer (BR-01)
**GodotXR is designed as a supportive learning aid and intervention tool.** It is *not* a replacement for professional speech therapy or medical diagnosis. All clinical metrics and gameplay mechanics are intended to support, not replace, the guidance of certified Speech-Language Pathologists (SLPs).

---

## 🎯 Target Audience
* **Age Group:** 7–11 years old.
* **Target Conditions:** * **SSD (Speech Sound Disorders):** Children struggling with articulation, pronunciation, and physical oral motor coordination.
  * **DLD/SLD (Developmental / Spoken Language Disorders):** Children facing challenges with vocabulary retrieval, syntax, and sentence formulation.

---

## ✨ Core VR Features

* **Immersive Interactive Learning:** Engaging VR environments (e.g., Magic Store, Virtual Supermarket) that mask therapeutic exercises as fun quests.
* **Pronunciation Practice:** Visual and audio prompts guiding children to repeat sounds, words, and short phrases.
* **Oral Motor Training:** Guided VR activities stimulating tongue, lip, and mouth movements.
* **Real-time Audio Processing:** Integration with Vosk AI to capture speech-to-text, assessing pronunciation accuracy and sentence length.
* **Dynamic Scaffolding & Feedback:** Instant visual/audio encouragement. If a child struggles, the system gracefully reduces difficulty to prevent frustration.
* **Automated Session Recording:** Background tracking of player movement, interaction events, and audio recordings, which are synchronized to the cloud for teacher/parent review.

---

## 🧠 Clinical Methodologies (Evidence-Based Practice)
The gameplay mechanics are directly mapped to American Speech-Language-Hearing Association (ASHA) standards:

### For Speech Sound Disorders (SSD)
* **Traditional Articulation Therapy & Oral Motor Training:** Exercises focusing on the physical placement of articulators.
* **Minimal Pairs Approach:** Using cognitive dissonance in game logic (e.g., asking for "Ca" but saying "Cá" yields the wrong VR object), helping children self-correct.
* **Modeling + Imitation:** The VR NPC provides a clear audio prompt, isolating ambient noise via the VR headset, and the child mimics the sound. Measured via **PCC (Percentage of Consonants Correct)**.

### For Developmental Language Disorders (DLD)
* **Milieu Language Teaching (MLT):** Naturalistic environments where children *must* communicate to progress (e.g., instructing a visually-impaired Robot Chef).
* **Semantic Feature Analysis (SFA):** NPCs provide functional clues (e.g., "I need something red to eat soup with") to help children overcome word-finding difficulties.
* **Modeling + Evoked Production:** Prompting the child to expand sentences to achieve higher **MLU (Mean Length of Utterance)** scores.

---

## 🛠️ Technical Stack & Hardware Requirements

* **Game Engine:** Godot Engine (GodotXR)
* **Supported Hardware:** Standalone VR headsets (Meta Quest 2, Meta Quest 3, or equivalent)
* **Input:** VR Controllers, Head Tracking, Built-in Microphone
* **Speech Recognition:** Vosk AI (Speech-to-Text Integration)
* **Connectivity:** Active Wi-Fi connection required for cloud synchronization, session uploading, and fetching personalized exercise data from the backend.

---

## 🎮 VR Application Screen Flow

1. **Start Screen:** Initial launch environment.
2. **Select/Confirm Profile:** Ensures data is tracked for the correct child.
3. **VR Main Menu:** Navigation hub for available exercises.
4. **Learning Activities:**
   * Pronunciation Exercise Scene
   * Vocabulary / Role-play Scene
   * Oral Motor Exercise Scene
5. **Feedback Loop:** In-game visual and audio rewards.
6. **Session Summary:** End-of-game performance overview.
7. **Cloud Sync:** Background upload of Replay Data, Audio logs, and Timestamped Event Tags to the backend server.

---

