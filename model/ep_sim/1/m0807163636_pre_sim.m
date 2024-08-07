%%
% @file  m0807163636_pre_sim 
%
% This file contains the initialization of the MIL simulation.
% @date  07-Aug-2024 16:36:37
%
% (c) 2007-2024 by BTC Embedded Systems AG, Germany
%%
% Pre-simulation init of WS variables in order to make model compilable.
if ~exist('i_if_378', 'var'), evalin('base', 'i_if_378 = [0, 0];'); end
if ~exist('i_if_380', 'var'), evalin('base', 'i_if_380 = [0, 0];'); end
if ~exist('i_if_382', 'var'), evalin('base', 'i_if_382 = [0, 0.0];'); end
if ~exist('i_if_384', 'var'), evalin('base', 'i_if_384 = [0, 30];'); end
if ~exist('i_if_386', 'var'), evalin('base', 'i_if_386 = [0, 35];'); end
if ~exist('i_if_388', 'var'), evalin('base', 'i_if_388 = [0, 45];'); end

%'seat_heating_control/runa2_sys/HeatingRequest_GetButtonPressed'
evalin('base', 'P_IDT_ButtonStatus.Value = boolean(i_if_378(1, 2));');

%'seat_heating_control/runa3_sys/Subsystem/HeatingActivate_SetHeatingCoil'
evalin('base', 'P_IDT_Temperature.Value = uint8(i_if_380(1, 2));');

%'seat_heating_control/runa1_sys/Constant'
evalin('base', 'RTE_OK = double(i_if_382(1, 2));');

%'seat_heating_control/runa3_sys/Subsystem/CPA_TemperatureRanges_TemperatureRanges'
evalin('base', 'TemperatureRanges_TemperatureStage1.Value = uint8(i_if_384(1, 2));');

%'seat_heating_control/runa3_sys/Subsystem/CPA_TemperatureRanges_TemperatureStage2'
evalin('base', 'TemperatureRanges_TemperatureStage2.Value = uint8(i_if_386(1, 2));');

%'seat_heating_control/runa3_sys/Subsystem/CPA_TemperatureRanges_TemperatureStage3'
evalin('base', 'TemperatureRanges_TemperatureStage3.Value = uint8(i_if_388(1, 2));');
