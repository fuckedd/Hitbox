--//Settings
local Settings = {
    Size = 10
}

--//Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--//Variables
local LocalPlayer = Players.LocalPlayer
local isRunning = false

--//Storage for original hitbox properties
local OriginalHitboxProperties = {}

--//Functions
function Alive(player)
    if player then
        return player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") or false
    end
    return false
end

local function ModifyHitboxes()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and Alive(v) then
            local head = v.Character.Head
            if not OriginalHitboxProperties[head] then
                OriginalHitboxProperties[head] = {
                    Massless = head.Massless,
                    Size = head.Size,
                    Transparency = head.Transparency
                }
            end
            head.Massless = true
            head.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
            head.Transparency = 1

            local face = head:FindFirstChild("face")
            if face then
                face.Transparency = 1
            end
        end
    end
end

local function ResetHitboxes()
    for head, properties in pairs(OriginalHitboxProperties) do
        head.Massless = properties.Massless
        head.Size = properties.Size
        head.Transparency = properties.Transparency

        local face = head:FindFirstChild("face")
        if face then
            face.Transparency = 0
        end
    end
    OriginalHitboxProperties = {}
end

local function ToggleScript()
    while isRunning do
        wait(1.5)
        ModifyHitboxes()
    end
    ResetHitboxes() -- Reset hitboxes when the script is deactivated
end

local function ToggleRunning()
    isRunning = not isRunning
    if isRunning then
        print("Script activated.")
        ToggleScript()
    else
        print("Script deactivated.")
        ResetHitboxes() -- Reset hitboxes when the script is deactivated
    end
end

local function OnKeyPress(input)
    if input.KeyCode == Enum.KeyCode.H then
        ToggleRunning()
    end
end

UserInputService.InputBegan:Connect(OnKeyPress)
