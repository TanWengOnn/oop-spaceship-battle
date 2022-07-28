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
    print(health);
    return true;
  }
}

class ArmoredSpaceShip implements SpaceShip {
  // Randomly absords hit
  // Reduce damage in percentage 
  // max 40% but will be random
  int maxArmorPower;
  @override
  double health;
  @override
  int firePower;

  @override 
  Map hit(int damage) {
    final random = Random();
    int min = 1;
    int max = maxArmorPower;
    int randomNumber = min + random.nextInt(max - min);

    double finalDamage = damage * (100 - randomNumber)/100;

    print("Name: Armor Ship, Blocked: ${damage - finalDamage}");


    health = health - finalDamage;

    return {"name":"Armor Ship", "health": health, "damage": finalDamage};
  }

  @override 
  bool isDestroy() {
    return true;
  }

  ArmoredSpaceShip(this.maxArmorPower, this.health, this.firePower);
}

class HightSpeedSpaceShip implements SpaceShip{
  // Whether dodges hit or not
  bool dodging; 

  @override
  double health;
  @override
  int firePower;

  @override 
  Map hit(int damage) {
    final random = Random();
    dodging = random.nextBool();

    if (dodging){
      health = health - damage;
    } else {
      print("Name: Speed Ship, Dodged Attack!");
      damage = 0;
    }
    
    return {"name":"Speed Ship", "health": health, "damage": damage};
  }

  @override 
  bool isDestroy() {
    return true;
  }

  HightSpeedSpaceShip(this.dodging, this.health, this.firePower);
}

class BattleField {
  bool attack;

  Map startBattle(SpaceShip armorShip, SpaceShip speedShip) { 

    if (attack){
      Map armorMessage = armorShip.hit(speedShip.firePower);
      print("Name: ${armorMessage["name"]}, Damage: ${armorMessage["damage"]} Health: ${armorMessage["health"]}\n");
      if (armorShip.health <= 0){
        return {"name":"Armor Ship", "isDestroy":armorShip.isDestroy()};
      }

      attack = false;
      
    } else {
      Map speedMessage = speedShip.hit(armorShip.firePower);
      print("Name: ${speedMessage["name"]}, Damage: ${speedMessage["damage"]} Health: ${speedMessage["health"]}\n");
      if (speedShip.health <= 0){
        return {"name":"Speed Ship", "isDestroy":speedShip.isDestroy()};
      }
      attack = true;
    }

    return {"name":"", "isDestroy":false};
    // Randomly a spaceship is selected and hit first
    // Spaceship hits each other 
    // Until one of them is destroyed 
  }

  BattleField(this.attack);
}

void main(List<String> arguments) {
  ArmoredSpaceShip armorShip = ArmoredSpaceShip(91, 100, 10);
  HightSpeedSpaceShip speedShip = HightSpeedSpaceShip(false, 100, 10);
    
  final random = Random();
  bool attack = random.nextBool();
  BattleField game = BattleField(attack);

  Map progess = {};
  
  do {
     progess = game.startBattle(armorShip, speedShip);

     if (progess["isDestroy"]){
      print("${progess["name"]} is destroyed!");
     }

     sleep(Duration(milliseconds:1000));
  }while(!progess["isDestroy"]);
  

}
