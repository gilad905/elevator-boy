const canvas = document.querySelector("canvas");
const ctx = canvas.getContext("2d");

export function drawRect(rect, isFill, lineWidth, color) {
  console.log({ rect, color });
  const { left, top, width, height } = rect;
  const drawType = isFill ? "fill" : "stroke";
  ctx.lineWidth = lineWidth;
  ctx[`${drawType}Style`] = color;
  ctx[`${drawType}Rect`](left, top, width, height);
}

// export function drawShape(points, isFill, lineWidth, color) {
//   ctx.beginPath();
//   ctx.moveTo(points[0].x, points[0].y);
//   for (const point of points) {
//     ctx.lineTo(point.x, point.y);
//   }
//   ctx.fillStyle = color;
//   if (isFill) {
//     ctx.fill();
//   } else {
//     ctx.stroke();
//   }
// }
