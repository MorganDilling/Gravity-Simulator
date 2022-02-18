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
        Font = Enum.Font.Gotham,
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
          local Type = type(props.SettingDefault)
          if Type == "boolean" then
            local state = State(props.SettingDefault)

            local toggle = State( 0 )

            local toggleSpring = Spring( toggle, 13 )

            return New "Frame" {
              Name = "ToggleBG",
              Size = UDim2.new( 0, 28, 0, 16 ),
              BackgroundColor3 = Color3.fromRGB( 94, 94, 94 ),
              Position = UDim2.new( 0.5, 0, 0.5, 0 ),
              AnchorPoint = Vector2.new( 0.5, 0.5 ),
              [ Children ] = {
                New "UICorner" {
                  CornerRadius = UDim.new( 1, 0 )
                },
                New "ImageButton" {
                  Name = "ToggleBG",
                  Size = UDim2.new( 0, 16, 0, 16 ),
                  BackgroundColor3 = Computed(function()
                    local state = state:get();
                    return ({[ false ] = Color3.fromRGB(228, 62, 62), [ true ] = Color3.fromRGB(126, 226, 79)})[state] -- chooses either red or green based on state
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
                    state:set(not state:get())
                    toggle:set(state:get() == false and 0 or 1)
                  end
                }
              }
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
            Size = UDim2.new( 0.3, 0, 0.3, 0 ),
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
              MenuItem {
                Name = "Testing 0",
                SettingDefault = false
              },
              MenuItem {
                Name = "Testing 1",
                SettingDefault = false
              },
              MenuItem {
                Name = "Testing 2",
                SettingDefault = false
              },
              MenuItem {
                Name = "Testing 3",
                SettingDefault = false
              },
            }
          }
        }
      }
    }
  }
end