# Al_OBSCustomRotationFilter
Custom rotation filter for OBS

This filter can rotate "source" around XYZ axis.<br>
Also let you change projection direction. <br>

Not so great. still has problems.

## Installation

* Download filters from "Releases".

* Open folder of OBS studio. (usually it's C:\Program Files (x86)\obs-studio) and goto <br>
  path\to\obsstudio\obs-studio\data\obs-plugins\frontend-tools\scripts

* Drag and drop these files to "scripts" folder <br>
 filter-alcustomrotate.effect.hlsl <br>
 filter-alcustomrotate.lua

* Open OBS <br>
 On top menu bar, Select "Tools" -> "Scripts" <br>
 Scripts window should show up.
 
* Press "+" mark (bottom left corner) <br>
  Then select "filter-alcustomrotate.lua" <br>
  Close Scripts window.
  
* In Sources tab, select the item which you want to apply effect. <br>
 Right click it and select "Filters". <br>
  Right click or Press "+" to add "Alcustomrotate" effect.
  
 After add effect, adjust palameters. (which is super hard part)
   
Happy streaming!

//Almine2
