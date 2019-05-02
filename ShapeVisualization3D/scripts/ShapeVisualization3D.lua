--[[----------------------------------------------------------------------------

  Application Name:
  ShapeVisualization3D

  Summary:
  Creation and overlay visualization of various 3D shape types.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the 3D viewer on the DevicePage.Zoom in on the
  visualized shapes for best experience.

  Restarting the Sample may be necessary to show images after loading the webpage.
  To run this Sample a device with SICK Algorithm API and AppEngine >= V2.5.0 is
  required. For example SIM4000 with latest firmware. Alternatively the Emulator
  in AppStudio 2.3 or higher can be used.

  More Information:
  Tutorial "Algorithms - Data Types".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())
assert(Shape3D, 'Shape3D API not present, check device capabilities')

-- Creating viewer
local viewer = View.create()
viewer:setID('viewer3D')

-- Setting up graphical overlay attributes
local shapeDecoration = View.ShapeDecoration.create()
shapeDecoration:setLineColor(0, 255, 0) -- Green
shapeDecoration:setPointSize(16)
shapeDecoration:setLineWidth(5)
shapeDecoration:setFillColor(0, 255, 0, 150) -- Transparent green

local intersectionDecoration = View.ShapeDecoration.create()
intersectionDecoration:setLineColor(255, 0, 0) -- Red
intersectionDecoration:setLineWidth(5)
intersectionDecoration:setPointType('DOT')
intersectionDecoration:setPointSize(16)

local pointDecoration = View.ShapeDecoration.create()
pointDecoration:setLineColor(0, 0, 255) -- Blue
pointDecoration:setPointType('DOT')
pointDecoration:setPointSize(16)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  viewer:clear()
  local w = 300

  local pc = PointCloud.create()
  pc:appendPoint(0, 0, 0)
  pc:appendPoint(0, 0, w)
  pc:appendPoint(0, w, 0)
  pc:appendPoint(0, w, w)
  pc:appendPoint(w, 0, 0)
  pc:appendPoint(w, 0, w)
  pc:appendPoint(w, w, 0)
  pc:appendPoint(w, w, w)

  local pcViewId = viewer:addPointCloud(pc)

  -- Line segment
  local startLine = Point.create(0, 430, -200)
  local endLine = Point.create(320, 50, 700)
  local line = Shape3D.createLineSegment(startLine, endLine)
  viewer:addShape(line, shapeDecoration, nil, pcViewId)
  viewer:addShape(startLine, pointDecoration, nil, pcViewId)
  viewer:addShape(endLine, pointDecoration, nil, pcViewId)

  -- Ellipse
  local ellipsePose = Transform.createTranslation3D(10, 50, 150)
  local ellipse = Shape3D.createEllipse(40, 100, ellipsePose)
  viewer:addShape(ellipse, shapeDecoration, nil, pcViewId)

  -- Elliptic cylinder
  local ellipticcylinderPose = Transform.createRigidAxisAngle3D({0, 1, 1}, 3.14 / 3, 150, 350, 140)
  local ellipticcylinder = Shape3D.createEllipticCylinder(80, 200, 150, ellipticcylinderPose)
  viewer:addShape(ellipticcylinder, shapeDecoration, nil, pcViewId)

  -- Intersection points between line segment and elliptical cylinder
  local linecylPts = ellipticcylinder:getIntersectionPoints(line:toLine())
  for _, pt in ipairs(linecylPts) do
    viewer:addShape(pt, intersectionDecoration, nil, pcViewId)
  end

  -- Rectangle
  local rectangle = Shape3D.createRectangle(120, 300):rotateY(3.14 / 3):rotateZ(3.14 / 5):translate(0, 0, 170)
  viewer:addShape(rectangle, shapeDecoration, nil, pcViewId)

  -- Intersection line between the planes of the ellipse and the rectangle
  -- Crop to bounding box of rectangle
  local ellipseRectLine = Shape3D.getIntersectionLine(ellipse:toPlane(), rectangle:toPlane())
  ellipseRectLine = ellipseRectLine:cropLine(rectangle:getBoundingBox())
  viewer:addShape(ellipseRectLine, intersectionDecoration, nil, pcViewId)

  -- Polygon
  local polyPoints = {
    Point.create(600, 200, 100),
    Point.create(530, 300, 150),
    Point.create(620, 505, 200),
    Point.create(650, 250, 100),
    Point.create(700, 300, 150),
    Point.create(720, 200, 100)
  }
  local polygon = Shape3D.createPolygon(polyPoints)
  viewer:addShape(polygon, shapeDecoration, nil, pcViewId)

  -- Polyline
  local polyline = Shape3D.createPolyline(polyPoints)
  viewer:addShape(polyline, shapeDecoration, nil, pcViewId)

  -- Sphere
  local sphere = Shape3D.createSphere(120):translate(100, 150, 300)
  viewer:addShape(sphere, shapeDecoration, nil, pcViewId)

  -- Cone
  local cone = Shape3D.createCone(100, 200):translate(0, 0, 300)
  viewer:addShape(cone, shapeDecoration, nil, pcViewId)

  viewer:present()

  print('App finished.')
end

Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
