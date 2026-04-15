import fs from "fs";

const paths = [
  "C:\\Users\\gilad\\Documents\\Programming\\Game dev\\Godot_v4.3-stable_win64\\Godot_v4.3-stable_win64.exe",
  "D:\\DEV\\Own\\Godot\\Godot_v4.3-stable_win64.exe\\Godot_v4.3-stable_win64.exe",
];

const godotPath = paths.find((path) => fs.existsSync(path));
console.log(godotPath);