export const elems = {
  // canvas: document.querySelector("canvas"),
};

export const defaultLineWidth = 2;

export const floorCount = 2;

export const world = {
  building: {
    rect: {
      width: 200,
      height: 400,
      left: 50,
      top: 50,
    },
    lineWidth: defaultLineWidth,
    color: "black",
  },
  floor: {
    lineWidth: 4,
    color: "brown",
    width: 400,
  },
  elevator: {
    lineWidth: 10,
    color: "blue",
  },
};
