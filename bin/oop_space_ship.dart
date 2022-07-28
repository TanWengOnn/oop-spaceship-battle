// import 'package:oop_space_ship/oop_space_ship.dart' as oop_space_ship;
import 'dart:math';
import 'dart:io';

abstract class SpaceShip {
  double health; 
  int firePower;

  SpaceShip(this.health, this.firePower);

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
    return {"name":"Armor Ship", "health": health, "damage": finalDamage};
  }

  ArmoredSpaceShip(this.maxArmorPower, double health, int firePower) : super(health, firePower);
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
    
    return {"name":"Speed Ship", "health": health, "damage": damage};
  }

  HightSpeedSpaceShip(this.dodging, double health, int firePower) : super(health, firePower);
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
        return {"name":"Armor Ship", "isDestroy":armorShip.isDestroy()};
      }
      // Change player
      attack = false;
      
    } else {
      // Getting Attack details
      Map speedMessage = speedShip.hit(armorShip.firePower);
      print("\x1B[34mName: ${speedMessage["name"]}, Damage: ${speedMessage["damage"]} Health: ${speedMessage["health"]}\n\x1B[0m");
     
      // Ship has no more health
      if (speedShip.isDestroy()){
        return {"name":"Speed Ship", "isDestroy":speedShip.isDestroy()};
      }
      // Change player
      attack = true;
    }

    return {"name":"", "isDestroy":false};
  }

  BattleField(this.attack);
}

void main(List<String> arguments) {
  // Initializing the ships 
  ArmoredSpaceShip armorShip = ArmoredSpaceShip(91, 100, 10);
  HightSpeedSpaceShip speedShip = HightSpeedSpaceShip(false, 100, 10);
  
  // Get a random starting player
  final random = Random();
  bool attack = random.nextBool();
  // Initializing the game
  BattleField game = BattleField(attack);

  Map progess = {};

  // Main Game Loop
  do {
    // Starting the game 
    progess = game.startBattle(armorShip, speedShip);

    // Game ended
    if (progess["isDestroy"]){
     print("\x1B[31m${progess["name"]} is destroyed!\x1B[0m");
    }

    // Slow down the game
    // sleep(Duration(milliseconds:1000));
  }while(!progess["isDestroy"]);
  

}
