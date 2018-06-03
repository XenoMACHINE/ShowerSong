#include <WiFi.h>
#include <DNSServer.h>
#include <WebServer.h>
#include <WiFiManager.h>   
#include <PubSubClient.h>

#define WIFI_SSID "Te connecte pas malheureux"
#define WIFI_PASSWORD "xenomachine"

const char* mqtt_server = "vps363392.ovh.net";
String url = "showerSong/";
//String urlPlay = url + "/playPause/";

WiFiClient espClient;
PubSubClient client(espClient);

//#define LED_BUILTIN 16

const int buttonPlayPause = 25;//4     // the number of the pushbutton pin
const int buttonNext = 33;
const int buttonPrev = 32;
const int buttonVolMore = 27;
const int buttonVolLess = 26;

int hasClicked = 0;

void setup() {
 
  Serial.begin(115200);
//  pinMode(LED_BUILTIN, OUTPUT);

  // initialize the pushbutton pin as an input:
  pinMode(buttonPlayPause, INPUT);
  pinMode(buttonNext, INPUT);
  pinMode(buttonPrev, INPUT);
  pinMode(buttonVolMore, INPUT);
  pinMode(buttonVolLess, INPUT);

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
 
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
 
  Serial.print("Message:");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
 
  Serial.println();
  Serial.println("-----------------------");
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
  } else {
      hasClicked = 0;
  }

  if (digitalRead(buttonVolMore) == HIGH) {
      Serial.println("--------Volume more---------");
      client.publish(url.c_str(), "More");
  } 
  
  if (digitalRead(buttonVolLess) == HIGH) {
      Serial.println("--------Volume less---------");
      client.publish(url.c_str(), "Less");
  }
  
  delay(100);
}
