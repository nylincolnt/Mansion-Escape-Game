import SwiftUI

// Enum for directions
enum Direction: String {
    case north, south, east, west, up, down
}

// Struct for Locations
struct Location {
    let name: String
    let description: String
    let exits: [Direction: String]
}

// Protocol for interactable items
protocol Interactable {
    var name: String { get }
    func interact(context: AdventureGameContext)
}

// Struct for items that can be picked up
struct Item: Interactable {
    var name: String
    
    func interact(context: AdventureGameContext) {
        context.write("You picked up the \(name).")
    }
}

// Main game struct
struct MansionEscapeExtended: AdventureGame {
    var title: String {
        return "Mansion Escape - Extended Edition"
    }
    
    // Game state
    private var currentLocation: Location
    private var locations: [String: Location]
    private var hasKey: Bool = false
    private var hasLantern: Bool = false
    private var hasAmulet: Bool = false
    private var timeLeft: Int = 15 // Turns left before time runs out
    
    init() {
        // Define locations
        let entryHall = Location(name: "Entry Hall", description: "You are in a grand, dusty hall with cobwebs hanging from the chandelier.", exits: [.north: "Living Room", .east: "Library", .down: "Basement", .up: "Attic"])
        let livingRoom = Location(name: "Living Room", description: "A gloomy living room with a cold fireplace. A locked door is to the north.", exits: [.south: "Entry Hall", .north: "Locked Room"])
        let library = Location(name: "Library", description: "The walls are lined with old, rotting books. There’s a key on a shelf.", exits: [.west: "Entry Hall"])
        let lockedRoom = Location(name: "Locked Room", description: "A room filled with mysterious symbols. There’s something unsettling about it.", exits: [.south: "Living Room", .north: "Final Room"])
        let basement = Location(name: "Basement", description: "A damp, dark basement. You need a light source to explore further.", exits: [.up: "Entry Hall"])
        let kitchen = Location(name: "Kitchen", description: "An old kitchen with broken utensils. A lantern is lying in a corner.", exits: [.west: "Living Room"])
        let attic = Location(name: "Attic", description: "The attic is dark and dusty. You need a lantern to search it.", exits: [.down: "Entry Hall"])
        let finalRoom = Location(name: "Final Room", description: "The final exit, but only those fully prepared can leave.", exits: [:])
        
        // Store locations in a dictionary
        locations = ["Entry Hall": entryHall, "Living Room": livingRoom, "Library": library, "Locked Room": lockedRoom, "Basement": basement, "Kitchen": kitchen, "Attic": attic, "Final Room": finalRoom]
        
        // Start in the entry hall
        currentLocation = entryHall
    }
    
    // Start the game
    mutating func start(context: AdventureGameContext) {
        context.write("You wake up in an abandoned mansion. Your goal is to escape by finding clues and items scattered across the rooms.")
        context.write(currentLocation.description)
        helpCommand(context: context)
    }
    
    // Handle user input
    mutating func handle(input: String, context: AdventureGameContext) {
        let commands = input.split(separator: " ").map { String($0).lowercased() }
        
        guard let command = commands.first else {
            context.write("Invalid command.")
            return
        }
        
        // Reduce time left
        timeLeft -= 1
        if timeLeft <= 0 {
            context.write("Time has run out. You're trapped in the mansion forever.")
            context.endGame()
            return
        }
        
        switch command {
        case "north", "south", "east", "west", "up", "down":
            move(direction: command, context: context)
        case "take":
            if commands.count > 1 {
                take(item: commands[1], context: context)
            } else {
                context.write("What do you want to take?")
            }
        case "use":
            if commands.count > 1 {
                use(item: commands[1], context: context)
            } else {
                context.write("What do you want to use?")
            }
        case "help":
            helpCommand(context: context)
        default:
            context.write("Invalid command.")
        }
    }
    
    // Move the player between locations
    mutating func move(direction: String, context: AdventureGameContext) {
        guard let dir = Direction(rawValue: direction), let newLocationName = currentLocation.exits[dir] else {
            context.write("You can't go that way.")
            return
        }
        
        if newLocationName == "Locked Room" && !hasKey {
            context.write("The door is locked. You need a key.")
            return
        } else if newLocationName == "Attic" && !hasLantern {
            context.write("It's too dark to explore the Attic without a light.")
            return
        }
        
        currentLocation = locations[newLocationName]!
        context.write(currentLocation.description)
        
        // Check for special endings
        if currentLocation.name == "Final Room" && hasKey && hasLantern && hasAmulet {
            context.write("You’ve gathered all the items and escaped the mansion! Congratulations!")
            context.endGame()
        } else if currentLocation.name == "Final Room" {
            context.write("You’ve entered the final room, but without the required items, you're trapped forever.")
            context.endGame()
        }
    }
    
    // Handle taking items
    mutating func take(item: String, context: AdventureGameContext) {
        if currentLocation.name == "Library" && item == "key" {
            let key = Item(name: "Key")
            hasKey = true
            key.interact(context: context)
        } else if currentLocation.name == "Basement" && item == "lantern" {
            let lantern = Item(name: "Lantern")
            hasLantern = true
            lantern.interact(context: context)
        } else if currentLocation.name == "Attic" && item == "amulet" {
            let amulet = Item(name: "Mysterious Amulet")
            hasAmulet = true
            amulet.interact(context: context)
        } else {
            context.write("There's no \(item) here.")
        }
    }
    
    // Use items to progress
    mutating func use(item: String, context: AdventureGameContext) {
        if currentLocation.name == "Living Room" && hasKey && item == "key" {
            context.write("You use the key to unlock the door to the north.")
        } else if currentLocation.name == "Attic" && hasLantern && item == "lantern" {
            context.write("You use the lantern to light up the attic. There's an amulet here.")
        } else if currentLocation.name == "Final Room" && hasAmulet && item == "amulet" {
            context.write("The amulet starts glowing... but something feels wrong. You are cursed by the amulet!")
            context.endGame()
        } else {
            context.write("You can't use the \(item) here.")
        }
    }
    
    // Display available commands
    func helpCommand(context: AdventureGameContext) {
        context.write("Available commands: north, south, east, west, up, down, take [item], use [item], help")
    }
}

// Launch the game
MansionEscapeExtended.display()

