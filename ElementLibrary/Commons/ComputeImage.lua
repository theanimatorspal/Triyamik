require "Present.Present"

--@note will have both compute image and non compute image
CComputeImage = function(inComputeImageTable)
          local t = {
                    p = "CENTER_CENTER",
                    d = vec3(100, 100, 1),
                    cd = vec3(100, 100, 1),
                    mat1 = mat4(0),
                    mat2 = mat4(0),
                    -- shader = "LINE2D"
          }
          return { CComputeImage = Default(inComputeImageTable, t) }
end

local computeImages = {}
local computePainters = {}

CComputeImagesGet = function()
          return computeImages, computePainters
end

local compileShaders = function() end
gprocess.CComputeImage = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = gUnique(inElementName)
          compileShaders()
          if not computeImages[ElementName] then
                    computeImages[ElementName] = {
                              cimage = gwid.CreateComputeImage(
                                        ComputePositionByName(inValue.p, inValue.d),
                                        inValue.cd),
                              sampled_image = gwid.CreateSampledImage(
                                        ComputePositionByName(inValue.p, inValue.d),
                                        inValue.d, nil, true, nil
                              ),
                    }
                    computeImages[ElementName].cimage.RegisterPainter(computePainters["LINE2D"], 0)
                    computeImages[ElementName].cd = vec3(inValue.cd)
                    local push = Jkr.Matrix2CustomImagePainterPushConstant()
                    push.a = mat4(vec4(0.0), vec4(1), vec4(0.3), vec4(0.0))
                    computeImages[ElementName].simage = gwid.CreateQuad(
                              ComputePositionByName(inValue.p, inValue.d),
                              inValue.d,
                              push,
                              "showImage",
                              computeImages[ElementName].sampled_image.mId
                    )
          end


          gAddFrameKeyElement(inFrameIndex, {
                    {
                              "CComputeImage",
                              handle = computeImages[ElementName],
                              value = inValue,
                              name = inElementName
                    }
          })
end

ExecuteFunctions["CComputeImage"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          local execute = inElement.handle[1]
          local cd = inElement.handle.cd
          local ceil = math.ceil
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    interp.z = ComputePositionByName(new.p, new.d).z
                    local interd = glerp_3f(prev.d, new.d, t)
                    inElement.handle.simage:Update(interp, interd)

                    local intermat1 = glerp_mat4f(prev.mat1, new.mat1, t)
                    local intermat2 = glerp_mat4f(prev.mat2, new.mat2, t)
                    gwid.c:PushOneTime(Jkr.CreateDispatchable(
                              function()
                                        execute(intermat1, intermat2, ceil(cd.x / 16.0), ceil(cd.x / 16.0), 1)
                              end
                    ), 1)
          else
                    inElement.handle.simage:Update(ComputePositionByName(new.p, new.d), new.d)
                    gwid.c:PushOneTime(Jkr.CreateDispatchable(
                              function()
                                        execute(new.mat1, new.mat2, ceil(cd.x / 16.0), ceil(cd.x / 16.0), 1)
                              end
                    ), 1)
          end
end

compileShaders = function()
          if not computePainters.CLEAR then
                    local shader = Jkr.CreateCustomImagePainter("cache/CLEAR.glsl",
                              TwoDimensionalIPs.Clear.str
                    )
                    shader:Store(Engine.i, gwindow)
                    computePainters.CLEAR = shader
          end
          if not computePainters.RECTANGLE then
                    local shader = Jkr.CreateCustomImagePainter("cache/RECTANGLE.glsl",
                              TwoDimensionalIPs.RoundedRectangle.str)
                    shader:Store(Engine.i, gwindow)
                    computePainters.RECTANGLE = shader
          end
          if not computePainters.CIRCLE then
                    local shader = Jkr.CreateCustomImagePainter("cache/CIRCLE.glsl", TwoDimensionalIPs.Circle.str)
                    shader:Store(Engine.i, gwindow)
                    computePainters.CIRCLE = shader
          end
          if not computePainters.LINE2D then
                    local shader = Jkr.CreateCustomImagePainter("cache/LINE2D.glsl",
                              TwoDimensionalIPs.HeaderWithoutBegin()
                              .GlslMainBegin()
                              .ImagePainterAssistMatrix2()
                              .Append [[
                              vec4 point1 = push.b * vec4(p1.x, p1.y, 0, 1);
                              vec4 point2 = push.b * vec4(p1.z, p1.w, 0, 1);
                              float x1 = point1.x;
                              float y1 = point1.y;
                              float x2 = point2.x;
                              float y2 = point2.y;
                              float x = float(gl_GlobalInvocationID.x);
                              float y = float(gl_GlobalInvocationID.y);

                              float small_x = x1;
                              float large_x = x2;
                              if (x1 > x2)
                              {
                              large_x = x1;
                              small_x = x2;
                              }

                              float small_y = y1;
                              float large_y = y2;
                              if (y1 > y2)
                              {
                              large_y = y1;
                              small_x = y2;
                              }
                              float thickness = p3.x;

                              // Calculate signed distance function
                              float sdf = 0;
                              if (abs(x2 - x1) < 0.0001) { // Handle vertical lines
                              sdf = abs(x - x1);
                              } else {
                              float slope = (y2 - y1) / (x2 - x1);
                              sdf = abs(y - y1 - slope * (x - x1));
                              }

                              vec4 color = p2;
                              if ((sdf < p3.x) && (x > small_x && x < large_x) && (y > small_y && y < large_y))  {
                              //debugPrintfEXT("xKo:%f, yKo:%f", x, y);
                              imageStore(storageImage, to_draw_at, color * (p3.x - sdf));
                              }

                              ]]
                              .GlslMainEnd().str
                    )
                    shader:Store(Engine.i, gwindow)
                    computePainters.LINE2D = shader
          end
end
