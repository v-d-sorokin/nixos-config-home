{-# LANGUAGE OverloadedStrings #-}
import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget.Weather

import System.Taffybar.Widget
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces

import System.Taffybar.Widget.Text.NetworkMonitor
import System.Taffybar.Widget.MPRIS2

import System.Taffybar.Widget.Generic.PollingBar
import System.Taffybar.Widget.Generic.PollingGraph

import System.Taffybar.Information.Memory
import System.Taffybar.Information.CPU

import System.Taffybar.Widget.CPUMonitor
import System.Taffybar.Widget.DiskIOMonitor
-- import System.Taffybar.Widget.FreedesktopNotifications
import System.Taffybar.Widget.Workspaces
import System.Taffybar.Widget.Battery
import System.Taffybar.Widget.SNITray

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
        netCfg = defaultGraphConfig
    let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
        windows = windowsNew defaultWindowsConfig
        wea = weatherNew ((defaultWeatherConfig "ULLI") { weatherTemplate = "$tempC$ °C"}) 10
        mem = pollingGraphNew memCfg 1 memCallback
        cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
        bat = textBatteryNew "$percentage$% ($status$)"
        net = networkMonitorNew defaultNetFormat Nothing
        hdd = dioMonitorNew hddCfg 1 "nvme0n1"
        tray = sniTrayNew
        audio = mpris2New
        layout = layoutNew defaultLayoutConfig
        workspaces = workspacesNew $ defaultWorkspacesConfig
    dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $ toTaffyConfig $ defaultSimpleTaffyConfig { startWidgets = workspaces : map (>>= buildContentsBox) [ layout, windows ]
                                          , endWidgets = map (>>= buildContentsBox) 
                                              [ wea, tray, clock, bat, mem, cpu, hdd, net, audio ]
                                          , barHeight = 55
                                          }
