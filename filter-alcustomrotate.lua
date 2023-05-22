obs = obslua

-- Returns the description displayed in the Scripts window
function script_description()
  return [[alcustomrotate Filter
  This Lua script adds a video filter named alcustomrotate. The filter can be added
  to a video source to change rotation and etc. just it.]]
end

-- Called on script startup
function script_load(settings)
  obs.obs_register_source(source_info)
end

-- Definition of the global variable containing the source_info structure
source_info = {}
source_info.id = 'filter-alcustomrotate'              -- Unique string identifier of the source type
source_info.type = obs.OBS_SOURCE_TYPE_FILTER   -- INPUT or FILTER or TRANSITION
source_info.output_flags = obs.OBS_SOURCE_VIDEO -- Combination of VIDEO/AUDIO/ASYNC/etc

-- Returns the name displayed in the list of filters
source_info.get_name = function()
  return "Alcustomrotate"
end

-- Creates the implementation data for the source
source_info.create = function(settings, source)

  -- Initializes the custom data table
  local data = {}
  data.source = source -- Keeps a reference to this filter as a source object
  data.width = 1
  data.height = 1
  data.rotatex = 0
  data.rotatey = 0
  data.rotatez = 0
  data.positionx = 0
  data.positiony = 0
  data.positionz = 0
  data.wrotatex = 0
  data.wrotatey = 0
  data.wrotatez = 0
  data.wpositionx = 0
  data.wpositiony = 0
  data.wpositionz = 0
  -- Compiles the effect
  obs.obs_enter_graphics()
  local effect_file_path = script_path() .. 'filter-alcustomrotate.effect.hlsl'
  data.effect = obs.gs_effect_create_from_file(effect_file_path, nil)
  obs.obs_leave_graphics()

  -- Calls the destroy function if the effect was not compiled properly
  if data.effect == nil then
    obs.blog(obs.LOG_ERROR, "Effect compilation failed for " .. effect_file_path)
    source_info.destroy(data)
    return nil
  end
  
  data.params = {}
  data.params.width = obs.gs_effect_get_param_by_name(data.effect, "width")
  data.params.height = obs.gs_effect_get_param_by_name(data.effect, "height")
  data.params.rotatex = obs.gs_effect_get_param_by_name(data.effect, "rotatex")
  data.params.rotatey = obs.gs_effect_get_param_by_name(data.effect, "rotatey")
  data.params.rotatez = obs.gs_effect_get_param_by_name(data.effect, "rotatez")
  data.params.positionx = obs.gs_effect_get_param_by_name(data.effect, "positionx")
  data.params.positiony = obs.gs_effect_get_param_by_name(data.effect, "positiony")
  data.params.positionz = obs.gs_effect_get_param_by_name(data.effect, "positionz")
  data.params.wrotatex = obs.gs_effect_get_param_by_name(data.effect, "wrotatex")
  data.params.wrotatey = obs.gs_effect_get_param_by_name(data.effect, "wrotatey")
  data.params.wrotatez = obs.gs_effect_get_param_by_name(data.effect, "wrotatez")
  data.params.wpositionx = obs.gs_effect_get_param_by_name(data.effect, "wpositionx")
  data.params.wpositiony = obs.gs_effect_get_param_by_name(data.effect, "wpositiony")
  data.params.wpositionz = obs.gs_effect_get_param_by_name(data.effect, "wpositionz")
  
  -- Calls update to initialize the rest of the properties-managed settings
  source_info.update(data, settings)
  return data
end

-- Destroys and release resources linked to the custom data
source_info.destroy = function(data)
  if data.effect ~= nil then
    obs.obs_enter_graphics()
    obs.gs_effect_destroy(data.effect)
    data.effect = nil
    obs.obs_leave_graphics()
  end
end

-- Returns the width of the source
source_info.get_width = function(data)
  return data.width
end

-- Returns the height of the source
source_info.get_height = function(data)
  return data.height
end

-- Called when rendering the source with the graphics subsystem
source_info.video_render = function(data)
  local parent = obs.obs_filter_get_parent(data.source)
  data.width = obs.obs_source_get_base_width(parent)
  data.height = obs.obs_source_get_base_height(parent)
  
  obs.obs_source_process_filter_begin(data.source, obs.GS_RGBA, obs.OBS_NO_DIRECT_RENDERING)

  -- Effect parameters initialization goes here
  obs.gs_effect_set_int(data.params.width, data.width)
  obs.gs_effect_set_int(data.params.height, data.height)
  obs.gs_effect_set_float(data.params.rotatex, data.rotatex)
  obs.gs_effect_set_float(data.params.rotatey, data.rotatey)
  obs.gs_effect_set_float(data.params.rotatez, data.rotatez)
  obs.gs_effect_set_float(data.params.positionx, data.positionx)
  obs.gs_effect_set_float(data.params.positiony, data.positiony)
  obs.gs_effect_set_float(data.params.positionz, data.positionz)
  obs.gs_effect_set_float(data.params.wrotatex, data.wrotatex)
  obs.gs_effect_set_float(data.params.wrotatey, data.wrotatey)
  obs.gs_effect_set_float(data.params.wrotatez, data.wrotatez)
  obs.gs_effect_set_float(data.params.wpositionx, data.wpositionx)
  obs.gs_effect_set_float(data.params.wpositiony, data.wpositiony)
  obs.gs_effect_set_float(data.params.wpositionz, data.wpositionz)
  
  obs.obs_source_process_filter_end(data.source, data.effect, data.width, data.height)
end


-- Sets the default settings for this source
source_info.get_defaults = function(settings)
  obs.obs_data_set_default_double(settings, "rotatex", 0.0)
  obs.obs_data_set_default_double(settings, "rotatey", 0.0)
  obs.obs_data_set_default_double(settings, "rotatez", 0.0)
  obs.obs_data_set_default_double(settings, "positionx", 0.0)
  obs.obs_data_set_default_double(settings, "positiony", 0.0)
  obs.obs_data_set_default_double(settings, "positionz", 0.0)
  obs.obs_data_set_default_double(settings, "wrotatex", 0.0)
  obs.obs_data_set_default_double(settings, "wrotatey", 0.0)
  obs.obs_data_set_default_double(settings, "wrotatez", 0.0)
  obs.obs_data_set_default_double(settings, "wpositionx", 0.0)
  obs.obs_data_set_default_double(settings, "wpositiony", 0.0)
  obs.obs_data_set_default_double(settings, "wpositionz", 0.0)
end

-- Gets the property information of this source
source_info.get_properties = function(data)
  local props = obs.obs_properties_create()
  obs.obs_properties_add_float_slider(props, "rotatex", "Source Rotation around Xaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "rotatey", "Source Rotation around Yaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "rotatez", "Source Rotation around Zaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "positionx", "Source X position", -1920.0, 1920.0, 0.01)
  obs.obs_properties_add_float_slider(props, "positiony", "Source Y position", -1920.0, 1920.0, 0.01)
  obs.obs_properties_add_float_slider(props, "positionz", "Source Z position", -1920.0, 1920.0, 0.01)
  obs.obs_properties_add_float_slider(props, "wrotatex", "World Rotation Xaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "wrotatey", "World Rotation Yaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "wrotatez", "World Rotation Zaxis", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "wpositionx", "World X position", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "wpositiony", "World Y position", -10.0, 10.0, 0.001)
  obs.obs_properties_add_float_slider(props, "wpositionz", "World Z position", -10.0, 10.0, 0.001)
  return props
end

-- Updates the internal data for this source upon settings change
source_info.update = function(data, settings)
  data.rotatex = obs.obs_data_get_double(settings, "rotatex")
  data.rotatey = obs.obs_data_get_double(settings, "rotatey")
  data.rotatez = obs.obs_data_get_double(settings, "rotatez")
  data.positionx = obs.obs_data_get_double(settings, "positionx")
  data.positiony = obs.obs_data_get_double(settings, "positiony")
  data.positionz = obs.obs_data_get_double(settings, "positionz")
  data.wrotatex = obs.obs_data_get_double(settings, "wrotatex")
  data.wrotatey = obs.obs_data_get_double(settings, "wrotatey")
  data.wrotatez = obs.obs_data_get_double(settings, "wrotatez")
  data.wpositionx = obs.obs_data_get_double(settings, "wpositionx")
  data.wpositiony = obs.obs_data_get_double(settings, "wpositiony")
  data.wpositionz = obs.obs_data_get_double(settings, "wpositionz")
end




