import           System.Taffybar
import           System.Taffybar.FreedesktopNotifications
import           System.Taffybar.SimpleClock
import           System.Taffybar.Systray
import           System.Taffybar.TaffyPager
import           System.Taffybar.Weather

import           System.Taffybar.Battery
import           System.Taffybar.DiskIOMonitor
import           System.Taffybar.MPRIS2
import           System.Taffybar.NetMonitor

import           System.Taffybar.Widgets.PollingBar
import           System.Taffybar.Widgets.PollingGraph
import           System.Taffybar.Widgets.PollingLabel
import           System.Taffybar.Widgets.Util

import           System.Information.CPU
import           System.Information.CPU2
import           System.Information.DiskIO
import           System.Information.Memory

import           Control.Monad
import           Data.Time.Locale.Compat
import           System.IO
import Graphics.UI.Gtk

memCallback = do
    mi <- parseMeminfo
    return [memoryUsedRatio mi]

cpuCallback = do
    (_, systemLoad, totalLoad) <- cpuLoad
    return [ totalLoad, systemLoad ]

cpuTempCallback = do
    temp <- head <$> getCPUTemp ["cpu0"]
    return [1.0] --[realToFrac temp / 100.0]

briCallback = do
    let dir = "/sys/class/backlight/intel_backlight/"
    actual <- (withFile (dir ++ "actual_brightness") ReadMode $ liftM read . hGetLine) :: IO Double
    max <- (withFile (dir ++ "max_brightness") ReadMode $ liftM read . hGetLine) :: IO Double
    return $ show (round $ actual / max * 100.0) ++ "%"

soundCallback = do
    return "mute"

pollingLabelNew' d tm f = do
  l    <- pollingLabelNew d tm f
  ebox <- eventBoxNew
  containerAdd ebox l
  widgetShowAll ebox
  return (toWidget ebox)

main = do
    let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                    , graphLabel = Just "mem"
                                    }
        cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                    , graphLabel = Just "cpu"
                                    }
        hddCfg = defaultGraphConfig { graphDataColors = [ (0, 0, 1, 1), (0, 1, 0, 0.5)]
                                    , graphLabel = Just "hdd"
                                    }
        tempCfg = defaultGraphConfig { graphDataColors = [ (1, 0, 0, 1)]
                                     , graphLabel = Just "temp"
                                     }
    let clock = textClockNew (Just defaultTimeLocale) "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
        pager = taffyPagerNew defaultPagerConfig
--        note = notifyAreaNew defaultNotificationConfig
        wea = weatherNew ((defaultWeatherConfig "ULLI") { weatherTemplate = "$tempC$ °C"}) 10
        mem = pollingGraphNew memCfg 1 memCallback
        cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
        temp = pollingGraphNew tempCfg 1 cpuTempCallback
        bri = pollingLabelNew' "-" 1 briCallback
        sound = pollingLabelNew' "-" 1 soundCallback
        wl = netMonitorNew 1.0 "wlp3s0"
        hdd = dioMonitorNew hddCfg 1 "sdb"
        bat = batteryBarNew defaultBatteryConfig 1
        tray = systrayNew
        audio = mpris2New

    defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager ]
                                          , endWidgets = [ tray, wea, clock, bat, bri, sound, mem, cpu, wl, audio ]
                                          , barHeight = 50
                                          , barPosition = Top
                                          }
