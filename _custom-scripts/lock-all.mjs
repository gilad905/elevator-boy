import fs from "node:fs";

const lockLine = "\nmetadata/_edit_lock_ = true";
const lockLinePat = new RegExp(lockLine, "g");
const toLock = !(process.argv[2] == "unlock");
console.log(toLock ? "locking" : "unlocking");

for (const file of fs.readdirSync("./scenes")) {
  let updated = 0;
  console.log(`checking ${file}`);
  const text = fs.readFileSync(`./scenes/${file}`, "utf8");
  let newText;
  if (toLock) {
    const elems = text.split(/(?=\s*\[)/);
    for (let i = 0; i < elems.length; i++) {
      if (elems[i].startsWith("[node ") && !elems[i].includes(lockLine)) {
        elems[i] += lockLine;
        updated++;
      }
    }
    newText = elems.join("");
  } else {
    updated = text.match(lockLinePat)?.length;
    newText = text.replaceAll(lockLine, "");
  }
  if (updated) {
    console.log(`writing ${updated} updates to ${file}`);
    fs.writeFileSync(`./scenes/${file}`, newText);
  }
}
console.log("done");
