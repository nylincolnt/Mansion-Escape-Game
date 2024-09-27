# *(Mansion Escape Game)*

* By Lincoln Nyarambi


## Explanations

**What locations/rooms does your game have?**

1. Entry Hall: The starting point of the game, a grand hall with cobwebs and a dusty chandelier.
2. Living Room: A gloomy room with a locked door leading to the north.
3. Library: A room filled with old, rotting books where a key is hidden.
4. Locked Room: Only accessible with the key, it holds clues and access to the final exit.
5. Basement: A damp, dark area that requires a light source to explore.
6. Kitchen: An abandoned kitchen with broken utensils and a lantern to be found.
7. Attic: A dusty, dark area that can only be accessed with the lantern, hiding the Mysterious Amulet.
8. Final Room: The final area that leads to either freedom or a sinister ending.
9. 
10. 

**What items does your game have?**

1. Key: Found in the Library, it is required to unlock the door to the Locked Room.
2. Lantern: Found in the Basement, necessary to explore the Attic.
3. Mysterious Amulet: Found in the Attic, it holds magical powers and affects the final outcome.

**Explain how your code is designed. In particular, describe how you used structs or enums, as well as protocols.**


The code is structured around three main components: structs, enums, and a protocol.

1.Structs:
-Location: This struct represents different rooms in the mansion. Each location has a name, a description, and possible exits.
-Item: This struct represents items that can be picked up and interacted with. It conforms to the Interactable protocol.

2.Enums: Direction: An enum that defines movement directions like north, south, east, west, up, and down.

3.Protocol: Interactable: A protocol for items the player can interact with, ensuring consistency in how items behave when used or picked up.

The game's structure is designed to make the code easy to extend, allowing for the addition of more locations or items without drastically changing the core logic.


**How do you use optionals in your program?**

-   Optionals are used in the exits dictionary for each Location. For example, some locations may not have exits in certain directions, and in such cases, the dictionary returns nil, preventing the player from moving in that direction. Additionally, optionals are used to check if the player has collected certain items (like the key, lantern, or amulet) before they can progress through certain parts of the game.


**What extra credit features did you implement, if any?**

-   Rich text formatting: Rich text is used when the player interacts with important items, like the key, lantern, and amulet, enhancing the visual feedback of the game.


## Endings

### Ending 1 : Escape

The player gathers all the items and escapes the mansion.

```
east          # Go to the Library
take key      # Pick up the key
west          # Go back to the Entry Hall
down          # Go to the Basement
take lantern  # Pick up the lantern
up            # Go back to the Entry Hall
up            # Go to the Attic
take amulet   # Pick up the Mysterious Amulet
down          # Go back to the Entry Hall
north         # Go to the Living Room
use key       # Use the key to unlock the Locked Room
north         # Go to the Locked Room
north         # Enter the Final Room and escape
```

### Ending 2 : Trapped Forever

The player reaches the Final Room without the necessary items and is trapped forever.

```
north         # Go to the Living Room
north         # Try to enter the Locked Room without the key
north         # Enter the Final Room without all the items

```

### Ending 3 : Cursed by the Amulet

The player uses the Mysterious Amulet in the Final Room, causing a cursed ending.

```
east          # Go to the Library
take key      # Pick up the key
west          # Go back to the Entry Hall
down          # Go to the Basement
take lantern  # Pick up the lantern
up            # Go back to the Entry Hall
up            # Go to the Attic
take amulet   # Pick up the Mysterious Amulet
down          # Go back to the Entry Hall
north         # Go to the Living Room
use key       # Use the key to unlock the Locked Room
north         # Go to the Locked Room
north         # Enter the Final Room
use amulet    # Use the amulet and get cursed

```
