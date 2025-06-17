## Agent Task Manager

This agent is designed to participate in Google Meet meetings, specifically handling conversations in multiple languages including Ukrainian, Russian, and Surjik (a mixed language). It utilizes Automatic Speech Recognition (ASR) and processes voice commands to interact with GitHub.

The agent performs the following key tasks:

1.  **Transcription Module:**
    *   **Purpose:** To capture audio from Google Meet, process it via an ASR engine, and display the resulting transcript.
    *   **Components:**
        *   **Audio Capture:**
            *   **Method:** Joins a Google Meet meeting as a participant using a headless browser (e.g., headless Chrome) and captures the audio stream of the meeting tab (e.g., using `tabCapture` API or similar).
            *   **Processing:** Captured audio is buffered, potentially down-sampled, and sent in chunks to the ASR service.
        *   **ASR Integration:**
            *   Connects to a chosen ASR engine (e.g., Whisper API, local Whisper instance, or other cloud ASR).
            *   Handles necessary authentication and API calls.
            *   Receives and processes text results from the ASR.
        *   **Language Handling:**
            *   Ideally, the ASR should support auto-detection or be configured for Ukrainian/Russian.
            *   For Surjik, a robust multilingual model like Whisper is recommended. It typically transcribes words into the language it identifies for each word.
        *   **Transcript Display:**
            *   Presents the real-time transcript within the Google Meet UI via the headless browser interface, appearing as a dedicated conversation participant.
            *   Provides real-time updates as speech is transcribed.
            *   *Advanced Feature:* Speaker diarization (identifying individual speakers) can be included if supported by the ASR.

2.  **Voice Command Module:**
    *   **Purpose:** To detect specific wake words or phrases from the transcript and interpret subsequent speech as commands for interacting with GitHub.
    *   **Components:**
        *   **Wake Word Detection:**
            *   Can be implemented using keyword spotting on the transcribed text (e.g., listening for "Hey Scribe," "GitHub Task," or equivalent phrases in Ukrainian/Russian).
            *   Alternatively, a dedicated lightweight wake-word engine (e.g., Picovoice Porcupine, Snowboy) can be used.
        *   **Command Parsing (NLU - Natural Language Understanding):**
            *   Upon wake word detection, captures the command phrase (e.g., "Create a task to fix the login bug for the frontend project").
            *   Uses NLU techniques (ranging from simple regex/keyword matching to more sophisticated tools like Rasa, spaCy, or a smaller LLM) to extract key information:
                *   **Intent:** e.g., `create_task`, `update_status`.
                *   **Entities:**
                    *   `task_title`: "fix the login bug"
                    *   `project_name`: "frontend project" (requires mapping to an actual GitHub project ID/name)
                    *   `assignee` (optional): "assign to Dmytro"
                    *   `description` (optional): "user cannot log in after password reset"
        *   **Interaction with Agent 2 (GitHub Integration):**
            *   Formats the extracted command information into a structured request (e.g., JSON).
            *   Sends this request to a separate component or service (referred to here as "Agent 2") responsible for interacting with the GitHub API. This communication could be via a local HTTP request or a secure API endpoint.
