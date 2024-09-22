require "ElementLibrary.Fancy.FancyRequire"

FancyEnumerate = function(inFancyEnumerateTable)
          local t = {
                    t = "__Enumeration",
                    items = {
                    },
                    indicate = -1,
                    view = -1,
                    hide = {},
                    rp = vec2(-0.9, -0.3),
                    rd = vec2(0.6, 0.3),
                    order = {}
          }
          return { FancyEnumerate = Default(inFancyEnumerateTable, t) }
end

local gEnums = {}
gprocess.FancyEnumerate = function(inPresentation, inValue, inFrameIndex, inElementName)
          local Elementname = gUnique(inElementName)
          local title = U()
          title.t = inValue.t

          local items = {}
          local item_bullets = {}

          if gEnums[Elementname] then
                    inValue.items = Copy(gEnums[Elementname].items)
          else
                    gEnums[Elementname] = Copy(inValue)
          end
          inValue.rd.y = 0.1 * #inValue.items
          inValue.rp.y = -0.1 * #inValue.items

          -- This is the text
          for i = 1, #inValue.items, 1 do
                    local it = U()
                    local itb = U()
                    if #inValue.order ~= 0 and #inValue.order == #inValue.items then
                              it.t = Copy(inValue.items[inValue.order[i]])
                    else
                              it.t = Copy(inValue.items[i])
                    end
                    itb.t = "" .. i
                    if inValue.indicate > 0 then
                              it.bc = white_color
                              itb.bc = white_color
                              it.o = "LEFT"
                    else
                              it.bc = transparent_color
                              itb.bc = transparent_color
                              it.o = "LEFT"
                    end

                    local shouldHide = (type(inValue.hide) == "table"
                                  and table.contains(inValue.hide, i)) or
                        (type(inValue.hide) == "string"
                                  and inValue.hide == "all")

                    if shouldHide then
                              itb.bc = vec4(vec3(1), 0)
                              itb.c = vec4(vec3(1), 0)
                              it.bc = vec4(vec3(1), 0)
                              it.c = vec4(vec3(1), 0)
                    end


                    items[#items + 1] = it
                    item_bullets[#item_bullets + 1] = itb
          end
          H():Add(
                    {
                              V():Add(item_bullets, CR(item_bullets)),
                              V():Add(items, CR(items)),
                    }, { 0.1, 0.9 }
          ):Update(rel_to_abs_p(inValue.rp), rel_to_abs_d(inValue.rd))

          if inValue.view ~= -1 then
                    for i = 1, #items, 1 do
                              if i ~= inValue.view then
                                        items[i].bc = vec4(vec3(1), 0)
                                        item_bullets[i].bc = vec4(vec3(1), 0)
                                        items[i].c = vec4(vec3(1), 0)
                                        item_bullets[i].c = vec4(vec3(1), 0)
                              end
                    end
                    V():Add(
                              {
                                        U(),
                                        H():Add({
                                                  item_bullets[inValue.view],
                                                  items[inValue.view],
                                        }, { 0.1, 0.8 }),
                                        U()
                              }, { 0.1, 0.1, 0.8 }
                    ):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))
          end

          -- print("items:", ginspect(items))
          -- print("item_bullets:", ginspect(item_bullets))


          for i, value in ipairs(items) do
                    value._push_constant = StrechedPC
                    if #inValue.order ~= 0 and #inValue.order == #inValue.items then
                              i = inValue.order[i]
                              -- value = items[inValue.order[i]]
                    end
                    gprocess.FancyButton(inPresentation, FancyButton(value).FancyButton, inFrameIndex,
                              "__fancy__enumeration" .. "__items__" .. inElementName .. i)
          end

          for i, value in ipairs(item_bullets) do
                    if #inValue.order ~= 0 and #inValue.order == #inValue.items then
                              i = inValue.order[i]
                              -- value = item_bullets[inValue.order[i]]
                    end
                    gprocess.FancyButton(inPresentation, FancyButton(value).FancyButton, inFrameIndex,
                              "__fancy_enumeration" .. "__bullets__" .. inElementName .. i)
          end
end
