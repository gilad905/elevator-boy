import * as constants from "./constants.mjs";
import * as canvas from "./canvas.mjs";

export function draw() {
  const { measures, colors, defaultLineWidth } = constants;
  canvas.drawRect(measures.building, false, defaultLineWidth, colors.elevator);
}
