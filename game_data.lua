starting_location = "Forest"

locations = {
  Home = {
    description = "A most hospitable place.",
    things = {"entrance", "key", "plant"}
  },
  Forest = {
    description = "It's kind of dark.",
    things = {"deer", "path", "stream"}
  },
  Kitchen = {
    description = "Mmmm. Smells good",
    things = {"counter", "door", "fridge"}
  },
  Limbo = {
    description = "I have no idea where I am.",
    things = {}
  }
}

things = {
  entrance = {
    description = "A red door",
    actions = {
      go = {location = "Kitchen"}
    }
  },
  key = {
    description = "Rusty and old.",
    actions = {
      take = {}
    }
  },
  plant = {
    description = "It could use some water.",
    actions = {}
  },
  deer = {
    description = "It is calmly munching on grass.",
    actions = {
      talk = {conversation = "deer"}
    }
  },
  path = {
    description = "I wonder where it goes.",
    actions = {
      go = {location = "Home"}
    }
  },
  stream = {
    description = "Wet and gurgly.",
    actions = {}
  },
  counter = {
    description = "I think it might be marble. Swanky.",
    actions = {}
  },
  door = {
    description = "I think it's locked",
    actions = {
      open = {requires = "key", actions = {go = {location = "Limbo"}}}
    }
  },
  fridge = {
    description = "I have a bad feeling about this.",
    actions = {
      open = {requires = nil, actions = {say = {text = "Wow, that really stinks!"}}}
    }
  }
}

data = {
  starting_location = starting_location,
  locations = locations,
  things = things
}

return data