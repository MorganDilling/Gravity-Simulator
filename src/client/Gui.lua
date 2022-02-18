--!nocheck

-- Services --
local ReplicatedStorage = game:GetService( "ReplicatedStorage" )
local Players = game:GetService( "Players" )

-- Modules --
local Fusion = require( ReplicatedStorage.Common.Fusion )

-- Module --
local UI = {}

-- Fusion --
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local State = Fusion.State
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local OnChange = Fusion.OnChange

-- States --
UI.Settings = {}

-- Constants --
local DEF_FONT = Enum.Font.Gotham

-- Components --
local MenuItem = function( props )
  UI.Settings[props.Name] = State( props.SettingDefault ) -- state

  return New "Frame" {
    Name = props.Name,
    BackgroundTransparency = 1,
    Size = UDim2.new( 1, 0, 0, 20 ),
    [ Children ] = {
      New "TextLabel" {
        Name = "Title",
        Text = Computed(function()
          return props.Name .. ": " .. tostring( UI.Settings[props.Name]:get() )
        end),
        BackgroundTransparency = 1,
        Size = UDim2.new( 0.5, 0, 1, 0 ),
        ClipsDescendants = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = DEF_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3,
        TextSize = 16
      },
      New "Frame" {
        Name = "SettingContainer",
        Size = UDim2.new( 0.2, 0, 1, 0 ),
        Position = UDim2.new( 1, 0, 0.5, 0 ),
        AnchorPoint = Vector2.new( 1, 0.5 ),
        BackgroundTransparency = 1,
        ZIndex = 3,
        [ Children ] = (function()
          local Type = type( props.SettingDefault )
          local Name = props.Name

          if Type == "boolean" then
            local toggle = State( ({ [ false ] = 0, [ true ] = 1 })[ UI.Settings[Name]:get() ] )

            local toggleSpring = Spring( toggle, 13 )

            return New "Frame" {
              Name = "ToggleBG",
              Size = UDim2.new( 0, 28, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 1, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 1, 0.5 ),
              ZIndex = 4,
              [ Children ] = {
                New "UICorner" {
                  CornerRadius = UDim.new( 1, 0 )
                },
                New "ImageButton" {
                  Name = "ToggleBG",
                  Size = UDim2.new( 0, 16, 0, 16 ),
                  ZIndex = 5,
                  BackgroundColor3 = Computed(function()
                    return ({ [ false ] = Color3.fromRGB(228, 62, 62), [ true ] = Color3.fromRGB(126, 226, 79) })[ UI.Settings[Name]:get() ] -- chooses either red or green based on state
                  end),
                  Position = Computed(function()
                    return UDim2.fromScale( toggleSpring:get(), 0.5)
                  end),
                  AnchorPoint = Computed(function()
                    return Vector2.new( toggleSpring:get(), 0.5)
                  end),
                  [ Children ] = {
                    New "UICorner" {
                      CornerRadius = UDim.new( 1, 0 )
                    },
                  },
                  [ OnEvent "Activated" ] = function()
                    UI.Settings[Name]:set( not UI.Settings[Name]:get() )
                    toggle:set( UI.Settings[Name]:get() == false and 0 or 1 )
                  end
                }
              }
            }
          elseif Type == "string" then
            return New "TextBox" {
              Name = "InputBox",
              Size = UDim2.new( 0, 150, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 1, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 1, 0.5 ),
              ZIndex = 4,
              ClearTextOnFocus = false,
              Font = DEF_FONT,
              TextXAlignment = Enum.TextXAlignment.Right,
              TextYAlignment = Enum.TextYAlignment.Center,
              TextColor3 = Color3.fromRGB(255, 255, 255),
              PlaceholderText = props.SettingDefault,
              PlaceholderColor3 = Color3.fromRGB(128, 128, 128),
              ClipsDescendants = true,
              TextSize = 14,
              [ Children ] = {
                New "UICorner" {
                  CornerRadius = UDim.new( 0, 6 )
                },
              },
              [ OnChange "Text"] = function( text )
                if text == "" then
                  UI.Settings[Name]:set( props.SettingDefault ) -- set to default
                  return -- exit function
                end
                UI.Settings[Name]:set( text )
              end
            }
          elseif Type == "number" then
            return New "TextBox" {
              Name = "InputBox",
              Size = UDim2.new( 0, 48, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 1, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 1, 0.5 ),
              ZIndex = 4,
              ClearTextOnFocus = false,
              Font = DEF_FONT,
              TextXAlignment = Enum.TextXAlignment.Center,
              TextYAlignment = Enum.TextYAlignment.Center,
              TextColor3 = Color3.fromRGB(255, 255, 255),
              PlaceholderText = tostring( props.SettingDefault ),
              PlaceholderColor3 = Color3.fromRGB(128, 128, 128),
              ClipsDescendants = true,
              TextSize = 14,
              [ Children ] = {
                New "UICorner" {
                  CornerRadius = UDim.new( 0, 6 )
                },
              },
              [ OnChange "Text"] = function( text )
                if text == "" then
                  UI.Settings[Name]:set( props.SettingDefault ) -- set to default
                  return -- exit function
                end

                local s, safeText = pcall(function()
                  return tonumber( text )
                end)
                if not s then UI.Settings[Name]:set( props.SettingDefault ); return; end
                UI.Settings[Name]:set( safeText )
              end
            }
          end
        end)()
      }
    }
  }
end

-- Initialisation --
function UI.UI ()

  return New "ScreenGui" {
    Parent = Players.LocalPlayer.PlayerGui,
    Name = "Gui",
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    
    [ Children ] = {
      New "Frame" {
        Name = "Container",
        Size = UDim2.new( 1, 0, 1, 0 ),
        ZIndex = -1,
        -- BackgroundTransparency = 0,
        [ Children ] = {
          New "UIGradient" {
            Color = ColorSequence.new {
              ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
              ColorSequenceKeypoint.new(1, Color3.fromRGB(173, 173, 173))
            },
            Rotation = 90
          },
          New "Frame" {
            Name = "Menu",
            BackgroundTransparency = 0.35,
            BackgroundColor3 = Color3.fromRGB( 0, 0, 0 ),
            Position = UDim2.new( 0, 16, 0, 46 ),
            Size = UDim2.new( 0.2, 0, 0, 0 ),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
            [ Children ] = {
              New "UICorner" {
                CornerRadius = UDim.new( 0, 8 )
              },
              New "UIPadding" {
                PaddingBottom = UDim.new( 0, 8 ),
                PaddingLeft = UDim.new( 0, 8 ),
                PaddingRight = UDim.new( 0, 8 ),
                PaddingTop = UDim.new( 0, 8 )
              },
              New "UIListLayout" {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.Name,
                Padding = UDim.new( 0, 3 )
              },
              -- UI.Settings
              MenuItem {
                Name = "Gravity",
                SettingDefault = -9.807
              },
              MenuItem {
                Name = "Freeze",
                SettingDefault = false
              },
            }
          }
        }
      }
    }
  }
end

-- interactable cube
UI.cube = New "ImageButton" {
  Name = "Cube",
  AnchorPoint = Vector2.new( 0.5, 0.5 ),
  Size = UDim2.new( 0, 100, 0, 100 ),
  Position = UDim2.new( 0.5, 0, 0.5, 0 ),
  ZIndex = 1,
  Image = "rbxassetid://8860016498",
  BackgroundTransparency = 1,
  [ Children ] = {
    New "ImageLabel" {
      Name = "Drop Shadow",
      Size = UDim2.new( 1, 20, 1, 20 ),
      AnchorPoint = Vector2.new( 0.5, 0.5 ),
      Position = UDim2.new( 0.5, 0, 0.5, 0 ),
      BackgroundTransparency = 1,
      ImageTransparency = 0.7,
      ZIndex = 0,
      Image = "rbxassetid://8859909186"
    }
  }
}

return UI