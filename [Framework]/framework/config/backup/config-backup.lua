Config = {}

Config.characterSettings = {
    maximumCharacter = 10, -- Maximum amount of characters you can have.
    checkOldCharacter = true, -- will check every character to see if the user still access to the role or ace.
    onPlayMessageSize = true -- false = old way (simple text) | true new way (bubble text)
}

Config.versionSettings = {
    version = "2.2.1", -- Version of the script.
}

Config.uiSettings = {
    serverName = {
        enabled = true, -- Set to false to disable the server name.
        name = "NAT2K15 Development | RP Server" -- The server name.
    },
    serverLogo = {
        enabled = true, -- Set to false to disable the server logo.
        url = "https://store.nat2k15.xyz/assets/logo.png" -- The server logo url.
    },
    settingsButton = {
        enabled = true, -- Set to false to disable the settings button.
    },
    handleButtons = {
        disconnectButton = true,
        refreshButton = true,
    },
    areaOfPatrol = {
        displayOnFramework = true
    },
    spawnLocation = {
        sizeDisplay = false, -- true for big |  false for small.
        lastLocation = {
            enabled = true, -- Set to false to disable the last location.
        },
        currentLocation = {
            enabled = true, -- Set to false to disable do not teleport
        },
    },
    theme = {
        darkMode = true -- false = light mode | true = dark mode (default theme)
    },
    departmentNames = {
        sortByAlphabetical = true -- true if you want it sort by alphabetical order
    },
    backgroundSettings = {
        customBackground = {
            enabled = true, -- if this is enabled and the user has a photo the slideshow wont work.
        },
        slideshow = {
            enabled = true,
            length = 3,
        },
        images = {
            "https://i.ibb.co/K79HXPM/backgroungssss.png",
        }
    },
    charactersButton = {
        text = '<i class="fa fa-solid fa-play"></i> Play as: {0} ({1})', -- %s will be replaced with the character name and department.
    },
    discordButton = {
        enabled = false,
        text = "Join Discord",
        url = "https://discord.gg/nat2k15",
        maxClicks = 3 -- resets everytime the player spawns
    },
    websiteButton = {
        enabled = false,
        text = "Tebex",
        url = "https://store.nat2k15.xyz",
        maxClicks = 3 -- resets everytime the player spawns
    },
    adminPanel = {
        allowedRoles = {
            "895878656478560306",
            "role or ace",
        },
    }
}

-- DISCORD OR ACE PERMS --
Config.use_discord = true;
Config.server_id = "800444740729307177" -- ignore this if using ace perms
Config.deptInfo = {
    ["civ_level"] = {
        permissions = {
            enabledEveryone = true;
            leoPermissions = false; -- if set to true. They will be able to see what LEO can see such as radio, panic, etc and use the commands. 
            allowedPerms = {
                "framework.bcso",
                "role here or ace perms",
            }
        },
        name = "Civilian",
        spawns = {
            {x =238.5, y =-878.5, z =31.5, label = 'Legion Square'},
            {x =1501.64, y =3758.03, z =33.94, label= 'Sandy Shores'}, 
            {x =-38.994251251221, y =6521.8715820313, z = 31.490852355957, label = 'Paleto Bay'}
        }
    },
    ["lspd_level"] = {
        permissions = {
            enabledEveryone = true;
            leoPermissions = true; -- if set to true. They will be able to see what LEO can see such as radio, panic, etc and use the commands. 
            allowedPerms = {
                "role here or ace perms",
                "role here or ace perms",
            }
        },
        name = "LSPD",
        spawns = {
            {x=-447.307, y=6009.122, z=32.616, label="Paleto Bay Sheriff Station"},
            {x=-52.1, y=-1110.68, z=26.44, label="Los Santos"},
        }
    },
    ["admin_level"] = {
        permissions = {
            enabledEveryone = false;
            leoPermissions = true; -- if set to true. They will be able to see what LEO can see such as radio, panic, etc and use the commands. 
            allowedPerms = {
                "8004449387931238711",
                "role here or ace perms",
            }
        },
        name = "Admin",
        spawns = {
            {x=-41.31, y=-1112.83, z=25.81, label="Los Santos"},
            {x=2464.8, y=4105.32, z=37.44, label="Sandy Shores"},
            {x=-267.43, y=6629.64, z=6.88, label="Paleto Bay"}
        }
    }
}

-- WHITELIST SYSTEM  [DISCORD MUST BE ENABLED FOR THIS TO WORK]-- 
Config.whitelistSettings = {
    enabled = false, -- Set to false to disable the whitelist.
    whitelistRoles = {
        "role-1",
        "role-2"
    },
    unauthorizedMessage = "You are not authorized to join this server.", -- The message that will be displayed when a player is not whitelisted.
}

-- Nearest Postal -- 
Config.postalSystem = {
    enabled = true,
    postalScript = "nearest-postal"
}

Config.blipSystem = {
    enabled = true,
    blipSetting = {
        timeout = 20, -- in ms. If you are experiencing issues with the blips lagging out causing crashes etc increase this number.
        autoenable = true, -- auto enables when they load in.
        showWhenOnFoot = true, -- show when the officer is on foot.
    },
    blipDept = {
        enabled = true,
        -- Dept name | Color names can be found here https://docs.fivem.net/docs/game-references/blips/#blip-colors | Only Works on foot
        blips = {
            -- Department Names
            ["BCSO"] = {color = 5},
            ["Admin"] = {color = 0},
        }
    }
}

Config.shotSpotter = {
    enabled = true,
    
    cooldown = 2000, -- in seconds. After a dispatch has been called. Other shots won't be called for this amount of time.
    cooldownBeforeDispatched = 10, -- in seconds. After a shot has been detected. The dispatch will be called after this amount of time.
    blipDeletionTime = 6, -- in seconds. After a blip has been created. It will be deleted after this amount of time. Make it lower the cooldownBeforeDispatched.

    -- Spotter wont go off if the weapon is one of the following --
    blacklistWeapons = {
        "WEAPON_UNARMED",
        "WEAPON_STUNGUN",
        "WEAPON_KNIFE",
        "WEAPON_KNUCKLE",
        "WEAPON_NIGHTSTICK",
        "WEAPON_HAMMER",
        "WEAPON_BAT",
        "WEAPON_GOLFCLUB",
        "WEAPON_CROWBAR",
        "WEAPON_BOTTLE",
        "WEAPON_DAGGER",
        "WEAPON_HATCHET",
        "WEAPON_MACHETE",
        "WEAPON_FLASHLIGHT",
        "WEAPON_SWITCHBLADE",
        "WEAPON_FIREEXTINGUISHER",
        "WEAPON_PETROLCAN",
        "WEAPON_SNOWBALL",
        "WEAPON_FLARE",
        "WEAPON_BALL",
    }
}

-- TWITTER FILTER -- 
Config.twitterFilter = {
    blacklistedWord = {
        "nigger",
        "faggot",
        "kys",
        "nigga",
        "fag",
        "jew",
        "racist"
    },
    -- if the words above are used in the twitter name it will change it to a random word below
    whitelistedWords = {
        "niceguy",
        "coolkid21",
        "xboxplayer10",
        "newhere!"
    }
}

-- PANIC SYSTEM --
Config.panicSystem = {
    enabled = true,
    useSound = true,
    volume = 0.7,
    soundLink = "https://cdn.discordapp.com/attachments/778825763973103636/993037089690112141/panic-sound.ogg?ex=662bef1b&is=662a9d9b&hm=4339c17ebf5b9ac8a61be4be5b39add47d0f3d85afead46a6ba84d8e0c72bbd4&", -- must end in ogg
    blipSystem = {
        enabled = true,
        waitBeforeDelete = 10, -- in seconds
        radius = 300.0
    }
}

-- DOOR LOCK -- 
Config.doorLock = {
    enabled = true,
    text = {
        unlock = '<i class="fas fa-lock-open" style="color: green"></i><b> [E] Unlock</b>',
        lock = '<i class="fas fa-lock" style="color: green"></i><b> [E] Lock</b>',
    },
    sound =  {
        enabled = true,
        unlocked = {
            link = "https://cdn.discordapp.com/attachments/833824685208240169/1092554307263537172/doorlock.ogg?ex=662c15fd&is=662ac47d&hm=5d710e16f52ea5c07b2801b59fb9117681aed96d4092ca689cd64f3301dbef40&",
        },
        locked = {
            link = "https://cdn.discordapp.com/attachments/833824685208240169/1092554307263537172/doorlock.ogg?ex=662c15fd&is=662ac47d&hm=5d710e16f52ea5c07b2801b59fb9117681aed96d4092ca689cd64f3301dbef40&"
        },
        volume = 0.7
    }
}

-- Mute System -- 
Config.muteSystem = {
    enabled = true,
    command = "mute",
    unmuteCommand = "unmute",
    defaultTime = "10m", -- 1s = 1 second, 1m = 1 minute, 1h = 1 hour, 1d = 1 day. (this is the default if the user doesnt input a time)
}

-- TASER CART -- 
Config.taserScript = {
    enabled = true,
    taserCarts = 3
}

-- CHAT BLOCKER -- 
Config.chatBlocker = {
    enabled = true,
    blacklistWords = {
        "gay",
        "fag",
        "kys",
        "faggot",
        "nigger",
        "nigga",
        "doxxing",
        "dox"
    }
}

-- LOADOUT SYSTEM --
Config.loadoutSystem = {
    ["lspd_level"] = {
        weapons = {
            'weapon_combatpistol', 
            'weapon_carbinerifle', 
            'weapon_pumpshotgun', 
            'weapon_nightstick', 
            'weapon_flashlight', 
            'weapon_fireextinguisher', 
            'weapon_flare', 
            'weapon_stungun',
        },
        components = {
            ["weapon_combatpistol"] = {
                "component_at_pi_flsh"
            },
            ["weapon_carbinerifle"] = {
                "component_at_ar_flsh",
                "component_at_scope_medium"
            },
            ["weapon_pumpshotgun"] = {
                "component_at_ar_flsh"
            }
        }

    },
    ["bcso_level"] = {
        weapons = {
            'weapon_combatpistol', 
        },
        components = {
            ["weapon_combatpistol"] = {
                "component_at_pi_flsh"
            },
        }
    },
}


-- priority SCRIPT -- 
Config.prioritySettings = {
    enabled = true,
    permissions = {
        everyone = true,
        leo = true,
        civ = true,
    },
    visibility = {
        leo = true,
    },
    htmlCode = {
        bottom = "20.5%", -- the lower the number the lower it will go
        left = "1.5%", -- the lower the number the more to the left it will go
        icon = '<i class="fa-solid fa-clock" style="color: green"></i>', -- can get them from https://fontawesome.com/icons/. If you wanna change the color of the icon just change the white
    },
    time = {
        maxTime = 45,
        defaultTime = 20,
    }
}

Config.streetLabel = {
    enabled = true,
    htmlCode = {
        bottom = "18.5%", -- the lower the number the lower it will go
        left = "1.5%", -- the lower the number the more to the left it will go
        icon = '<i class="fas fa-road" style="color: green"></i>', -- can get them from https://fontawesome.com/icons/. If you wanna change the color of the icon just change the white
    },
    onlyDisplayWhenInVehicle = false -- only display when the user is inside a vehicle
}


-- AOP SCRIPT-- 
Config.aopSettings = {
    enabled = true,
    defaultAop = "Sandy Shores",
    visibility = {
        leo = true, 
    },
    htmlCode = {
        bottom = "24.5%", -- the lower the number the lower it will go
        left = "1.5%", -- the lower the number the more to the left it will go
        icon = '<i class="fas fa-chart-area" style="color: green"></i>', -- can get them from https://fontawesome.com/icons/. If you wanna change the color of the icon just change the white
    },
    autoSwitcher = true,
    autoSwitcherSettings = {
        [0] = {
            time = 10, -- In Min
            aop = "Sandy Shores",
        },
        [1] = {
            time = 10, -- In Min
            aop = "Paleto Bay",
        },
        
    }
}

-- PEACETIME -- 
Config.peacetimeSettings = {
    enabled = true,
    leoVision = true,
    affectLeo = false,
    affectAdmins = false,
    htmlCode = {
        bottom = "22.5%", -- the lower the number the lower it will go
        left = "1.5%",-- the lower the number the more to the left it will go
        icon = '<i class="fas fa-peace" style="color: %s"></i>', -- can get them from https://fontawesome.com/icons/. The style="%s" is for the color its required. only change the class name
        color = { -- supports hex and rgba colors
            active = "red",
            disabled = "green"
        }
    }
}


-- DISCORD RICH PRESENCE -- 
Config.richPresence = {
    enabled = true,
    clientid = 801534049944207381, -- this is your bot id
    displayPlayingAs = "Currently playing as %s [%s]", --  set to false to disable. you can reorginze if you wish the first %s is the name and second one is the dept

    icons = {
        small = {
            text = "discord.gg/RquDVTfDwu",
            icon = "https://i.imgur.com/ZsuQUE3.png",
        },
        big = {
            text = "NAT2K15 RP",
            icon = "https://i.imgur.com/ZsuQUE3.png",
        }
    },


    discordButtons = {
        enabled = true,
        button1 = {
            label = "Discord",
            url = "https://discord.gg/RquDVTfDwu"
        },
        button2 = {
            enabled = true,
            label = "Connect",
            url = "fivem://connect/IP:30120"
        }
    }
}

-- CHAT COMMANDS -- 
Config.commands = {
    oocCommand = true,
    doCommand = true,
    meCommand = true,
    merCommand = true,
    dobCommand = true,
    twitterCommand = true,
    gMeCommand = true,
    radioCommand = true,
    emsCommand = true,
    darkWebCommand = true,
    whoamiCommand = true,
    loadoutCommand = true,
    Command_911 = false,
    adminChatCommand = true,
    tpCommand = true,
    clearWeaponsCommand = true,
    chatClearCommand = true,
    telpCommand = true,
    callAdminCommand = true,
    leoBlipCommand = true,
}
-- Admin Permissions
Config.adminPermissions = {
    GiveAllDepartments = true
}

