import           Data.Monoid
import           XMonad                           hiding ((|||))
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Util.EZConfig             (additionalKeys)
import           XMonad.Util.Run                  (spawnPipe)


import           XMonad.Layout.DwmStyle
import           XMonad.Layout.LayoutCombinators
import           XMonad.Layout.NoBorders
import           XMonad.Layout.SimplestFloat


import           XMonad.Prompt
import           XMonad.Prompt.Shell
import           XMonad.Prompt.XMonad

import           System.Exit
import           System.IO

import qualified Data.Map                         as M
import qualified XMonad.StackSet                  as W

import           Graphics.X11.ExtraTypes.XF86
import           System.Taffybar.Hooks.PagerHints (pagerHints)
import           XMonad.Hooks.EwmhDesktops        (ewmh)


import           Control.Concurrent               (forkOS)
import           XMonad.Config.Desktop
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.ToggleLayouts      (ToggleLayout (..),
                                                   toggleLayouts)

import           XMonad.Layout.Column
import           XMonad.Layout.DragPane
import           XMonad.Layout.FixedColumn
import           XMonad.Layout.TwoPane

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
-- myTerminal      = "urxvt -fn 'xft:Source Code Pro:pixelsize=22' -background black -foreground gray"
myTerminal = "evilvte"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use.
myModMask       = mod4Mask

-- A tagging example:
myWorkspaces    = ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#333333"
myFocusedBorderColor = "#235a6e"

shellConf :: XPConfig
shellConf = def { font = "xft: Sans-12", height = 40 }

-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@XConfig {XMonad.modMask = modm} = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm .|. shiftMask, xK_x     ), spawn "chromium")
    , ((modm .|. shiftMask, xK_f     ), spawn "firefox")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_Escape), sendMessage $ ToggleStrut U)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm,               xK_m ), sendMessage $ JumpToLayout "Full")
    , ((modm,               xK_f ), sendMessage $ JumpToLayout "SimplestFloat")
    , ((modm,               xK_t ), sendMessage $ JumpToLayout "Tall")

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm .|. shiftMask, xK_Delete     ), sendMessage $ ToggleStrut U)


    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    -- , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
--    , ((modm .|. shiftMask,   xK_space     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm .|. shiftMask, xK_h), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm .|. shiftMask, xK_l), sendMessage (IncMasterN (-1)))

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_space), withFocused $ windows . W.sink)

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((modm              , xK_Tab   ), windows W.focusDown    )
    , ((modm              , xK_F3    ), shellPrompt shellConf )

      -- multimedia keys
      --
    , ((0            , xF86XK_AudioLowerVolume), spawn "sudo amixer -q set Master 2dB-")
    , ((0            , xF86XK_AudioRaiseVolume), spawn "sudo amixer -q set Master 2dB+")
    , ((0            , xF86XK_AudioMute), spawn "sudo amixer -q set Master toggle")
      -- XF86AudioNext
    , ((0            , 0x1008ff17), spawn "audacious -f")
      -- XF86AudioPrev
    , ((0            , 0x1008ff16), spawn "audacious -r")
      -- XF86AudioPlay
    , ((0            , 0x1008ff14), spawn "audacious -t")
    , ((0            , xF86XK_Calculater), spawn "kcalc")
    , ((0            , xF86XK_Sleep), spawn "sudo systemctl suspend")
      -- XF86WebCam
    , ((0            , 0x1008ff8f),  spawn "scrot")
    , ((0            , xF86XK_Music), spawn "audacious")
    , ((0            , xF86XK_AudioMedia), spawn "audacious")
      --  0x1008ff41, XF86Launch1
      --  , ((modm,               xK_space ), sendMessage NextLayout)
      --  , ((0,               xK_Tab   ), windows W.focusDown)
      -- XF86ZoomIn
      , ((0            , xF86XK_LaunchA),  spawn "xdotool key ctrl click 4")
      -- XF86ZoomOut
      , ((0            , xF86XK_ZoomOut),  spawn "xdotool key 'ctrl+minus'")
      --
      , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight +10")
      , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -10")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_i, xK_o] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button3), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button2), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)
    ]


myLayouts = avoidStruts (smartBorders others) ||| smartBorders Full
    where
        others = tiled ||| simplestFloat ||| fixed ||| twopane ||| column
        tiled   = Tall nmaster delta ratio
        nmaster = 1
        ratio   = 1/2
        delta   = 3/100
        fixed = FixedColumn 1 20 100 10
        twopane = TwoPane (3/100) (1/2)
        dragpane = dragPane Horizontal (1/10) (1/2)
        column = Column (16/10)

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "XTerm"          --> doFloat
    , className =? "feh"            --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "Audacious" --> doShift "ι"
    ] <+> manageDocks

main = do
    xmproc <- spawnPipe "taffybar"
    xmonad $ docks $ ewmh $ pagerHints $ def
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , keys               = myKeys
        , mouseBindings      = myMouseBindings
        , layoutHook         = myLayouts
        , manageHook         = myManageHook <+> manageHook def <+> manageDocks
    }
