local mq = require('mq')
local utils = require('utils')
local commands = require('commands')
local gui = require('gui')
local nav = require('nav')
local pull = require('pull')

utils.PluginCheck()

mq.cmd('/assist off')

mq.imgui.init('controlGUI', gui.controlGUI)

commands.init()

local toggleboton = gui.botOn or false

local function returnChaseToggle()
    if gui.botOn and gui.returnToCamp and not toggleboton then
        if nav.campLocation == nil then
            nav.setCamp()
            toggleboton = true
        end
    elseif not gui.botOn and toggleboton then
        nav.clearCamp()
        toggleboton = false
    end
end

utils.loadPullConfig()

while gui.controlGUI do

    returnChaseToggle()

    if gui.botOn then

        utils.monitorNav()

        if gui.pullOn then
            pull.pullRoutine()
        end
        
        if gui.assistMelee then
            utils.assistMonitor()
        end
    end

    mq.doevents()
    mq.delay(100)
end