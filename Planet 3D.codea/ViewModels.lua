-------------------------------------------------------------------------------
-- Planet Generator
-- Written by John Millard
-------------------------------------------------------------------------------
-- Description:
-- This is used as a simple model viewer and a means to exclude certain 
-- models from the Nature pack from being used in planet generation.
-- This is stored inside a json text file in the project to be later read.
-------------------------------------------------------------------------------

function setup()
    scene = craft.scene()
    scene.sky.active = false

    models = assetList("Nature", "models")
    
    viewer = scene.camera:add(OrbitViewer)
    
    model = scene:entity()
    mr = model:add(craft.renderer)  
    
    saved(parameter.integer, "ModelNumber", 1, #models, 1, function(n)
        loadModel(n)
    end)
    
    parameter.action("Next",function()
        ModelNumber = math.min(ModelNumber + 1, #models)
        loadModel(ModelNumber)
    end)
    
    exclude = readText("Project:exclude")
    if exclude then
        exclude = json.decode(exclude)
    else
        exclude = {}
    end
    
    parameter.action("Exclude", function()
        exclude[models[ModelNumber]] = not (exclude[models[ModelNumber]] or false)
        saveText("Project:exclude", json.encode(exclude))
    end)
    
    parameter.watch("models[ModelNumber]")
    parameter.watch("exclude[models[ModelNumber]] and 'Yes' or 'No'")
end

function loadModel(modelNumber)
    mr.model = craft.model("Nature:"..models[modelNumber])
    local bounds = mr.model.bounds
    model.position = vec3(-bounds.center.x,0,-bounds.center.z) 
end

function update(dt) 
    scene:update(dt)
end

-- This function gets called once every frame
function draw()
    update(DeltaTime)
    
    scene:draw()
end

function PrintExplanation()
    output.clear()
    print("Loading models is easy, simply create an entity and add a MeshRenderer.")
    print("Set the mesh using craft.model(asset)")
    print("In this example we have used assetList to get all models from the nature pack")
    print("Models will try to load a material if there is one, otherwise a blank material will be used.")
end


