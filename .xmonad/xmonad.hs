{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

import           XMonad
import           XMonad.Hooks.DynamicLog      (dynamicLogWithPP, ppOutput,
                                               xmobar)
import           XMonad.Hooks.FadeInactive    (fadeIn, fadeInactiveLogHook,
                                               fadeOutLogHook)
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.Circle         (Circle (..))
import           XMonad.Layout.LayoutModifier (ModifiedLayout)
import           XMonad.Operations
import           XMonad.StackSet              hiding (workspaces)
import           XMonad.Util.EZConfig

import           Control.Applicative          ((<|>))
import           Control.Monad                (when)
import qualified Data.List                    as L

-- Dev1 and Dev2 should be shown first.
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
  -- there might be a data race, I'm not sure now
  [ ((myModMask, xK_c), (withFocused killWindow) >> sendMessage Killed) ] ++
  [ ((myModMask, xK_i), (sendMessage Fade)) ] ++
  [ ((myModMask, xK_b), (sendMessage ToggleStruts)) ]

myManageHook = composeAll
  [ (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat
  , (className =? "TelegramDesktop" <&&> title =? "Media viewer") --> doFloat
  , (className =? "Anki" <&&> title =? "Add") --> doFloat
  , (className =? "mpv" <&&> className =? "gl") --> doFloat
  ]

-- Slightly configured Tall layout with
-- an ability to switch fading on and off
data Fading = On | Off
  deriving (Show, Read, Eq)

switch :: Fading -> Fading
switch On  = Off
switch Off = On

data Fade = Fade
  deriving (Typeable)

instance Message Fade

data Killed = Killed
  deriving (Typeable)

instance Message Killed

data MyTall a = MyTall
  { fading :: Fading
  , tall   :: (Tall a)
  }
  deriving (Show, Read)

instance LayoutClass MyTall a where
  pureLayout = pureLayout . tall

  -- There is always at least one master window
  -- and there can't be more master windows then windows on this workspace
  handleMessage mt@(MyTall fade (Tall nmaster delta frac)) m =
      case fromMessage m of
        Just (IncMasterN d) -> Just <$> incmastern d
        Nothing  ->
          case fromMessage m of
            Just Killed -> Just <$> kill
            Nothing     -> pure (pureMessage mt m)
    where
      winNumA = withWindowSet (pure . L.length . integrate' . stack . workspace . current)
      shrink n = max 1 . min n

      kill =
        winNumA >>= (\n -> pure $ MyTall fade (Tall (shrink (n - 1) nmaster) delta frac))

      incmastern d =
        winNumA >>= (\n -> pure $ MyTall fade (Tall (shrink n (d + nmaster)) delta frac))


  pureMessage (MyTall fade (Tall nmaster delta frac)) m
      =   resize   <$> fromMessage m
      <|> swfading <$> fromMessage m
    where
      resize Shrink = MyTall fade (Tall nmaster delta (max 0 $ frac-delta))
      resize Expand = MyTall fade (Tall nmaster delta (min 1 $ frac+delta))

      swfading Fade = MyTall (switch fade) (Tall nmaster delta frac)

  -- A hack to get internal state out of an existential
  description (MyTall fade _) = show fade

myLogHook :: X ()
myLogHook = withWindowSet $ \winSet -> do
  let curLayout = layout . workspace . current $ winSet
  case description curLayout of
    "On" -> fadeInactiveLogHook 0.85
    _    -> fadeInactiveLogHook 1

myLayoutHook = avoidStruts $ tiled ||| Full
  where
    tiled = MyTall fade $ Tall nmaster delta ratio
    fade    = On
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2

myModMask = mod4Mask

myConfig = def
  { modMask     = myModMask
  , borderWidth = 0
  , workspaces  = fmap snd myWorkspaces
  , layoutHook  = avoidStruts myLayoutHook
  , logHook     = myLogHook
  , manageHook  = myManageHook <+> manageHook def
  , terminal    = "alacritty"
  } `additionalKeys` myAdditionalKeys

main = do
  spawn "xmobar"
  xmonad (docks myConfig)


