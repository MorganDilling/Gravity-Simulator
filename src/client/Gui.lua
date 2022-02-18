--!nocheck

-- Services --
local ReplicatedStorage = game:GetService( "ReplicatedStorage" )
local Players = game:GetService( "Players" )

-- Modules --
local Fusion = require( ReplicatedStorage.Common.Fusion )

-- Fusion --
local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local State = Fusion.State
local Computed = Fusion.Computed
local Spring = Fusion.Spring
local OnChange = Fusion.OnChange

-- States --
local Settings = {}

-- Constants --
local DEF_FONT = Enum.Font.Gotham

-- Components --
local MenuItem = function( props )
  return New "Frame" {
    Name = props.Name,
    BackgroundTransparency = 1,
    Size = UDim2.new( 1, 0, 0, 20 ),
    [ Children ] = {
      New "TextLabel" {
        Name = "Title",
        Text = props.Name,
        BackgroundTransparency = 1,
        Size = UDim2.new( 0.5, 0, 1, 0 ),
        ClipsDescendants = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = DEF_FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextSize = 16
      },
      New "Frame" {
        Name = "SettingContainer",
        Size = UDim2.new( 0.2, 0, 1, 0 ),
        Position = UDim2.new( 1, 0, 0.5, 0 ),
        AnchorPoint = Vector2.new( 1, 0.5 ),
        BackgroundTransparency = 1,
        [ Children ] = (function()
          local Type = type( props.SettingDefault )
          local Name = props.Name
          Settings[Name] = State( props.SettingDefault ) -- state

          if Type == "boolean" then
            local toggle = State( ({ [ false ] = 0, [ true ] = 1 })[ Settings[Name]:get() ] )

            local toggleSpring = Spring( toggle, 13 )

            return New "Frame" {
              Name = "ToggleBG",
              Size = UDim2.new( 0, 28, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 1, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 1, 0.5 ),
              [ Children ] = {
                New "UICorner" {
                  CornerRadius = UDim.new( 1, 0 )
                },
                New "ImageButton" {
                  Name = "ToggleBG",
                  Size = UDim2.new( 0, 16, 0, 16 ),
                  BackgroundColor3 = Computed(function()
                    return ({ [ false ] = Color3.fromRGB(228, 62, 62), [ true ] = Color3.fromRGB(126, 226, 79) })[ Settings[Name]:get() ] -- chooses either red or green based on state
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
                    Settings[Name]:set( not Settings[Name]:get() )
                    toggle:set( Settings[Name]:get() == false and 0 or 1 )
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
                  Settings[Name]:set( props.SettingDefault ) -- set to default
                  return -- exit function
                end
                Settings[Name]:set( text )
              end
            }
          elseif Type == "number" then
            return New "TextBox" {
              Name = "InputBox",
              Size = UDim2.new( 0, 48, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 1, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 1, 0.5 ),
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
                  Settings[Name]:set( props.SettingDefault ) -- set to default
                  return -- exit function
                end

                local s, safeText = pcall(function()
                  return tonumber( text )
                end)
                if not s then return end
                Settings[Name]:set( safeText )
              end
            }
          end
        end)()
      }
    }
  }
end

-- Initialisation --
return function ()

  return New "ScreenGui" {
    Parent = Players.LocalPlayer.PlayerGui,
    Name = "Gui",
    
    [ Children ] = {
      New "Frame" {
        Name = "Container",
        Size = UDim2.new( 1, 0, 1, 0 ),
        BackgroundTransparency = 1,
        [ Children ] = {
          New "Frame" {
            Name = "Menu",
            BackgroundTransparency = 0.35,
            BackgroundColor3 = Color3.fromRGB( 0, 0, 0 ),
            Position = UDim2.new( 0, 16, 0, 10 ),
            Size = UDim2.new( 0.3, 0, 0, 0 ),
            AutomaticSize = Enum.AutomaticSize.Y,
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
              -- Settings
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