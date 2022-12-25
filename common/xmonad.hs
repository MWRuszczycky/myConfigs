import qualified XMonad                  as XM
import qualified XMonad.StackSet         as W
import qualified Data.Map                as M
import qualified XMonad.Hooks.DynamicLog as DL
import qualified XMonad.Layout.Spacing   as LS
import XMonad                                   ( xmonad       )
import XMonad.Layout.IndependentScreens         ( countScreens )
import Control.Monad                            ( when         )
import Data.Bits                                ( (.|.)        )

main = xmonad =<< myXmobar myConfiguration

myConfiguration = XM.def
        { XM.borderWidth           = 1
        , XM.terminal              = "urxvt"
        , XM.normalBorderColor     = "#000000"
        , XM.focusedBorderColor    = "#00afaf"
        , XM.modMask               = XM.mod4Mask
        , XM.keys                  = reBindKeys
        , XM.focusFollowsMouse     = False
        , XM.startupHook           = runAtStartup
        , XM.layoutHook            = addSpace XM.def
        }

-- Strings to run external processes
runBashProfile   = "bash ~/.bash_profile"
setupDualScreens = "xrandr --output HDMI-1 --primary --auto --right-of LVDS-1"
runXmobar        = "xmobar"
runDMenu         = "dmenu_run -b -nb black -nf '#00ceff' -sb black -sf '#ee9a00'"
setBackground    = "feh --bg-fill ~/Pictures/Background/MaKe.jpg"

-- Processes to run when XMonad starts.
runAtStartup = do
    XM.spawn runBashProfile
    thereAreTwoScreens <- (==2) <$> countScreens
    when thereAreTwoScreens $ XM.spawn setupDualScreens
    XM.spawn setBackground

-- Add 2 pixel space around each window when there is more than one.
addSpace = LS.smartSpacing 2 . XM.layoutHook

-- Set up XMobar from the XMonad end. This only handles the input from
-- XMonad which is supplied to the StdinReader command. The rest of
-- the commands need to be specified in the .xmobarrc configuration
-- file in the home directory, otherwise you will get a default.
myXmobar = DL.statusBar runXmobar myPP toggleKey
    where toggleKey c = let m = XM.modMask c in ( m, XM.xK_b )
          myPP = XM.def { DL.ppCurrent = DL.xmobarColor "#00ceff" "" . DL.wrap "[" "]"
                     , DL.ppVisible = DL.wrap "(" ")"
                     , DL.ppUrgent  = DL.xmobarColor "red" ""
                     , DL.ppSep     = " | "
                     , DL.ppTitle   = DL.xmobarColor "#00d659" "" . DL.shorten 60
                     }

-- Rebind the keys. This is a function that takes the configuration,
-- extracts the current bindings from it and merges it with a new
-- map of key bindings rewriting any that are already defined. The
-- bindings are a map of modifier-key pairs to XMonad actions.
reBindKeys c@(XM.XConfig {XM.modMask = m}) = M.union ks ( XM.keys XM.def c )
    where retileFloating = XM.withFocused $ XM.windows . W.sink
          ks = M.fromList $
             [ -- Start dmenu with mod-d
               ( (m, XM.xK_d), XM.spawn runDMenu             )
               -- Start a new terminal with mod-Return
             , ( (m, XM.xK_Return), XM.spawn $ XM.terminal c )
               -- Moving between the windows
             , ( (m, XM.xK_h), XM.windows W.focusUp          )
             , ( (m, XM.xK_t), XM.windows W.focusDown        )
               -- Repositioning the windows
             , ( (m .|. XM.shiftMask, XM.xK_h), XM.windows W.swapUp     )
             , ( (m .|. XM.shiftMask, XM.xK_t), XM.windows W.swapDown   )
             , ( (m .|. XM.shiftMask, XM.xK_m), XM.windows W.swapMaster )
               -- Move windows into or out of master pane
             , ( (m, XM.xK_c), XM.sendMessage (XM.IncMasterN 1)    )
             , ( (m, XM.xK_w), XM.sendMessage (XM.IncMasterN (-1)) )
               -- Resizing the windows
             , ( (m .|. XM.shiftMask, XM.xK_c), XM.sendMessage XM.Expand )
             , ( (m .|. XM.shiftMask, XM.xK_w), XM.sendMessage XM.Shrink )
               -- Retile a floating window
             , ( (m .|. XM.shiftMask, XM.xK_Return), retileFloating      )
             , ( (m, XM.xK_x), XM.kill                                   )
             ]
             -- This removes the greedy view so that windows stay in
             -- there original workspace when you change workspaces.
             ++ [ ( (m' .|. m, k), XM.windows $ f i )
                    | (i,k)  <- zip (XM.workspaces c) [XM.xK_1 .. XM.xK_9]
                    , (f,m') <- [(W.view, 0), (W.shift, XM.shiftMask)]
                ]
