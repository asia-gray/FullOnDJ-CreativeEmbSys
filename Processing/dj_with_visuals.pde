import processing.sound.*;
import processing.serial.*;


SoundFile song1, song2;
FFT fft;
int bands = 512;
float[] spectrum = new float[bands];


Serial port;
float volume1 = 0.5;
float speed1 = 1.0;
float volume2 = 0.5;
float speed2 = 1.0;
ArrayList<DetectionCircle> circles = new ArrayList<DetectionCircle>();


void setup() {
    size(1000, 1000);
    background(0);

    //insert song 1 here, change the mp3 file to your liking
    song1 = new SoundFile(this, "st_sade.mp3");
    song1.play();
    
    //insert song 2 here, change the mp3 file to your liking
    song2 = new SoundFile(this, "heated.mp3");


    // initialize FFT
    fft = new FFT(this, bands);
    fft.input(song1);
    //playsongs
    song1.play();
    song2.play();

    
    port = new Serial(this, Serial.list()[4], 115200);
    print(port);
    port.bufferUntil('\n');
}
void draw() {
    background(0);

    if (port.available() > 0) {
    String data = port.readStringUntil('\n');  // reading serial data until newline
    
    if (data != null) {
        //println("Raw Data: " + data);  this prints the raw data from the serial port in case you ever wanted to debug

        String[] values = split(data.trim(), ',');  // trim whitespace and split by comma
        
        if (values.length == 4) {  // ensure the correct number of values is received
            try {
                int faderOne = int(values[0]); 
                int speedOne = int(values[1]);
                int faderTwo = int(values[2]); 
                int speedTwo = int(values[3]); 

                println("Parsed Values: ");
                println("Fader 1: " + faderOne);
                println("Speed 1: " + speedOne);
                println("Fader 2: " + faderTwo);
                println("Speed 2: " + speedTwo);

                // Map and print mapped values for song1
                volume1 = map(faderOne, 0, 4095, 0.0, 1.0); // map to 0.0 - 1.0 range
                speed1 = map(speedOne, 0, 1600, 0.5, 2.0);  // map to 0.5 - 2.0 also one of my potentiometers was wonky and only went up to 1600 so adjust if needed
                println("Mapped Volume 1: " + volume1);
                println("Mapped Speed 1: " + speed1);

                song1.amp(volume1);  // set audio volume
                song1.rate(speed1);  // set playback rate

                // Map and print mapped values for song2
                volume2 = map(faderTwo, 0, 4095, 0.0, 1.0); // map to 0.0 - 1.0 range
                speed2 = map(speedTwo, 0, 4095, 0.5, 2.0);  // map to 0.5 - 2.0
                println("Mapped Volume 2: " + volume2);
                println("Mapped Speed 2: " + speed2);

                song2.amp(volume2);  // set audio volume
                song2.rate(speed2);  // set playback rate

            } catch (Exception e) {
                println("Error parsing or mapping values: " + e.getMessage());
            }
        } else {
            println("Invalid data format. Received: " + data);
            }
        }
    }
    
    // analyze the audio and fill the spectrum array
    fft.analyze(spectrum);

    // calculate the band index for 200 Hz
    int sampleRate = 44100; // Default sample rate
    int bandIndex = int((200.0 / (sampleRate / 2)) * bands);
    int kickBand = int((50.0 / (sampleRate / 2)) * bands);
    int bassBand = int((100.0 / (sampleRate / 2)) * bands);
    int vocalBand = int((1000.0 / (sampleRate / 2)) * bands);  
    int cymbalBand = int((15000.0 / (sampleRate / 2)) * bands);
    int clapBand = int((1000.0 / (sampleRate / 2)) * bands);
    int leadVocals = int((1500.0 / (sampleRate / 2)) * bands);
    int harmonicBand = int((800.0 / (sampleRate / 2)) * bands);
    int mainVocalBand = int((1200.0 / (sampleRate / 2)) * bands);
    float vibrato = abs(spectrum[mainVocalBand] - spectrum[mainVocalBand + 1]); // comparing adjacent bands
    int sustainedNoteBand = int((1000.0 / (sampleRate / 2)) * bands);
    int backingVocalBand = int((1200.0 / (sampleRate / 2)) * bands);
    int vocalBreathBand = int((800.0 / (sampleRate / 2)) * bands);
    int guitarBand = int((2000.0 / (sampleRate / 2)) * bands);
    float decay = spectrum[100] - spectrum[150]; // comparing amplitude decay across bands
    int autotuneBand = int((1000.0 / (sampleRate / 2)) * bands);
    
    if (spectrum[mainVocalBand] > 0.5 && frameCount % 20 == 0) {
        circles.add(new DetectionCircle("Main Vocal", color(0, 255, 0)));
        //println("Dynamic volume detected!");
    }
    if (spectrum[autotuneBand] > 0.4) { // Adjust based on autotuned content
        //println("Autotune effect detected!");
        circles.add(new DetectionCircle("Autotune", color(255, 255, 0)));
    }

    if (decay > 0.2) {
          //println("Reverb or chorus detected!");
          circles.add(new DetectionCircle("Decay", color(90, 88, 0)));
    }
    if (spectrum[vocalBand] > 0.3 && spectrum[guitarBand] > 0.3) {
        //println("Vocals and instruments detected!");
        circles.add(new DetectionCircle("Vocal", color(8, 67, 2)));
     }
     
    
    if (spectrum[vocalBreathBand] < 0.05) { // Low amplitude threshold
          //println("Breath or pause detected!");
          circles.add(new DetectionCircle("Vocal Breath", color(78, 0, 45)));
    }

    
    if (spectrum[backingVocalBand] > 0.15) { // Lower threshold for subtle detection
          //println("Backing vocals detected!");
          circles.add(new DetectionCircle("Backing Vocals", color(0, 78, 23)));
      }
    
    if (spectrum[sustainedNoteBand] > 0.3 && frameCount % 30 == 0) { // Check consistency over frames
        //println("Sustained note detected!");
        circles.add(new DetectionCircle("Long Notes", color(65, 34, 2)));
    }

    
    if (vibrato > 0.05) {
        //println("Vibrato detected!");
        circles.add(new DetectionCircle("Vibrato", color(89, 255, 0)));
    }

    if (spectrum[harmonicBand] > 0.25) { // Adjust threshold
        //println("Melody or harmonic instrument detected!");
        circles.add(new DetectionCircle("Harmonic", color(8, 124, 210)));
    }

    if (spectrum[leadVocals] > 0.3) { // Adjust threshold
        //println("Vocals detected!");
        circles.add(new DetectionCircle("Lead Vocal", color(88, 12, 110)));
    }
    if (spectrum[clapBand] > 0.2) { // Adjust threshold
        //println("Clap detected!");
        circles.add(new DetectionCircle("Claps", color(205, 89, 167)));
     }

    
    if (spectrum[cymbalBand] > 0.1) { // Adjust threshold
        //println("Cymbal detected!");
        circles.add(new DetectionCircle("Cymbal", color(87, 34, 30)));
      }

    if (spectrum[vocalBand] > 0.2) { // Adjust threshold
        //println("Vocal/Melody detected!");
        circles.add(new DetectionCircle("Melody", color(140, 178, 23)));
    }

    if (spectrum[bassBand] > 0.3) { // Adjust threshold
        //println("Bass detected!");
        circles.add(new DetectionCircle("Bass", color(220, 7, 90)));
    }
    if (spectrum[kickBand] > 0.2) { // Adjust threshold
      //println("Kick detected!");
        circles.add(new DetectionCircle("Kick", color(20, 247, 9)));
    }

    // Check the amplitude in the snare frequency range
    if (spectrum[bandIndex] > 0.1) { // Adjust threshold as needed
        circles.add(new DetectionCircle("Snare", color(86, 27, 90)));; // Flash the screen white
    }

    // visualizing the spectrum
    for (int i = 0; i < bands; i++) {
        float x = map(i, 0, bands, 0, width);
        float h = -height + map(spectrum[i], 0, 1, height, 0);
        rect(x, height, width/bands, h);
    }
    
     for (int i = circles.size() - 1; i >= 0; i--) {
        DetectionCircle c = circles.get(i);
        c.update();
        c.display();

        // remove the circle if its duration is complete
        if (c.isFinished()) {
            circles.remove(i);
        }
    }
}

class DetectionCircle {
    String type;
    color circleColor;
    int x, y, size, duration;

    DetectionCircle(String type, color circleColor) {
        this.type = type;
        this.circleColor = circleColor;
        this.x = int(random(width)); 
        this.y = int(random(height));
        this.size = int(random(30, 80)); 
        this.duration = 1; 
    }

    void update() {
        duration--; 
    }

    void display() {
        fill(circleColor);
        noStroke();
        ellipse(x, y, size, size);
    }

    boolean isFinished() {
        return duration <= 0; 
    }
 
}
