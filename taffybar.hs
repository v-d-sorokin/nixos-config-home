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
import           System.Information.DiskIO
import           System.Information.Memory

import           Data.Time.Locale.Compat

import           Graphics.UI.Gtk
-- import Web.Cloud.Dropbox

memCallback = do
    mi <- parseMeminfo
    return [memoryUsedRatio mi]

cpuCallback = do
    (_, systemLoad, totalLoad) <- cpuLoad
    return [ totalLoad, systemLoad ]

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
    let clock = textClockNew (Just defaultTimeLocale) "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
        pager = taffyPagerNew defaultPagerConfig
        note = notifyAreaNew defaultNotificationConfig
        wea = weatherNew ((defaultWeatherConfig "KMSN") { weatherTemplate = "$tempC$ °C"}) 10
        mem = pollingGraphNew memCfg 1 memCallback
        cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
        wl = netMonitorNew 1.0 "wlp3s0"
        eth = netMonitorNew 1.0 "enp0s25"
        hdd = dioMonitorNew hddCfg 1 "sdb5"
        bat = batteryBarNew defaultBatteryConfig 1
        tray = systrayNew
        audio = mpris2New

    defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                          , endWidgets = [ tray, wea, clock, bat, mem, cpu, hdd, wl, eth, audio ]
                                          , barHeight = 50
                                          , barPosition = Top
                                          }
