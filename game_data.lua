starting_scene = "Forest"

scenes = {
  Home = {
    title = "Home",
    description = "A most hospitable place.",
    things = {"entrance", "key", "plant"}
  },
  Forest = {
    title = "Forest",
    description = "It's kind of dark.",
    things = {"deer", "path", "stream"}
  },
  Kitchen = {
    title = "Kitchen",
    description = "Mmmm. Smells good",
    things = {"counter", "door", "fridge"}
  },
  Limbo = {
    title = "Limbo",
    description = "This place is strange and unknowable. It's scary, but you also find that you're kind of calm. Maybe it isn't horrible, but you can't help but wonder if after a while, you might start to get concerned that there is nothing to do. Now that you think about it, do you even have a body? Are you breathing? Whoa. This is wild.",
  },
  Conversation_1 = {
    title = "Conversation Test",
    actions = {
      {name = "say",text="Yes, I thought so too."},
      {name = "set_variable",var="parent_scene",value="`$scene.previous`"}
    },
    interactions = {
      {text="Why did you think that?",actions = {{name = "go",scene = "Conversation_2"}}},
      {text="I don't like that at all.",actions= {{name="go",scene = "Conversation_3"}}},
      {text="That's it. Let's fight!",actions = {{name ="say",text = "Nah, I don't think so."},{name ="go",scene="$parent_scene"}}}
    }
  },
  Conversation_2 = {
    title = "Conversation Test",
    actions = {{name="say",text="Well, just look at it."}},
    interactions = {
      {text="I'm done with this conversation.",actions = {{name="go",scene = "Limbo"}}}
    }
  },
  Conversation_3 = {
    title = "Conversation Test",
    actions = {{name="say",text="Not my problem."}},
    interactions= {
      {text="I'm done with this conversation.",actions={{name="go",scene = "`$parent_scene`"}}}
    }
  }
}

things = {
  entrance = {
    description = "A red door.",
    interactions = {
      {text="go",actions={{name="go",scene = "Kitchen"}}}
    }
  },
  key = {
    description = "A rusty, old key.",
    interactions = {
      {text="take",actions={{name="take"}}}
    }
  },
  plant = {
    description = "A wilted plant.",
    interactions = {}
  },
  deer = {
    description = "A deer calmly munching on tufts of grass.",
    interactions = {
      {text="talk",actions={{name="go", scene="Conversation_1"}}}
    }
  },
  path = {
    description = "A path disappearing into the trees.",
    interactions = {
      {text="go",actions = {{name="go",scene = "Home"}}}
    }
  },
  stream = {
    description = "A gurgling stream.",
    interactions = {}
  },
  counter = {
    description = "A marble countertop.",
    interactions = {}
  },
  door = {
    description = "A firmly closed door.",
    interactions = {
      {text="open",actions= {{name ="go",requires = {thing="key",response="It's seems to be locked. Maybe I need a key."},scene = "Limbo"}}}
    }
  },
  fridge = {
    description = "A dirty and suspiciously quiet refrigerator.",
    interactions = {
      {text="open",actions = {{name="say",text = "Wow, that really stinks! I'm gonna shut that."}}}
    }
  }
}

data = {
  starting_scene = starting_scene,
  scenes = scenes,
  things = things
}

return data