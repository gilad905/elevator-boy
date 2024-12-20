import * as constants from "./constants.mjs";
import * as canvas from "./canvas.mjs";

const { floorCount } = constants;
const innerBuildingRect = getInnerBuildingRect();
const floorHeight = parseInt(innerBuildingRect.height / floorCount);

export function draw() {
  drawBuilding();
  drawFloors();
  drawElevator(1);
}

function drawBuilding() {
  const { building } = constants.world;
  canvas.drawRect(building.rect, false, building.lineWidth, building.color);
}

function drawFloors() {
  const { floor, building } = constants.world;
  for (let i = 0; i < floorCount; i++) {
    const floorRect = {
      left: innerBuildingRect.left + building.rect.width,
      width: floor.width,
      top: innerBuildingRect.top + i * floorHeight,
      height: floorHeight,
    };
    canvas.drawRect(floorRect, false, floor.lineWidth, floor.color);
  }
}

function drawElevator(floorNum) {
  const { floor, elevator } = constants.world;
  const floorTopIndex = floorCount - floorNum;
  const rect = { ...innerBuildingRect };
  rect.top += floorTopIndex * floorHeight;
  rect.height = floorHeight;
  canvas.drawRect(rect, false, elevator.lineWidth, elevator.color);
}

function getInnerBuildingRect() {
  const { building } = constants.world;
  const innerBuildingRect = {};
  for (const type of ["left", "top"]) {
    innerBuildingRect[type] = building.rect[type] + building.lineWidth;
  }
  for (const type of ["width", "height"]) {
    innerBuildingRect[type] = building.rect[type] - building.lineWidth * 2;
  }
  return innerBuildingRect;
}
