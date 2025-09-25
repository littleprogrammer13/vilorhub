-- [FE] Advanced BTools
-- Funciona em FE moderno
-- Pode ser carregado via loadstring

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local BToolsFolder = Instance.new("Folder", LocalPlayer)
BToolsFolder.Name = "AdvancedBTools"

local selectedTarget = nil
local grabConnection = nil
local currentColor = BrickColor.Random()

local function createTool(name, action)
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = false
    tool.CanBeDropped = true
    tool.Parent = LocalPlayer.Backpack

    local scriptLocal = Instance.new("LocalScript")
    scriptLocal.Parent = tool
    scriptLocal.Source = [[
        local tool = script.Parent
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local actionFunc = function(target) ]] .. action .. [[ end

        tool.Activated:Connect(function()
            local target = mouse.Target
            if target and target:IsDescendantOf(workspace) and target.Anchored == false then
                actionFunc(target)
            end
        end)
    ]]
end

-- Hammer: destrói peças
createTool("Hammer", "target:Destroy()")

-- Clone: duplica e organiza
createTool("Clone", [[
    local clone = target:Clone()
    clone.Parent = workspace
    clone.CFrame = target.CFrame + Vector3.new(2,0,0)
]])

-- Grab: move objeto com click para soltar
createTool("Grab", [[
    if grabConnection then grabConnection:Disconnect() grabConnection=nil return end
    grabConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if target and target.Parent then
            target.CFrame = CFrame.new(mouse.Hit.Position)
        else
            grabConnection:Disconnect()
            grabConnection = nil
        end
    end)
]])

-- Delete: remove peça
createTool("Delete", "target:Destroy()")

-- Resize: aumenta/diminui tamanho com clique
createTool("Resize", [[
    if mouse.Button1Down then
        target.Size = target.Size * 1.5
    elseif mouse.Button2Down then
        target.Size = target.Size / 1.5
    end
]])

-- Paint: muda cor
createTool("Paint", [[
    target.BrickColor = BrickColor.Random()
]])

-- Sit: teleporta jogador sobre a peça
createTool("Sit", [[
    player.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
]])

print("Advanced BTools loaded! Equip suas ferramentas no Backpack.")
