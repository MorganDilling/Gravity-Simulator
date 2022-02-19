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
local DragStart: Vector3
local StartPos: Vector3

local function cubeInputUpdate (input: InputObject): nil
  local delta: Vector3 = input.Position - DragStart
  local Position = UDim2.new( StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y )
  
  local AbSize = Cube.AbsoluteSize
  local AbPos = {
      X = Position.X.Scale * Cube.Parent.AbsoluteSize.X + Position.X.Offset - AbSize.X * Cube.AnchorPoint.X,
      Y = Position.Y.Scale * Cube.Parent.AbsoluteSize.Y + Position.Y.Offset - AbSize.Y * Cube.AnchorPoint.Y
  }

  local ScreenX = Camera.ViewportSize.X
  local ScreenY = Camera.ViewportSize.Y
  local TopbarOffset = 0 -- 36

  local Left = AbPos.X
  local Right = AbPos.X + AbSize.X
  local Top = AbPos.Y + TopbarOffset
  local Bottom = AbPos.Y + AbSize.Y + TopbarOffset

  local Outside = Left < 0 or Top < 0 or Right > ScreenX or Bottom > ScreenY

  if Outside then return end

  Cube.Position = Position
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
        cubeInputUpdate(input)
    end
end)