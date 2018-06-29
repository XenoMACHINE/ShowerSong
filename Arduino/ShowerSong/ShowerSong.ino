#include <WiFi.h>
#include <DNSServer.h>
#include <WebServer.h>
#include <WiFiManager.h>   
#include <PubSubClient.h>
#include <TM1637Display.h>

#define WIFI_SSID "iPhone Alex"
#define WIFI_PASSWORD "xenox7676"

const char* mqtt_server = "vps363392.ovh.net";
String url = "showerSong/";
String clockUrl = url + "clock/";
//String urlPlay = url + "/playPause/";

WiFiClient espClient;
PubSubClient client(espClient);

const int buttonPlayPause = 27;     // the number of the pushbutton pin
const int buttonNext = 14;
const int buttonPrev = 26;
const int buttonVolMore = 13;
const int buttonVolLess = 12;

const int playPauseLED = 5;
const int buttonNextLED = 4;
const int buttonPrevLED = 18;
const int buttonVolMoreLED = 15;
const int buttonVolLessLED = 2;

int hasClicked = 0;
int playPauseStatus = 0;
int blinkStatus = 0;

const int CLK = 25; //Set the CLK pin connection to the display
const int DIO = 33; //Set the DIO pin connection to the display

TM1637Display display(CLK, DIO);

void setup() {
 
  Serial.begin(115200);
//  pinMode(LED_BUILTIN, OUTPUT);

  // initialize the pushbutton pin as an input:
  pinMode(buttonPlayPause, INPUT);
  pinMode(buttonNext, INPUT);
  pinMode(buttonPrev, INPUT);
  pinMode(buttonVolMore, INPUT);
  pinMode(buttonVolLess, INPUT);

  pinMode(playPauseLED, OUTPUT);
  pinMode(buttonNextLED, OUTPUT);
  pinMode(buttonPrevLED, OUTPUT);
  pinMode(buttonVolMoreLED, OUTPUT);
  pinMode(buttonVolLessLED, OUTPUT);

  display.setBrightness(0x0f);
  display.showNumberDecEx(0, 0b01000000, true);

  /*WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();*/
  
  WiFiManager wifiManager;
  wifiManager.autoConnect("ShowerSong WiFi Configuration");
  Serial.println("Wifi connected");

  client.setServer(mqtt_server, 8080);
  client.disconnect();
  client.setCallback(callback);
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ShowersongESP" + random(1000))) {
      client.subscribe(clockUrl.c_str());
      Serial.println("connected");
    } else {
      client.disconnect();
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 2 seconds before retrying
      delay(2000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
 
  //Serial.print("Message arrived in topic: ");
  //Serial.println(topic);
 
  //Serial.print("Message:");
  String message = "";
  for (int i=0; i < length; i++) {
    message += (char)payload[i];
    //Serial.print((char)payload[i]);
  }
 
  //Serial.println();
  //Serial.println("-----------------------");
  
  display.showNumberDecEx(message.toInt(), 0b01000000, true);
}

  
void loop() {
  client.loop();
  
  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:

  // else if chaine pour les press 1 une fois par 1
  if (digitalRead(buttonPlayPause) == HIGH) {
    if (hasClicked == 0){
      Serial.println("--------PlayPause---------");
      client.publish(url.c_str(), "PlayPause");
      
      if(playPauseStatus == 1){
        playPauseStatus = 0;
      }else{
        playPauseStatus = 1;
      }

      hasClicked = 1;
    }
  } else if (digitalRead(buttonNext) == HIGH) {
    if (hasClicked == 0){
      Serial.println("--------Next---------");
      client.publish(url.c_str(), "Next");
      hasClicked = 1;
    }
  } else if (digitalRead(buttonPrev) == HIGH) {
    if (hasClicked == 0){
      Serial.println("--------Prev---------");
      client.publish(url.c_str(), "Prev");
      hasClicked = 1;
    }
  } else if (digitalRead(buttonVolLess) == HIGH) {
      Serial.println("--------Volume less---------");
      client.publish(url.c_str(), "Less");
  } else if (digitalRead(buttonVolMore) == HIGH) {
      Serial.println("--------Volume more---------");
      client.publish(url.c_str(), "More");
  } else {
      //Serial.println("nothing");
      hasClicked = 0;
  }
  

  //Blink when pause
  if(playPauseStatus == 0){//for 100 delay (5 and 10)
    if(blinkStatus >= 3){
      if(blinkStatus == 6){
        blinkStatus = 0;
      }
      digitalWrite(playPauseLED, HIGH);
    }else{
      digitalWrite(playPauseLED, LOW);
    }
    blinkStatus++;
  }else{
    digitalWrite(playPauseLED, LOW);
  }
  
  delay(200);
}
