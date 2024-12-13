# GO DJ! : ESP32 DJ Controller with Music Visualization

**Author:** Asia Gray

## Project Overview
GO DJ! is a mini DJ controller designed to integrate audio playback, real-time controls, and vibrant music visualizations. This was my final projecr fot my Creative Embedded Systems course. The DIY controller combines the ESP32 TTGO, with sliding and rotary potentiometers, and Processing software to deliver an engaging audio-visual experience. 

![Project GIF](link-to-gif-here)

## Design Goals
1. Create a functioning DJ controller with volume and playback speed controls.
2. Implement dynamic, beat-reactive music visualizations using Processing.
3. Develop a compact and realistic appealing enclosure for the hardware.
---

## Hardware Components

1. **ESP32 TTGO T-Display**: Dual-core microcontroller with built-in Wi-Fi and a small integrated screen for debugging.
2. **Sliding Potentiometers (2x)**: Control volume for each track.
3. **Rotary Potentiometers (2x)**: Adjust playback speed.
4. **Thin Cardboard**: Used for constructing the enclosure.

<img width="571" alt="fritzing-final-creative-emb-sys" src="https://github.com/user-attachments/assets/c1ab91a8-47d6-4531-b727-4ea007c02d9f" />


---

## Software Components

1. **Arduino IDE**: For programming the ESP32.
2. **Processing**: For music visualization and audio playback via the Sound library.
3. **Libraries Used**:
   - Sound Library (Processing)
   - FFT Analysis (Processing)
   - WebSockets (ESP32-Processing communication)

---

---

## Key Features

### Audio Playback
- Plays up to two preloaded songs stored on your computer.
- **Special Note**: I did not upload the mp3 files I used due to copyright issues but you can convert your preffered files easily using this free [Youtube to mp3 converter](https://cnvmp3.com/)
- Independent volume control via sliding potentiometers.
- Adjustable playback speed using rotary potentiometers.

### Music Visualization
- Dynamic visualizations in Processing based on FFT frequency analysis.
- Reacts to beats, melodies, kicks, guitar strings, and other musical elements.
- Smooth animations using synchronized colored circles.

### Enclosure Design
- Hand-crafted cardboard design with black paint and glitter accents.

---


## Supplementary Images
1. **Final Design**: ![Image of the finished DJ controller](link-to-image-here)
2. **Enclosure Construction**: ![Image showing enclosure assembly](link-to-image-here)
3. **Visualization Demo**: ![GIF of the music visualization](link-to-image-here)

---

## References
- [DIY USB DJ Controller](https://www.instructables.com/DIY-USB-DJ-Controller/)
- [Make an Amazing MIDI Controller](https://www.instructables.com/Make-an-Amazing-MIDI-Controller/)

---

## Acknowledgments
Special thanks to my professor and classmates for their guidance and feedback throughout the project.

---

## How to Replicate
Using the provided code and hardware setup instructions, you can recreate GO DJ! and customize it further. Check the included Arduino and Processing files in this repository to get started. Happy DJing!

