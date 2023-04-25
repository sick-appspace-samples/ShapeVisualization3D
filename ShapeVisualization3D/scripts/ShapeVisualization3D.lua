
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())
assert(Shape3D, 'Shape3D API not present, check device capabilities')

-- Creating viewer
local viewer = View.create()

-- Setting up graphical overlay attributes
local shapeDecoration = View.ShapeDecoration.create():setLineColor(0, 255, 0) -- Green
shapeDecoration:setPointSize(16):setLineWidth(3):setFillColor(0, 200, 0) -- Darker Green

local intersectionDecoration = View.ShapeDecoration.create():setLineColor(255, 0, 0) -- Red
intersectionDecoration:setLineWidth(5):setPointType('DOT'):setPointSize(16)

local pointDecoration = View.ShapeDecoration.create():setLineColor(0, 0, 255) -- Blue
pointDecoration:setPointType('DOT'):setPointSize(16)

local pointCoudDecoration = View.PointCloudDecoration.create():setPointSize(5)

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

  viewer:addPointCloud(pc, pointCoudDecoration)

  -- Line segment
  local startLine = Point.create(0, 430, -200)
  local endLine = Point.create(320, 50, 700)
  local line = Shape3D.createLineSegment(startLine, endLine)
  viewer:addShape(line, shapeDecoration)
  viewer:addShape(startLine, pointDecoration)
  viewer:addShape(endLine, pointDecoration)

  -- Ellipse
  local ellipsePose = Transform.createTranslation3D(10, 50, 150)
  local ellipse = Shape3D.createEllipse(40, 100, ellipsePose)
  viewer:addShape(ellipse, shapeDecoration)

  -- Elliptic cylinder
  local ellipticcylinderPose = Transform.createRigidAxisAngle3D({0, 1, 1}, 3.14 / 3, 150, 350, 140)
  local ellipticcylinder = Shape3D.createEllipticCylinder(80, 200, 150, ellipticcylinderPose)
  viewer:addShape(ellipticcylinder, shapeDecoration)

  -- Intersection points between line segment and elliptical cylinder
  local linecylPts = ellipticcylinder:getIntersectionPoints(line:toLine())
  for _, pt in ipairs(linecylPts) do
    viewer:addShape(pt, intersectionDecoration)
  end

  -- Rectangle
  local rectangle = Shape3D.createRectangle(120, 300):rotateY(3.14 / 3):rotateZ(3.14 / 5):translate(0, 0, 170)
  viewer:addShape(rectangle, shapeDecoration)

  -- Intersection line between the planes of the ellipse and the rectangle
  -- Crop to bounding box of rectangle
  local ellipseRectLine = Shape3D.getIntersectionLine(ellipse:toPlane(), rectangle:toPlane())
  ellipseRectLine = ellipseRectLine:cropLine(rectangle:getBoundingBox())
  viewer:addShape(ellipseRectLine, intersectionDecoration)

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
  viewer:addShape(polygon, shapeDecoration)

  -- Polyline
  local polyline = Shape3D.createPolyline(polyPoints)
  viewer:addShape(polyline, shapeDecoration)

  -- Sphere
  local sphere = Shape3D.createSphere(120):translate(100, 150, 300)
  viewer:addShape(sphere, shapeDecoration)

  -- Cone
  local cone = Shape3D.createCone(100, 200):translate(0, 0, 300)
  viewer:addShape(cone, shapeDecoration)

  viewer:present()

  print('App finished.')
end

Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
