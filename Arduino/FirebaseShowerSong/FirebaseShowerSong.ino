//
// Copyright 2015 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// FirebaseDemo_ESP32 is a sample that demo the different functions
// of the FirebaseArduino API.

#include <WiFi.h>
#include <IOXhop_FirebaseESP32.h>

// Set these to run example.
#define FIREBASE_HOST "begenius-ab01f.firebaseio.com"
#define FIREBASE_AUTH "rhKQ6OwIjpO9b6SvC9uym7bbmq9y7egnoHBCfwMq"
#define WIFI_SSID "ESGI"
#define WIFI_PASSWORD "Reseau-GES"

StaticJsonBuffer<200> jsonBuffer;

const int buttonPin = 4;     // the number of the pushbutton pin
int buttonState = 0;         // variable for reading the pushbutton status

int hasClicked = 0;
int playPause = 0;

void setup() {
  Serial.begin(115200);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
/*
  //Create a object
  JsonObject& obj = jsonBuffer.createObject();
  obj["play"] = 0;
  //obj["to"] = id;

  Firebase.push("showerSong",obj);

  if (Firebase.failed()) {
      Serial.print("pushing /invitations failed:");
      Serial.println(Firebase.error());  
      return;
  }
  */

  /*Firebase.stream("/showerSong/-LDAi7iXRSZhJVG42ruV", [](FirebaseStream stream) {
    String eventType = stream.getEvent();
    eventType.toLowerCase();
     
    Serial.print("event: ");
    Serial.println(eventType);
    if (eventType == "put") {
      Serial.print("data: ");
      Serial.println(stream.getDataString());
      String path = stream.getPath();
      String data = stream.getDataString();

      Serial.println(path.c_str()+1);
      Serial.println(data);
    }
  });*/
}

void setPlayPause(){
  if(playPause == 0){
    playPause = 1;
  }else{
    playPause = 0;
  }
}

void loop() {
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    // turn LED on:
    if (hasClicked == 0){
      Serial.print("ON----------------    ");
      Serial.println(playPause);
      hasClicked = 1;
      setPlayPause();
      Firebase.set("showerSong/-LDAi7iXRSZhJVG42ruV", playPause);
    }
  } else {
    // turn LED off:
    //Serial.println("OFF");
    hasClicked = 0;
  }
  
  delay(100);
}
