{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE LambdaCase            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TupleSections         #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE ViewPatterns          #-}

{-# OPTIONS_GHC -Wno-deprecations #-}

import           XMonad                        hiding (Screen, focus)
import           XMonad.Core
import           XMonad.Operations             hiding (focus)
import           XMonad.StackSet               hiding (workspaces)
import qualified XMonad.StackSet               as W

import           Graphics.X11.Xinerama

import           XMonad.Config.Kde
import           XMonad.Config.Prime           (getClassHint)

import           XMonad.Hooks.DynamicLog       (dynamicLogWithPP, ppOutput,
                                                xmobar, xmonadPropLog)
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers    (doRectFloat)
import           XMonad.Hooks.RefocusLast      (refocusLastLogHook,
                                                refocusLastWhen, swapWithLast,
                                                toggleFocus)
import           XMonad.Hooks.WindowSwallowing
import           XMonad.Hooks.FloatConfigureReq (fixSteamFlicker)

import           XMonad.Layout.Magnifier
import           XMonad.Layout.LayoutModifier
import           XMonad.Layout.ResizableTile   (MirrorResize (..))
import           XMonad.Layout.ThreeColumns

import           XMonad.Util.EZConfig
import           XMonad.Util.Run
import           XMonad.Util.XUtils
import           XMonad.Util.WindowProperties

import           Control.Applicative           ((<|>))
import           System.Directory
import           System.Random
import           Control.Arrow                 ((&&&), (>>>))
import           Control.Concurrent
import           Control.Monad                 (when)
import           Data.Foldable
import           Data.Function
import           Data.List                     ((\\))
import qualified Data.List                     as List
import           Data.Map                      (Map)
import qualified Data.Map                      as Map
import           Data.Maybe
import           Data.Monoid                   (All)
import           Data.Ratio
import           GHC.List                      (lookup)
import           Text.Read                     (readMaybe)


data MyWorkspaces
  = Storm | Sleep  | Static
  | Laura | Alesia | Mine
  | Dawn  | Twain  | Gone
  deriving (Show, Eq, Bounded, Ord, Enum, Read)

{-
  Keys which are used for switching to a specific workspace.
 -}
myWorkspaces :: [(KeySym, String)]
myWorkspaces = zip keys workspaces
  where
    keys =
      [ xK_n, xK_m, xK_bracketleft
      , xK_bracketright, xK_backslash, xK_semicolon
      , xK_quoteright, xK_6, xK_7
      , xK_8, xK_9, xK_0
      ]
    workspaces = fmap show [ Storm .. ]

myAdditionalKeys :: [((KeyMask, KeySym), X ())]
myAdditionalKeys =
  [ ((myModMask, key), (windows $ greedyView ws))
  | (key, ws) <- myWorkspaces
  ] ++
  [ ((myModMask .|. shiftMask, key), (windows $ shift ws))
  | (key, ws) <- myWorkspaces
  ] ++
  -- Windows are numbered starting from 1
  [ ((myModMask, key), windows (modify' (swapNumber n)))
  | (key, n) <-  zip [xK_1 .. xK_6] [0 .. 5]
  ] ++

  [ ((myModMask, xK_c), killsWindowAndProcess [])
  , ((myModMask .|. shiftMask, xK_c), killsWindowAndProcess
      ["zoom", "telegram-desktop", "slack", "discord", "steam"]
    )

  , ((myModMask, xK_z), sendMessage MirrorShrink)
  , ((myModMask, xK_a), sendMessage MirrorExpand)
  , ((myModMask .|. shiftMask, xK_z), sendMessage Reset)

  , ((myModMask, xK_Return), spawn "alacritty")
  , ((myModMask, xK_space), sendMessage ToggleMsg)

  , ((myModMask, xK_i), windows focusMaster)
  , ((myModMask .|. shiftMask, xK_i), windows swapMaster)

  , ((myModMask, xK_f), withFocused (sink >>> windows))

  , ((myModMask, xK_u     ), sendMessage NextLayout)
  , ((myModMask, xK_comma ), sendMessage (IncMasterN ( 1)))
  , ((myModMask, xK_period), sendMessage (IncMasterN (-1)))

  {-
    Hide xmobar. Doesn't work when there are no windows.
   -}
  , ((myModMask, xK_o), sendMessage ToggleStruts)

  , ((myModMask, xK_Tab), toggleFocus)
  , ((myModMask .|. shiftMask, xK_Tab), swapWithLast)


  {-
    Rofi is used for navigating workspaces and opening applications.
    @TODO: There is an annoying bug when rofi spawns on the wrong screen
    if there are no windows open on the focused one.
   -}
  , ((myModMask, xK_p), spawn "rofi -m -4 -show run")
  , ((myModMask .|. shiftMask, xK_p), spawn "rofi -m -4 -show window")
  ]
  ++
  [((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]


swapNumber :: Int -> Stack a -> Stack a
swapNumber n stack =
  let
    (ls, mrs) = splitAt n (integrate stack)
  in case mrs of
       (m:rs) -> Stack
         { focus = m
         , up    = reverse ls
         , down  = rs
         }
       [] -> stack


killsWindowAndProcess :: [String] ->  X ()
killsWindowAndProcess names = withFocused $ \fkd -> do
  dpy <- asks display
  name <- fmap resName . io $ getClassHint dpy fkd

  withFocused killWindow

  when (name `elem` names) $ do
    let squash = concat :: Maybe [a] -> [a]
    mprop <- fmap squash $ getProp32s "_NET_WM_PID" fkd
    case mprop of
      [] -> pure ()
      (prop:_) ->
        spawn ("kill " <> show prop)


myManageHook :: ManageHook
myManageHook = composeAll $
  [ (className =? "Firefox" <&&> resource =? "Dialog")            --> doFloat
  , (title =? "NoScript Blocked Objects — Mozilla Firefox")       --> doFloat
  , (title =? "Floating Lab") --> doFloat
  , (title =? "float") --> doFloat
  , (className =? "TelegramDesktop" <&&> title =? "Media viewer") --> doFloat
  , (className =? "Anki")                                         --> doFloatTop
  , (className =? "Steam" <&&> title =? "Friends List")           --> doRectFloat (RationalRect (3 % 4) (1 % 2) (1 % 4) (1 % 2))

  {-
    KDE4 floating windows.
   -}
  , (title =? "Desktop - Plasma")   --> doFloatTop
  , (title =? "plasma-desktop")     --> doFloatTop
  , (title =? "win7")               --> doFloatTop
  , (className =? "plasmashell")    --> doFloatTop
  , (className =? "Plasma")         --> doFloatTop
  , (className =? "krunner")        --> doFloatTop
  , (className =? "kmix")           --> doFloatTop
  , (className =? "klipper")        --> doFloatTop
  , (className =? "Plasmoidviewer") --> doFloatTop
  , (className =? "kwalletd5")      --> doFloatTop
  ]
  where
    sendTo :: [String] -> MyWorkspaces -> [ManageHook]
    sendTo names ws = map (\name -> className =? name --> doShift (show ws)) names

doFloatTop :: ManageHook
doFloatTop = doFloat


type XScreen = Screen WorkspaceId (Layout Window) Window ScreenId ScreenDetail

 {-
   Show the name of the current workspace.
   1. Names should not be longer than 6 characters for aesthetic reasons.
  -}
myLogHook :: X ()
myLogHook = withWindowSet $ \winSet ->
  let
    csid :: ScreenId
    csid = screen $ current winSet

    ss :: [XScreen]
    ss = List.sortOn screen $ screens winSet

    ws :: [WindowSpace]
    ws = workspace <$> ss

    showName :: WindowSpace -> String
    showName w = xmobarName 7 (tag w)

    showScreenId :: XScreen -> String
    showScreenId s
      | sid /= csid = (\(S i) -> show i) sid
      | otherwise   = (\(S i) -> "[" ++ show i ++ "]") sid
      where
        sid = screen s
  in
    xmonadPropLog $ case ws of
      []  -> error "At least 1 workspace is always present"
      [w] -> showName w
      _   -> List.intercalate ", "
        $ zipWith each
          (showScreenId <$> ss)
          (showName <$> ws)
        where
          each n w = n ++ ":" ++ w

xmobarName :: Int -> String -> String
xmobarName n = go . List.take n
  where
    go str =
      let
        plen   = n - List.length str
        side   = plen `div` 2
        offset = plen `mod` 2
        padding n = List.take n $ List.repeat ' '
      in
        padding side ++ str ++ padding (side + offset)


type (<?>) = Choose
infixr 3 <?>

type (!*) = ModifiedLayout
infixr 4 !*

type MyLayout = (AvoidStruts !* FullScreen !* (MyThreeCols <?> MyTiled)) Window
myLayout :: MyLayout
myLayout = avoidStruts $ fullScreen $ threeCols ||| tiled

type MyTiled = (ResizeVertically !* Tall)
tiled :: MyTiled Window
tiled = resizeVertically delta $ Tall nmasters delta ratio

type MyThreeCols
  = (InverseMaster    -- Decrease master instead of increasing
  !* ResizeVertically -- Allow windows to be resized vertically as well
  !* ThreeCol         -- Three columns layout
  )
threeCols :: MyThreeCols Window
threeCols
  = inverseMaster
  $ resizeVertically delta
  $ ThreeColMid nmasters delta ratio

nmasters :: Int
nmasters = 1

delta, ratio :: Ratio Integer
delta   = 6/100
ratio   = 1/2

myModMask :: KeyMask
myModMask = mod4Mask

myHandleEventHook :: Event -> X All
myHandleEventHook
  =  refocusLastWhen (liftX . pure $ True)
  <> fixSteamFlicker
  -- I have no idea what it does
  -- <> swallowEventHook (className =? "Alacritty" <||> className =? "Termite") (return True)

-- myConfig :: XConfig DefaultLayout
myConfig = kde4Config
  { modMask            = myModMask
  , borderWidth        = 3
  , focusedBorderColor = "#e2a478"
  , normalBorderColor  = "#1c1c1c"
  , workspaces         = fmap snd myWorkspaces
  , layoutHook         = myLayout
  , logHook            = refocusLastLogHook <+> myLogHook
  , manageHook         =
    manageHook kde4Config <+> myManageHook -- <+> insertPosition Below Newer
  , handleEventHook    = myHandleEventHook
  , focusFollowsMouse  = False
  , terminal           = "alacritty"
  } `additionalKeys` myAdditionalKeys

main :: IO ()
main = do
  {-
    Ensure that only one instance of XMobar is running.
   -}
  spawn "killall xmobar" >> threadDelay 100000

  {-
    Spawn XMobar on each screen.
   -}
  dpy <- openDisplay ""
  ns  <- List.length <$> getScreenInfo dpy
  for_ [0 .. ns - 1] $ \n -> spawn $ "xmobar --screen " <> show (ns - n - 1)


  {-
    Start XMonad.
   -}
  xmonad . ewmh . docks $ myConfig


{-
  My own layouts
 -}

data ResizeVertically a = ResizeVertically
  { rv_delta :: Rational
  , rv_fracs :: Map Window Rational
  }
  deriving (Show, Read)

resizeVertically :: Rational -> l a -> ModifiedLayout ResizeVertically l a
resizeVertically r l = ModifiedLayout (ResizeVertically r Map.empty) l

instance LayoutModifier ResizeVertically Window where
  handleMess layout msg
    | Just MirrorShrink <- fromMessage msg = resizeFocus (rv_delta layout)
    | Just MirrorExpand <- fromMessage msg = resizeFocus (0 - rv_delta layout)

    | Just Reset <- fromMessage msg = pure $ Just $ layout { rv_fracs = Map.empty }

    | otherwise = pure Nothing

    where
      resizeFocus :: Rational -> X (Maybe (ResizeVertically Window))
      resizeFocus delta = do
        mws <- stack . workspace . current <$> gets windowset
        pure $ mws >>= Just . resizeFocus' delta

      resizeFocus' :: Rational -> Stack Window -> ResizeVertically Window
      resizeFocus' delta stack = layout { rv_fracs = newfracs }
        where
          newfracs = Map.insertWith (+) (focus stack) delta (rv_fracs layout)

  redoLayout
    :: ResizeVertically Window
    -> Rectangle
    -> Maybe (Stack Window)
    -> [(Window, Rectangle)]
    -> X ([(Window, Rectangle)], Maybe (ResizeVertically Window))
  redoLayout _ _ Nothing wrs = pure (wrs, Nothing)
  redoLayout rv screen (Just _) wrs = do
    fs <- floating <$> gets windowset
    let wrs_new = concat $ resplitVertically screen fs (rv_fracs rv) <$> separateCols wrs

    pure . (, Nothing) $ wrs_new



type List a = [a]

-- TODO: this might screw up the order of floating windows
separateCols
  :: List (Window, Rectangle)
  -> List (List (Window, Rectangle))
separateCols
  =   List.sortBy (compare `on` (snd >>> rect_x))
  >>> List.groupBy ((==) `on` (snd >>> rect_x))
  >>> fmap (List.sortBy (compare `on` (snd >>> rect_y)))


resplitVertically
  :: Rectangle               {- dimensions of the whole screen -}
  -> Map Window RationalRect {- floating windows -}
  -> Map Window Rational     {- fractions by which to resplit windows -}
  -> [(Window, Rectangle)]
  -> [(Window, Rectangle)]
resplitVertically screen floats fracs = go
  where
    go :: [(Window, Rectangle)] -> [(Window, Rectangle)]
    go [] = []

    -- If there is only one window, do nothing
    go [wr] = [wr]

    -- The last window is resized from the top border
    go [(w, r), (w_last, r_last)] =
      let frac = Map.findWithDefault 0 w fracs
          frac_last = Map.findWithDefault 0 w_last fracs
          d = delta (frac + frac_last)
          r' = fit screen $ r { rect_height = rect_height r + d }
          r_last' = fit screen $
            r_last
              { rect_height = rect_height r_last - d
              , rect_y      = rect_y r_last + fi d
              }
      in [(w, r'), (w_last, r_last')]


    -- Generally windows are resized by moving the bottom border of triangle
    go ((w, r):(w_next, r_next):wrs)
      | Just frac <- Map.lookup w fracs =
        let
          d = delta frac
          r' = fit screen $ r { rect_height = rect_height r + d }
          r_next' = fit screen $
            r_next
              { rect_height = rect_height r_next - d
              , rect_y      = rect_y r_next + fi d
              }
        in (w, r') : go ((w_next, r_next'):wrs)

    -- Otherwise do nothing
    go (wr:wrs) = wr : go wrs

    delta :: Rational -> Dimension
    delta frac = truncate $ fromIntegral (rect_height screen) * frac

fit :: Rectangle -> Rectangle -> Rectangle
fit (Rectangle sx sy sw sh) (Rectangle x y w h) = Rectangle x' y' w' h'
  where
    x' = max sx (x - max 0 (x + fi w - sx - fi sw))
    y' = max sy (y - max 0 (y + fi h - sy - fi sh))
    w' = min sw w
    h' = min sh h

data Reset = Reset
    deriving (Typeable)
instance Message Reset

---------------------------------------------------

data InverseMaster a = InverseMaster
  deriving (Show, Read)

instance LayoutModifier InverseMaster Window where
  handleMessOrMaybeModifyIt _ msg
    | Just (IncMasterN d) <- fromMessage msg = pure . Just . Right . SomeMessage $ IncMasterN (-d)
    | otherwise = pure Nothing

inverseMaster :: l a -> ModifiedLayout InverseMaster l a
inverseMaster = ModifiedLayout InverseMaster


----------------------------------------------------

data ToggleMsg = ToggleMsg
  deriving (Typeable)
instance Message ToggleMsg


data FullScreen a = FullScreen { fs_toggle :: Toggle }
  deriving (Read, Show)

fullScreen :: l a -> ModifiedLayout FullScreen l a
fullScreen = ModifiedLayout (FullScreen Off)

instance LayoutModifier FullScreen Window where
  redoLayout layout screen (Just stack) wrs =
    case (fs_toggle layout) of
      On  -> pure (applyFullscreen screen stack wrs, Nothing)
      Off -> pure (wrs, Nothing)
  redoLayout _ _ _ wrs = pure (wrs, Nothing)

  pureMess = handlePureMess

handlePureMess :: FullScreen a -> SomeMessage -> Maybe (FullScreen a)
handlePureMess layout msg
  | Just ToggleMsg <- fromMessage msg = Just layout { fs_toggle = toggle $ fs_toggle layout }
handlePureMess _ _ = Nothing


applyFullscreen :: Rectangle -> Stack Window -> [(Window, Rectangle)] -> [(Window, Rectangle)]
applyFullscreen screen stack wrs = reverse $ foldr go [] wrs
  where
    go :: (Window, Rectangle) -> [(Window, Rectangle)] -> [(Window, Rectangle)]
    go (w, wr) ws
      | focused == w = ws ++ [(w, screen)]
      | otherwise    = (w, wr) : ws

    focused = focus stack


data Toggle = On | Off
  deriving (Read, Show, Eq)

toggle :: Toggle -> Toggle
toggle On  = Off
toggle Off = On

