import XMonad
import XMonad.Prompt
import XMonad.Hooks.Script
import XMonad.Layout.ShowWName
import XMonad.Hooks.DynamicLog
import XMonad.Actions.DynamicWorkspaces
import XMonad.Hooks.SetWMName
import Data.Monoid
import System.Exit
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.PerWorkspace
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageDocks
import XMonad.Layout.PerWorkspace
import XMonad.Layout.EqualSpacing
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run
import XMonad.Hooks.UrgencyHook
import System.IO

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myTerminal = "urxvt"
myBorderWidth = 3
myModMask = mod4Mask
myWorkspaces = ["1:term","2:chrome","3:emacs","4:slack","5","6","7","8","9"]


colorYellow1 = "#FCE94F"
colorYellow2 = "#EDD400"
colorYellow3 = "#C4A000"

colorOrange1 = "#FCAF3E"
colorOrange2 = "#F57900"
colorOrange3 = "#CE5C00"

colorRed1 = "#EF2929"
colorRed2 = "#CC0000"
colorRed3 = "#A40000"

colorGreyLight1 = "#EEEEEC"
colorGreyLight2 = "#D3D7CF"
colorGreyLight3 = "#BABDB6"

colorGreyDark1 = "#888A85"
colorGreyDark2 = "#555753"
colorGreyDark3 = "#2E3436"

myNormalBorderColor  = colorGreyLight1
myFocusedBorderColor = colorRed3

equalSpaceLayout = equalSpacing 50 5 0 1 $ tiled ||| Mirror tiled ||| Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

newsLayout = equalSpacing 50 5 0 1 $ Full

myLayoutHook = avoidStruts $ onWorkspaces ["7:main"] newsLayout $
               equalSpaceLayout

myStartupHook = setWMName "LG3D"

myManageHook = composeAll
    [ className =? "mpv"            --> doFloat
    , className =? "Gimp"           --> doFloat ]

myEventHook = mempty

myXmonadBar = "dzen2 -x '0' -y '0' -h '35' -w '1900' -ta 'l' -fg '" ++ colorGreyLight2 ++"' -bg '" ++ colorGreyDark3 ++"'"
myStatusBar = "dzen2 -x '1900' -y '0' -h '35' -w '1400' -ta 'r' -fg '" ++ colorGreyLight2 ++"' -bg '" ++ colorGreyDark3 ++"'"

myLogHook h = dynamicLogWithPP $ defaultPP
    { ppCurrent         = dzenColor colorOrange1 colorGreyDark3 . pad 
    , ppHidden          = dzenColor colorGreyLight1 colorGreyDark3 . pad 
    , ppHiddenNoWindows = dzenColor colorGreyDark1 colorGreyDark3 . pad 
    , ppLayout          = dzenColor colorYellow1 colorGreyDark3 . pad 
    , ppUrgent          = dzenColor colorRed2 colorGreyDark3 . pad . dzenStrip
    , ppTitle           = shorten 100
    , ppWsSep           = ""
    , ppSep             = ""
    , ppOutput          = hPutStrLn h
    }
    
main = do
     dzenLeftBar <- spawnPipe myXmonadBar
     spawn $ "conky -c /home/dnardo/.config/conky/conky.config | " ++ myStatusBar
     xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
          modMask = mod4Mask
	, focusedBorderColor = "#ee9a00"
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        , layoutHook         = myLayoutHook
        , manageHook         = myManageHook
        , handleEventHook    = myEventHook
        , logHook            = myLogHook dzenLeftBar
        , startupHook        = myStartupHook
	}        
        `additionalKeys`
	[((mod4Mask, xK_r), renameWorkspace defaultXPConfig)]
