local M = {}

function M.Start(Modules)
    local Config = Modules.Config
    local State = Modules.State

    State.AiLoaded = true
    State.AiRunning = true
    State.GameConnected = false

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RepStorage = game:GetService("ReplicatedStorage")

    local Sunfish = LocalPlayer.PlayerScripts.AI.Sunfish
    local ChessUI = LocalPlayer.PlayerScripts.ChessLocalUI

    local function GetGameType(ClockText)
        return Config.ClockNameMapping[ClockText] or "Unknown"
    end

    local function GetSmartWait(ClockText, MoveCount)
        local Range = Config.ClockWaitMapping[ClockText] or Config.ClockWaitMapping["bullet"]
        local Base = math.random(Range.Min, Range.Max)
        if MoveCount < math.random(7,12) then
            return Base * 0.5
        elseif MoveCount < math.random(12,40) then
            return GetGameType(ClockText) ~= "bullet" and Base * 4 or Base * 2
        end
        return Base * 1.2
    end

    local function GetFunction(Name, Source)
        for i = 1, 10 do
            for _, fn in ipairs(getgc(true)) do
                if typeof(fn) == "function"
                   and debug.getinfo(fn).name == Name
                   and debug.getinfo(fn).source:sub(-#Source) == Source then
                    return fn
                end
            end
            task.wait(0.1)
        end
        warn("Failed to find " .. Name)
    end

    local function InitializeFunctions()
        return GetFunction("GetBestMove", "Sunfish"), GetFunction("PlayMove", "ChessLocalUI")
    end

    local function StartGameHandler(Board)
        local GetBestMove, PlayMove = InitializeFunctions()
        local MoveCount, GameEnded = 0, false

        local function IsLocalPlayersTurn()
            return (LocalPlayer.Name == Board.WhitePlayer.Value) == Board.WhiteToPlay.Value
        end

        local ClockLabel = Board.Clock.MainBody.SurfaceGui[
            LocalPlayer.Name == Board.WhitePlayer.Value and "WhiteTime" or "BlackTime"
        ]

        task.wait(0.1)
        local ClockText = ClockLabel.ContentText
        local WaitTime = GetSmartWait(ClockText, MoveCount)

        coroutine.wrap(function()
            task.wait(3)
            while not GameEnded do
                if IsLocalPlayersTurn() and State.AiRunning then
                    local Fen = Board.FEN.Value
                    local Move = GetBestMove(nil, Fen, 5000)
                    if Move then
                        task.wait(WaitTime)
                        PlayMove(Move)
                        MoveCount += 1
                        WaitTime = GetSmartWait(ClockText, MoveCount)
                    end
                end
                task.wait(0.2)
            end
        end)()

        RepStorage.Chess.EndGameEvent.OnClientEvent:Once(function()
            GameEnded = true
            State.GameConnected = false
            print("[LOG]: Game ended.")
        end)
    end

    if not State.GameConnected then
        RepStorage.Chess.StartGameEvent.OnClientEvent:Connect(function(Board)
            if Board and (LocalPlayer.Name == Board.WhitePlayer.Value or LocalPlayer.Name == Board.BlackPlayer.Value) then
                print("[LOG]: New game started.")
                StartGameHandler(Board)
            end
        end)
        State.GameConnected = true
    else
        warn("Game instance already exists.")
    end
end

return M
