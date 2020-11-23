import "graphics" for Color, Canvas, ImageData
import "dome" for Window, Process
import "math" for Vec, M
import "input" for Keyboard, Mouse
import "./keys" for Key
import "./sprite" for Sprite, Pillar
import "./door" for Door

var MAP_WIDTH = 30
var MAP_HEIGHT = 30

var TEXTURE = List.filled(0, null)
var TEX_WIDTH = 8
var TEX_HEIGHT = 8

var SPEED = 0.001
var MOVE_SPEED = 2/ 60

var Forward = Key.new("w", true, SPEED)
var Back = Key.new("s", true, -SPEED)
var LeftBtn = Key.new("a", true, -1)
var RightBtn = Key.new("d", true, 1)
var StrafeLeftBtn = Key.new("left", true, -SPEED)
var StrafeRightBtn = Key.new("right", true, SPEED)

var KEYS = [
  Back, Forward, LeftBtn, RightBtn, StrafeLeftBtn, StrafeRightBtn
]

var FloorTexture = ImageData.loadFromFile("floor.png")
var CeilTexture = ImageData.loadFromFile("ceil.png")

var DOORS = [
  Door.new(Vec.new(2, 11)),
  Door.new(Vec.new(3, 13))
]

var MAP = [
    2,2,2,2,2,2,2,2,2,2,2,4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,3,1,1,1,1,1,3,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,2,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,5,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,2,0,0,0,0,0,0,0,0,3,1,1,0,1,1,3,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,2,5,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
]

var PI_RAD = Num.pi / 180


class Game {
  static init() {
    var SCALE = 4
    Mouse.relative = true
    Mouse.hidden = true
    Canvas.resize(320, 200)
    Window.resize(SCALE*Canvas.width, SCALE*Canvas.height)
    __sprites = [
      Pillar.new(Vec.new(8, 13)),
      Pillar.new(Vec.new(9, 15))
    ]
    __position = Vec.new(7, 11)
    __direction = Vec.new(0, -1)

    __angle = 0
    __camera = Vec.new(-1, 0)
    __zBuffer = List.filled(Canvas.width, Num.largest)

    // Prepare textures
    for (i in 1..4) {
      TEXTURE.add(importImage("wall%(i).png"))
    }
    TEXTURE.add(importImage("door.png"))
  }

  // Round-tripping to fetch image data is too slow, so we import the image data into
  // Wren memory for faster retrieval.
  static importImage(path) {
    var texture = []
    var img = ImageData.loadFromFile(path)
    for (y in 0...img.height) {
      for (x in 0...img.width) {
        texture.add(img.pget(x,y))
      }
    }
    return texture
  }

  static update() {
    KEYS.each {|key| key.update() }
    var oldPosition = __position
    if (Keyboard.isKeyDown("escape")) {
      Process.exit()
    }

    if (Keyboard.isKeyDown("left")) {
      __angle = __angle + LeftBtn.action
    }
    if (Keyboard.isKeyDown("right")) {
      __angle = __angle + RightBtn.action
    }
    if (Keyboard.isKeyDown("d")) {
      __position = __position + __direction.perp * MOVE_SPEED
    }
    if (Keyboard.isKeyDown("a")) {
      __position = __position - __direction.perp * MOVE_SPEED
    }
    if (Keyboard.isKeyDown("w")) {
      __position = __position + __direction * MOVE_SPEED
    }
    if (Keyboard.isKeyDown("s")) {
      __position = __position - __direction * MOVE_SPEED
    }

    if (Mouse.x != 0) {
      __angle = __angle + M.mid(-2.5, Mouse.x, 2.5)
    }

    __angle = __angle % 360
    if (__angle < 0) {
      __angle = __angle + 360
    }

    var solid = isTileHit(__position)
    if (!solid) {
      for (entity in __sprites) {
        if ((entity.pos - __position).length < 0.5) {
          solid = solid || entity.solid
        }
      }
    }

    var castResult = castRay(__position, __direction, true)

    var targetPos = castResult[0]
    var dist = targetPos - __position

    if (Keyboard.isKeyDown("space")) {
      if (getTileAt(targetPos) == 5 && dist.length < 2.5) {
        getDoorAt(targetPos).open()
      }
    }

    if (solid) {
      __position = oldPosition
    }

    __direction = Vec.new(M.cos(__angle * PI_RAD), M.sin(__angle * PI_RAD))
    __camera = __direction.perp

    DOORS.each {|door|
      if ((door.pos - __position).length >= 2.5) {
        door.close()
      }
      door.update()
    }
  }

  static castRay(rayPosition, rayDirection, ignoreDoors) {
    // var rayPosition = position
    // var rayDirection = direction + (__camera * cameraX)
    // double sideDistanceX = sqrt(1.0 + (rayDirection.GetY() * rayDirection.GetY() / (rayDirection.GetX() * rayDirection.GetX())));
    // double sideDistanceY = sqrt(1.0 + (rayDirection.GetX() * rayDirection.GetX() / (rayDirection.GetY() * rayDirection.GetY())));

    var sideDistanceX = (1.0 + rayDirection.y.pow(2) / rayDirection.x.pow(2)).sqrt
    var sideDistanceY = (1.0 + rayDirection.x.pow(2) / rayDirection.y.pow(2)).sqrt

    var nextSideDistanceX
    var nextSideDistanceY
    var mapPos = Vec.new(rayPosition.x.floor, rayPosition.y.floor)
    var stepDirection = Vec.new()
    if (rayDirection.x < 0) {
      stepDirection.x = -1
      nextSideDistanceX = (rayPosition.x - mapPos.x) * sideDistanceX
    } else {
      stepDirection.x = 1
      nextSideDistanceX = (mapPos.x + 1.0 - rayPosition.x) * sideDistanceX
    }
    if (rayDirection.y < 0) {
      stepDirection.y = -1
      nextSideDistanceY = (rayPosition.y - mapPos.y) * sideDistanceY
    } else {
      stepDirection.y = 1
      nextSideDistanceY = (mapPos.y + 1.0 - rayPosition.y) * sideDistanceY
    }

    var hit = false
    var side = 0
    while (!hit) {
      if (nextSideDistanceX < nextSideDistanceY) {
        nextSideDistanceX = nextSideDistanceX + sideDistanceX
        mapPos.x = (mapPos.x + stepDirection.x)
        side = 0
      } else {
        nextSideDistanceY = nextSideDistanceY + sideDistanceY
        mapPos.y = (mapPos.y + stepDirection.y)
        side = 1
      }

      var tile = getTileAt(mapPos)
      if (tile == 5) {
        // Figure out the door position
        var doorState = ignoreDoors ? 1 : getDoorAt(mapPos).state
        var adj
        var ray_mult
        // Adjustment
        if (side == 0) {
          adj = mapPos.x - __position.x + 1
          if (__position.x < mapPos.x) {
            adj = adj - 1
          }
          ray_mult = adj / rayDirection.x
        } else {
          // var halfX = mapPos.x + sideDistanceX * 0.5
          adj = mapPos.y - __position.y
          if (__position.y > mapPos.y) {
            adj = adj + 1
          }
          ray_mult = adj / rayDirection.y
        }

        var rye2 = rayPosition.y + rayDirection.y * ray_mult
        var rxe2 = rayPosition.x + rayDirection.x * ray_mult

        var trueDeltaX = sideDistanceX
        var trueDeltaY = sideDistanceY
        if (rayDirection.y.abs < 0.01) {
          trueDeltaY = 100
        }
        if (rayDirection.x.abs < 0.01) {
          trueDeltaX = 100
        }


        if (side == 0) {
          // var halfY = mapPos.y + sideDistanceY * 0.5
          var true_y_step = (trueDeltaX * trueDeltaX - 1).sqrt
          var half_step_in_y = rye2 + (stepDirection.y * true_y_step) * 0.5
          hit = (half_step_in_y.floor == mapPos.y) && (1 - 2*(half_step_in_y - mapPos.y)).abs > 1 - doorState
          if (hit) {
            // mapPos.y = mapPos.y + 0.5
          }
        } else {
          var true_x_step = (trueDeltaY * trueDeltaY - 1).sqrt
          var half_step_in_x = rxe2 + (stepDirection.x * true_x_step) * 0.5
          hit = (half_step_in_x.floor == mapPos.x) && (1 - 2*(half_step_in_x - mapPos.x)).abs > 1 - doorState
          if (hit) {
            // mapPos.x = mapPos.x +  0.5
          }
        }
      } else {
        hit = tile > 0
      }
    }
    return [ mapPos, side, stepDirection ]
  }

  static isTileHit(pos) {
    var mapPos = Vec.new(pos.x.floor, pos.y.floor)
    var tile = getTileAt(mapPos)
    var hit = false
    if (tile == 5) {
      hit = getDoorAt(mapPos).state > 0.5
    } else {
      hit = tile > 0
    }
    return hit
  }

  static draw(alpha) {
    // Canvas.cls(Color.lightgray)
    // Canvas.rectfill(0, Canvas.height / 2, Canvas.width, Canvas.height / 2, Color.darkgray)
    // Floor casting
    // rayDir for leftmost ray (x = 0) and rightmost ray (x = w)
    var rayDir0 = __direction - __camera
    var rayDir1 = __direction + __camera
    // vertical camera position
    var posZ = 0.5 * Canvas.height
    for (y in 0...(Canvas.height / 2)) {

      // Compute position compared to horizon
      var p = (y - (Canvas.height / 2)).floor


      // Horizontal distance from the camera to the floor for current row
      // Must be negative because of reasons
      var rowDistance = -posZ / p

      // calculate the real world step vector we have to add for each x (parallel to camera plane)
      // adding step by step avoids multiplications with a weight in the inner loop
      var floorStepX = ((rayDir1.x - rayDir0.x) * rowDistance) / Canvas.width
      var floorStepY = ((rayDir1.y - rayDir0.y) * rowDistance) / Canvas.width

      // real world coordinates of the leftmost column. This will be updated as we step to the right.
      var floorX = __position.x + rayDir0.x * rowDistance
      var floorY = __position.y + rayDir0.y * rowDistance

      for (x in 0...Canvas.width) {
        // the cell coord is simply got from the integer parts of floorX and floorY
        var cellX = floorX.floor
        var cellY = floorY.floor

        // get the texture coordinate from the fractional part
        var diffX = floorX - cellX
        var diffY = floorY - cellY

        floorX = floorX + floorStepX
        floorY = floorY + floorStepY


        // draw floor
        var floorTex = FloorTexture
        var floorTexX = ((floorTex.width - 1) * diffX).floor
        var floorTexY = ((floorTex.height - 1) * diffY).floor
        var c = floorTex.pget(floorTexX, floorTexY)
        Canvas.pset(x, Canvas.height - y - 1, c)

        // draw ceiling
        var ceilTex = CeilTexture
        var ceilTexX = ((ceilTex.width - 1) * diffX).floor
        var ceilTexY = ((ceilTex.height - 1) * diffY).floor
        c = ceilTex.pget(ceilTexX, ceilTexY)
        Canvas.pset(x, y, c)
      }
    }


    // Wall casting
    for (x in 0...Canvas.width) {
      var cameraX = 2 * (x / Canvas.width) - 1
      var rayPosition = __position
      var rayDirection = __direction + (__camera * cameraX)
      var castResult = castRay(rayPosition, rayDirection, false)
      var mapPos = castResult[0]
      var side = castResult[1]
      var stepDirection = castResult[2]
      var hit = isTileHit(mapPos)

      var color = Color.black
      var tile = getTileAt(mapPos)
      var texture = TEXTURE[tile - 1]

      var perpWallDistance
      if (tile == 5) {
        // If it's a door, we need to shift the map position to draw it in the correct location
        if (side == 0) {
          mapPos.x = mapPos.x + stepDirection.x / 2
        } else {
          mapPos.y = mapPos.y + stepDirection.y / 2
        }
      }
      if (side == 0) {
        perpWallDistance = M.abs((mapPos.x - __position.x + (1 - stepDirection.x) / 2) / rayDirection.x)
      } else {
        perpWallDistance = M.abs((mapPos.y - __position.y + (1 - stepDirection.y) / 2) / rayDirection.y)
      }
      var lineHeight = M.abs(Canvas.height / perpWallDistance)
      var drawStart = (-lineHeight / 2) + (Canvas.height / 2)
      var drawEnd = (lineHeight / 2) + (Canvas.height / 2)
      var alpha = 0.5
      //SET THE ZBUFFER FOR THE SPRITE CASTING
      __zBuffer[x] = perpWallDistance //perpendicular distance is used

      /*
      UNTEXTURED COLOR CHOOSER
      */
      if (texture == null) {
        if (tile == 1) {
          color = Color.red
        } else if (tile == 2) {
          color = Color.green
        } else if (tile == 3) {
          color = Color.blue
        } else if (tile == 4) {
          color = Color.white
        } else if (tile == 5) {
          color = Color.purple
        }
        if (side == 1) {
          color = Color.rgb(color.r * alpha, color.g * alpha, color.b * alpha)
        }
        Canvas.line(x, drawStart, x, drawEnd, color)
      } else {
        var wallX
        if (side == 0) {
          wallX = __position.y + perpWallDistance * rayDirection.y
        } else {
          wallX = __position.x + perpWallDistance * rayDirection.x
        }
        wallX = wallX - wallX.floor
        var texX = wallX * TEX_WIDTH
        if (side == 0 && rayDirection.x < 0) {
          texX = TEX_WIDTH - texX
        }
        if (side == 1 && rayDirection.y > 0) {
          texX = TEX_WIDTH - texX
        }
        texX = texX.floor % TEX_WIDTH
        var texStep = 1.0 * TEX_HEIGHT / lineHeight
        // If we are too close to a block, the lineHeight is gigantic, resulting in slowness
        // So we clip the drawStart-End and _then_ calculate the texture position.
        drawStart = M.max(0, drawStart)
        drawEnd = M.min(Canvas.height, drawEnd)
        var texPos = (drawStart - Canvas.height / 2 + lineHeight / 2) * texStep
        for (y in drawStart...drawEnd) {
          var texY = (texPos).floor % TEX_HEIGHT
          // color = texture.pget(texX, texY)
          color = texture[(texY * TEX_WIDTH + texX)]
          if (side == 1) {
            color = Color.rgb(color.r * alpha, color.g * alpha, color.b * alpha)
          }
          Canvas.pset(x, y, color)
          texPos = texPos + texStep
        }
      }
    }

    sortSprites(__sprites, __position)
    var dir = __direction
    var h = Canvas.height
    var w = Canvas.width
    var cam = -__camera


    for (sprite in __sprites) {
      var uDiv = sprite.uDiv
      var vDiv = sprite.vDiv
      var vMove = sprite.vMove


      var spriteX = sprite.pos.x - __position.x
      var spriteY = sprite.pos.y - __position.y

      var invDet = 1.0 / (-cam.x * dir.y + dir.x * cam.y)
      var transformX = invDet * (dir.y * spriteX - dir.x * spriteY)
      //this is actually the depth inside the screen, that what Z is in 3D
      var transformY = invDet * (cam.y * spriteX - cam.x * spriteY)

      var vMoveScreen = (vMove / transformY).floor

      var spriteScreenX = ((w / 2) * (1 + transformX / transformY)).floor
      // Prevent fisheye
      var spriteHeight = ((h / transformY).abs / vDiv).floor
      var drawStartY = ((h - spriteHeight) / 2).floor + vMoveScreen
      if (drawStartY < 0) {
        drawStartY = 0
      }
      var drawEndY = ((h + spriteHeight) / 2).floor + vMoveScreen
      if (drawEndY >= h) {
        drawEndY = h
      }

      var spriteWidth = (((h / transformY).abs / uDiv) / 2).floor
      var drawStartX = (spriteScreenX - spriteWidth / 2).floor
      if (drawStartX < 0) {
        drawStartX = 0
      }
      var drawEndX = (spriteScreenX + spriteWidth / 2).floor
      if (drawEndX >= w) {
        drawEndX = w - 1
      }

      var texWidth = sprite.textures[0].width - 1
      var texHeight = sprite.textures[0].height - 1

      for (stripe in drawStartX...drawEndX) {
        //  int texX = int(256 * (stripe - (-spriteWidth / 2 + spriteScreenX)) * texWidth / spriteWidth) / 256;
        var texX = ((stripe - (-spriteWidth / 2 + spriteScreenX)) * texWidth / spriteWidth).abs

        // Conditions for this if:
        //1) it's in front of camera plane so you don't see things behind you
        //2) it's on the screen (left)
        //3) it's on the screen (right)
        //4) ZBuffer, with perpendicular distance
        // TODO: stripe SHOULD be allowed to be 0
        if (transformY > 0 && stripe > 0 && stripe < w && transformY < __zBuffer[stripe]) {
          for (y in drawStartY...drawEndY) {
            var texY = ((y - (-spriteHeight / 2 + h / 2)) * texHeight / spriteHeight).abs
            // System.print("%(texX) %(texY)")
            // var texY = ((y - drawStartY) / spriteHeight) * texHeight
            var color = sprite.textures[0].pget(texX, texY)
            Canvas.pset(stripe, y, color)
          }
        }
      }
    }

    var centerX = Canvas.width / 2
    var centerY = Canvas.height / 2
    Canvas.line(centerX - 8, centerY, centerX + 8, centerY, Color.green, 1)
    Canvas.line(centerX, centerY - 8, centerX, centerY + 8, Color.green, 1)

    Canvas.print(__angle, 0, 0, Color.white)
  }

  static getTileAt(position) {
    var pos = Vec.new(position.x.floor, position.y.floor)
    if (pos.x >= 0 && pos.x < MAP_WIDTH && pos.y >= 0 && pos.y < MAP_HEIGHT) {
      return MAP[MAP_WIDTH * pos.y + pos.x]
    }
    return 1
  }

  static getDoorAt(pos) {
    var mapPos = Vec.new(pos.x.floor, pos.y.floor)
    for (door in DOORS) {
      if (door.pos == mapPos) {
        return door
      }
    }
    return null
  }

  static sortSprites(list, position) {
    var i = 1
    while (i < list.count) {
      var x = list[i]
      var j = i - 1
      while (j >= 0 && (list[j].pos-position).length < (x.pos-position).length) {
        list[j + 1] = list[j]
        j = j - 1
      }
      list[j + 1] = x
      i = i + 1
    }

  }


}
