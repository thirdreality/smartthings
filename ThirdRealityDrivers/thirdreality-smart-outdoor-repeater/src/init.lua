-- Copyright 2024 SmartThings
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

local capabilities = require "st.capabilities"
local ZigbeeDriver = require "st.zigbee"
local defaults = require "st.zigbee.defaults"
local clusters = require "st.zigbee.zcl.clusters"

local Basic = clusters.Basic
local PowerConfiguration = clusters.PowerConfiguration
local TemperatureMeasurement = clusters.TemperatureMeasurement

local function do_refresh(self, device)
  device:send(Basic.attributes.ZCLVersion:read(device))
  device:send(TemperatureMeasurement.attributes.MeasuredValue:read(device))
  device:send(PowerConfiguration.attributes.BatteryPercentageRemaining:read(device))
end

local zigbee_outdoor_repeater_driver = {
  supported_capabilities = {
    capabilities.temperatureMeasurement,
    capabilities.battery,
    capabilities.refresh,
  },
  capability_handlers = {
    [capabilities.refresh.ID] = {
      [capabilities.refresh.commands.refresh.NAME] = do_refresh,
    }
  },
  health_check = false,
}

defaults.register_for_default_handlers(zigbee_outdoor_repeater_driver, zigbee_outdoor_repeater_driver.supported_capabilities)
local driver = ZigbeeDriver("thirdreality-smart-outdoor-repeater", zigbee_outdoor_repeater_driver)
driver:run()
