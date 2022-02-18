--!strict

-- Services --
local Players: Players = game:GetService( "Players" )
local Workspace: Workspace = game:GetService( "Workspace" )
local StarterGui: StarterGui = game:GetService( "StarterGui" )
local UserInputService: UserInputService = game:GetService( "UserInputService" )

-- Modules --
local MainGui = require( script.Gui )

-- Variables --
local Camera: Camera = Workspace.CurrentCamera

-- Initialisation --

-- create ui
local Gui: ScreenGui = MainGui.UI()
Gui.Parent = Players.LocalPlayer.PlayerGui

-- make camera non-moveable
Camera.CameraType = Enum.CameraType.Scriptable

-- disable chat & player list
StarterGui:SetCoreGuiEnabled( Enum.CoreGuiType.All, false )

-- Cube Interaction --
local Cube: ImageButton = MainGui.cube
Cube.Parent = Gui.Container

-- Dragging variables --
local Dragging: boolean = false
local DragInput: InputObject
local DragStart: UDim2
local StartPos: UDim2

local function cubeUpdate (input: InputObject): nil
  local delta: UDim2 = input.Position - DragStart
  Cube.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
end

Cube.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = Cube.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Cube.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        cubeUpdate(input)
    end
end)