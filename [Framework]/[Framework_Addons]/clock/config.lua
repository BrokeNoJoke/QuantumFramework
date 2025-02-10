config = {}

config.frameworkName = 'framework'
config.mainWebhook = 'https://discord.com/api/webhooks/1234982399343988818/v1A1fugJxK3mlMGK64D7ppD0u6kK90At7w0Mk9FgQ1l6i0uq069Hwa0tySStQZmCwBrF'


config.departmentInfo = {
    ["LSPD"] = {
        fullName = 'San Andres State Troopers', -- full department name
        webhook = 'WEBHOOK HERE', -- department webhook
        startEmbedTitle = 'Department Log Started!', -- department time log start title for the embed 
        endEmbedTitle = 'Department Log Ended!',-- department time log end title for the embed 
        startEmbedColour = '32768', -- department start colour for the embed 
        endEmbedColour = '16711680',-- department end  colour for the embed 
        embedThumbnail = 'THUMBNAIL URL HERE' -- embed thumbnail
          
    },
    ["Civilian"] = {
        fullName = 'Civilian Department',
        webhook = 'https://discord.com/api/webhooks/1234982399343988818/v1A1fugJxK3mlMGK64D7ppD0u6kK90At7w0Mk9FgQ1l6i0uq069Hwa0tySStQZmCwBrF',
        startEmbedTitle = 'Department Log Started!',
        endEmbedTitle = 'Department Log Ended!',
        startEmbedColour = '32768',
        endEmbedColour = '16711680',
        embedThumbnail = 'ddd'
          
    },
}

config.afk = {
    defaultTimeAfk = 10 -- in seconds how long do they have to be afk before it starts counting
}
