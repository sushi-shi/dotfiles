{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
import           XMonad
import           XMonad.Hooks.DynamicLog      (xmobar)
import           XMonad.Hooks.FadeInactive    (fadeIn, fadeInactiveLogHook,
                                               fadeOutLogHook)
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.Circle         (Circle (..))
import           XMonad.Layout.LayoutModifier (ModifiedLayout)
import           XMonad.StackSet              hiding (workspaces)
import           XMonad.Util.EZConfig

import           Control.Monad                (when)
data Workspace = Dev1 | Dev2
               | W6   | W7   | W8  | W9
               | W10  | W11  | W12 | W13    | W14
  deriving (Show, Eq, Bounded, Ord, Enum)

myWorkspaces = zip
  ([xK_n, xK_m] ++ [xK_1..xK_9])
  (fmap show [Dev1 ..])

myAdditionalKeys =
  [ ((myModMask, key), (windows $ greedyView ws))
  | (key, ws) <- myWorkspaces
  ] ++
  [ ((myModMask .|. shiftMask, key), (windows $ shift ws))
  | (key, ws) <- myWorkspaces
  ] ++
  [((myModMask, xK_c), (withFocused killWindow)) ] ++
  [((myModMask, xK_i), (withWindowSet (mapM_ fadeIn . index)))]

myManageHook = composeAll
  [ (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat
  , (className =? "TelegramDesktop" <&&> title =? "Media viewer") --> doFloat
  , (title =? "Labs") --> doFloat
  , (className =? "Anki" <&&> title =? "Add") --> doFloat
  , (className =? "mpv" <&&> className =? "gl") --> doFloat
  ]

-- A simple wrapper to be able to distinguish between
-- layouts with and without fading
newtype TH a = TH (Tall a)
  deriving (Show, Read)

instance LayoutClass TH a where
  pureLayout (TH tall)  = pureLayout tall
  pureMessage (TH tall) = fmap TH . pureMessage tall
  description _         = "TH"

tiledH = TH $ Tall nmaster delta ratio
  where
    nmaster = 1
    delta   = 1/100
    ratio   = 1/2

myLogHook :: X ()
myLogHook = withWindowSet $ \winSet -> do
  let curLayout = layout . workspace . current $ winSet
  if (description curLayout == description tiledH)
    then fadeInactiveLogHook 0.85
    else fadeInactiveLogHook 1

myLayoutHook = avoidStruts $ tiledH ||| tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2

myModMask = mod4Mask

myConfig = def
  { modMask     = myModMask
  , borderWidth = 0
  , workspaces  = fmap snd myWorkspaces
  , layoutHook  = myLayoutHook
  , logHook     = myLogHook
  , manageHook  = myManageHook <+> manageHook def
  , terminal    = "alacritty"
  } `additionalKeys` myAdditionalKeys

main = xmonad =<< xmobar myConfig
