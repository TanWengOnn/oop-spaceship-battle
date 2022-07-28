// import 'package:oop_space_ship/oop_space_ship.dart' as oop_space_ship;
import 'dart:math';
import 'dart:io';

abstract class SpaceShip {
  String shipName;
  double health; 
  int firePower;
  int score;

  SpaceShip(this. shipName,this.health, this.firePower, this.score);

  // Methods
  // Hit
  Map hit(int firePower);

  // isDestroy 
  bool isDestroy() {
    return health <= 0;
  }
}

class ArmoredSpaceShip extends SpaceShip {
  // Randomly absords hit
  // Reduce damage in percentage 
  int maxArmorPower;

  @override 
  Map hit(int damage) {
    // Get random value for armor
    final random = Random();
    int min = 1;
    int max = maxArmorPower;
    int randomNumber = min + random.nextInt(max - min);

    // Get the reduced damage
    double finalDamage = damage * (100 - randomNumber)/100;
    print("\x1B[32mName: Armor Ship, Blocked: ${damage - finalDamage}\x1B[0m");

    // Deduct health
    health = health - finalDamage;
    return {"name":shipName, "health": health, "damage": finalDamage};
  }

  ArmoredSpaceShip(
    this.maxArmorPower, 
    String shipName, 
    double health, 
    int firePower, 
    int score) : super(shipName ,health, firePower, score);
}

class HightSpeedSpaceShip extends SpaceShip{
  // Whether dodges hit or not
  bool dodging; 

  @override 
  Map hit(int damage) {
    // Get random boolean value
    final random = Random();
    dodging = random.nextBool();

    // Dodge attack if true
    if (dodging){
      health = health - damage;
    } else {
      print("\x1B[34mName: Speed Ship, Dodged Attack!\x1B[0m");
      damage = 0;
    }
    
    return {"name":shipName, "health": health, "damage": damage};
  }

  HightSpeedSpaceShip(
    this.dodging, 
    String shipName,
    double health, 
    int firePower, 
    int score) : super(shipName, health, firePower, score);
}

class BattleField {
  /* 
    Randomly a spaceship is selected and hit first
    Spaceship hits each other 
    Until one of them is destroyed 
  */

  bool attack;

  Map startBattle(SpaceShip armorShip, SpaceShip speedShip) { 

    // Attack Armored Ship if true
    if (attack){
      // Getting Attack details
      Map armorMessage = armorShip.hit(speedShip.firePower);
      print("\x1B[32mName: ${armorMessage["name"]}, Damage: ${armorMessage["damage"]} Health: ${armorMessage["health"]}\n\x1B[0m");
      
      // Ship has no more health
      if (armorShip.isDestroy()){
        return {
          "winName": speedShip.shipName, //"Speed Ship", 
          "loseName": armorShip.shipName,//"Armor Ship", 
          "isDestroy":armorShip.isDestroy(), 
          "winScore":speedShip.score += 1,
          "loseScore":armorShip.score
        };
      }
      // Change player
      attack = false;
      
    } else {
      // Getting Attack details
      Map speedMessage = speedShip.hit(armorShip.firePower);
      print("\x1B[34mName: ${speedMessage["name"]}, Damage: ${speedMessage["damage"]} Health: ${speedMessage["health"]}\n\x1B[0m");
     
      // Ship has no more health
      if (speedShip.isDestroy()){
        return {
          "winName": armorShip.shipName,//"Armor Ship", 
          "loseName": speedShip.shipName,// "Speed Ship", 
          "isDestroy":speedShip.isDestroy(), 
          "winScore":armorShip.score += 1,
          "loseScore":speedShip.score
        };
      }
      // Change player
      attack = true;
    }

    return {"name":"", "isDestroy":false, "winScore": 0};
  }

  BattleField(this.attack);
}

void main(List<String> arguments) {
  // Initializing the ships 
  ArmoredSpaceShip armorShip = ArmoredSpaceShip(91, "Armor Ship", 100, 10, 0);
  HightSpeedSpaceShip speedShip = HightSpeedSpaceShip(false, "Speed Ship", 100, 10, 0);
  
  // Get a random starting player
  final random = Random();
  bool attack = random.nextBool();
  // Initializing the game
  BattleField game = BattleField(attack);

  Map progress = {};
  int match = 1;

  // Main Game Loop
  do {
    // Starting the game 
    progress = game.startBattle(armorShip, speedShip);

    // Game ended
    if (progress["isDestroy"]){
      print("Match $match!");
      print("\x1B[31m${progress["loseName"]} is destroyed!\x1B[0m");
      print("${progress["winName"]}: score: ${progress["winScore"]}, ${progress["loseName"]}: score: ${progress["loseScore"]}");
      print("/-----------------------------------------------------------/");

      if (progress["winName"] == armorShip.shipName){
        armorShip = ArmoredSpaceShip(91, "Armor Ship", 100, 10, progress["winScore"]);
        speedShip = HightSpeedSpaceShip(false, "Speed Ship", 100, 10, progress["loseScore"]);
      }else{
        armorShip = ArmoredSpaceShip(91, "Armor Ship", 100, 10, progress["loseScore"]);
        speedShip = HightSpeedSpaceShip(false, "Speed Ship", 100, 10, progress["winScore"]);
      }
      
      match += 1;
    }

    if (progress["winScore"] == 3){
      print("${progress["winName"]} Wins!");
    }
    // Slow down the game
    // sleep(Duration(milliseconds:1000));
  }while(progress["winScore"] != 3);

}

