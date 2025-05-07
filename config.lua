local Config = {}

Config.ClockWaitMapping = {
    ["∞"]   = { Min = 4, Max = 7 },
    ["1:00"] = { Min = 0, Max = 1 },
    ["3:00"] = { Min = 2, Max = 3 },
    ["10:00"] = { Min = 4, Max = 7 },
}

Config.ClockNameMapping = {
    ["1:00"]  = "Bullet",
    ["3:00"]  = "Blitz",
    ["10:00"] = "Rapid",
    ["∞"]    = "Casual",
}

Config.IconImage = "http://www.roblox.com/asset/?id=95384848753847"

Config.Colors = {
    On = {
        Background = Color3.fromRGB(255, 170, 0),
        Text       = Color3.fromRGB(22,  16, 12),
        Icon       = Color3.fromRGB(22,  16, 12),
    },
    Off = {
        Background = Color3.fromRGB(22,  16, 12),
        Text       = Color3.fromRGB(255, 170, 0),
        Icon       = Color3.fromRGB(255, 170, 0),
    }
}

return Config
