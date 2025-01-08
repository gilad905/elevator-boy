import fs from "node:fs";
import path from "node:path";

if (process.argv[2] == "hardcoded") {
  process.argv.splice(2, Infinity, 1.5, "./scenes/main.tscn");
}

let [factor, file, lineNum, decimals] = process.argv.slice(2);
if (!factor || !file) {
  const cmd = ".\\" + path.relative(".", process.argv[1]);
  const args = "hardcoded | (factor file [line_num] [decimals])";
  console.error(`Usage: node ${cmd} ${args}`);
  process.exit(1);
}
decimals ??= -1;
console.log(file);
// console.log({ factor, file, lineNum, decimals });
const text = fs.readFileSync(file, "utf8");

resize();

function resize() {
  const lines = text.split("\n");
  if (lineNum) {
    resizeLine(lines, lineNum);
  } else {
    console.log("resizing entire file");
    const pat =
      /(?<=^[^=]*)(position|scale|polygon|width|points|_size|offset|region_rect)/;
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (pat.test(line)) {
        resizeLine(lines, i + 1);
      }
    }
  }
  fs.writeFileSync(file, lines.join("\n"));
  console.log("done");
}

function resizeLine(lines, lineNum) {
  const line = lines[lineNum - 1];
  console.log("original:", line);
  const chars = line.split("");
  const numsPat = new RegExp(/\b[\d.]+\b/g);
  const matches = [...line.matchAll(numsPat)];
  for (let i = matches.length - 1; i >= 0; i--) {
    const match = matches[i];
    let numDecimals = decimals;
    if (decimals == -1) {
      numDecimals = match[0].split(".")[1]?.length || 0;
    }
    const resized = (parseFloat(match[0]) * factor).toFixed(numDecimals);
    chars.splice(match.index, match[0].length, ...resized.split(""));
  }
  const resized = chars.join("");
  console.log("resized:", resized);
  lines.splice(lineNum - 1, 1, resized);
}
