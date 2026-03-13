const $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Matched = { $tag: 0 };
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Char(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Char.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split.prototype.$tag = 4;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Assertion(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Assertion.prototype.$tag = 5;
const $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Empty = { $tag: 0 };
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Capture(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Capture.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrMore(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrMore.prototype.$tag = 4;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$OneOrMore(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$OneOrMore.prototype.$tag = 5;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrOne(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrOne.prototype.$tag = 6;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Repeat(param0, param1, param2, param3) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
  this._3 = param3;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Repeat.prototype.$tag = 7;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Concat(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Concat.prototype.$tag = 8;
function $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Alternate(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
$64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Alternate.prototype.$tag = 9;
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function $bound_check(arr, index) {
  if (index < 0 || index >= arr.length) throw new Error("Index out of bounds");
}
const moonbitlang$core$builtin$$random_seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
const moonbitlang$core$builtin$$int_to_string_js = (x, radix) => {
  return x.toString(radix);
};
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const Option$None$0$ = { $tag: 0 };
function Option$Some$0$(param0) {
  this._0 = param0;
}
Option$Some$0$.prototype.$tag = 1;
const moonbitlang$core$builtin$$JSArray$push = (arr, val) => { arr.push(val); };
const $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$1$ = { $tag: 0 };
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$1$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Break$1$.prototype.$tag = 1;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$1$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Return$1$.prototype.$tag = 2;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$1$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$Error$1$.prototype.$tag = 3;
function $64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$1$(param0) {
  this._0 = param0;
}
$64$moonbitlang$47$core$47$builtin$46$ForeachResult$JumpOuter$1$.prototype.$tag = 4;
const moonbitlang$core$builtin$$JSArray$set_length = (arr, len) => { arr.length = len; };
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
const moonbitlang$core$array$$JSArray$copy = (arr) => arr.slice(0);
function Result$Err$2$(param0) {
  this._0 = param0;
}
Result$Err$2$.prototype.$tag = 0;
function Result$Ok$2$(param0) {
  this._0 = param0;
}
Result$Ok$2$.prototype.$tag = 1;
function Result$Err$3$(param0) {
  this._0 = param0;
}
Result$Err$3$.prototype.$tag = 0;
function Result$Ok$3$(param0) {
  this._0 = param0;
}
Result$Ok$3$.prototype.$tag = 1;
function Result$Err$4$(param0) {
  this._0 = param0;
}
Result$Err$4$.prototype.$tag = 0;
function Result$Ok$4$(param0) {
  this._0 = param0;
}
Result$Ok$4$.prototype.$tag = 1;
function Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError.prototype.$tag = 0;
function Result$Err$5$(param0) {
  this._0 = param0;
}
Result$Err$5$.prototype.$tag = 0;
function Result$Ok$5$(param0) {
  this._0 = param0;
}
Result$Ok$5$.prototype.$tag = 1;
function Result$Err$6$(param0) {
  this._0 = param0;
}
Result$Err$6$.prototype.$tag = 0;
function Result$Ok$6$(param0) {
  this._0 = param0;
}
Result$Ok$6$.prototype.$tag = 1;
function Result$Err$7$(param0) {
  this._0 = param0;
}
Result$Err$7$.prototype.$tag = 0;
function Result$Ok$7$(param0) {
  this._0 = param0;
}
Result$Ok$7$.prototype.$tag = 1;
function Result$Err$8$(param0) {
  this._0 = param0;
}
Result$Err$8$.prototype.$tag = 0;
function Result$Ok$8$(param0) {
  this._0 = param0;
}
Result$Ok$8$.prototype.$tag = 1;
function Result$Err$9$(param0) {
  this._0 = param0;
}
Result$Err$9$.prototype.$tag = 0;
function Result$Ok$9$(param0) {
  this._0 = param0;
}
Result$Ok$9$.prototype.$tag = 1;
function Result$Err$10$(param0) {
  this._0 = param0;
}
Result$Err$10$.prototype.$tag = 0;
function Result$Ok$10$(param0) {
  this._0 = param0;
}
Result$Ok$10$.prototype.$tag = 1;
const moonbitlang$core$string$$boyer_moore_horspool_find$46$constr$47$888 = 0;
const moonbitlang$core$string$$brute_force_find$46$constr$47$902 = 0;
const moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$70 = "m";
const moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$71 = "s";
const moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$72 = "i";
const moonbitlang$core$string$regex$internal$regexp$$compile$46$42$bind$124$66 = "";
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$979 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(-1, -1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$980 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(-1, -1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$981 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(-1, -1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$982 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(-1, -1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$983 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(-1, -1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$984 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump(-1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1047 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(3, 1);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1048 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump(0);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1049 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save(0);
const moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1050 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save(1);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1296 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(4);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1297 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(5);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1298 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(3);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1299 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(1);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1300 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(2);
const moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1301 = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Assertion(0);
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1462 = { _0: "C", _1: "C" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1463 = { _0: "Other", _1: "C" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1464 = { _0: "Cc", _1: "Cc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1465 = { _0: "Control", _1: "Cc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1466 = { _0: "cntrl", _1: "Cc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1467 = { _0: "Cf", _1: "Cf" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1468 = { _0: "Format", _1: "Cf" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1469 = { _0: "Cn", _1: "Cn" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1470 = { _0: "Unassigned", _1: "Cn" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1471 = { _0: "Co", _1: "Co" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1472 = { _0: "Private_Use", _1: "Co" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1473 = { _0: "Cs", _1: "Cs" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1474 = { _0: "Surrogate", _1: "Cs" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1475 = { _0: "L", _1: "L" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1476 = { _0: "Letter", _1: "L" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1477 = { _0: "LC", _1: "LC" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1478 = { _0: "Cased_Letter", _1: "LC" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1479 = { _0: "Ll", _1: "Ll" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1480 = { _0: "Lowercase_Letter", _1: "Ll" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1481 = { _0: "Lm", _1: "Lm" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1482 = { _0: "Modifier_Letter", _1: "Lm" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1483 = { _0: "Lo", _1: "Lo" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1484 = { _0: "Other_Letter", _1: "Lo" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1485 = { _0: "Lt", _1: "Lt" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1486 = { _0: "Titlecase_Letter", _1: "Lt" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1487 = { _0: "Lu", _1: "Lu" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1488 = { _0: "Uppercase_Letter", _1: "Lu" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1489 = { _0: "M", _1: "M" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1490 = { _0: "Mark", _1: "M" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1491 = { _0: "Combining_Mark", _1: "M" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1492 = { _0: "Mc", _1: "Mc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1493 = { _0: "Spacing_Mark", _1: "Mc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1494 = { _0: "Me", _1: "Me" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1495 = { _0: "Enclosing_Mark", _1: "Me" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1496 = { _0: "Mn", _1: "Mn" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1497 = { _0: "Nonspacing_Mark", _1: "Mn" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1498 = { _0: "N", _1: "N" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1499 = { _0: "Number", _1: "N" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1500 = { _0: "Nd", _1: "Nd" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1501 = { _0: "Decimal_Number", _1: "Nd" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1502 = { _0: "digit", _1: "Nd" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1503 = { _0: "Nl", _1: "Nl" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1504 = { _0: "Letter_Number", _1: "Nl" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1505 = { _0: "No", _1: "No" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1506 = { _0: "Other_Number", _1: "No" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1507 = { _0: "P", _1: "P" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1508 = { _0: "Punctuation", _1: "P" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1509 = { _0: "punct", _1: "P" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1510 = { _0: "Pc", _1: "Pc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1511 = { _0: "Connector_Punctuation", _1: "Pc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1512 = { _0: "Pd", _1: "Pd" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1513 = { _0: "Dash_Punctuation", _1: "Pd" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1514 = { _0: "Pe", _1: "Pe" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1515 = { _0: "Close_Punctuation", _1: "Pe" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1516 = { _0: "Pf", _1: "Pf" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1517 = { _0: "Final_Punctuation", _1: "Pf" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1518 = { _0: "Pi", _1: "Pi" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1519 = { _0: "Initial_Punctuation", _1: "Pi" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1520 = { _0: "Po", _1: "Po" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1521 = { _0: "Other_Punctuation", _1: "Po" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1522 = { _0: "Ps", _1: "Ps" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1523 = { _0: "Open_Punctuation", _1: "Ps" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1524 = { _0: "S", _1: "S" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1525 = { _0: "Symbol", _1: "S" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1526 = { _0: "Sc", _1: "Sc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1527 = { _0: "Currency_Symbol", _1: "Sc" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1528 = { _0: "Sk", _1: "Sk" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1529 = { _0: "Modifier_Symbol", _1: "Sk" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1530 = { _0: "Sm", _1: "Sm" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1531 = { _0: "Math_Symbol", _1: "Sm" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1532 = { _0: "So", _1: "So" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1533 = { _0: "Other_Symbol", _1: "So" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1534 = { _0: "Z", _1: "Z" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1535 = { _0: "Separator", _1: "Z" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1536 = { _0: "Zl", _1: "Zl" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1537 = { _0: "Line_Separator", _1: "Zl" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1538 = { _0: "Zp", _1: "Zp" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1539 = { _0: "Paragraph_Separator", _1: "Zp" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1540 = { _0: "Zs", _1: "Zs" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1541 = { _0: "Space_Separator", _1: "Zs" };
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$cs = [55296, 57343];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_digit = [48, 57];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_digit = [0, 47, 58, 1114111];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_word = [48, 57, 65, 90, 95, 95, 97, 122];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_word = [0, 47, 58, 64, 91, 94, 96, 96, 123, 1114111];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_any = [0, 1114111];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_any_not_new_line = [0, 9, 17, 1114111];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_white_space_or_line_terminator = [9, 13, 32, 32, 160, 160, 5760, 5760, 8192, 8202, 8232, 8233, 8239, 8239, 8287, 8287, 12288, 12288, 65279, 65279];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_white_space_or_line_terminator = [0, 8, 14, 31, 33, 159, 161, 5759, 5761, 8191, 8203, 8231, 8234, 8238, 8240, 8286, 8288, 12287, 12289, 65278, 65280, 1114111];
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96 = "aAAabBBbcCCcdDDdeEEefFFfgGGghHHhiIIijJJjkKKKKklLLlmMMmnNNnoOOopPPpqQQqrRRrsSSſſstTTtuUUuvVVvwWWwxXXxyYYyzZZzμµµΜΜμàÀÀàáÁÁáâÂÂâãÃÃãäÄÄäåÅÅÅÅåæÆÆæçÇÇçèÈÈèéÉÉéêÊÊêëËËëìÌÌìíÍÍíîÎÎîïÏÏïðÐÐðñÑÑñòÒÒòóÓÓóôÔÔôõÕÕõöÖÖöøØØøùÙÙùúÚÚúûÛÛûüÜÜüýÝÝýþÞÞþāĀĀāăĂĂăąĄĄąćĆĆćĉĈĈĉċĊĊċčČČčďĎĎďđĐĐđēĒĒēĕĔĔĕėĖĖėęĘĘęěĚĚěĝĜĜĝğĞĞğġĠĠġģĢĢģĥĤĤĥħĦĦħĩĨĨĩīĪĪīĭĬĬĭįĮĮįĳĲĲĳĵĴĴĵķĶĶķĺĹĹĺļĻĻļľĽĽľŀĿĿŀłŁŁłńŃŃńņŅŅņňŇŇňŋŊŊŋōŌŌōŏŎŎŏőŐŐőœŒŒœŕŔŔŕŗŖŖŗřŘŘřśŚŚśŝŜŜŝşŞŞşšŠŠšţŢŢţťŤŤťŧŦŦŧũŨŨũūŪŪūŭŬŬŭůŮŮůűŰŰűųŲŲųŵŴŴŵŷŶŶŷÿŸŸÿźŹŹźżŻŻżžŽŽžɓƁƁɓƃƂƂƃƅƄƄƅɔƆƆɔƈƇƇƈɖƉƉɖɗƊƊɗƌƋƋƌǝƎƎǝəƏƏəɛƐƐɛƒƑƑƒɠƓƓɠɣƔƔɣɩƖƖɩɨƗƗɨƙƘƘƙɯƜƜɯɲƝƝɲɵƟƟɵơƠƠơƣƢƢƣƥƤƤƥʀƦƦʀƨƧƧƨʃƩƩʃƭƬƬƭʈƮƮʈưƯƯưʊƱƱʊʋƲƲʋƴƳƳƴƶƵƵƶʒƷƷʒƹƸƸƹƽƼƼƽǆǄǄǅǅǆǉǇǇǈǈǉǌǊǊǋǋǌǎǍǍǎǐǏǏǐǒǑǑǒǔǓǓǔǖǕǕǖǘǗǗǘǚǙǙǚǜǛǛǜǟǞǞǟǡǠǠǡǣǢǢǣǥǤǤǥǧǦǦǧǩǨǨǩǫǪǪǫǭǬǬǭǯǮǮǯǳǱǱǲǲǳǵǴǴǵƕǶǶƕƿǷǷƿǹǸǸǹǻǺǺǻǽǼǼǽǿǾǾǿȁȀȀȁȃȂȂȃȅȄȄȅȇȆȆȇȉȈȈȉȋȊȊȋȍȌȌȍȏȎȎȏȑȐȐȑȓȒȒȓȕȔȔȕȗȖȖȗșȘȘșțȚȚțȝȜȜȝȟȞȞȟƞȠȠƞȣȢȢȣȥȤȤȥȧȦȦȧȩȨȨȩȫȪȪȫȭȬȬȭȯȮȮȯȱȰȰȱȳȲȲȳⱥȺȺⱥȼȻȻȼƚȽȽƚⱦȾȾⱦɂɁɁɂƀɃɃƀʉɄɄʉʌɅɅʌɇɆɆɇɉɈɈɉɋɊɊɋɍɌɌɍɏɎɎɏιͅͅΙΙιιιͱͰͰͱͳͲͲͳͷͶͶͷϳͿͿϳάΆΆάέΈΈέήΉΉήίΊΊίόΌΌόύΎΎύώΏΏώαΑΑαβΒΒϐϐβγΓΓγδΔΔδεΕΕϵϵεζΖΖζηΗΗηθΘΘϑϑϴϴθκΚΚϰϰκλΛΛλνΝΝνξΞΞξοΟΟοπΠΠϖϖπρΡΡϱϱρσΣΣςςστΤΤτυΥΥυφΦΦϕϕφχΧΧχψΨΨψωΩΩΩΩωϊΪΪϊϋΫΫϋϗϏϏϗϙϘϘϙϛϚϚϛϝϜϜϝϟϞϞϟϡϠϠϡϣϢϢϣϥϤϤϥϧϦϦϧϩϨϨϩϫϪϪϫϭϬϬϭϯϮϮϯϸϷϷϸϲϹϹϲϻϺϺϻͻϽϽͻͼϾϾͼͽϿϿͽѐЀЀѐёЁЁёђЂЂђѓЃЃѓєЄЄєѕЅЅѕіІІіїЇЇїјЈЈјљЉЉљњЊЊњћЋЋћќЌЌќѝЍЍѝўЎЎўџЏЏџаААабББбвВВᲀᲀвгГГгдДДᲁᲁдеЕЕежЖЖжзЗЗзиИИийЙЙйкККклЛЛлмММмнННноООᲂᲂопППпрРРрсССᲃᲃстТТᲄᲄᲅᲅтуУУуфФФфхХХхцЦЦцчЧЧчшШШшщЩЩщъЪЪᲆᲆъыЫЫыьЬЬьэЭЭэюЮЮюяЯЯяѡѠѠѡѣѢѢᲇᲇѣѥѤѤѥѧѦѦѧѩѨѨѩѫѪѪѫѭѬѬѭѯѮѮѯѱѰѰѱѳѲѲѳѵѴѴѵѷѶѶѷѹѸѸѹѻѺѺѻѽѼѼѽѿѾѾѿҁҀҀҁҋҊҊҋҍҌҌҍҏҎҎҏґҐҐґғҒҒғҕҔҔҕҗҖҖҗҙҘҘҙқҚҚқҝҜҜҝҟҞҞҟҡҠҠҡңҢҢңҥҤҤҥҧҦҦҧҩҨҨҩҫҪҪҫҭҬҬҭүҮҮүұҰҰұҳҲҲҳҵҴҴҵҷҶҶҷҹҸҸҹһҺҺһҽҼҼҽҿҾҾҿӏӀӀӏӂӁӁӂӄӃӃӄӆӅӅӆӈӇӇӈӊӉӉӊӌӋӋӌӎӍӍӎӑӐӐӑӓӒӒӓӕӔӔӕӗӖӖӗәӘӘәӛӚӚӛӝӜӜӝӟӞӞӟӡӠӠӡӣӢӢӣӥӤӤӥӧӦӦӧөӨӨөӫӪӪӫӭӬӬӭӯӮӮӯӱӰӰӱӳӲӲӳӵӴӴӵӷӶӶӷӹӸӸӹӻӺӺӻӽӼӼӽӿӾӾӿԁԀԀԁԃԂԂԃԅԄԄԅԇԆԆԇԉԈԈԉԋԊԊԋԍԌԌԍԏԎԎԏԑԐԐԑԓԒԒԓԕԔԔԕԗԖԖԗԙԘԘԙԛԚԚԛԝԜԜԝԟԞԞԟԡԠԠԡԣԢԢԣԥԤԤԥԧԦԦԧԩԨԨԩԫԪԪԫԭԬԬԭԯԮԮԯաԱԱաբԲԲբգԳԳգդԴԴդեԵԵեզԶԶզէԷԷէըԸԸըթԹԹթժԺԺժիԻԻիլԼԼլխԽԽխծԾԾծկԿԿկհՀՀհձՁՁձղՂՂղճՃՃճմՄՄմյՅՅյնՆՆնշՇՇշոՈՈոչՉՉչպՊՊպջՋՋջռՌՌռսՍՍսվՎՎվտՏՏտրՐՐրցՑՑցւՒՒւփՓՓփքՔՔքօՕՕօֆՖՖֆⴀႠႠⴀⴁႡႡⴁⴂႢႢⴂⴃႣႣⴃⴄႤႤⴄⴅႥႥⴅⴆႦႦⴆⴇႧႧⴇⴈႨႨⴈⴉႩႩⴉⴊႪႪⴊⴋႫႫⴋⴌႬႬⴌⴍႭႭⴍⴎႮႮⴎⴏႯႯⴏⴐႰႰⴐⴑႱႱⴑⴒႲႲⴒⴓႳႳⴓⴔႴႴⴔⴕႵႵⴕⴖႶႶⴖⴗႷႷⴗⴘႸႸⴘⴙႹႹⴙⴚႺႺⴚⴛႻႻⴛⴜႼႼⴜⴝႽႽⴝⴞႾႾⴞⴟႿႿⴟⴠჀჀⴠⴡჁჁⴡⴢჂჂⴢⴣჃჃⴣⴤჄჄⴤⴥჅჅⴥⴧჇჇⴧⴭჍჍⴭᏰᏸᏸᏰᏱᏹᏹᏱᏲᏺᏺᏲᏳᏻᏻᏳᏴᏼᏼᏴᏵᏽᏽᏵꙋᲈᲈꙊꙊꙋᲊᲉᲉᲊაᲐᲐაბᲑᲑბგᲒᲒგდᲓᲓდეᲔᲔევᲕᲕვზᲖᲖზთᲗᲗთიᲘᲘიკᲙᲙკლᲚᲚლმᲛᲛმნᲜᲜნოᲝᲝოპᲞᲞპჟᲟᲟჟრᲠᲠრსᲡᲡსტᲢᲢტუᲣᲣუფᲤᲤფქᲥᲥქღᲦᲦღყᲧᲧყშᲨᲨშჩᲩᲩჩცᲪᲪცძᲫᲫძწᲬᲬწჭᲭᲭჭხᲮᲮხჯᲯᲯჯჰᲰᲰჰჱᲱᲱჱჲᲲᲲჲჳᲳᲳჳჴᲴᲴჴჵᲵᲵჵჶᲶᲶჶჷᲷᲷჷჸᲸᲸჸჹᲹᲹჹჺᲺᲺჺჽᲽᲽჽჾᲾᲾჾჿᲿᲿჿḁḀḀḁḃḂḂḃḅḄḄḅḇḆḆḇḉḈḈḉḋḊḊḋḍḌḌḍḏḎḎḏḑḐḐḑḓḒḒḓḕḔḔḕḗḖḖḗḙḘḘḙḛḚḚḛḝḜḜḝḟḞḞḟḡḠḠḡḣḢḢḣḥḤḤḥḧḦḦḧḩḨḨḩḫḪḪḫḭḬḬḭḯḮḮḯḱḰḰḱḳḲḲḳḵḴḴḵḷḶḶḷḹḸḸḹḻḺḺḻḽḼḼḽḿḾḾḿṁṀṀṁṃṂṂṃṅṄṄṅṇṆṆṇṉṈṈṉṋṊṊṋṍṌṌṍṏṎṎṏṑṐṐṑṓṒṒṓṕṔṔṕṗṖṖṗṙṘṘṙṛṚṚṛṝṜṜṝṟṞṞṟṡṠṠẛẛṡṣṢṢṣṥṤṤṥṧṦṦṧṩṨṨṩṫṪṪṫṭṬṬṭṯṮṮṯṱṰṰṱṳṲṲṳṵṴṴṵṷṶṶṷṹṸṸṹṻṺṺṻṽṼṼṽṿṾṾṿẁẀẀẁẃẂẂẃẅẄẄẅẇẆẆẇẉẈẈẉẋẊẊẋẍẌẌẍẏẎẎẏẑẐẐẑẓẒẒẓẕẔẔẕßẞẞßạẠẠạảẢẢảấẤẤấầẦẦầẩẨẨẩẫẪẪẫậẬẬậắẮẮắằẰẰằẳẲẲẳẵẴẴẵặẶẶặẹẸẸẹẻẺẺẻẽẼẼẽếẾẾếềỀỀềểỂỂểễỄỄễệỆỆệỉỈỈỉịỊỊịọỌỌọỏỎỎỏốỐỐốồỒỒồổỔỔổỗỖỖỗộỘỘộớỚỚớờỜỜờởỞỞởỡỠỠỡợỢỢợụỤỤụủỦỦủứỨỨứừỪỪừửỬỬửữỮỮữựỰỰựỳỲỲỳỵỴỴỵỷỶỶỷỹỸỸỹỻỺỺỻỽỼỼỽỿỾỾỿἀἈἈἀἁἉἉἁἂἊἊἂἃἋἋἃἄἌἌἄἅἍἍἅἆἎἎἆἇἏἏἇἐἘἘἐἑἙἙἑἒἚἚἒἓἛἛἓἔἜἜἔἕἝἝἕἠἨἨἠἡἩἩἡἢἪἪἢἣἫἫἣἤἬἬἤἥἭἭἥἦἮἮἦἧἯἯἧἰἸἸἰἱἹἹἱἲἺἺἲἳἻἻἳἴἼἼἴἵἽἽἵἶἾἾἶἷἿἿἷὀὈὈὀὁὉὉὁὂὊὊὂὃὋὋὃὄὌὌὄὅὍὍὅὑὙὙὑὓὛὛὓὕὝὝὕὗὟὟὗὠὨὨὠὡὩὩὡὢὪὪὢὣὫὫὣὤὬὬὤὥὭὭὥὦὮὮὦὧὯὯὧᾀᾈᾈᾀᾁᾉᾉᾁᾂᾊᾊᾂᾃᾋᾋᾃᾄᾌᾌᾄᾅᾍᾍᾅᾆᾎᾎᾆᾇᾏᾏᾇᾐᾘᾘᾐᾑᾙᾙᾑᾒᾚᾚᾒᾓᾛᾛᾓᾔᾜᾜᾔᾕᾝᾝᾕᾖᾞᾞᾖᾗᾟᾟᾗᾠᾨᾨᾠᾡᾩᾩᾡᾢᾪᾪᾢᾣᾫᾫᾣᾤᾬᾬᾤᾥᾭᾭᾥᾦᾮᾮᾦᾧᾯᾯᾧᾰᾸᾸᾰᾱᾹᾹᾱὰᾺᾺὰάΆΆάᾳᾼᾼᾳὲῈῈὲέΈΈέὴῊῊὴήΉΉήῃῌῌῃΐΐΐΐῐῘῘῐῑῙῙῑὶῚῚὶίΊΊίΰΰΰΰῠῨῨῠῡῩῩῡὺῪῪὺύΎΎύῥῬῬῥὸῸῸὸόΌΌόὼῺῺὼώΏΏώῳῼῼῳⅎℲℲⅎⅰⅠⅠⅰⅱⅡⅡⅱⅲⅢⅢⅲⅳⅣⅣⅳⅴⅤⅤⅴⅵⅥⅥⅵⅶⅦⅦⅶⅷⅧⅧⅷⅸⅨⅨⅸⅹⅩⅩⅹⅺⅪⅪⅺⅻⅫⅫⅻⅼⅬⅬⅼⅽⅭⅭⅽⅾⅮⅮⅾⅿⅯⅯⅿↄↃↃↄⓐⒶⒶⓐⓑⒷⒷⓑⓒⒸⒸⓒⓓⒹⒹⓓⓔⒺⒺⓔⓕⒻⒻⓕⓖⒼⒼⓖⓗⒽⒽⓗⓘⒾⒾⓘⓙⒿⒿⓙⓚⓀⓀⓚⓛⓁⓁⓛⓜⓂⓂⓜⓝⓃⓃⓝⓞⓄⓄⓞⓟⓅⓅⓟⓠⓆⓆⓠⓡⓇⓇⓡⓢⓈⓈⓢⓣⓉⓉⓣⓤⓊⓊⓤⓥⓋⓋⓥⓦⓌⓌⓦⓧⓍⓍⓧⓨⓎⓎⓨⓩⓏⓏⓩⰰⰀⰀⰰⰱⰁⰁⰱⰲⰂⰂⰲⰳⰃⰃⰳⰴⰄⰄⰴⰵⰅⰅⰵⰶⰆⰆⰶⰷⰇⰇⰷⰸⰈⰈⰸⰹⰉⰉⰹⰺⰊⰊⰺⰻⰋⰋⰻⰼⰌⰌⰼⰽⰍⰍⰽⰾⰎⰎⰾⰿⰏⰏⰿⱀⰐⰐⱀⱁⰑⰑⱁⱂⰒⰒⱂⱃⰓⰓⱃⱄⰔⰔⱄⱅⰕⰕⱅⱆⰖⰖⱆⱇⰗⰗⱇⱈⰘⰘⱈⱉⰙⰙⱉⱊⰚⰚⱊⱋⰛⰛⱋⱌⰜⰜⱌⱍⰝⰝⱍⱎⰞⰞⱎⱏⰟⰟⱏⱐⰠⰠⱐⱑⰡⰡⱑⱒⰢⰢⱒⱓⰣⰣⱓⱔⰤⰤⱔⱕⰥⰥⱕⱖⰦⰦⱖⱗⰧⰧⱗⱘⰨⰨⱘⱙⰩⰩⱙⱚⰪⰪⱚⱛⰫⰫⱛⱜⰬⰬⱜⱝⰭⰭⱝⱞⰮⰮⱞⱟⰯⰯⱟⱡⱠⱠⱡɫⱢⱢɫᵽⱣⱣᵽɽⱤⱤɽⱨⱧⱧⱨⱪⱩⱩⱪⱬⱫⱫⱬɑⱭⱭɑɱⱮⱮɱɐⱯⱯɐɒⱰⱰɒⱳⱲⱲⱳⱶⱵⱵⱶȿⱾⱾȿɀⱿⱿɀⲁⲀⲀⲁⲃⲂⲂⲃⲅⲄⲄⲅⲇⲆⲆⲇⲉⲈⲈⲉⲋⲊⲊⲋⲍⲌⲌⲍⲏⲎⲎⲏⲑⲐⲐⲑⲓⲒⲒⲓⲕⲔⲔⲕⲗⲖⲖⲗⲙⲘⲘⲙⲛⲚⲚⲛⲝⲜⲜⲝⲟⲞⲞⲟⲡⲠⲠⲡⲣⲢⲢⲣⲥⲤⲤⲥⲧⲦⲦⲧⲩⲨⲨⲩⲫⲪⲪⲫⲭⲬⲬⲭⲯⲮⲮⲯⲱⲰⲰⲱⲳⲲⲲⲳⲵⲴⲴⲵⲷⲶⲶⲷⲹⲸⲸⲹⲻⲺⲺⲻⲽⲼⲼⲽⲿⲾⲾⲿⳁⳀⳀⳁⳃⳂⳂⳃⳅⳄⳄⳅⳇⳆⳆⳇⳉⳈⳈⳉⳋⳊⳊⳋⳍⳌⳌⳍⳏⳎⳎⳏⳑⳐⳐⳑⳓⳒⳒⳓⳕⳔⳔⳕⳗⳖⳖⳗⳙⳘⳘⳙⳛⳚⳚⳛⳝⳜⳜⳝⳟⳞⳞⳟⳡⳠⳠⳡⳣⳢⳢⳣⳬⳫⳫⳬⳮⳭⳭⳮⳳⳲⳲⳳꙁꙀꙀꙁꙃꙂꙂꙃꙅꙄꙄꙅꙇꙆꙆꙇꙉꙈꙈꙉꙍꙌꙌꙍꙏꙎꙎꙏꙑꙐꙐꙑꙓꙒꙒꙓꙕꙔꙔꙕꙗꙖꙖꙗꙙꙘꙘꙙꙛꙚꙚꙛꙝꙜꙜꙝꙟꙞꙞꙟꙡꙠꙠꙡꙣꙢꙢꙣꙥꙤꙤꙥꙧꙦꙦꙧꙩꙨꙨꙩꙫꙪꙪꙫꙭꙬꙬꙭꚁꚀꚀꚁꚃꚂꚂꚃꚅꚄꚄꚅꚇꚆꚆꚇꚉꚈꚈꚉꚋꚊꚊꚋꚍꚌꚌꚍꚏꚎꚎꚏꚑꚐꚐꚑꚓꚒꚒꚓꚕꚔꚔꚕꚗꚖꚖꚗꚙꚘꚘꚙꚛꚚꚚꚛꜣꜢꜢꜣꜥꜤꜤꜥꜧꜦꜦꜧꜩꜨꜨꜩꜫꜪꜪꜫꜭꜬꜬꜭꜯꜮꜮꜯꜳꜲꜲꜳꜵꜴꜴꜵꜷꜶꜶꜷꜹꜸꜸꜹꜻꜺꜺꜻꜽꜼꜼꜽꜿꜾꜾꜿꝁꝀꝀꝁꝃꝂꝂꝃꝅꝄꝄꝅꝇꝆꝆꝇꝉꝈꝈꝉꝋꝊꝊꝋꝍꝌꝌꝍꝏꝎꝎꝏꝑꝐꝐꝑꝓꝒꝒꝓꝕꝔꝔꝕꝗꝖꝖꝗꝙꝘꝘꝙꝛꝚꝚꝛꝝꝜꝜꝝꝟꝞꝞꝟꝡꝠꝠꝡꝣꝢꝢꝣꝥꝤꝤꝥꝧꝦꝦꝧꝩꝨꝨꝩꝫꝪꝪꝫꝭꝬꝬꝭꝯꝮꝮꝯꝺꝹꝹꝺꝼꝻꝻꝼᵹꝽꝽᵹꝿꝾꝾꝿꞁꞀꞀꞁꞃꞂꞂꞃꞅꞄꞄꞅꞇꞆꞆꞇꞌꞋꞋꞌɥꞍꞍɥꞑꞐꞐꞑꞓꞒꞒꞓꞗꞖꞖꞗꞙꞘꞘꞙꞛꞚꞚꞛꞝꞜꞜꞝꞟꞞꞞꞟꞡꞠꞠꞡꞣꞢꞢꞣꞥꞤꞤꞥꞧꞦꞦꞧꞩꞨꞨꞩɦꞪꞪɦɜꞫꞫɜɡꞬꞬɡɬꞭꞭɬɪꞮꞮɪʞꞰꞰʞʇꞱꞱʇʝꞲꞲʝꭓꞳꞳꭓꞵꞴꞴꞵꞷꞶꞶꞷꞹꞸꞸꞹꞻꞺꞺꞻꞽꞼꞼꞽꞿꞾꞾꞿꟁꟀꟀꟁꟃꟂꟂꟃꞔꟄꟄꞔʂꟅꟅʂᶎꟆꟆᶎꟈꟇꟇꟈꟊꟉꟉꟊɤꟋꟋɤꟍꟌꟌꟍꟑꟐꟐꟑꟗꟖꟖꟗꟙꟘꟘꟙꟛꟚꟚꟛƛꟜꟜƛꟶꟵꟵꟶᎠꭰꭰᎠᎡꭱꭱᎡᎢꭲꭲᎢᎣꭳꭳᎣᎤꭴꭴᎤᎥꭵꭵᎥᎦꭶꭶᎦᎧꭷꭷᎧᎨꭸꭸᎨᎩꭹꭹᎩᎪꭺꭺᎪᎫꭻꭻᎫᎬꭼꭼᎬᎭꭽꭽᎭᎮꭾꭾᎮᎯꭿꭿᎯᎰꮀꮀᎰᎱꮁꮁᎱᎲꮂꮂᎲᎳꮃꮃᎳᎴꮄꮄᎴᎵꮅꮅᎵᎶꮆꮆᎶᎷꮇꮇᎷᎸꮈꮈᎸᎹꮉꮉᎹᎺꮊꮊᎺᎻꮋꮋᎻᎼꮌꮌᎼᎽꮍꮍᎽᎾꮎꮎᎾᎿꮏꮏᎿᏀꮐꮐᏀᏁꮑꮑᏁᏂꮒꮒᏂᏃꮓꮓᏃᏄꮔꮔᏄᏅꮕꮕᏅᏆꮖꮖᏆᏇꮗꮗᏇᏈꮘꮘᏈᏉꮙꮙᏉᏊꮚꮚᏊᏋꮛꮛᏋᏌꮜꮜᏌᏍꮝꮝᏍᏎꮞꮞᏎᏏꮟꮟᏏᏐꮠꮠᏐᏑꮡꮡᏑᏒꮢꮢᏒᏓꮣꮣᏓᏔꮤꮤᏔᏕꮥꮥᏕᏖꮦꮦᏖᏗꮧꮧᏗᏘꮨꮨᏘᏙꮩꮩᏙᏚꮪꮪᏚᏛꮫꮫᏛᏜꮬꮬᏜᏝꮭꮭᏝᏞꮮꮮᏞᏟꮯꮯᏟᏠꮰꮰᏠᏡꮱꮱᏡᏢꮲꮲᏢᏣꮳꮳᏣᏤꮴꮴᏤᏥꮵꮵᏥᏦꮶꮶᏦᏧꮷꮷᏧᏨꮸꮸᏨᏩꮹꮹᏩᏪꮺꮺᏪᏫꮻꮻᏫᏬꮼꮼᏬᏭꮽꮽᏭᏮꮾꮾᏮᏯꮿꮿᏯﬆﬅﬅﬆａＡＡａｂＢＢｂｃＣＣｃｄＤＤｄｅＥＥｅｆＦＦｆｇＧＧｇｈＨＨｈｉＩＩｉｊＪＪｊｋＫＫｋｌＬＬｌｍＭＭｍｎＮＮｎｏＯＯｏｐＰＰｐｑＱＱｑｒＲＲｒｓＳＳｓｔＴＴｔｕＵＵｕｖＶＶｖｗＷＷｗｘＸＸｘｙＹＹｙｚＺＺｚ𐐨𐐀𐐀𐐨𐐩𐐁𐐁𐐩𐐪𐐂𐐂𐐪𐐫𐐃𐐃𐐫𐐬𐐄𐐄𐐬𐐭𐐅𐐅𐐭𐐮𐐆𐐆𐐮𐐯𐐇𐐇𐐯𐐰𐐈𐐈𐐰𐐱𐐉𐐉𐐱𐐲𐐊𐐊𐐲𐐳𐐋𐐋𐐳𐐴𐐌𐐌𐐴𐐵𐐍𐐍𐐵𐐶𐐎𐐎𐐶𐐷𐐏𐐏𐐷𐐸𐐐𐐐𐐸𐐹𐐑𐐑𐐹𐐺𐐒𐐒𐐺𐐻𐐓𐐓𐐻𐐼𐐔𐐔𐐼𐐽𐐕𐐕𐐽𐐾𐐖𐐖𐐾𐐿𐐗𐐗𐐿𐑀𐐘𐐘𐑀𐑁𐐙𐐙𐑁𐑂𐐚𐐚𐑂𐑃𐐛𐐛𐑃𐑄𐐜𐐜𐑄𐑅𐐝𐐝𐑅𐑆𐐞𐐞𐑆𐑇𐐟𐐟𐑇𐑈𐐠𐐠𐑈𐑉𐐡𐐡𐑉𐑊𐐢𐐢𐑊𐑋𐐣𐐣𐑋𐑌𐐤𐐤𐑌𐑍𐐥𐐥𐑍𐑎𐐦𐐦𐑎𐑏𐐧𐐧𐑏𐓘𐒰𐒰𐓘𐓙𐒱𐒱𐓙𐓚𐒲𐒲𐓚𐓛𐒳𐒳𐓛𐓜𐒴𐒴𐓜𐓝𐒵𐒵𐓝𐓞𐒶𐒶𐓞𐓟𐒷𐒷𐓟𐓠𐒸𐒸𐓠𐓡𐒹𐒹𐓡𐓢𐒺𐒺𐓢𐓣𐒻𐒻𐓣𐓤𐒼𐒼𐓤𐓥𐒽𐒽𐓥𐓦𐒾𐒾𐓦𐓧𐒿𐒿𐓧𐓨𐓀𐓀𐓨𐓩𐓁𐓁𐓩𐓪𐓂𐓂𐓪𐓫𐓃𐓃𐓫𐓬𐓄𐓄𐓬𐓭𐓅𐓅𐓭𐓮𐓆𐓆𐓮𐓯𐓇𐓇𐓯𐓰𐓈𐓈𐓰𐓱𐓉𐓉𐓱𐓲𐓊𐓊𐓲𐓳𐓋𐓋𐓳𐓴𐓌𐓌𐓴𐓵𐓍𐓍𐓵𐓶𐓎𐓎𐓶𐓷𐓏𐓏𐓷𐓸𐓐𐓐𐓸𐓹𐓑𐓑𐓹𐓺𐓒𐓒𐓺𐓻𐓓𐓓𐓻𐖗𐕰𐕰𐖗𐖘𐕱𐕱𐖘𐖙𐕲𐕲𐖙𐖚𐕳𐕳𐖚𐖛𐕴𐕴𐖛𐖜𐕵𐕵𐖜𐖝𐕶𐕶𐖝𐖞𐕷𐕷𐖞𐖟𐕸𐕸𐖟𐖠𐕹𐕹𐖠𐖡𐕺𐕺𐖡𐖣𐕼𐕼𐖣𐖤𐕽𐕽𐖤𐖥𐕾𐕾𐖥𐖦𐕿𐕿𐖦𐖧𐖀𐖀𐖧𐖨𐖁𐖁𐖨𐖩𐖂𐖂𐖩𐖪𐖃𐖃𐖪𐖫𐖄𐖄𐖫𐖬𐖅𐖅𐖬𐖭𐖆𐖆𐖭𐖮𐖇𐖇𐖮𐖯𐖈𐖈𐖯𐖰𐖉𐖉𐖰𐖱𐖊𐖊𐖱𐖳𐖌𐖌𐖳𐖴𐖍𐖍𐖴𐖵𐖎𐖎𐖵𐖶𐖏𐖏𐖶𐖷𐖐𐖐𐖷𐖸𐖑𐖑𐖸𐖹𐖒𐖒𐖹𐖻𐖔𐖔𐖻𐖼𐖕𐖕𐖼𐳀𐲀𐲀𐳀𐳁𐲁𐲁𐳁𐳂𐲂𐲂𐳂𐳃𐲃𐲃𐳃𐳄𐲄𐲄𐳄𐳅𐲅𐲅𐳅𐳆𐲆𐲆𐳆𐳇𐲇𐲇𐳇𐳈𐲈𐲈𐳈𐳉𐲉𐲉𐳉𐳊𐲊𐲊𐳊𐳋𐲋𐲋𐳋𐳌𐲌𐲌𐳌𐳍𐲍𐲍𐳍𐳎𐲎𐲎𐳎𐳏𐲏𐲏𐳏𐳐𐲐𐲐𐳐𐳑𐲑𐲑𐳑𐳒𐲒𐲒𐳒𐳓𐲓𐲓𐳓𐳔𐲔𐲔𐳔𐳕𐲕𐲕𐳕𐳖𐲖𐲖𐳖𐳗𐲗𐲗𐳗𐳘𐲘𐲘𐳘𐳙𐲙𐲙𐳙𐳚𐲚𐲚𐳚𐳛𐲛𐲛𐳛𐳜𐲜𐲜𐳜𐳝𐲝𐲝𐳝𐳞𐲞𐲞𐳞𐳟𐲟𐲟𐳟𐳠𐲠𐲠𐳠𐳡𐲡𐲡𐳡𐳢𐲢𐲢𐳢𐳣𐲣𐲣𐳣𐳤𐲤𐲤𐳤𐳥𐲥𐲥𐳥𐳦𐲦𐲦𐳦𐳧𐲧𐲧𐳧𐳨𐲨𐲨𐳨𐳩𐲩𐲩𐳩𐳪𐲪𐲪𐳪𐳫𐲫𐲫𐳫𐳬𐲬𐲬𐳬𐳭𐲭𐲭𐳭𐳮𐲮𐲮𐳮𐳯𐲯𐲯𐳯𐳰𐲰𐲰𐳰𐳱𐲱𐲱𐳱𐳲𐲲𐲲𐳲𐵰𐵐𐵐𐵰𐵱𐵑𐵑𐵱𐵲𐵒𐵒𐵲𐵳𐵓𐵓𐵳𐵴𐵔𐵔𐵴𐵵𐵕𐵕𐵵𐵶𐵖𐵖𐵶𐵷𐵗𐵗𐵷𐵸𐵘𐵘𐵸𐵹𐵙𐵙𐵹𐵺𐵚𐵚𐵺𐵻𐵛𐵛𐵻𐵼𐵜𐵜𐵼𐵽𐵝𐵝𐵽𐵾𐵞𐵞𐵾𐵿𐵟𐵟𐵿𐶀𐵠𐵠𐶀𐶁𐵡𐵡𐶁𐶂𐵢𐵢𐶂𐶃𐵣𐵣𐶃𐶄𐵤𐵤𐶄𐶅𐵥𐵥𐶅𑣀𑢠𑢠𑣀𑣁𑢡𑢡𑣁𑣂𑢢𑢢𑣂𑣃𑢣𑢣𑣃𑣄𑢤𑢤𑣄𑣅𑢥𑢥𑣅𑣆𑢦𑢦𑣆𑣇𑢧𑢧𑣇𑣈𑢨𑢨𑣈𑣉𑢩𑢩𑣉𑣊𑢪𑢪𑣊𑣋𑢫𑢫𑣋𑣌𑢬𑢬𑣌𑣍𑢭𑢭𑣍𑣎𑢮𑢮𑣎𑣏𑢯𑢯𑣏𑣐𑢰𑢰𑣐𑣑𑢱𑢱𑣑𑣒𑢲𑢲𑣒𑣓𑢳𑢳𑣓𑣔𑢴𑢴𑣔𑣕𑢵𑢵𑣕𑣖𑢶𑢶𑣖𑣗𑢷𑢷𑣗𑣘𑢸𑢸𑣘𑣙𑢹𑢹𑣙𑣚𑢺𑢺𑣚𑣛𑢻𑢻𑣛𑣜𑢼𑢼𑣜𑣝𑢽𑢽𑣝𑣞𑢾𑢾𑣞𑣟𑢿𑢿𑣟𖹠𖹀𖹀𖹠𖹡𖹁𖹁𖹡𖹢𖹂𖹂𖹢𖹣𖹃𖹃𖹣𖹤𖹄𖹄𖹤𖹥𖹅𖹅𖹥𖹦𖹆𖹆𖹦𖹧𖹇𖹇𖹧𖹨𖹈𖹈𖹨𖹩𖹉𖹉𖹩𖹪𖹊𖹊𖹪𖹫𖹋𖹋𖹫𖹬𖹌𖹌𖹬𖹭𖹍𖹍𖹭𖹮𖹎𖹎𖹮𖹯𖹏𖹏𖹯𖹰𖹐𖹐𖹰𖹱𖹑𖹑𖹱𖹲𖹒𖹒𖹲𖹳𖹓𖹓𖹳𖹴𖹔𖹔𖹴𖹵𖹕𖹕𖹵𖹶𖹖𖹖𖹶𖹷𖹗𖹗𖹷𖹸𖹘𖹘𖹸𖹹𖹙𖹙𖹹𖹺𖹚𖹚𖹺𖹻𖹛𖹛𖹻𖹼𖹜𖹜𖹼𖹽𖹝𖹝𖹽𖹾𖹞𖹞𖹾𖹿𖹟𖹟𖹿𞤢𞤀𞤀𞤢𞤣𞤁𞤁𞤣𞤤𞤂𞤂𞤤𞤥𞤃𞤃𞤥𞤦𞤄𞤄𞤦𞤧𞤅𞤅𞤧𞤨𞤆𞤆𞤨𞤩𞤇𞤇𞤩𞤪𞤈𞤈𞤪𞤫𞤉𞤉𞤫𞤬𞤊𞤊𞤬𞤭𞤋𞤋𞤭𞤮𞤌𞤌𞤮𞤯𞤍𞤍𞤯𞤰𞤎𞤎𞤰𞤱𞤏𞤏𞤱𞤲𞤐𞤐𞤲𞤳𞤑𞤑𞤳𞤴𞤒𞤒𞤴𞤵𞤓𞤓𞤵𞤶𞤔𞤔𞤶𞤷𞤕𞤕𞤷𞤸𞤖𞤖𞤸𞤹𞤗𞤗𞤹𞤺𞤘𞤘𞤺𞤻𞤙𞤙𞤻𞤼𞤚𞤚𞤼𞤽𞤛𞤛𞤽𞤾𞤜𞤜𞤾𞤿𞤝𞤝𞤿𞥀𞤞𞤞𞥀𞥁𞤟𞤟𞥁𞥂𞤠𞤠𞥂𞥃𞤡𞤡𞥃";
const huangxl$md2mind$$parse_headings$46$42$bind$124$174 = "\n";
const huangxl$md2mind$$make_indent$46$42$bind$124$177 = "";
const huangxl$md2mind$$render_ascii_mindmap$46$42$bind$124$184 = "\n";
const huangxl$md2mind$$json_string$46$42$bind$124$189 = "\\";
const huangxl$md2mind$$json_string$46$42$bind$124$190 = "\\\\";
const huangxl$md2mind$$json_string$46$42$bind$124$187 = "\"";
const huangxl$md2mind$$json_string$46$42$bind$124$188 = "\\\"";
const huangxl$md2mind$$json_string$46$42$bind$124$185 = "\n";
const huangxl$md2mind$$json_string$46$42$bind$124$186 = "\\n";
const huangxl$md2mind$$children_json$46$42$bind$124$207 = ",";
const huangxl$md2mind$$render_roots_json$46$42$bind$124$218 = ",";
const huangxl$md2mind$$repeat_hashes$46$42$bind$124$227 = "";
const huangxl$md2mind$$render_markdown$46$42$bind$124$234 = "\n";
const moonbitlang$core$builtin$$seed = moonbitlang$core$builtin$$random_seed();
const map = moonbitlang$core$builtin$$Map$new$46$inner$0$(3000);
const _bind = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96.length;
let _tmp = 0;
while (true) {
  const _param_start = _tmp;
  if (moonbitlang$core$string$$String$char_length_ge$46$inner(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, 2, _param_start, _bind)) {
    const _ch1 = moonbitlang$core$string$$String$unsafe_char_at(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, 0, _param_start, _bind));
    const _ch2 = moonbitlang$core$string$$String$unsafe_char_at(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, 1, _param_start, _bind));
    const _bind$2 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, 2, _param_start, _bind);
    let _bind$3;
    if (_bind$2 === undefined) {
      _bind$3 = _bind;
    } else {
      const _Some = _bind$2;
      _bind$3 = _Some;
    }
    moonbitlang$core$builtin$$Map$set$0$(map, _ch1, _ch2);
    _tmp = _bind$3;
    continue;
  } else {
    if (moonbitlang$core$string$$String$char_length_eq$46$inner(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding$46$42$bind$124$96, 1, _param_start, _bind)) {
      $panic();
      break;
    } else {
      break;
    }
  }
}
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding = map;
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises = moonbitlang$core$builtin$$Map$from_array$1$([moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1462, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1463, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1464, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1465, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1466, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1467, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1468, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1469, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1470, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1471, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1472, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1473, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1474, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1475, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1476, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1477, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1478, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1479, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1480, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1481, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1482, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1483, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1484, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1485, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1486, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1487, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1488, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1489, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1490, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1491, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1492, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1493, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1494, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1495, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1496, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1497, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1498, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1499, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1500, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1501, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1502, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1503, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1504, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1505, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1506, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1507, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1508, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1509, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1510, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1511, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1512, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1513, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1514, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1515, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1516, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1517, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1518, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1519, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1520, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1521, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1522, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1523, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1524, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1525, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1526, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1527, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1528, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1529, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1530, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1531, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1532, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1533, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1534, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1535, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1536, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1537, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1538, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1539, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1540, moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises$46$tuple$47$1541]);
const moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_ranges = moonbitlang$core$builtin$$Map$from_array$2$([{ _0: "LC", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("AZazµµÀÖØöøƺƼƿǄʓʕʯͰͳͶͷͻͽͿͿΆΆΈΊΌΌΎΡΣϵϷҁҊԯԱՖՠֈႠჅჇჇჍჍაჺჽჿᎠᏵᏸᏽᲀᲊᲐᲺᲽᲿᴀᴫᵫᵷᵹᶚḀἕἘἝἠὅὈὍὐὗὙὙὛὛὝὝὟώᾀᾴᾶᾼιιῂῄῆῌῐΐῖΊῠῬῲῴῶῼℂℂℇℇℊℓℕℕℙℝℤℤΩΩℨℨKℭℯℴℹℹℼℿⅅⅉⅎⅎↃↄⰀⱻⱾⳤⳫⳮⳲⳳⴀⴥⴧⴧⴭⴭꙀꙭꚀꚛꜢꝯꝱꞇꞋꞎꞐꟍꟐꟑꟓꟓꟕꟜꟵꟶꟺꟺꬰꭚꭠꭨꭰꮿﬀﬆﬓﬗＡＺａｚ𐐀𐑏𐒰𐓓𐓘𐓻𐕰𐕺𐕼𐖊𐖌𐖒𐖔𐖕𐖗𐖡𐖣𐖱𐖳𐖹𐖻𐖼𐲀𐲲𐳀𐳲𐵐𐵥𐵰𐶅𑢠𑣟𖹀𖹿𝐀𝑔𝑖𝒜𝒞𝒟𝒢𝒢𝒥𝒦𝒩𝒬𝒮𝒹𝒻𝒻𝒽𝓃𝓅𝔅𝔇𝔊𝔍𝔔𝔖𝔜𝔞𝔹𝔻𝔾𝕀𝕄𝕆𝕆𝕊𝕐𝕒𝚥𝚨𝛀𝛂𝛚𝛜𝛺𝛼𝜔𝜖𝜴𝜶𝝎𝝐𝝮𝝰𝞈𝞊𝞨𝞪𝟂𝟄𝟋𝼀𝼉𝼋𝼞𝼥𝼪𞤀𞥃")) }, { _0: "L", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("AZazªªµµººÀÖØöøˁˆˑˠˤˬˬˮˮͰʹͶͷͺͽͿͿΆΆΈΊΌΌΎΡΣϵϷҁҊԯԱՖՙՙՠֈאתׯײؠيٮٯٱۓەەۥۦۮۯۺۼۿۿܐܐܒܯݍޥޱޱߊߪߴߵߺߺࠀࠕࠚࠚࠤࠤࠨࠨࡀࡘࡠࡪࡰࢇࢉࢎࢠࣉऄहऽऽॐॐक़ॡॱঀঅঌএঐওনপরললশহঽঽৎৎড়ঢ়য়ৡৰৱৼৼਅਊਏਐਓਨਪਰਲਲ਼ਵਸ਼ਸਹਖ਼ੜਫ਼ਫ਼ੲੴઅઍએઑઓનપરલળવહઽઽૐૐૠૡૹૹଅଌଏଐଓନପରଲଳଵହଽଽଡ଼ଢ଼ୟୡୱୱஃஃஅஊஎஐஒகஙசஜஜஞடணதநபமஹௐௐఅఌఎఐఒనపహఽఽౘౚౝౝౠౡಀಀಅಌಎಐಒನಪಳವಹಽಽೝೞೠೡೱೲഄഌഎഐഒഺഽഽൎൎൔൖൟൡൺൿඅඖකනඳරලලවෆกะาำเๆກຂຄຄຆຊຌຣລລວະາຳຽຽເໄໆໆໜໟༀༀཀཇཉཬྈྌကဪဿဿၐၕၚၝၡၡၥၦၮၰၵႁႎႎႠჅჇჇჍჍაჺჼቈቊቍቐቖቘቘቚቝበኈኊኍነኰኲኵኸኾዀዀዂዅወዖዘጐጒጕጘፚᎀᎏᎠᏵᏸᏽᐁᙬᙯᙿᚁᚚᚠᛪᛱᛸᜀᜑᜟᜱᝀᝑᝠᝬᝮᝰកឳៗៗៜៜᠠᡸᢀᢄᢇᢨᢪᢪᢰᣵᤀᤞᥐᥭᥰᥴᦀᦫᦰᧉᨀᨖᨠᩔᪧᪧᬅᬳᭅᭌᮃᮠᮮᮯᮺᯥᰀᰣᱍᱏᱚᱽᲀᲊᲐᲺᲽᲿᳩᳬᳮᳳᳵᳶᳺᳺᴀᶿḀἕἘἝἠὅὈὍὐὗὙὙὛὛὝὝὟώᾀᾴᾶᾼιιῂῄῆῌῐΐῖΊῠῬῲῴῶῼⁱⁱⁿⁿₐₜℂℂℇℇℊℓℕℕℙℝℤℤΩΩℨℨKℭℯℹℼℿⅅⅉⅎⅎↃↄⰀⳤⳫⳮⳲⳳⴀⴥⴧⴧⴭⴭⴰⵧⵯⵯⶀⶖⶠⶦⶨⶮⶰⶶⶸⶾⷀⷆⷈⷎⷐⷖⷘⷞⸯⸯ々〆〱〵〻〼ぁゖゝゟァヺーヿㄅㄯㄱㆎㆠㆿㇰㇿ㐀䶿一ꒌꓐꓽꔀꘌꘐꘟꘪꘫꙀꙮꙿꚝꚠꛥꜗꜟꜢꞈꞋꟍꟐꟑꟓꟓꟕꟜꟲꠁꠃꠅꠇꠊꠌꠢꡀꡳꢂꢳꣲꣷꣻꣻꣽꣾꤊꤥꤰꥆꥠꥼꦄꦲꧏꧏꧠꧤꧦꧯꧺꧾꨀꨨꩀꩂꩄꩋꩠꩶꩺꩺꩾꪯꪱꪱꪵꪶꪹꪽꫀꫀꫂꫂꫛꫝꫠꫪꫲꫴꬁꬆꬉꬎꬑꬖꬠꬦꬨꬮꬰꭚꭜꭩꭰꯢ가힣ힰퟆퟋퟻ豈舘並龎ﬀﬆﬓﬗיִיִײַﬨשׁזּטּלּמּמּנּסּףּפּצּﮱﯓﴽﵐﶏﶒﷇﷰﷻﹰﹴﹶﻼＡＺａｚｦﾾￂￇￊￏￒￗￚￜ𐀀𐀋𐀍𐀦𐀨𐀺𐀼𐀽𐀿𐁍𐁐𐁝𐂀𐃺𐊀𐊜𐊠𐋐𐌀𐌟𐌭𐍀𐍂𐍉𐍐𐍵𐎀𐎝𐎠𐏃𐏈𐏏𐐀𐒝𐒰𐓓𐓘𐓻𐔀𐔧𐔰𐕣𐕰𐕺𐕼𐖊𐖌𐖒𐖔𐖕𐖗𐖡𐖣𐖱𐖳𐖹𐖻𐖼𐗀𐗳𐘀𐜶𐝀𐝕𐝠𐝧𐞀𐞅𐞇𐞰𐞲𐞺𐠀𐠅𐠈𐠈𐠊𐠵𐠷𐠸𐠼𐠼𐠿𐡕𐡠𐡶𐢀𐢞𐣠𐣲𐣴𐣵𐤀𐤕𐤠𐤹𐦀𐦷𐦾𐦿𐨀𐨀𐨐𐨓𐨕𐨗𐨙𐨵𐩠𐩼𐪀𐪜𐫀𐫇𐫉𐫤𐬀𐬵𐭀𐭕𐭠𐭲𐮀𐮑𐰀𐱈𐲀𐲲𐳀𐳲𐴀𐴣𐵊𐵥𐵯𐶅𐺀𐺩𐺰𐺱𐻂𐻄𐼀𐼜𐼧𐼧𐼰𐽅𐽰𐾁𐾰𐿄𐿠𐿶𑀃𑀷𑁱𑁲𑁵𑁵𑂃𑂯𑃐𑃨𑄃𑄦𑅄𑅄𑅇𑅇𑅐𑅲𑅶𑅶𑆃𑆲𑇁𑇄𑇚𑇚𑇜𑇜𑈀𑈑𑈓𑈫𑈿𑉀𑊀𑊆𑊈𑊈𑊊𑊍𑊏𑊝𑊟𑊨𑊰𑋞𑌅𑌌𑌏𑌐𑌓𑌨𑌪𑌰𑌲𑌳𑌵𑌹𑌽𑌽𑍐𑍐𑍝𑍡𑎀𑎉𑎋𑎋𑎎𑎎𑎐𑎵𑎷𑎷𑏑𑏑𑏓𑏓𑐀𑐴𑑇𑑊𑑟𑑡𑒀𑒯𑓄𑓅𑓇𑓇𑖀𑖮𑗘𑗛𑘀𑘯𑙄𑙄𑚀𑚪𑚸𑚸𑜀𑜚𑝀𑝆𑠀𑠫𑢠𑣟𑣿𑤆𑤉𑤉𑤌𑤓𑤕𑤖𑤘𑤯𑤿𑤿𑥁𑥁𑦠𑦧𑦪𑧐𑧡𑧡𑧣𑧣𑨀𑨀𑨋𑨲𑨺𑨺𑩐𑩐𑩜𑪉𑪝𑪝𑪰𑫸𑯀𑯠𑰀𑰈𑰊𑰮𑱀𑱀𑱲𑲏𑴀𑴆𑴈𑴉𑴋𑴰𑵆𑵆𑵠𑵥𑵧𑵨𑵪𑶉𑶘𑶘𑻠𑻲𑼂𑼂𑼄𑼐𑼒𑼳𑾰𑾰𒀀𒎙𒒀𒕃𒾐𒿰𓀀𓐯𓑁𓑆𓑠𔏺𔐀𔙆𖄀𖄝𖠀𖨸𖩀𖩞𖩰𖪾𖫐𖫭𖬀𖬯𖭀𖭃𖭣𖭷𖭽𖮏𖵀𖵬𖹀𖹿𖼀𖽊𖽐𖽐𖾓𖾟𖿠𖿡𖿣𖿣𗀀𘟷𘠀𘳕𘳿𘴈𚿰𚿳𚿵𚿻𚿽𚿾𛀀𛄢𛄲𛄲𛅐𛅒𛅕𛅕𛅤𛅧𛅰𛋻𛰀𛱪𛱰𛱼𛲀𛲈𛲐𛲙𝐀𝑔𝑖𝒜𝒞𝒟𝒢𝒢𝒥𝒦𝒩𝒬𝒮𝒹𝒻𝒻𝒽𝓃𝓅𝔅𝔇𝔊𝔍𝔔𝔖𝔜𝔞𝔹𝔻𝔾𝕀𝕄𝕆𝕆𝕊𝕐𝕒𝚥𝚨𝛀𝛂𝛚𝛜𝛺𝛼𝜔𝜖𝜴𝜶𝝎𝝐𝝮𝝰𝞈𝞊𝞨𝞪𝟂𝟄𝟋𝼀𝼞𝼥𝼪𞀰𞁭𞄀𞄬𞄷𞄽𞅎𞅎𞊐𞊭𞋀𞋫𞓐𞓫𞗐𞗭𞗰𞗰𞟠𞟦𞟨𞟫𞟭𞟮𞟰𞟾𞠀𞣄𞤀𞥃𞥋𞥋𞸀𞸃𞸅𞸟𞸡𞸢𞸤𞸤𞸧𞸧𞸩𞸲𞸴𞸷𞸹𞸹𞸻𞸻𞹂𞹂𞹇𞹇𞹉𞹉𞹋𞹋𞹍𞹏𞹑𞹒𞹔𞹔𞹗𞹗𞹙𞹙𞹛𞹛𞹝𞹝𞹟𞹟𞹡𞹢𞹤𞹤𞹧𞹪𞹬𞹲𞹴𞹷𞹹𞹼𞹾𞹾𞺀𞺉𞺋𞺛𞺡𞺣𞺥𞺩𞺫𞺻𠀀𪛟𪜀𫜹𫝀𫠝𫠠𬺡𬺰𮯠𮯰𮹝丽𪘀𰀀𱍊𱍐𲎯")) }, { _0: "M", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("̀ͯ҃҉ׇׇֽֿֿׁׂًؚٰٰܑܑ֑ׅٟ۪ۭׄؐۖۜ۟ۤۧۨܰ݊ަް߽߽࡙࡛ࣣ߫߳ࠖ࠙ࠛࠣࠥࠧࠩ࠭ࢗ࢟࣊࣡ःऺ़ाॏ॑ॗॢॣঁঃ়়াৄেৈো্ৗৗৢৣ৾৾ਁਃ਼਼ਾੂੇੈੋ੍ੑੑੰੱੵੵઁઃ઼઼ાૅેૉો્ૢૣૺ૿ଁଃ଼଼ାୄେୈୋ୍୕ୗୢୣஂஂாூெைொ்ௗௗఀఄ఼఼ాౄెైొ్ౕౖౢౣಁಃ಼಼ಾೄೆೈೊ್ೕೖೢೣೳೳഀഃ഻഼ാൄെൈൊ്ൗൗൢൣඁඃ්්ාුූූෘෟෲෳััิฺ็๎ັັິຼ່໎༹༹༘༙༵༵༷༷༾༿྄ཱ྆྇ྍྗྙྼ࿆࿆ါှၖၙၞၠၢၤၧၭၱၴႂႍႏႏႚႝ፝፟ᜒ᜕ᜲ᜴ᝒᝓᝲᝳ឴៓៝៝᠋᠍᠏᠏ᢅᢆᢩᢩᤠᤫᤰ᤻ᨗᨛᩕᩞ᩠᩿᩿᩼᪰ᫎᬀᬄ᬴᭄᭫᭳ᮀᮂᮡᮭ᯦᯳ᰤ᳔᳨᰷᳭᳭᳐᳒᳴᳴᳷゙゚⵿⵿〪᷿〯᳹᷀⃐⃰⳯⳱ⷠⷿ꙯꙲ꙴ꙽ꚞꚟ꛰꛱ꠂꠂ꠆꠆ꠋꠋꠣꠧ꠬꠬ꢀꢁꢴꣅ꣠꣱ꣿꣿꤦ꤭ꥇ꥓ꦀꦃ꦳꧀ꧥꧥꨩꨶꩃꩃꩌꩍꩻꩽꪴꪰꪰꪲꪷꪸꪾ꪿꫁꫁ꫫꫯꫵ꫶ꯣꯪ꯬꯭ﬞﬞ︀️𐇽𐇽𐋠𐋠︠︯𐍶𐍺𐨁𐨃𐨅𐨆𐨌𐨿𐨿𐨺𐫦𐨏𐨸𐫥𐴤𐴧𐵩𐵭𐺫𐺬𐻼𐻿𐽆𐽐𐾅𐾂𑀀𑀂𑀸𑁆𑁰𑁰𑁳𑁴𑁿𑂂𑂰𑂺𑃂𑃂𑄀𑄂𑄧𑄴𑅅𑅆𑅳𑅳𑆀𑆂𑆳𑇀𑇉𑇌𑇎𑇏𑈬𑈷𑈾𑈾𑉁𑉁𑋟𑋪𑌀𑌃𑌻𑌼𑌾𑍄𑍇𑍈𑍋𑍍𑍗𑍗𑍢𑍣𑍦𑍬𑍰𑍴𑎸𑏀𑏅𑏅𑏅𑏇𑏊𑏌𑏐𑏒𑏒𑏡𑏢𑐵𑑆𑑞𑑞𑒰𑓃𑖯𑖵𑖸𑗀𑗜𑗝𑘰𑙀𑚫𑚷𑜝𑜫𑠬𑠺𑤰𑤵𑤷𑤸𑤻𑤾𑥀𑥀𑥂𑥃𑧑𑧗𑧚𑧠𑧤𑧤𑨁𑨊𑨳𑨹𑨻𑨾𑩇𑩇𑩑𑩛𑪊𑪙𑰯𑰶𑰸𑰿𑲒𑲧𑲩𑲶𑴱𑴶𑴺𑴺𑴼𑴽𑴿𑵅𑵇𑵇𑶊𑶎𑶐𑶑𑶓𑶗𑻳𑻶𑼀𑼁𑼃𑼃𑼴𑼺𑼾𑽂𑽚𑽚𓑀𓑀𓑇𓑕𖄞𖫰𖫴𖄯𖬰𖬶𖽏𖽏𖽑𖾇𖾏𖾒𖿤𖿤𖿰𖿱𛲝𛲞𜼀𜼭𜼰𜽆𝅩𝅥𝅲𝅻𝆂𝆋𝅭𝆅𝆪𝆭𝉂𝉄𝨀𝨶𝨻𝩬𝩵𝩵𝪄𝪄𝪛𝪟𝪡𝪯𞥊𞗯𞣐𞣖𞀀𞀆𞀈𞀘𞀛𞀡𞀣𞀤𞀦𞀪𞂏𞂏𞄰𞄶𞊮𞊮𞋬𞋯𞓯𞗮𞥄𞓬󠄀󠇯")) }, { _0: "N", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("09²³¹¹¼¾٠٩۰۹߀߉०९০৯৴৹੦੯૦૯୦୯୲୷௦௲౦౯౸౾೦೯൘൞൦൸෦෯๐๙໐໙༠༳၀၉႐႙፩፼ᛮᛰ០៩៰៹᠐᠙᥆᥏᧐᧚᪀᪉᪐᪙᭐᭙᮰᮹᱀᱉᱐᱙⁰⁰⁴⁹₀₉⅐ↂↅ↉①⒛⓪⓿❶➓⳽⳽〇〇〡〩〸〺㆒㆕㈠㈩㉈㉏㉑㉟㊀㊉㊱㊿꘠꘩ꛦꛯ꠰꠵꣐꣙꤀꤉꧐꧙꧰꧹꩐꩙꯰꯹０９𐄇𐄳𐅀𐅸𐆊𐆋𐋡𐋻𐌠𐌣𐍁𐍁𐍊𐍊𐏑𐏕𐒠𐒩𐡘𐡟𐡹𐡿𐢧𐢯𐣻𐣿𐤖𐤛𐦼𐦽𐧀𐧏𐧒𐧿𐩀𐩈𐩽𐩾𐪝𐪟𐫫𐫯𐭘𐭟𐭸𐭿𐮩𐮯𐳺𐳿𐴰𐴹𐵀𐵉𐹠𐹾𐼝𐼦𐽑𐽔𐿅𐿋𑁒𑁯𑃰𑃹𑄶𑄿𑇐𑇙𑇡𑇴𑋰𑋹𑑐𑑙𑓐𑓙𑙐𑙙𑛀𑛉𑛐𑛣𑜰𑜻𑣠𑣲𑥐𑥙𑯰𑯹𑱐𑱬𑵐𑵙𑶠𑶩𑽐𑽙𑿀𑿔𒐀𒑮𖄰𖄹𖩠𖩩𖫀𖫉𖭐𖭙𖭛𖭡𖵰𖵹𖺀𖺖𜳰𜳹𝋀𝋓𝋠𝋳𝍠𝍸𝟎𝟿𞅀𞅉𞋰𞋹𞓰𞓹𞗱𞗺𞣇𞣏𞥐𞥙𞱱𞲫𞲭𞲯𞲱𞲴𞴁𞴭𞴯𞴽🄀🄌🯰🯹")) }, { _0: "P", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("!#%*,/:;?@[]__{{}}¡¡§§««¶·»»¿¿;;··՚՟։֊־־׀׀׃׃׆׆׳״؉؊،؍؛؛؝؟٪٭۔۔܀܍߷߹࠰࠾࡞࡞।॥॰॰৽৽੶੶૰૰౷౷಄಄෴෴๏๏๚๛༄༒༔༔༺༽྅྅࿐࿔࿙࿚၊၏჻჻፠፨᐀᐀᙮᙮᚛᚜᛫᛭᜵᜶។៖៘៚᠀᠊᥄᥅᨞᨟᪠᪦᪨᪭᭎᭏᭚᭠᭽᭿᯼᯿᰻᰿᱾᱿᳀᳇᳓᳓‐‧‰⁃⁅⁑⁓⁞⁽⁾₍₎⌈⌋〈〉❨❵⟅⟆⟦⟯⦃⦘⧘⧛⧼⧽⳹⳼⳾⳿⵰⵰⸀⸮⸰⹏⹒⹝、〃〈】〔〟〰〰〽〽゠゠・・꓾꓿꘍꘏꙳꙳꙾꙾꛲꛷꡴꡷꣎꣏꣸꣺꣼꣼꤮꤯꥟꥟꧁꧍꧞꧟꩜꩟꫞꫟꫰꫱꯫꯫﴾﴿︐︙︰﹒﹔﹡﹣﹣﹨﹨﹪﹫！＃％＊，／：；？＠［］＿＿｛｛｝｝｟･𐄀𐄂𐎟𐎟𐏐𐏐𐕯𐕯𐡗𐡗𐤟𐤟𐤿𐤿𐩐𐩘𐩿𐩿𐫰𐫶𐬹𐬿𐮙𐮜𐵮𐵮𐺭𐺭𐽕𐽙𐾆𐾉𑁇𑁍𑂻𑂼𑂾𑃁𑅀𑅃𑅴𑅵𑇅𑇈𑇍𑇍𑇛𑇛𑇝𑇟𑈸𑈽𑊩𑊩𑏔𑏕𑏗𑏘𑑋𑑏𑑚𑑛𑑝𑑝𑓆𑓆𑗁𑗗𑙁𑙃𑙠𑙬𑚹𑚹𑜼𑜾𑠻𑠻𑥄𑥆𑧢𑧢𑨿𑩆𑪚𑪜𑪞𑪢𑬀𑬉𑯡𑯡𑱁𑱅𑱰𑱱𑻷𑻸𑽃𑽏𑿿𑿿𒑰𒑴𒿱𒿲𖩮𖩯𖫵𖫵𖬷𖬻𖭄𖭄𖵭𖵯𖺗𖺚𖿢𖿢𛲟𛲟𝪇𝪋𞗿𞗿𞥞𞥟")) }, { _0: "S", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("$$++<>^^``||~~¢¦¨©¬¬®±´´¸¸××÷÷˂˅˒˟˥˫˭˭˯˿͵͵΄΅϶϶҂҂֍֏؆؈؋؋؎؏۞۞۩۩۽۾߶߶߾߿࢈࢈৲৳৺৻૱૱୰୰௳௺౿౿൏൏൹൹฿฿༁༃༓༓༕༗༚༟༴༴༶༶༸༸྾࿅࿇࿌࿎࿏࿕࿘႞႟᎐᎙᙭᙭៛៛᥀᥀᧞᧿᭡᭪᭴᭼᾽᾽᾿῁῍῏῝῟῭`´῾⁄⁄⁒⁒⁺⁼₊₌₠⃀℀℁℃℆℈℉℔℔№℘℞℣℥℥℧℧℩℩℮℮℺℻⅀⅄⅊⅍⅏⅏↊↋←⌇⌌⌨⌫␩⑀⑊⒜ⓩ─❧➔⟄⟇⟥⟰⦂⦙⧗⧜⧻⧾⭳⭶⮕⮗⯿⳥⳪⹐⹑⺀⺙⺛⻳⼀⿕⿰⿿〄〄〒〓〠〠〶〷〾〿゛゜㆐㆑㆖㆟㇀㇥㇯㇯㈀㈞㈪㉇㉐㉐㉠㉿㊊㊰㋀㏿䷀䷿꒐꓆꜀꜖꜠꜡꞉꞊꠨꠫꠶꠹꩷꩹꭛꭛꭪꭫﬩﬩﮲﯂﵀﵏﷏﷏﷼﷿﹢﹢﹤﹦﹩﹩＄＄＋＋＜＞＾＾｀｀｜｜～～￠￦￨￮￼�𐄷𐄿𐅹𐆉𐆌𐆎𐆐𐆜𐆠𐆠𐇐𐇼𐡷𐡸𐫈𐫈𐶎𐶏𑜿𑜿𑿕𑿱𖬼𖬿𖭅𖭅𛲜𛲜𜰀𜳯𜴀𜺳𜽐𜿃𝀀𝃵𝄀𝄦𝄩𝅘𝅥𝅲𝅪𝅬𝆃𝆄𝆌𝆩𝆮𝇪𝈀𝉁𝉅𝉅𝌀𝍖𝛁𝛁𝛛𝛛𝛻𝛻𝜕𝜕𝜵𝜵𝝏𝝏𝝯𝝯𝞉𝞉𝞩𝞩𝟃𝟃𝠀𝧿𝨷𝨺𝩭𝩴𝩶𝪃𝪅𝪆𞅏𞅏𞋿𞋿𞲬𞲬𞲰𞲰𞴮𞴮𞻰𞻱🀀🀫🀰🂓🂠🂮🂱🂿🃁🃏🃑🃵🄍🆭🇦🈂🈐🈻🉀🉈🉐🉑🉠🉥🌀🛗🛜🛬🛰🛼🜀🝶🝻🟙🟠🟫🟰🟰🠀🠋🠐🡇🡐🡙🡠🢇🢐🢭🢰🢻🣀🣁🤀🩓🩠🩭🩰🩼🪀🪉🪏🫆🫎🫜🫟🫩🫰🫸🬀🮒🮔🯯")) }, { _0: "Z", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("              　　")) }, { _0: "C", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("\u0000\u001f\u007f­؅؜؜۝࢖࣢࣢᠎᠎​‏‪‮⁠￻𑂽𑃏𓐰𓐿𛲠𜯿𝅳􏿽")) }, { _0: "Cn", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("͸͹΀΃΋΋΍΍΢΢԰԰՗՘֋֌֐֐׈׏׫׮׵׿܎܎݋݌޲޿߻߼࠮࠯࠿࠿࡜࡝࡟࡟࡫࡯࢏࢏࢒࢖঄঄঍঎঑঒঩঩঱঱঳঵঺঻৅৆৉৊৏৖৘৛৞৞৤৥৿਀਄਄਋਎਑਒਩਩਱਱਴਴਷਷਺਻਽਽੃੆੉੊੎੐੒੘੝੝੟੥੷઀઄઄઎઎઒઒઩઩઱઱઴઴઺઻૆૆૊૊૎૏૑૟૤૥૲૸଀଀଄଄଍଎଑଒଩଩଱଱଴଴଺଻୅୆୉୊୎୔୘୛୞୞୤୥୸஁஄஄஋஍஑஑஖஘஛஛஝஝஠஢஥஧஫஭஺஽௃௅௉௉௎௏௑௖௘௥௻௿఍఍఑఑఩఩఺఻౅౅౉౉౎౔౗౗౛౜౞౟౤౥౰౶಍಍಑಑಩಩಴಴಺಻೅೅೉೉೎೔೗೜೟೟೤೥೰೰೴೿഍഍഑഑൅൅൉൉൐൓൤൥඀඀඄඄඗඙඲඲඼඼඾඿෇෉෋෎෕෕෗෗෠෥෰෱෵฀฻฾๜຀຃຃຅຅຋຋຤຤຦຦຾຿໅໅໇໇໏໏໚໛໠໿཈཈཭཰྘྘྽྽࿍࿍࿛࿿჆჆჈჌჎჏቉቉቎቏቗቗቙቙቞቟኉኉኎኏኱኱኶኷኿኿዁዁዆዇዗዗጑጑጖጗፛፜፽፿᎚᎟᏶᏷᏾᏿᚝᚟᛹᛿᜖᜞᜷᜿᝔᝟᝭᝭᝱᝱᝴᝿៞៟៪៯៺៿᠚᠟᡹᡿᢫᢯᣶᣿᤟᤟᤬᤯᤼᤿᥁᥃᥮᥯᥵᥿᦬᦯᧊᧏᧛᧝᨜᨝᩟᩟᩽᩾᪊᪏᪚᪟᪮᪯᫏᫿᭍᭍᯴᯻᰸᰺᱊᱌᲋᲏᲻᲼᳈᳏᳻᳿἖἗἞἟὆὇὎὏὘὘὚὚὜὜὞὞὾὿᾵᾵῅῅῔῕῜῜῰῱῵῵῿῿⁥⁥⁲⁳₏₏₝₟⃁⃏⃱⃿↌↏␪␿⑋⑟⭴⭵⮖⮖⳴⳸⴦⴦⴨⴬⴮⴯⵨⵮⵱⵾⶗⶟⶧⶧⶯⶯⶷⶷⶿⶿⷇⷇⷏⷏⷗⷗⷟⷟⹞⹿⺚⺚⻴⻿⿖⿯぀぀゗゘㄀㄄㄰㄰㆏㆏㇦㇮㈟㈟꒍꒏꓇꓏꘬꘿꛸꛿꟎꟏꟒꟒꟔꟔꟝꟱꠭꠯꠺꠿꡸꡿꣆꣍꣚꣟꥔꥞꥽꥿꧎꧎꧚꧝꧿꧿꨷꨿꩎꩏꩚꩛꫃꫚꫷꬀꬇꬈꬏꬐꬗꬟꬧꬧꬯꬯꭬꭯꯮꯯꯺꯿힤힯퟇퟊퟼퟿﩮﩯﫚﫿﬇﬒﬘﬜﬷﬷﬽﬽﬿﬿﭂﭂﭅﭅﯃﯒﶐﶑﷈﷎﷐﷯︚︟﹓﹓﹧﹧﹬﹯﹵﹵﻽﻾＀＀﾿￁￈￉￐￑￘￙￝￟￧￧￯￸￾￿𐀌𐀌𐀧𐀧𐀻𐀻𐀾𐀾𐁎𐁏𐁞𐁿𐃻𐃿𐄃𐄆𐄴𐄶𐆏𐆏𐆝𐆟𐆡𐇏𐇾𐉿𐊝𐊟𐋑𐋟𐋼𐋿𐌤𐌬𐍋𐍏𐍻𐍿𐎞𐎞𐏄𐏇𐏖𐏿𐒞𐒟𐒪𐒯𐓔𐓗𐓼𐓿𐔨𐔯𐕤𐕮𐕻𐕻𐖋𐖋𐖓𐖓𐖖𐖖𐖢𐖢𐖲𐖲𐖺𐖺𐖽𐖿𐗴𐗿𐜷𐜿𐝖𐝟𐝨𐝿𐞆𐞆𐞱𐞱𐞻𐟿𐠆𐠇𐠉𐠉𐠶𐠶𐠹𐠻𐠽𐠾𐡖𐡖𐢟𐢦𐢰𐣟𐣳𐣳𐣶𐣺𐤜𐤞𐤺𐤾𐥀𐥿𐦸𐦻𐧐𐧑𐨄𐨄𐨇𐨋𐨔𐨔𐨘𐨘𐨶𐨷𐨻𐨾𐩉𐩏𐩙𐩟𐪠𐪿𐫧𐫪𐫷𐫿𐬶𐬸𐭖𐭗𐭳𐭷𐮒𐮘𐮝𐮨𐮰𐯿𐱉𐱿𐲳𐲿𐳳𐳹𐴨𐴯𐴺𐴿𐵦𐵨𐶆𐶍𐶐𐹟𐹿𐹿𐺪𐺪𐺮𐺯𐺲𐻁𐻅𐻻𐼨𐼯𐽚𐽯𐾊𐾯𐿌𐿟𐿷𐿿𑁎𑁑𑁶𑁾𑃃𑃌𑃎𑃏𑃩𑃯𑃺𑃿𑄵𑄵𑅈𑅏𑅷𑅿𑇠𑇠𑇵𑇿𑈒𑈒𑉂𑉿𑊇𑊇𑊉𑊉𑊎𑊎𑊞𑊞𑊪𑊯𑋫𑋯𑋺𑋿𑌄𑌄𑌍𑌎𑌑𑌒𑌩𑌩𑌱𑌱𑌴𑌴𑌺𑌺𑍅𑍆𑍉𑍊𑍎𑍏𑍑𑍖𑍘𑍜𑍤𑍥𑍭𑍯𑍵𑍿𑎊𑎊𑎌𑎍𑎏𑎏𑎶𑎶𑏁𑏁𑏃𑏄𑏆𑏆𑏋𑏋𑏖𑏖𑏙𑏠𑏣𑏿𑑜𑑜𑑢𑑿𑓈𑓏𑓚𑕿𑖶𑖷𑗞𑗿𑙅𑙏𑙚𑙟𑙭𑙿𑚺𑚿𑛊𑛏𑛤𑛿𑜛𑜜𑜬𑜯𑝇𑟿𑠼𑢟𑣳𑣾𑤇𑤈𑤊𑤋𑤔𑤔𑤗𑤗𑤶𑤶𑤹𑤺𑥇𑥏𑥚𑦟𑦨𑦩𑧘𑧙𑧥𑧿𑩈𑩏𑪣𑪯𑫹𑫿𑬊𑮿𑯢𑯯𑯺𑯿𑰉𑰉𑰷𑰷𑱆𑱏𑱭𑱯𑲐𑲑𑲨𑲨𑲷𑳿𑴇𑴇𑴊𑴊𑴷𑴹𑴻𑴻𑴾𑴾𑵈𑵏𑵚𑵟𑵦𑵦𑵩𑵩𑶏𑶏𑶒𑶒𑶙𑶟𑶪𑻟𑻹𑻿𑼑𑼑𑼻𑼽𑽛𑾯𑾱𑾿𑿲𑿾𒎚𒏿𒑯𒑯𒑵𒑿𒕄𒾏𒿳𒿿𓑖𓑟𔏻𔏿𔙇𖃿𖄺𖟿𖨹𖨿𖩟𖩟𖩪𖩭𖪿𖪿𖫊𖫏𖫮𖫯𖫶𖫿𖭆𖭏𖭚𖭚𖭢𖭢𖭸𖭼𖮐𖴿𖵺𖸿𖺛𖻿𖽋𖽎𖾈𖾎𖾠𖿟𖿥𖿯𖿲𖿿𘟸𘟿𘳖𘳾𘴉𚿯𚿴𚿴𚿼𚿼𚿿𚿿𛄣𛄱𛄳𛅏𛅓𛅔𛅖𛅣𛅨𛅯𛋼𛯿𛱫𛱯𛱽𛱿𛲉𛲏𛲚𛲛𛲤𜯿𜳺𜳿𜺴𜻿𜼮𜼯𜽇𜽏𜿄𜿿𝃶𝃿𝄧𝄨𝇫𝇿𝉆𝊿𝋔𝋟𝋴𝋿𝍗𝍟𝍹𝏿𝑕𝑕𝒝𝒝𝒠𝒡𝒣𝒤𝒧𝒨𝒭𝒭𝒺𝒺𝒼𝒼𝓄𝓄𝔆𝔆𝔋𝔌𝔕𝔕𝔝𝔝𝔺𝔺𝔿𝔿𝕅𝕅𝕇𝕉𝕑𝕑𝚦𝚧𝟌𝟍𝪌𝪚𝪠𝪠𝪰𝻿𝼟𝼤𝼫𝿿𞀇𞀇𞀙𞀚𞀢𞀢𞀥𞀥𞀫𞀯𞁮𞂎𞂐𞃿𞄭𞄯𞄾𞄿𞅊𞅍𞅐𞊏𞊯𞊿𞋺𞋾𞌀𞓏𞓺𞗏𞗻𞗾𞘀𞟟𞟧𞟧𞟬𞟬𞟯𞟯𞟿𞟿𞣅𞣆𞣗𞣿𞥌𞥏𞥚𞥝𞥠𞱰𞲵𞴀𞴾𞷿𞸄𞸄𞸠𞸠𞸣𞸣𞸥𞸦𞸨𞸨𞸳𞸳𞸸𞸸𞸺𞸺𞸼𞹁𞹃𞹆𞹈𞹈𞹊𞹊𞹌𞹌𞹐𞹐𞹓𞹓𞹕𞹖𞹘𞹘𞹚𞹚𞹜𞹜𞹞𞹞𞹠𞹠𞹣𞹣𞹥𞹦𞹫𞹫𞹳𞹳𞹸𞹸𞹽𞹽𞹿𞹿𞺊𞺊𞺜𞺠𞺤𞺤𞺪𞺪𞺼𞻯𞻲𞿿🀬🀯🂔🂟🂯🂰🃀🃀🃐🃐🃶🃿🆮🇥🈃🈏🈼🈿🉉🉏🉒🉟🉦🋿🛘🛛🛭🛯🛽🛿🝷🝺🟚🟟🟬🟯🟱🟿🠌🠏🡈🡏🡚🡟🢈🢏🢮🢯🢼🢿🣂🣿🩔🩟🩮🩯🩽🩿🪊🪎🫇🫍🫝🫞🫪🫯🫹🫿🮓🮓🯺🿿𪛠𪛿𫜺𫜿𫠞𫠟𬺢𬺯𮯡𮯯𮹞𯟿𯨞𯿿𱍋𱍏𲎰󠀀󠀂󠀟󠂀󠃿󠇰󯿿󿿾󿿿")) }, { _0: "Cc", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("\u0000\u001f\u007f")) }, { _0: "Zs", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("            　　")) }, { _0: "Po", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("!#%'**,,./:;?@\\\\¡¡§§¶·¿¿;;··՚՟։։׀׀׃׃׆׆׳״؉؊،؍؛؛؝؟٪٭۔۔܀܍߷߹࠰࠾࡞࡞।॥॰॰৽৽੶੶૰૰౷౷಄಄෴෴๏๏๚๛༄༒༔༔྅྅࿐࿔࿙࿚၊၏჻჻፠፨᙮᙮᛫᛭᜵᜶។៖៘៚᠀᠅᠇᠊᥄᥅᨞᨟᪠᪦᪨᪭᭎᭏᭚᭠᭽᭿᯼᯿᰻᰿᱾᱿᳀᳇᳓᳓‖‗†‧‰‸※‾⁁⁃⁇⁑⁓⁓⁕⁞⳹⳼⳾⳿⵰⵰⸀⸁⸆⸈⸋⸋⸎⸖⸘⸙⸛⸛⸞⸟⸪⸮⸰⸹⸼⸿⹁⹁⹃⹏⹒⹔、〃〽〽・・꓾꓿꘍꘏꙳꙳꙾꙾꛲꛷꡴꡷꣎꣏꣸꣺꣼꣼꤮꤯꥟꥟꧁꧍꧞꧟꩜꩟꫞꫟꫰꫱꯫꯫︐︖︙︙︰︰﹅﹆﹉﹌﹐﹒﹔﹗﹟﹡﹨﹨﹪﹫！＃％＇＊＊，，．／：；？＠＼＼｡｡､･𐄀𐄂𐎟𐎟𐏐𐏐𐕯𐕯𐡗𐡗𐤟𐤟𐤿𐤿𐩐𐩘𐩿𐩿𐫰𐫶𐬹𐬿𐮙𐮜𐽕𐽙𐾆𐾉𑁇𑁍𑂻𑂼𑂾𑃁𑅀𑅃𑅴𑅵𑇅𑇈𑇍𑇍𑇛𑇛𑇝𑇟𑈸𑈽𑊩𑊩𑏔𑏕𑏗𑏘𑑋𑑏𑑚𑑛𑑝𑑝𑓆𑓆𑗁𑗗𑙁𑙃𑙠𑙬𑚹𑚹𑜼𑜾𑠻𑠻𑥄𑥆𑧢𑧢𑨿𑩆𑪚𑪜𑪞𑪢𑬀𑬉𑯡𑯡𑱁𑱅𑱰𑱱𑻷𑻸𑽃𑽏𑿿𑿿𒑰𒑴𒿱𒿲𖩮𖩯𖫵𖫵𖬷𖬻𖭄𖭄𖵭𖵯𖺗𖺚𖿢𖿢𛲟𛲟𝪇𝪋𞗿𞗿𞥞𞥟")) }, { _0: "Sc", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("$$¢¥֏֏؋؋߾߿৲৳৻৻૱૱௹௹฿฿៛៛₠⃀꠸꠸﷼﷼﹩﹩＄＄￠￡￥￦𑿝𑿠𞋿𞋿𞲰𞲰")) }, { _0: "Ps", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("(([[{{༺༺༼༼᚛᚛‚‚„„⁅⁅⁽⁽₍₍⌈⌈⌊⌊〈〈❨❨❪❪❬❬❮❮❰❰❲❲❴❴⟅⟅⟦⟦⟨⟨⟪⟪⟬⟬⟮⟮⦃⦃⦅⦅⦇⦇⦉⦉⦋⦋⦍⦍⦏⦏⦑⦑⦓⦓⦕⦕⦗⦗⧘⧘⧚⧚⧼⧼⸢⸢⸤⸤⸦⸦⸨⸨⹂⹂⹕⹕⹗⹗⹙⹙⹛⹛〈〈《《「「『『【【〔〔〖〖〘〘〚〚〝〝﴿﴿︗︗︵︵︷︷︹︹︻︻︽︽︿︿﹁﹁﹃﹃﹇﹇﹙﹙﹛﹛﹝﹝（（［［｛｛｟｟｢｢")) }, { _0: "Pe", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("))]]}}༻༻༽༽᚜᚜⁆⁆⁾⁾₎₎⌉⌉⌋⌋〉〉❩❩❫❫❭❭❯❯❱❱❳❳❵❵⟆⟆⟧⟧⟩⟩⟫⟫⟭⟭⟯⟯⦄⦄⦆⦆⦈⦈⦊⦊⦌⦌⦎⦎⦐⦐⦒⦒⦔⦔⦖⦖⦘⦘⧙⧙⧛⧛⧽⧽⸣⸣⸥⸥⸧⸧⸩⸩⹖⹖⹘⹘⹚⹚⹜⹜〉〉》》」」』』】】〕〕〗〗〙〙〛〛〞〟﴾﴾︘︘︶︶︸︸︺︺︼︼︾︾﹀﹀﹂﹂﹄﹄﹈﹈﹚﹚﹜﹜﹞﹞））］］｝｝｠｠｣｣")) }, { _0: "Sm", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("++<>||~~¬¬±±××÷÷϶϶؆؈⁄⁄⁒⁒⁺⁼₊₌℘℘⅀⅄⅋⅋←↔↚↛↠↠↣↣↦↦↮↮⇎⇏⇒⇒⇔⇔⇴⋿⌠⌡⍼⍼⎛⎳⏜⏡▷▷◁◁◸◿♯♯⟀⟄⟇⟥⟰⟿⤀⦂⦙⧗⧜⧻⧾⫿⬰⭄⭇⭌﬩﬩﹢﹢﹤﹦＋＋＜＞｜｜～～￢￢￩￬𐶎𐶏𝛁𝛁𝛛𝛛𝛻𝛻𝜕𝜕𝜵𝜵𝝏𝝏𝝯𝝯𝞉𝞉𝞩𝞩𝟃𝟃𞻰𞻱")) }, { _0: "Pd", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("--֊֊־־᐀᐀᠆᠆‐―⸗⸗⸚⸚⸺⸻⹀⹀⹝⹝〜〜〰〰゠゠︱︲﹘﹘﹣﹣－－𐵮𐵮𐺭𐺭")) }, { _0: "Nd", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("09٠٩۰۹߀߉०९০৯੦੯૦૯୦୯௦௯౦౯೦೯൦൯෦෯๐๙໐໙༠༩၀၉႐႙០៩᠐᠙᥆᥏᧐᧙᪀᪉᪐᪙᭐᭙᮰᮹᱀᱉᱐᱙꘠꘩꣐꣙꤀꤉꧐꧙꧰꧹꩐꩙꯰꯹０９𐒠𐒩𐴰𐴹𐵀𐵉𑁦𑁯𑃰𑃹𑄶𑄿𑇐𑇙𑋰𑋹𑑐𑑙𑓐𑓙𑙐𑙙𑛀𑛉𑛐𑛣𑜰𑜹𑣠𑣩𑥐𑥙𑯰𑯹𑱐𑱙𑵐𑵙𑶠𑶩𑽐𑽙𖄰𖄹𖩠𖩩𖫀𖫉𖭐𖭙𖵰𖵹𜳰𜳹𝟎𝟿𞅀𞅉𞋰𞋹𞓰𞓹𞗱𞗺𞥐𞥙🯰🯹")) }, { _0: "Lu", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("AZÀÖØÞĀĀĂĂĄĄĆĆĈĈĊĊČČĎĎĐĐĒĒĔĔĖĖĘĘĚĚĜĜĞĞĠĠĢĢĤĤĦĦĨĨĪĪĬĬĮĮİİĲĲĴĴĶĶĹĹĻĻĽĽĿĿŁŁŃŃŅŅŇŇŊŊŌŌŎŎŐŐŒŒŔŔŖŖŘŘŚŚŜŜŞŞŠŠŢŢŤŤŦŦŨŨŪŪŬŬŮŮŰŰŲŲŴŴŶŶŸŹŻŻŽŽƁƂƄƄƆƇƉƋƎƑƓƔƖƘƜƝƟƠƢƢƤƤƦƧƩƩƬƬƮƯƱƳƵƵƷƸƼƼǄǄǇǇǊǊǍǍǏǏǑǑǓǓǕǕǗǗǙǙǛǛǞǞǠǠǢǢǤǤǦǦǨǨǪǪǬǬǮǮǱǱǴǴǶǸǺǺǼǼǾǾȀȀȂȂȄȄȆȆȈȈȊȊȌȌȎȎȐȐȒȒȔȔȖȖȘȘȚȚȜȜȞȞȠȠȢȢȤȤȦȦȨȨȪȪȬȬȮȮȰȰȲȲȺȻȽȾɁɁɃɆɈɈɊɊɌɌɎɎͰͰͲͲͶͶͿͿΆΆΈΊΌΌΎΏΑΡΣΫϏϏϒϔϘϘϚϚϜϜϞϞϠϠϢϢϤϤϦϦϨϨϪϪϬϬϮϮϴϴϷϷϹϺϽЯѠѠѢѢѤѤѦѦѨѨѪѪѬѬѮѮѰѰѲѲѴѴѶѶѸѸѺѺѼѼѾѾҀҀҊҊҌҌҎҎҐҐҒҒҔҔҖҖҘҘҚҚҜҜҞҞҠҠҢҢҤҤҦҦҨҨҪҪҬҬҮҮҰҰҲҲҴҴҶҶҸҸҺҺҼҼҾҾӀӁӃӃӅӅӇӇӉӉӋӋӍӍӐӐӒӒӔӔӖӖӘӘӚӚӜӜӞӞӠӠӢӢӤӤӦӦӨӨӪӪӬӬӮӮӰӰӲӲӴӴӶӶӸӸӺӺӼӼӾӾԀԀԂԂԄԄԆԆԈԈԊԊԌԌԎԎԐԐԒԒԔԔԖԖԘԘԚԚԜԜԞԞԠԠԢԢԤԤԦԦԨԨԪԪԬԬԮԮԱՖႠჅჇჇჍჍᎠᏵᲉᲉᲐᲺᲽᲿḀḀḂḂḄḄḆḆḈḈḊḊḌḌḎḎḐḐḒḒḔḔḖḖḘḘḚḚḜḜḞḞḠḠḢḢḤḤḦḦḨḨḪḪḬḬḮḮḰḰḲḲḴḴḶḶḸḸḺḺḼḼḾḾṀṀṂṂṄṄṆṆṈṈṊṊṌṌṎṎṐṐṒṒṔṔṖṖṘṘṚṚṜṜṞṞṠṠṢṢṤṤṦṦṨṨṪṪṬṬṮṮṰṰṲṲṴṴṶṶṸṸṺṺṼṼṾṾẀẀẂẂẄẄẆẆẈẈẊẊẌẌẎẎẐẐẒẒẔẔẞẞẠẠẢẢẤẤẦẦẨẨẪẪẬẬẮẮẰẰẲẲẴẴẶẶẸẸẺẺẼẼẾẾỀỀỂỂỄỄỆỆỈỈỊỊỌỌỎỎỐỐỒỒỔỔỖỖỘỘỚỚỜỜỞỞỠỠỢỢỤỤỦỦỨỨỪỪỬỬỮỮỰỰỲỲỴỴỶỶỸỸỺỺỼỼỾỾἈἏἘἝἨἯἸἿὈὍὙὙὛὛὝὝὟὟὨὯᾸΆῈΉῘΊῨῬῸΏℂℂℇℇℋℍℐℒℕℕℙℝℤℤΩΩℨℨKℭℰℳℾℿⅅⅅↃↃⰀⰯⱠⱠⱢⱤⱧⱧⱩⱩⱫⱫⱭⱰⱲⱲⱵⱵⱾⲀⲂⲂⲄⲄⲆⲆⲈⲈⲊⲊⲌⲌⲎⲎⲐⲐⲒⲒⲔⲔⲖⲖⲘⲘⲚⲚⲜⲜⲞⲞⲠⲠⲢⲢⲤⲤⲦⲦⲨⲨⲪⲪⲬⲬⲮⲮⲰⲰⲲⲲⲴⲴⲶⲶⲸⲸⲺⲺⲼⲼⲾⲾⳀⳀⳂⳂⳄⳄⳆⳆⳈⳈⳊⳊⳌⳌⳎⳎⳐⳐⳒⳒⳔⳔⳖⳖⳘⳘⳚⳚⳜⳜⳞⳞⳠⳠⳢⳢⳫⳫⳭⳭⳲⳲꙀꙀꙂꙂꙄꙄꙆꙆꙈꙈꙊꙊꙌꙌꙎꙎꙐꙐꙒꙒꙔꙔꙖꙖꙘꙘꙚꙚꙜꙜꙞꙞꙠꙠꙢꙢꙤꙤꙦꙦꙨꙨꙪꙪꙬꙬꚀꚀꚂꚂꚄꚄꚆꚆꚈꚈꚊꚊꚌꚌꚎꚎꚐꚐꚒꚒꚔꚔꚖꚖꚘꚘꚚꚚꜢꜢꜤꜤꜦꜦꜨꜨꜪꜪꜬꜬꜮꜮꜲꜲꜴꜴꜶꜶꜸꜸꜺꜺꜼꜼꜾꜾꝀꝀꝂꝂꝄꝄꝆꝆꝈꝈꝊꝊꝌꝌꝎꝎꝐꝐꝒꝒꝔꝔꝖꝖꝘꝘꝚꝚꝜꝜꝞꝞꝠꝠꝢꝢꝤꝤꝦꝦꝨꝨꝪꝪꝬꝬꝮꝮꝹꝹꝻꝻꝽꝾꞀꞀꞂꞂꞄꞄꞆꞆꞋꞋꞍꞍꞐꞐꞒꞒꞖꞖꞘꞘꞚꞚꞜꞜꞞꞞꞠꞠꞢꞢꞤꞤꞦꞦꞨꞨꞪꞮꞰꞴꞶꞶꞸꞸꞺꞺꞼꞼꞾꞾꟀꟀꟂꟂꟄꟇꟉꟉꟋꟌꟐꟐꟖꟖꟘꟘꟚꟚꟜꟜꟵꟵＡＺ𐐀𐐧𐒰𐓓𐕰𐕺𐕼𐖊𐖌𐖒𐖔𐖕𐲀𐲲𐵐𐵥𑢠𑢿𖹀𖹟𝐀𝐙𝐴𝑍𝑨𝒁𝒜𝒜𝒞𝒟𝒢𝒢𝒥𝒦𝒩𝒬𝒮𝒵𝓐𝓩𝔄𝔅𝔇𝔊𝔍𝔔𝔖𝔜𝔸𝔹𝔻𝔾𝕀𝕄𝕆𝕆𝕊𝕐𝕬𝖅𝖠𝖹𝗔𝗭𝘈𝘡𝘼𝙕𝙰𝚉𝚨𝛀𝛢𝛺𝜜𝜴𝝖𝝮𝞐𝞨𝟊𝟊𞤀𞤡")) }, { _0: "Sk", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("^^``¨¨¯¯´´¸¸˂˅˒˟˥˫˭˭˯˿͵͵΄΅࢈࢈᾽᾽᾿῁῍῏῝῟῭`´῾゛゜꜀꜖꜠꜡꞉꞊꭛꭛꭪꭫﮲﯂＾＾｀｀￣￣🏻🏿")) }, { _0: "Pc", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("__‿⁀⁔⁔︳︴﹍﹏＿＿")) }, { _0: "Ll", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("azµµßöøÿāāăăąąććĉĉċċččďďđđēēĕĕėėęęěěĝĝğğġġģģĥĥħħĩĩīīĭĭįįııĳĳĵĵķĸĺĺļļľľŀŀłłńńņņňŉŋŋōōŏŏőőœœŕŕŗŗřřśśŝŝşşššţţťťŧŧũũūūŭŭůůűűųųŵŵŷŷźźżżžƀƃƃƅƅƈƈƌƍƒƒƕƕƙƛƞƞơơƣƣƥƥƨƨƪƫƭƭưưƴƴƶƶƹƺƽƿǆǆǉǉǌǌǎǎǐǐǒǒǔǔǖǖǘǘǚǚǜǝǟǟǡǡǣǣǥǥǧǧǩǩǫǫǭǭǯǰǳǳǵǵǹǹǻǻǽǽǿǿȁȁȃȃȅȅȇȇȉȉȋȋȍȍȏȏȑȑȓȓȕȕȗȗșșțțȝȝȟȟȡȡȣȣȥȥȧȧȩȩȫȫȭȭȯȯȱȱȳȹȼȼȿɀɂɂɇɇɉɉɋɋɍɍɏʓʕʯͱͱͳͳͷͷͻͽΐΐάώϐϑϕϗϙϙϛϛϝϝϟϟϡϡϣϣϥϥϧϧϩϩϫϫϭϭϯϳϵϵϸϸϻϼаџѡѡѣѣѥѥѧѧѩѩѫѫѭѭѯѯѱѱѳѳѵѵѷѷѹѹѻѻѽѽѿѿҁҁҋҋҍҍҏҏґґғғҕҕҗҗҙҙққҝҝҟҟҡҡңңҥҥҧҧҩҩҫҫҭҭүүұұҳҳҵҵҷҷҹҹһһҽҽҿҿӂӂӄӄӆӆӈӈӊӊӌӌӎӏӑӑӓӓӕӕӗӗәәӛӛӝӝӟӟӡӡӣӣӥӥӧӧөөӫӫӭӭӯӯӱӱӳӳӵӵӷӷӹӹӻӻӽӽӿӿԁԁԃԃԅԅԇԇԉԉԋԋԍԍԏԏԑԑԓԓԕԕԗԗԙԙԛԛԝԝԟԟԡԡԣԣԥԥԧԧԩԩԫԫԭԭԯԯՠֈაჺჽჿᏸᏽᲀᲈᲊᲊᴀᴫᵫᵷᵹᶚḁḁḃḃḅḅḇḇḉḉḋḋḍḍḏḏḑḑḓḓḕḕḗḗḙḙḛḛḝḝḟḟḡḡḣḣḥḥḧḧḩḩḫḫḭḭḯḯḱḱḳḳḵḵḷḷḹḹḻḻḽḽḿḿṁṁṃṃṅṅṇṇṉṉṋṋṍṍṏṏṑṑṓṓṕṕṗṗṙṙṛṛṝṝṟṟṡṡṣṣṥṥṧṧṩṩṫṫṭṭṯṯṱṱṳṳṵṵṷṷṹṹṻṻṽṽṿṿẁẁẃẃẅẅẇẇẉẉẋẋẍẍẏẏẑẑẓẓẕẝẟẟạạảảấấầầẩẩẫẫậậắắằằẳẳẵẵặặẹẹẻẻẽẽếếềềểểễễệệỉỉịịọọỏỏốốồồổổỗỗộộớớờờởởỡỡợợụụủủứứừừửửữữựựỳỳỵỵỷỷỹỹỻỻỽỽỿἇἐἕἠἧἰἷὀὅὐὗὠὧὰώᾀᾇᾐᾗᾠᾧᾰᾴᾶᾷιιῂῄῆῇῐΐῖῗῠῧῲῴῶῷℊℊℎℏℓℓℯℯℴℴℹℹℼℽⅆⅉⅎⅎↄↄⰰⱟⱡⱡⱥⱦⱨⱨⱪⱪⱬⱬⱱⱱⱳⱴⱶⱻⲁⲁⲃⲃⲅⲅⲇⲇⲉⲉⲋⲋⲍⲍⲏⲏⲑⲑⲓⲓⲕⲕⲗⲗⲙⲙⲛⲛⲝⲝⲟⲟⲡⲡⲣⲣⲥⲥⲧⲧⲩⲩⲫⲫⲭⲭⲯⲯⲱⲱⲳⲳⲵⲵⲷⲷⲹⲹⲻⲻⲽⲽⲿⲿⳁⳁⳃⳃⳅⳅⳇⳇⳉⳉⳋⳋⳍⳍⳏⳏⳑⳑⳓⳓⳕⳕⳗⳗⳙⳙⳛⳛⳝⳝⳟⳟⳡⳡⳣⳤⳬⳬⳮⳮⳳⳳⴀⴥⴧⴧⴭⴭꙁꙁꙃꙃꙅꙅꙇꙇꙉꙉꙋꙋꙍꙍꙏꙏꙑꙑꙓꙓꙕꙕꙗꙗꙙꙙꙛꙛꙝꙝꙟꙟꙡꙡꙣꙣꙥꙥꙧꙧꙩꙩꙫꙫꙭꙭꚁꚁꚃꚃꚅꚅꚇꚇꚉꚉꚋꚋꚍꚍꚏꚏꚑꚑꚓꚓꚕꚕꚗꚗꚙꚙꚛꚛꜣꜣꜥꜥꜧꜧꜩꜩꜫꜫꜭꜭꜯꜱꜳꜳꜵꜵꜷꜷꜹꜹꜻꜻꜽꜽꜿꜿꝁꝁꝃꝃꝅꝅꝇꝇꝉꝉꝋꝋꝍꝍꝏꝏꝑꝑꝓꝓꝕꝕꝗꝗꝙꝙꝛꝛꝝꝝꝟꝟꝡꝡꝣꝣꝥꝥꝧꝧꝩꝩꝫꝫꝭꝭꝯꝯꝱꝸꝺꝺꝼꝼꝿꝿꞁꞁꞃꞃꞅꞅꞇꞇꞌꞌꞎꞎꞑꞑꞓꞕꞗꞗꞙꞙꞛꞛꞝꞝꞟꞟꞡꞡꞣꞣꞥꞥꞧꞧꞩꞩꞯꞯꞵꞵꞷꞷꞹꞹꞻꞻꞽꞽꞿꞿꟁꟁꟃꟃꟈꟈꟊꟊꟍꟍꟑꟑꟓꟓꟕꟕꟗꟗꟙꟙꟛꟛꟶꟶꟺꟺꬰꭚꭠꭨꭰꮿﬀﬆﬓﬗａｚ𐐨𐑏𐓘𐓻𐖗𐖡𐖣𐖱𐖳𐖹𐖻𐖼𐳀𐳲𐵰𐶅𑣀𑣟𖹠𖹿𝐚𝐳𝑎𝑔𝑖𝑧𝒂𝒛𝒶𝒹𝒻𝒻𝒽𝓃𝓅𝓏𝓪𝔃𝔞𝔷𝕒𝕫𝖆𝖟𝖺𝗓𝗮𝘇𝘢𝘻𝙖𝙯𝚊𝚥𝛂𝛚𝛜𝛡𝛼𝜔𝜖𝜛𝜶𝝎𝝐𝝕𝝰𝞈𝞊𝞏𝞪𝟂𝟄𝟉𝟋𝟋𝼀𝼉𝼋𝼞𝼥𝼪𞤢𞥃")) }, { _0: "So", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("¦¦©©®®°°҂҂֍֎؎؏۞۞۩۩۽۾߶߶৺৺୰୰௳௸௺௺౿౿൏൏൹൹༁༃༓༓༕༗༚༟༴༴༶༶༸༸྾࿅࿇࿌࿎࿏࿕࿘႞႟᎐᎙᙭᙭᥀᥀᧞᧿᭡᭪᭴᭼℀℁℃℆℈℉℔℔№℗℞℣℥℥℧℧℩℩℮℮℺℻⅊⅊⅌⅍⅏⅏↊↋↕↙↜↟↡↢↤↥↧↭↯⇍⇐⇑⇓⇓⇕⇳⌀⌇⌌⌟⌢⌨⌫⍻⍽⎚⎴⏛⏢␩⑀⑊⒜ⓩ─▶▸◀◂◷☀♮♰❧➔➿⠀⣿⬀⬯⭅⭆⭍⭳⭶⮕⮗⯿⳥⳪⹐⹑⺀⺙⺛⻳⼀⿕⿰⿿〄〄〒〓〠〠〶〷〾〿㆐㆑㆖㆟㇀㇥㇯㇯㈀㈞㈪㉇㉐㉐㉠㉿㊊㊰㋀㏿䷀䷿꒐꓆꠨꠫꠶꠷꠹꠹꩷꩹﵀﵏﷏﷏﷽﷿￤￤￨￨￭￮￼�𐄷𐄿𐅹𐆉𐆌𐆎𐆐𐆜𐆠𐆠𐇐𐇼𐡷𐡸𐫈𐫈𑜿𑜿𑿕𑿜𑿡𑿱𖬼𖬿𖭅𖭅𛲜𛲜𜰀𜳯𜴀𜺳𜽐𜿃𝀀𝃵𝄀𝄦𝄩𝅘𝅥𝅲𝅪𝅬𝆃𝆄𝆌𝆩𝆮𝇪𝈀𝉁𝉅𝉅𝌀𝍖𝠀𝧿𝨷𝨺𝩭𝩴𝩶𝪃𝪅𝪆𞅏𞅏𞲬𞲬𞴮𞴮🀀🀫🀰🂓🂠🂮🂱🂿🃁🃏🃑🃵🄍🆭🇦🈂🈐🈻🉀🉈🉐🉑🉠🉥🌀🏺🐀🛗🛜🛬🛰🛼🜀🝶🝻🟙🟠🟫🟰🟰🠀🠋🠐🡇🡐🡙🡠🢇🢐🢭🢰🢻🣀🣁🤀🩓🩠🩭🩰🩼🪀🪉🪏🫆🫎🫜🫟🫩🫰🫸🬀🮒🮔🯯")) }, { _0: "Lo", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ªªººƻƻǀǃʔʔאתׯײؠؿفيٮٯٱۓەەۮۯۺۼۿۿܐܐܒܯݍޥޱޱߊߪࠀࠕࡀࡘࡠࡪࡰࢇࢉࢎࢠࣈऄहऽऽॐॐक़ॡॲঀঅঌএঐওনপরললশহঽঽৎৎড়ঢ়য়ৡৰৱৼৼਅਊਏਐਓਨਪਰਲਲ਼ਵਸ਼ਸਹਖ਼ੜਫ਼ਫ਼ੲੴઅઍએઑઓનપરલળવહઽઽૐૐૠૡૹૹଅଌଏଐଓନପରଲଳଵହଽଽଡ଼ଢ଼ୟୡୱୱஃஃஅஊஎஐஒகஙசஜஜஞடணதநபமஹௐௐఅఌఎఐఒనపహఽఽౘౚౝౝౠౡಀಀಅಌಎಐಒನಪಳವಹಽಽೝೞೠೡೱೲഄഌഎഐഒഺഽഽൎൎൔൖൟൡൺൿඅඖකනඳරලලවෆกะาำเๅກຂຄຄຆຊຌຣລລວະາຳຽຽເໄໜໟༀༀཀཇཉཬྈྌကဪဿဿၐၕၚၝၡၡၥၦၮၰၵႁႎႎᄀቈቊቍቐቖቘቘቚቝበኈኊኍነኰኲኵኸኾዀዀዂዅወዖዘጐጒጕጘፚᎀᎏᐁᙬᙯᙿᚁᚚᚠᛪᛱᛸᜀᜑᜟᜱᝀᝑᝠᝬᝮᝰកឳៜៜᠠᡂᡄᡸᢀᢄᢇᢨᢪᢪᢰᣵᤀᤞᥐᥭᥰᥴᦀᦫᦰᧉᨀᨖᨠᩔᬅᬳᭅᭌᮃᮠᮮᮯᮺᯥᰀᰣᱍᱏᱚᱷᳩᳬᳮᳳᳵᳶᳺᳺℵℸⴰⵧⶀⶖⶠⶦⶨⶮⶰⶶⶸⶾⷀⷆⷈⷎⷐⷖⷘⷞ〆〆〼〼ぁゖゟゟァヺヿヿㄅㄯㄱㆎㆠㆿㇰㇿ㐀䶿一ꀔꀖꒌꓐꓷꔀꘋꘐꘟꘪꘫꙮꙮꚠꛥꞏꞏꟷꟷꟻꠁꠃꠅꠇꠊꠌꠢꡀꡳꢂꢳꣲꣷꣻꣻꣽꣾꤊꤥꤰꥆꥠꥼꦄꦲꧠꧤꧧꧯꧺꧾꨀꨨꩀꩂꩄꩋꩠꩯꩱꩶꩺꩺꩾꪯꪱꪱꪵꪶꪹꪽꫀꫀꫂꫂꫛꫜꫠꫪꫲꫲꬁꬆꬉꬎꬑꬖꬠꬦꬨꬮꯀꯢ가힣ힰퟆퟋퟻ豈舘並龎יִיִײַﬨשׁזּטּלּמּמּנּסּףּפּצּﮱﯓﴽﵐﶏﶒﷇﷰﷻﹰﹴﹶﻼｦｯｱﾝﾠﾾￂￇￊￏￒￗￚￜ𐀀𐀋𐀍𐀦𐀨𐀺𐀼𐀽𐀿𐁍𐁐𐁝𐂀𐃺𐊀𐊜𐊠𐋐𐌀𐌟𐌭𐍀𐍂𐍉𐍐𐍵𐎀𐎝𐎠𐏃𐏈𐏏𐑐𐒝𐔀𐔧𐔰𐕣𐗀𐗳𐘀𐜶𐝀𐝕𐝠𐝧𐠀𐠅𐠈𐠈𐠊𐠵𐠷𐠸𐠼𐠼𐠿𐡕𐡠𐡶𐢀𐢞𐣠𐣲𐣴𐣵𐤀𐤕𐤠𐤹𐦀𐦷𐦾𐦿𐨀𐨀𐨐𐨓𐨕𐨗𐨙𐨵𐩠𐩼𐪀𐪜𐫀𐫇𐫉𐫤𐬀𐬵𐭀𐭕𐭠𐭲𐮀𐮑𐰀𐱈𐴀𐴣𐵊𐵍𐵏𐵏𐺀𐺩𐺰𐺱𐻂𐻄𐼀𐼜𐼧𐼧𐼰𐽅𐽰𐾁𐾰𐿄𐿠𐿶𑀃𑀷𑁱𑁲𑁵𑁵𑂃𑂯𑃐𑃨𑄃𑄦𑅄𑅄𑅇𑅇𑅐𑅲𑅶𑅶𑆃𑆲𑇁𑇄𑇚𑇚𑇜𑇜𑈀𑈑𑈓𑈫𑈿𑉀𑊀𑊆𑊈𑊈𑊊𑊍𑊏𑊝𑊟𑊨𑊰𑋞𑌅𑌌𑌏𑌐𑌓𑌨𑌪𑌰𑌲𑌳𑌵𑌹𑌽𑌽𑍐𑍐𑍝𑍡𑎀𑎉𑎋𑎋𑎎𑎎𑎐𑎵𑎷𑎷𑏑𑏑𑏓𑏓𑐀𑐴𑑇𑑊𑑟𑑡𑒀𑒯𑓄𑓅𑓇𑓇𑖀𑖮𑗘𑗛𑘀𑘯𑙄𑙄𑚀𑚪𑚸𑚸𑜀𑜚𑝀𑝆𑠀𑠫𑣿𑤆𑤉𑤉𑤌𑤓𑤕𑤖𑤘𑤯𑤿𑤿𑥁𑥁𑦠𑦧𑦪𑧐𑧡𑧡𑧣𑧣𑨀𑨀𑨋𑨲𑨺𑨺𑩐𑩐𑩜𑪉𑪝𑪝𑪰𑫸𑯀𑯠𑰀𑰈𑰊𑰮𑱀𑱀𑱲𑲏𑴀𑴆𑴈𑴉𑴋𑴰𑵆𑵆𑵠𑵥𑵧𑵨𑵪𑶉𑶘𑶘𑻠𑻲𑼂𑼂𑼄𑼐𑼒𑼳𑾰𑾰𒀀𒎙𒒀𒕃𒾐𒿰𓀀𓐯𓑁𓑆𓑠𔏺𔐀𔙆𖄀𖄝𖠀𖨸𖩀𖩞𖩰𖪾𖫐𖫭𖬀𖬯𖭣𖭷𖭽𖮏𖵃𖵪𖼀𖽊𖽐𖽐𗀀𘟷𘠀𘳕𘳿𘴈𛀀𛄢𛄲𛄲𛅐𛅒𛅕𛅕𛅤𛅧𛅰𛋻𛰀𛱪𛱰𛱼𛲀𛲈𛲐𛲙𝼊𝼊𞄀𞄬𞅎𞅎𞊐𞊭𞋀𞋫𞓐𞓪𞗐𞗭𞗰𞗰𞟠𞟦𞟨𞟫𞟭𞟮𞟰𞟾𞠀𞣄𞸀𞸃𞸅𞸟𞸡𞸢𞸤𞸤𞸧𞸧𞸩𞸲𞸴𞸷𞸹𞸹𞸻𞸻𞹂𞹂𞹇𞹇𞹉𞹉𞹋𞹋𞹍𞹏𞹑𞹒𞹔𞹔𞹗𞹗𞹙𞹙𞹛𞹛𞹝𞹝𞹟𞹟𞹡𞹢𞹤𞹤𞹧𞹪𞹬𞹲𞹴𞹷𞹹𞹼𞹾𞹾𞺀𞺉𞺋𞺛𞺡𞺣𞺥𞺩𞺫𞺻𠀀𪛟𪜀𫜹𫝀𫠝𫠠𬺡𬺰𮯠𮯰𮹝丽𪘀𰀀𱍊𱍐𲎯")) }, { _0: "Pi", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("««‘‘‛“‟‟‹‹⸂⸂⸄⸄⸉⸉⸌⸌⸜⸜⸠⸠")) }, { _0: "Cf", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("­­؀؅؜؜۝۝܏܏࢐࢑࣢࣢᠎᠎​‏‪‮⁠⁤⁦⁯﻿﻿￹￻𑂽𑂽𑃍𑃍𓐰𓐿𛲠𛲣𝅳𝅺󠀁󠀁󠀠󠁿")) }, { _0: "No", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("²³¹¹¼¾৴৹୲୷௰௲౸౾൘൞൰൸༪༳፩፼៰៹᧚᧚⁰⁰⁴⁹₀₉⅐⅟↉↉①⒛⓪⓿❶➓⳽⳽㆒㆕㈠㈩㉈㉏㉑㉟㊀㊉㊱㊿꠰꠵𐄇𐄳𐅵𐅸𐆊𐆋𐋡𐋻𐌠𐌣𐡘𐡟𐡹𐡿𐢧𐢯𐣻𐣿𐤖𐤛𐦼𐦽𐧀𐧏𐧒𐧿𐩀𐩈𐩽𐩾𐪝𐪟𐫫𐫯𐭘𐭟𐭸𐭿𐮩𐮯𐳺𐳿𐹠𐹾𐼝𐼦𐽑𐽔𐿅𐿋𑁒𑁥𑇡𑇴𑜺𑜻𑣪𑣲𑱚𑱬𑿀𑿔𖭛𖭡𖺀𖺖𝋀𝋓𝋠𝋳𝍠𝍸𞣇𞣏𞱱𞲫𞲭𞲯𞲱𞲴𞴁𞴭𞴯𞴽🄀🄌")) }, { _0: "Pf", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("»»’’””››⸃⸃⸅⸅⸊⸊⸍⸍⸝⸝⸡⸡")) }, { _0: "Lt", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ǅǅǈǈǋǋǲǲᾈᾏᾘᾟᾨᾯᾼᾼῌῌῼῼ")) }, { _0: "Lm", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ʰˁˆˑˠˤˬˬˮˮʹʹͺͺՙՙــۥۦߴߵߺߺࠚࠚࠤࠤࠨࠨࣉࣉॱॱๆๆໆໆჼჼៗៗᡃᡃᪧᪧᱸᱽᴬᵪᵸᵸᶛᶿⁱⁱⁿⁿₐₜⱼⱽⵯⵯⸯⸯ々々〱〵〻〻ゝゞーヾꀕꀕꓸꓽꘌꘌꙿꙿꚜꚝꜗꜟꝰꝰꞈꞈꟲꟴꟸꟹꧏꧏꧦꧦꩰꩰꫝꫝꫳꫴꭜꭟꭩꭩｰｰﾞﾟ𐞀𐞅𐞇𐞰𐞲𐞺𐵎𐵎𐵯𐵯𖭀𖭃𖵀𖵂𖵫𖵬𖾓𖾟𖿠𖿡𖿣𖿣𚿰𚿳𚿵𚿻𚿽𚿾𞀰𞁭𞄷𞄽𞓫𞓫𞥋𞥋")) }, { _0: "Mn", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ׇׇֽֿֿׁׂًؚٰٰܑܑ֑ׅٟ۪ۭ̀ͯ҃҇ׄؐۖۜ۟ۤۧۨܰ݊ަް߽߽࡙࡛ࣣ߫߳ࠖ࠙ࠛࠣࠥࠧࠩ࠭ࢗ࢟࣊࣡ंऺऺ़़ुै््॑ॗॢॣঁঁ়়ুৄ্্ৢৣ৾৾ਁਂ਼਼ੁੂੇੈੋ੍ੑੑੰੱੵੵઁં઼઼ુૅેૈ્્ૢૣૺ૿ଁଁ଼଼ିିୁୄ୍୍୕ୖୢୣஂஂீீ்்ఀఀఄఄ఼఼ాీెైొ్ౕౖౢౣಁಁ಼಼ಿಿೆೆೌ್ೢೣഀഁ഻഼ുൄ്്ൢൣඁඁ්්ිුූූััิฺ็๎ັັິຼ່໎ཱ༹༹༘༙༵༵༷༷ཾ྄ྀ྆྇ྍྗྙྼ࿆࿆ိူဲ့္်ွှၘၙၞၠၱၴႂႂႅႆႍႍႝႝ፝፟ᜒ᜔ᜲᜳᝒᝓᝲᝳ឴឵ិួំំ៉៓៝៝᠋᠍᠏᠏ᢅᢆᢩᢩᤠᤢᤧᤨᤲᤲ᤻ᨘ᤹ᨗᨛᨛᩖᩖᩘᩞ᩠᩠ᩢᩢᩥᩬᩳ᩿᩿᪽ᪿ᩼᪰ᫎᬀᬃ᬴᬴ᬶᬺᬼᬼᭂᭂ᭫᭳ᮀᮁᮢᮥᮨᮩ᮫ᮭ᯦᯦ᯨᯩᯭᯭᯯᯱᰬᰳᰶ᳔᳢᳨⃥᰷゙゚⵿⵿〪᳭᳭᷿〭᳐᳒᳠᳴᳴᳸᳹᷀⃐⃜⃡⃡⃰⳯⳱ⷠⷿ꙯꙯ꙴ꙽ꚞꚟ꛰꛱ꠂꠂ꠆꠆ꠋꠋꠥꠦ꠬꠬꣄ꣅ꣠꣱ꣿꣿꤦ꤭ꥇꥑꦀꦂ꦳꦳ꦶꦹꦼꦽꧥꧥꨩꨮꨱꨲꨵꨶꩃꩃꩌꩌꩼꩼꪴꪰꪰꪲꪷꪸꪾ꪿꫁꫁ꫬꫭ꫶꫶ꯥꯥꯨꯨ꯭꯭ﬞﬞ︀️𐇽𐇽𐋠𐋠︠︯𐍶𐍺𐨁𐨃𐨅𐨆𐨌𐨿𐨿𐨺𐫦𐨏𐨸𐫥𐴤𐴧𐵩𐵭𐺫𐺬𐻼𐻿𐽆𐽐𐾅𐾂𑀁𑀁𑀸𑁆𑁰𑁰𑁳𑁴𑁿𑂁𑂳𑂶𑂺𑂹𑃂𑃂𑄀𑄂𑄧𑄫𑄭𑅳𑅳𑄴𑆀𑆁𑆶𑆾𑇉𑇌𑇏𑇏𑈯𑈱𑈴𑈴𑈶𑈷𑈾𑈾𑉁𑉁𑋟𑋟𑋣𑋪𑌀𑌁𑌻𑌼𑍀𑍀𑍦𑍬𑍰𑍴𑎻𑏀𑏎𑏎𑏐𑏐𑏒𑏒𑏡𑏢𑐸𑐿𑑂𑑄𑑆𑑆𑑞𑑞𑒳𑒸𑒺𑒺𑒿𑓀𑓃𑓂𑖲𑖵𑖼𑖽𑗀𑖿𑗜𑗝𑘳𑘺𑘽𑘽𑘿𑙀𑚫𑚫𑚭𑚭𑚰𑚵𑚷𑚷𑜝𑜝𑜟𑜟𑜢𑜥𑜧𑜫𑠯𑠷𑠺𑠹𑤻𑤼𑥃𑥃𑤾𑤾𑧔𑧗𑧚𑧛𑧠𑧠𑨁𑨊𑨳𑨸𑨻𑨾𑩇𑩇𑩑𑩖𑩙𑩛𑪊𑪖𑪘𑪙𑰰𑰶𑰸𑰽𑰿𑰿𑲒𑲧𑲪𑲰𑲲𑲳𑲵𑲶𑴱𑴶𑴺𑴺𑴼𑴽𑴿𑵅𑵇𑵇𑶐𑶑𑶕𑶕𑶗𑶗𑻳𑻴𑼀𑼁𑼶𑼺𑽀𑽀𑽂𑽂𑽚𑽚𓑀𓑀𓑇𓑕𖄢𖄭𖫰𖫴𖄯𖬰𖬶𖽏𖽏𖾏𖾒𖿤𖿤𛲝𛲞𜼀𜼭𜼰𜽆𝅧𝅩𝅻𝆂𝆋𝆅𝆪𝆭𝉂𝉄𝨀𝨶𝨻𝩬𝩵𝩵𝪄𝪄𝪛𝪟𝪡𝪯𞥊𞗯𞣐𞣖𞀀𞀆𞀈𞀘𞀛𞀡𞀣𞀤𞀦𞀪𞂏𞂏𞄰𞄶𞊮𞊮𞋬𞋯𞓯𞗮𞥄𞓬󠄀󠇯")) }, { _0: "Me", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("҈҉᪾᪾⃝⃠⃢⃤꙰꙲")) }, { _0: "Mc", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ःःऻऻाीॉौॎॏংঃাীেৈোৌৗৗਃਃਾੀઃઃાીૉૉોૌଂଃାାୀୀେୈୋୌୗୗாிுூெைொௌௗௗఁఃుౄಂಃಾಾೀೄೇೈೊೋೕೖೳೳംഃാീെൈൊൌൗൗංඃාෑෘෟෲෳ༾༿ཿཿါာေေးးျြၖၗၢၤၧၭႃႄႇႌႏႏႚႜ᜕᜕᜴᜴ាាើៅះៈᤣᤦᤩᤫᤰᤱᤳᤸᨙᨚᩕᩕᩗᩗᩡᩡᩣᩤᩭᩲᬄᬄᬵᬵᬻᬻᬽᭁᭃ᭄ᮂᮂᮡᮡᮦᮧ᮪᮪ᯧᯧᯪᯬᯮᯮ᯲᯳ᰤᰫᰴᰵ᳡᳡᳷᳷〮〯ꠣꠤꠧꠧꢀꢁꢴꣃꥒ꥓ꦃꦃꦴꦵꦺꦻꦾ꧀ꨯꨰꨳꨴꩍꩍꩻꩻꩽꩽꫫꫫꫮꫯꫵꫵꯣꯤꯦꯧꯩꯪ꯬꯬𑀀𑀀𑀂𑀂𑂂𑂂𑂰𑂲𑂷𑂸𑄬𑄬𑅅𑅆𑆂𑆂𑆳𑆵𑆿𑇀𑇎𑇎𑈬𑈮𑈲𑈳𑈵𑈵𑋠𑋢𑌂𑌃𑌾𑌿𑍁𑍄𑍇𑍈𑍋𑍍𑍗𑍗𑍢𑍣𑎸𑎺𑏅𑏅𑏅𑏇𑏊𑏌𑏍𑏏𑏏𑐵𑐷𑑀𑑁𑑅𑑅𑒰𑒲𑒹𑒹𑒻𑒾𑓁𑓁𑖯𑖱𑖸𑖻𑖾𑖾𑘰𑘲𑘻𑘼𑘾𑘾𑚬𑚬𑚮𑚯𑚶𑚶𑜞𑜞𑜠𑜡𑜦𑜦𑠬𑠮𑠸𑠸𑤰𑤵𑤷𑤸𑤽𑤽𑥀𑥀𑥂𑥂𑧑𑧓𑧜𑧟𑧤𑧤𑨹𑨹𑩗𑩘𑪗𑪗𑰯𑰯𑰾𑰾𑲩𑲩𑲱𑲱𑲴𑲴𑶊𑶎𑶓𑶔𑶖𑶖𑻵𑻶𑼃𑼃𑼴𑼵𑼾𑼿𑽁𑽁𖄪𖄬𖽑𖾇𖿰𖿱𝅥𝅦𝅲𝅭")) }, { _0: "Nl", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("ᛮᛰⅠↂↅↈ〇〇〡〩〸〺ꛦꛯ𐅀𐅴𐍁𐍁𐍊𐍊𐏑𐏕𒐀𒑮")) }, { _0: "Zl", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("  ")) }, { _0: "Zp", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("  ")) }, { _0: "Cs", _1: moonbitlang$core$string$regex$internal$regexp$internal$unicode$$cs }, { _0: "Co", _1: moonbitlang$core$builtin$$Iter$collect$3$(moonbitlang$core$string$$String$iter("󰀀󿿽􀀀􏿽")) }]);
function moonbitlang$core$abort$$abort$4$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$5$(msg) {
  $panic();
}
function moonbitlang$core$abort$$abort$6$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$7$(msg) {
  return $panic();
}
function moonbitlang$core$abort$$abort$8$(msg) {
  return $panic();
}
function moonbitlang$core$builtin$$StringBuilder$new$46$inner(size_hint) {
  return { val: "" };
}
function moonbitlang$core$builtin$$Logger$write_char$9$(self, ch) {
  const _bind$2 = self;
  _bind$2.val = `${_bind$2.val}${String.fromCodePoint(ch)}`;
}
function moonbitlang$core$builtin$$code_point_of_surrogate_pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function moonbitlang$core$string$$String$unsafe_char_at(self, index) {
  const c1 = self.charCodeAt(index);
  if (55296 <= c1 && c1 <= 56319) {
    const _tmp$2 = index + 1 | 0;
    const c2 = self.charCodeAt(_tmp$2);
    return moonbitlang$core$builtin$$code_point_of_surrogate_pair(c1, c2);
  } else {
    return c1;
  }
}
function moonbitlang$core$array$$Array$at$10$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$4$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$11$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$3$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$array$$Array$at$12$(self, index) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    return self[index];
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$Hasher$combine$13$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$13$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$4$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$4$(value, self);
}
function moonbitlang$core$builtin$$Hasher$combine$3$(self, value) {
  moonbitlang$core$builtin$$Hash$hash_combine$3$(value, self);
}
function moonbitlang$core$builtin$$Hasher$avalanche(self) {
  let acc = self.acc;
  acc = acc ^ (acc >>> 15 | 0);
  acc = Math.imul(acc, -2048144777) | 0;
  acc = acc ^ (acc >>> 13 | 0);
  acc = Math.imul(acc, -1028477379) | 0;
  acc = acc ^ (acc >>> 16 | 0);
  return acc;
}
function moonbitlang$core$builtin$$Hasher$finalize(self) {
  return moonbitlang$core$builtin$$Hasher$avalanche(self);
}
function moonbitlang$core$builtin$$Hasher$new$46$inner(seed) {
  return { acc: (seed >>> 0) + (374761393 >>> 0) | 0 };
}
function moonbitlang$core$builtin$$Hasher$new(seed$46$opt) {
  let seed;
  if (seed$46$opt === undefined) {
    seed = moonbitlang$core$builtin$$seed;
  } else {
    const _Some = seed$46$opt;
    seed = _Some;
  }
  return moonbitlang$core$builtin$$Hasher$new$46$inner(seed);
}
function moonbitlang$core$builtin$$Hash$hash$14$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$13$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$15$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$4$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$builtin$$Hash$hash$16$(self) {
  const _self = moonbitlang$core$builtin$$Hasher$new(undefined);
  moonbitlang$core$builtin$$Hasher$combine$3$(_self, self);
  return moonbitlang$core$builtin$$Hasher$finalize(_self);
}
function moonbitlang$core$int$$Int$to_string$46$inner(self, radix) {
  return moonbitlang$core$builtin$$int_to_string_js(self, radix);
}
function moonbitlang$core$string$$String$substring$46$inner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    end$2 = _Some;
  }
  return start >= 0 && (start <= end$2 && end$2 <= len) ? self.substring(start, end$2) : $panic();
}
function moonbitlang$core$builtin$$Logger$write_substring$9$(self, str, start, len) {
  const _bind$2 = self;
  _bind$2.val = `${_bind$2.val}${moonbitlang$core$string$$String$substring$46$inner(str, start, start + len | 0)}`;
}
function moonbitlang$core$builtin$$StringBuilder$write_iter(self, iter) {
  iter((ch) => {
    moonbitlang$core$builtin$$Logger$write_char$9$(self, ch);
    return 1;
  });
}
function moonbitlang$core$array$$Array$iter$3$(self) {
  const _p = (yield_) => {
    const _len = self.length;
    let _tmp$2 = 0;
    while (true) {
      const _i = _tmp$2;
      if (_i < _len) {
        const v = self[_i];
        const _bind$2 = yield_(v);
        if (_bind$2 === 1) {
        } else {
          return 0;
        }
        _tmp$2 = _i + 1 | 0;
        continue;
      } else {
        return 1;
      }
    }
  };
  return _p;
}
function moonbitlang$core$int$$Int$next_power_of_two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function moonbitlang$core$builtin$$Map$new$46$inner$17$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$2 = capacity$2 - 1 | 0;
  const _bind$3 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$4 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$5 = undefined;
  return { entries: _bind$4, size: 0, capacity: capacity$2, capacity_mask: _bind$2, grow_at: _bind$3, head: _bind$5, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$0$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$2 = capacity$2 - 1 | 0;
  const _bind$3 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$4 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$5 = undefined;
  return { entries: _bind$4, size: 0, capacity: capacity$2, capacity_mask: _bind$2, grow_at: _bind$3, head: _bind$5, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$1$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$2 = capacity$2 - 1 | 0;
  const _bind$3 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$4 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$5 = undefined;
  return { entries: _bind$4, size: 0, capacity: capacity$2, capacity_mask: _bind$2, grow_at: _bind$3, head: _bind$5, tail: -1 };
}
function moonbitlang$core$builtin$$Map$new$46$inner$2$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$2 = capacity$2 - 1 | 0;
  const _bind$3 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$4 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$5 = undefined;
  return { entries: _bind$4, size: 0, capacity: capacity$2, capacity_mask: _bind$2, grow_at: _bind$3, head: _bind$5, tail: -1 };
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$17$(self, idx, entry) {
  const _bind$2 = self.tail;
  if (_bind$2 === -1) {
    self.head = entry;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    _tmp$3.next = entry;
  }
  self.tail = idx;
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, idx);
  _tmp$2[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, idx, entry) {
  const _bind$2 = self.tail;
  if (_bind$2 === -1) {
    self.head = entry;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    _tmp$3.next = entry;
  }
  self.tail = idx;
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, idx);
  _tmp$2[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, idx, entry) {
  const _bind$2 = self.tail;
  if (_bind$2 === -1) {
    self.head = entry;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    _tmp$3.next = entry;
  }
  self.tail = idx;
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, idx);
  _tmp$2[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, idx, entry) {
  const _bind$2 = self.tail;
  if (_bind$2 === -1) {
    self.head = entry;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    _tmp$3.next = entry;
  }
  self.tail = idx;
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, idx);
  _tmp$2[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$builtin$$Map$set_entry$17$(self, entry, new_idx) {
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, new_idx);
  _tmp$2[new_idx] = entry;
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$0$(self, entry, new_idx) {
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, new_idx);
  _tmp$2[new_idx] = entry;
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$1$(self, entry, new_idx) {
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, new_idx);
  _tmp$2[new_idx] = entry;
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$set_entry$2$(self, entry, new_idx) {
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, new_idx);
  _tmp$2[new_idx] = entry;
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$builtin$$Map$push_away$17$(self, idx, entry) {
  let _tmp$2 = entry.psl + 1 | 0;
  let _tmp$3 = idx + 1 & self.capacity_mask;
  let _tmp$4 = entry;
  while (true) {
    const psl = _tmp$2;
    const idx$2 = _tmp$3;
    const entry$2 = _tmp$4;
    const _tmp$5 = self.entries;
    $bound_check(_tmp$5, idx$2);
    const _bind$2 = _tmp$5[idx$2];
    if (_bind$2 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$17$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$2;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$17$(self, entry$2, idx$2);
        _tmp$2 = _curr_entry.psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        _tmp$4 = _curr_entry;
        continue;
      } else {
        _tmp$2 = psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$0$(self, idx, entry) {
  let _tmp$2 = entry.psl + 1 | 0;
  let _tmp$3 = idx + 1 & self.capacity_mask;
  let _tmp$4 = entry;
  while (true) {
    const psl = _tmp$2;
    const idx$2 = _tmp$3;
    const entry$2 = _tmp$4;
    const _tmp$5 = self.entries;
    $bound_check(_tmp$5, idx$2);
    const _bind$2 = _tmp$5[idx$2];
    if (_bind$2 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$2;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$0$(self, entry$2, idx$2);
        _tmp$2 = _curr_entry.psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        _tmp$4 = _curr_entry;
        continue;
      } else {
        _tmp$2 = psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$1$(self, idx, entry) {
  let _tmp$2 = entry.psl + 1 | 0;
  let _tmp$3 = idx + 1 & self.capacity_mask;
  let _tmp$4 = entry;
  while (true) {
    const psl = _tmp$2;
    const idx$2 = _tmp$3;
    const entry$2 = _tmp$4;
    const _tmp$5 = self.entries;
    $bound_check(_tmp$5, idx$2);
    const _bind$2 = _tmp$5[idx$2];
    if (_bind$2 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$2;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$1$(self, entry$2, idx$2);
        _tmp$2 = _curr_entry.psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        _tmp$4 = _curr_entry;
        continue;
      } else {
        _tmp$2 = psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$push_away$2$(self, idx, entry) {
  let _tmp$2 = entry.psl + 1 | 0;
  let _tmp$3 = idx + 1 & self.capacity_mask;
  let _tmp$4 = entry;
  while (true) {
    const psl = _tmp$2;
    const idx$2 = _tmp$3;
    const entry$2 = _tmp$4;
    const _tmp$5 = self.entries;
    $bound_check(_tmp$5, idx$2);
    const _bind$2 = _tmp$5[idx$2];
    if (_bind$2 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$2;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$builtin$$Map$set_entry$2$(self, entry$2, idx$2);
        _tmp$2 = _curr_entry.psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        _tmp$4 = _curr_entry;
        continue;
      } else {
        _tmp$2 = psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$builtin$$Map$set_with_hash$17$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$17$(self);
  }
  let _bind$2;
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$3 = _tmp$4[idx];
    if (_bind$3 === undefined) {
      _bind$2 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$3;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$17$(self, idx, _curr_entry);
        _bind$2 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2 = psl + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$2._0;
  const _psl = _bind$2._1;
  const _bind$3 = self.tail;
  const _bind$4 = undefined;
  const entry = { prev: _bind$3, next: _bind$4, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$17$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$0$(self);
  }
  let _bind$2;
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$3 = _tmp$4[idx];
    if (_bind$3 === undefined) {
      _bind$2 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$3;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$0$(self, idx, _curr_entry);
        _bind$2 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2 = psl + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$2._0;
  const _psl = _bind$2._1;
  const _bind$3 = self.tail;
  const _bind$4 = undefined;
  const entry = { prev: _bind$3, next: _bind$4, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$0$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$1$(self);
  }
  let _bind$2;
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$3 = _tmp$4[idx];
    if (_bind$3 === undefined) {
      _bind$2 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$3;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$1$(self, idx, _curr_entry);
        _bind$2 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2 = psl + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$2._0;
  const _psl = _bind$2._1;
  const _bind$3 = self.tail;
  const _bind$4 = undefined;
  const entry = { prev: _bind$3, next: _bind$4, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$1$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$builtin$$Map$grow$2$(self);
  }
  let _bind$2;
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$3 = _tmp$4[idx];
    if (_bind$3 === undefined) {
      _bind$2 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$3;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$builtin$$Map$push_away$2$(self, idx, _curr_entry);
        _bind$2 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2 = psl + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$2._0;
  const _psl = _bind$2._1;
  const _bind$3 = self.tail;
  const _bind$4 = undefined;
  const entry = { prev: _bind$3, next: _bind$4, psl: _psl, hash: hash, key: key, value: value };
  moonbitlang$core$builtin$$Map$add_entry_to_tail$2$(self, _idx, entry);
}
function moonbitlang$core$builtin$$Map$grow$17$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2 = old_head;
  while (true) {
    const _param = _tmp$2;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$17$(self, _key, _value, _hash);
      _tmp$2 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$0$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2 = old_head;
  while (true) {
    const _param = _tmp$2;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$0$(self, _key, _value, _hash);
      _tmp$2 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$1$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2 = old_head;
  while (true) {
    const _param = _tmp$2;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$1$(self, _key, _value, _hash);
      _tmp$2 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$grow$2$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2 = old_head;
  while (true) {
    const _param = _tmp$2;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _value = _x.value;
      const _hash = _x.hash;
      moonbitlang$core$builtin$$Map$set_with_hash$2$(self, _key, _value, _hash);
      _tmp$2 = _next;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$set$17$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$17$(self, key, value, moonbitlang$core$builtin$$Hash$hash$14$(key));
}
function moonbitlang$core$builtin$$Map$set$0$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$0$(self, key, value, moonbitlang$core$builtin$$Hash$hash$16$(key));
}
function moonbitlang$core$builtin$$Map$set$1$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$1$(self, key, value, moonbitlang$core$builtin$$Hash$hash$14$(key));
}
function moonbitlang$core$builtin$$Map$set$2$(self, key, value) {
  moonbitlang$core$builtin$$Map$set_with_hash$2$(self, key, value, moonbitlang$core$builtin$$Hash$hash$14$(key));
}
function moonbitlang$core$builtin$$Map$from_array$17$(arr) {
  const length = arr.length;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$builtin$$Map$new$46$inner$17$(capacity);
  const _p$2 = arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _p$3 = _tmp$2;
    if (_p$3 < _p$2) {
      const _p$4 = arr[_p$3];
      moonbitlang$core$builtin$$Map$set$17$(m, _p$4._0, _p$4._1);
      _tmp$2 = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$builtin$$Map$from_array$1$(arr) {
  const length = arr.length;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$builtin$$Map$new$46$inner$1$(capacity);
  const _p$2 = arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _p$3 = _tmp$2;
    if (_p$3 < _p$2) {
      const _p$4 = arr[_p$3];
      moonbitlang$core$builtin$$Map$set$1$(m, _p$4._0, _p$4._1);
      _tmp$2 = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$builtin$$Map$from_array$2$(arr) {
  const length = arr.length;
  let capacity = moonbitlang$core$int$$Int$next_power_of_two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  const m = moonbitlang$core$builtin$$Map$new$46$inner$2$(capacity);
  const _p$2 = arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _p$3 = _tmp$2;
    if (_p$3 < _p$2) {
      const _p$4 = arr[_p$3];
      moonbitlang$core$builtin$$Map$set$2$(m, _p$4._0, _p$4._1);
      _tmp$2 = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function moonbitlang$core$builtin$$Map$get$17$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$14$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$0$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$16$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      return -1;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return -1;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$1$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$14$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      return undefined;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$get$2$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$14$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      return Option$None$0$;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return new Option$Some$0$(_entry.value);
      }
      if (i > _entry.psl) {
        return Option$None$0$;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$builtin$$Map$contains$17$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$14$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      return false;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$array$$Array$push$10$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$13$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$6$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$18$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$11$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$4$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$19$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$3$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$array$$Array$push$12$(self, value) {
  moonbitlang$core$builtin$$JSArray$push(self, value);
}
function moonbitlang$core$builtin$$Iter$each$20$(self, f) {
  const _foreach_result = { val: $64$moonbitlang$47$core$47$builtin$46$ForeachResult$Continue$1$ };
  self((a) => {
    f(a);
    return 1;
  });
  const _tmp$2 = _foreach_result.val;
  switch (_tmp$2.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _break = _tmp$2;
      _break._0;
      return;
    }
    case 2: {
      const _return = _tmp$2;
      return _return._0;
    }
    case 3: {
      $panic();
      return;
    }
    default: {
      $panic();
      return;
    }
  }
}
function moonbitlang$core$builtin$$Iter$to_array$6$(self) {
  const result = [];
  self((e) => {
    moonbitlang$core$array$$Array$push$6$(result, e);
    return 1;
  });
  return result;
}
function moonbitlang$core$builtin$$Iter$collect$3$(self) {
  const result = [];
  moonbitlang$core$builtin$$Iter$each$20$(self, (e) => {
    moonbitlang$core$array$$Array$push$3$(result, e);
  });
  return result;
}
function moonbitlang$core$builtin$$Hasher$consume4(self, input) {
  const _p = (self.acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  self.acc = Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function moonbitlang$core$builtin$$Hasher$combine_uint(self, value) {
  self.acc = (self.acc >>> 0) + (4 >>> 0) | 0;
  moonbitlang$core$builtin$$Hasher$consume4(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine_int(self, value) {
  moonbitlang$core$builtin$$Hasher$combine_uint(self, value);
}
function moonbitlang$core$builtin$$Hasher$combine_string(self, value) {
  const _end858 = value.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end858) {
      moonbitlang$core$builtin$$Hasher$combine_uint(self, value.charCodeAt(i));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$builtin$$Hasher$combine_char(self, value) {
  moonbitlang$core$builtin$$Hasher$combine_uint(self, value);
}
function moonbitlang$core$builtin$$Hash$hash_combine$13$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_string(hasher, self);
}
function moonbitlang$core$builtin$$Hash$hash_combine$4$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_int(hasher, self);
}
function moonbitlang$core$builtin$$println$13$(input) {
  console.log(input);
}
function moonbitlang$core$array$$Array$sub$46$inner$12$(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  return start$2 >= 0 && (start$2 <= end$2 && end$2 <= len) ? { buf: self, start: start$2, end: end$2 } : moonbitlang$core$abort$$abort$8$("View index out of bounds");
}
function moonbitlang$core$array$$Array$new$46$inner$18$(capacity) {
  return [];
}
function moonbitlang$core$array$$Array$unsafe_truncate_to_length$18$(self, new_len) {
  moonbitlang$core$builtin$$JSArray$set_length(self, new_len);
}
function moonbitlang$core$array$$Array$make$4$(len, elem) {
  const arr = new Array(len);
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < len) {
      arr[i] = elem;
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return arr;
}
function moonbitlang$core$array$$Array$set$4$(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function moonbitlang$core$array$$Array$set$11$(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function moonbitlang$core$array$$Array$set$12$(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    $bound_check(self, index);
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function moonbitlang$core$array$$Array$clear$18$(self) {
  moonbitlang$core$array$$Array$unsafe_truncate_to_length$18$(self, 0);
}
function moonbitlang$core$array$$ArrayView$join$13$(self, separator) {
  if ((self.end - self.start | 0) === 0) {
    return "";
  } else {
    const _hd = self.buf[self.start];
    const _bind$2 = self.buf;
    const _bind$3 = 1 + self.start | 0;
    const _bind$4 = self.end;
    const _x = { buf: _bind$2, start: _bind$3, end: _bind$4 };
    const hd = moonbitlang$core$string$$ToStringView$to_string_view$13$(_hd);
    let size_hint = hd.end - hd.start | 0;
    const _len = _x.end - _x.start | 0;
    let _tmp$2 = 0;
    while (true) {
      const _i = _tmp$2;
      if (_i < _len) {
        const s = _bind$2[_bind$3 + _i | 0];
        const _tmp$3 = size_hint;
        const _p = moonbitlang$core$string$$ToStringView$to_string_view$13$(s);
        size_hint = _tmp$3 + ((_p.end - _p.start | 0) + (separator.end - separator.start | 0) | 0) | 0;
        _tmp$2 = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    size_hint = size_hint << 1;
    const buf = moonbitlang$core$builtin$$StringBuilder$new$46$inner(size_hint);
    moonbitlang$core$builtin$$Logger$write_substring$9$(buf, hd.str, hd.start, hd.end - hd.start | 0);
    if (moonbitlang$core$string$$String$char_length_eq$46$inner(separator.str, 0, separator.start, separator.end)) {
      const _len$2 = _x.end - _x.start | 0;
      let _tmp$3 = 0;
      while (true) {
        const _i = _tmp$3;
        if (_i < _len$2) {
          const s = _bind$2[_bind$3 + _i | 0];
          const s$2 = moonbitlang$core$string$$ToStringView$to_string_view$13$(s);
          moonbitlang$core$builtin$$Logger$write_substring$9$(buf, s$2.str, s$2.start, s$2.end - s$2.start | 0);
          _tmp$3 = _i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    } else {
      const _len$2 = _x.end - _x.start | 0;
      let _tmp$3 = 0;
      while (true) {
        const _i = _tmp$3;
        if (_i < _len$2) {
          const s = _bind$2[_bind$3 + _i | 0];
          const s$2 = moonbitlang$core$string$$ToStringView$to_string_view$13$(s);
          moonbitlang$core$builtin$$Logger$write_substring$9$(buf, separator.str, separator.start, separator.end - separator.start | 0);
          moonbitlang$core$builtin$$Logger$write_substring$9$(buf, s$2.str, s$2.start, s$2.end - s$2.start | 0);
          _tmp$3 = _i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
    return buf.val;
  }
}
function moonbitlang$core$array$$get_limit(len) {
  let len$2 = len;
  let limit = 0;
  while (true) {
    if (len$2 > 0) {
      len$2 = len$2 / 2 | 0;
      limit = limit + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return limit;
}
function moonbitlang$core$array$$Array$bubble_sort_by$12$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const _start1309 = actual_start + 1 | 0;
  let _tmp$2 = _start1309;
  while (true) {
    const i = _tmp$2;
    if (i < actual_end) {
      let _tmp$3 = i;
      while (true) {
        const j = _tmp$3;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$12$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$12$(arr, j)) > 0) {
          const temp = moonbitlang$core$array$$Array$at$12$(arr, j);
          moonbitlang$core$array$$Array$set$12$(arr, j, moonbitlang$core$array$$Array$at$12$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$12$(arr, j - 1 | 0, temp);
          _tmp$3 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$582(_env, a_idx, b_idx) {
  const actual_start = _env._3;
  const swaps = _env._2;
  const cmp = _env._1;
  const arr = _env._0;
  const a_pos = actual_start + a_idx | 0;
  const b_pos = actual_start + b_idx | 0;
  if (cmp(moonbitlang$core$array$$Array$at$12$(arr, a_pos), moonbitlang$core$array$$Array$at$12$(arr, b_pos)) > 0) {
    const temp = moonbitlang$core$array$$Array$at$12$(arr, a_pos);
    moonbitlang$core$array$$Array$set$12$(arr, a_pos, moonbitlang$core$array$$Array$at$12$(arr, b_pos));
    moonbitlang$core$array$$Array$set$12$(arr, b_pos, temp);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$583(_env, a_idx, b_idx, c_idx) {
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$582(_env, a_idx, b_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$582(_env, b_idx, c_idx);
  moonbitlang$core$array$$choose_pivot_by$46$sort_2$47$582(_env, a_idx, b_idx);
}
function moonbitlang$core$array$$Array$choose_pivot_by$12$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const len = actual_end - actual_start | 0;
  const swaps = { val: 0 };
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: arr, _1: cmp, _2: swaps, _3: actual_start };
    if (len > 50) {
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$583(_env, a - 1 | 0, a, a + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$583(_env, b - 1 | 0, b, b + 1 | 0);
      moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$583(_env, c - 1 | 0, c, c + 1 | 0);
    }
    moonbitlang$core$array$$choose_pivot_by$46$sort_3$47$583(_env, a, b, c);
  }
  if (swaps.val === 12) {
    const mid_len = len / 2 | 0;
    let _tmp$2 = 0;
    while (true) {
      const i = _tmp$2;
      if (i < mid_len) {
        const j = (len - i | 0) - 1 | 0;
        const i_pos = actual_start + i | 0;
        const j_pos = actual_start + j | 0;
        const temp = moonbitlang$core$array$$Array$at$12$(arr, i_pos);
        moonbitlang$core$array$$Array$set$12$(arr, i_pos, moonbitlang$core$array$$Array$at$12$(arr, j_pos));
        moonbitlang$core$array$$Array$set$12$(arr, j_pos, temp);
        _tmp$2 = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return { _0: ((actual_start + len | 0) - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: actual_start + b | 0, _1: swaps.val === 0 };
  }
}
function moonbitlang$core$array$$Array$sift_down_by$12$(arr, start, end, index, cmp) {
  let current = index;
  const len = end - start | 0;
  let child = (Math.imul(current, 2) | 0) + 1 | 0;
  while (true) {
    if (child < len) {
      const child_pos = start + child | 0;
      const current_pos = start + current | 0;
      if ((child + 1 | 0) < len && cmp(moonbitlang$core$array$$Array$at$12$(arr, child_pos), moonbitlang$core$array$$Array$at$12$(arr, child_pos + 1 | 0)) < 0) {
        child = child + 1 | 0;
      }
      const new_child_pos = start + child | 0;
      if (cmp(moonbitlang$core$array$$Array$at$12$(arr, current_pos), moonbitlang$core$array$$Array$at$12$(arr, new_child_pos)) >= 0) {
        return undefined;
      }
      const temp = moonbitlang$core$array$$Array$at$12$(arr, current_pos);
      moonbitlang$core$array$$Array$set$12$(arr, current_pos, moonbitlang$core$array$$Array$at$12$(arr, new_child_pos));
      moonbitlang$core$array$$Array$set$12$(arr, new_child_pos, temp);
      current = child;
      child = (Math.imul(current, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$heap_sort_by$12$(arr, start, end, cmp) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return undefined;
  }
  const len = actual_end - actual_start | 0;
  let _tmp$2 = (len / 2 | 0) - 1 | 0;
  while (true) {
    const i = _tmp$2;
    if (i >= 0) {
      moonbitlang$core$array$$Array$sift_down_by$12$(arr, actual_start, actual_end, i, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$3 = len - 1 | 0;
  while (true) {
    const i = _tmp$3;
    if (i > 0) {
      const last = actual_start + i | 0;
      const temp = moonbitlang$core$array$$Array$at$12$(arr, actual_start);
      moonbitlang$core$array$$Array$set$12$(arr, actual_start, moonbitlang$core$array$$Array$at$12$(arr, last));
      moonbitlang$core$array$$Array$set$12$(arr, last, temp);
      moonbitlang$core$array$$Array$sift_down_by$12$(arr, actual_start, actual_start + i | 0, 0, cmp);
      _tmp$3 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function moonbitlang$core$array$$Array$partition_by$12$(arr, start, end, cmp, pivot_index) {
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return { _0: actual_start, _1: true };
  }
  const last_index = actual_end - 1 | 0;
  const temp = moonbitlang$core$array$$Array$at$12$(arr, pivot_index);
  moonbitlang$core$array$$Array$set$12$(arr, pivot_index, moonbitlang$core$array$$Array$at$12$(arr, last_index));
  moonbitlang$core$array$$Array$set$12$(arr, last_index, temp);
  const pivot = moonbitlang$core$array$$Array$at$12$(arr, last_index);
  let i = actual_start;
  let partitioned = true;
  let _tmp$2 = actual_start;
  while (true) {
    const j = _tmp$2;
    if (j < last_index) {
      if (cmp(moonbitlang$core$array$$Array$at$12$(arr, j), pivot) < 0) {
        if (i !== j) {
          const temp$2 = moonbitlang$core$array$$Array$at$12$(arr, i);
          moonbitlang$core$array$$Array$set$12$(arr, i, moonbitlang$core$array$$Array$at$12$(arr, j));
          moonbitlang$core$array$$Array$set$12$(arr, j, temp$2);
          partitioned = false;
        }
        i = i + 1 | 0;
      }
      _tmp$2 = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const temp$2 = moonbitlang$core$array$$Array$at$12$(arr, i);
  moonbitlang$core$array$$Array$set$12$(arr, i, moonbitlang$core$array$$Array$at$12$(arr, last_index));
  moonbitlang$core$array$$Array$set$12$(arr, last_index, temp$2);
  return { _0: i, _1: partitioned };
}
function moonbitlang$core$array$$Array$try_bubble_sort_by$12$(arr, start, end, cmp) {
  let tries = 0;
  const actual_start = start < 0 ? 0 : start;
  const actual_end = end > arr.length ? arr.length : end;
  if (actual_start >= actual_end) {
    return true;
  }
  const _start1324 = actual_start + 1 | 0;
  let _tmp$2 = _start1324;
  while (true) {
    const i = _tmp$2;
    if (i < actual_end) {
      let sorted = true;
      let _tmp$3 = i;
      while (true) {
        const j = _tmp$3;
        if (j > actual_start && cmp(moonbitlang$core$array$$Array$at$12$(arr, j - 1 | 0), moonbitlang$core$array$$Array$at$12$(arr, j)) > 0) {
          sorted = false;
          const temp = moonbitlang$core$array$$Array$at$12$(arr, j);
          moonbitlang$core$array$$Array$set$12$(arr, j, moonbitlang$core$array$$Array$at$12$(arr, j - 1 | 0));
          moonbitlang$core$array$$Array$set$12$(arr, j - 1 | 0, temp);
          _tmp$3 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (!sorted) {
        tries = tries + 1 | 0;
        if (tries > 8) {
          return false;
        }
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function moonbitlang$core$array$$Array$quick_sort_by$12$(arr, start, end, cmp, pred, limit) {
  let limit$2 = limit;
  let current_start = start;
  let current_end = end;
  let pred$2 = pred;
  let was_partitioned = true;
  let balanced = true;
  while (true) {
    const len = current_end - current_start | 0;
    if (len <= 16) {
      if (len >= 2) {
        moonbitlang$core$array$$Array$bubble_sort_by$12$(arr, current_start, current_end, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      moonbitlang$core$array$$Array$heap_sort_by$12$(arr, current_start, current_end, cmp);
      return undefined;
    }
    const _bind$2 = moonbitlang$core$array$$Array$choose_pivot_by$12$(arr, current_start, current_end, cmp);
    const _pivot_index = _bind$2._0;
    const _likely_sorted = _bind$2._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (moonbitlang$core$array$$Array$try_bubble_sort_by$12$(arr, current_start, current_end, cmp)) {
        return undefined;
      }
    }
    const _bind$3 = moonbitlang$core$array$$Array$partition_by$12$(arr, current_start, current_end, cmp, _pivot_index);
    const _actual_pivot_pos = _bind$3._0;
    const _partitioned = _bind$3._1;
    was_partitioned = _partitioned;
    const pivot_pos = _actual_pivot_pos - current_start | 0;
    const diff = len - pivot_pos | 0;
    balanced = (pivot_pos < diff ? pivot_pos : diff) >= (len / 8 | 0);
    if (!balanced) {
      limit$2 = limit$2 - 1 | 0;
    }
    const _bind$4 = pred$2;
    if (_bind$4 === undefined) {
    } else {
      const _Some = _bind$4;
      const _pred = _Some;
      if (cmp(_pred, moonbitlang$core$array$$Array$at$12$(arr, _actual_pivot_pos)) === 0) {
        let i = _actual_pivot_pos;
        while (true) {
          if (i < current_end && cmp(_pred, moonbitlang$core$array$$Array$at$12$(arr, i)) === 0) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        current_start = i;
        continue;
      }
    }
    const left_start = current_start;
    const right_start = _actual_pivot_pos + 1 | 0;
    const right_end = current_end;
    if ((_actual_pivot_pos - left_start | 0) < (right_end - right_start | 0)) {
      moonbitlang$core$array$$Array$quick_sort_by$12$(arr, left_start, _actual_pivot_pos, cmp, pred$2, limit$2);
      pred$2 = moonbitlang$core$array$$Array$at$12$(arr, _actual_pivot_pos);
      current_start = right_start;
      current_end = right_end;
    } else {
      moonbitlang$core$array$$Array$quick_sort_by$12$(arr, right_start, right_end, cmp, moonbitlang$core$array$$Array$at$12$(arr, _actual_pivot_pos), limit$2);
      current_start = left_start;
      current_end = _actual_pivot_pos;
    }
    continue;
  }
}
function moonbitlang$core$array$$Array$sort_by_key$21$(self, map$2) {
  moonbitlang$core$array$$Array$quick_sort_by$12$(self, 0, self.length, (a, b) => $compare_int(map$2(a), map$2(b)), undefined, moonbitlang$core$array$$get_limit(self.length));
}
function moonbitlang$core$array$$Array$copy$4$(self) {
  return moonbitlang$core$array$$JSArray$copy(self);
}
function moonbitlang$core$array$$Array$join$13$(self, separator) {
  return moonbitlang$core$array$$ArrayView$join$13$({ buf: self, start: 0, end: self.length }, separator);
}
function moonbitlang$core$builtin$$Hash$hash_combine$3$(self, hasher) {
  moonbitlang$core$builtin$$Hasher$combine_char(hasher, self);
}
function moonbitlang$core$builtin$$Show$to_string$3$(self) {
  return String.fromCodePoint(self);
}
function moonbitlang$core$set$$Set$new$46$inner$4$(capacity) {
  const capacity$2 = moonbitlang$core$int$$Int$next_power_of_two(capacity);
  const _bind$2 = capacity$2 - 1 | 0;
  const _bind$3 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$4 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$5 = undefined;
  return { entries: _bind$4, size: 0, capacity: capacity$2, capacity_mask: _bind$2, grow_at: _bind$3, head: _bind$5, tail: -1 };
}
function moonbitlang$core$set$$Set$add_entry_to_tail$4$(self, idx, entry) {
  const _bind$2 = self.tail;
  if (_bind$2 === -1) {
    self.head = entry;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    _tmp$3.next = entry;
  }
  self.tail = idx;
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, idx);
  _tmp$2[idx] = entry;
  self.size = self.size + 1 | 0;
}
function moonbitlang$core$set$$Set$set_entry$4$(self, entry, new_idx) {
  const _tmp$2 = self.entries;
  $bound_check(_tmp$2, new_idx);
  _tmp$2[new_idx] = entry;
  const _bind$2 = entry.next;
  if (_bind$2 === undefined) {
    self.tail = new_idx;
    return;
  } else {
    const _Some = _bind$2;
    const _next = _Some;
    _next.prev = new_idx;
    return;
  }
}
function moonbitlang$core$set$$Set$push_away$4$(self, idx, entry) {
  let _tmp$2 = entry.psl + 1 | 0;
  let _tmp$3 = idx + 1 & self.capacity_mask;
  let _tmp$4 = entry;
  while (true) {
    const psl = _tmp$2;
    const idx$2 = _tmp$3;
    const entry$2 = _tmp$4;
    const _tmp$5 = self.entries;
    $bound_check(_tmp$5, idx$2);
    const _bind$2 = _tmp$5[idx$2];
    if (_bind$2 === undefined) {
      entry$2.psl = psl;
      moonbitlang$core$set$$Set$set_entry$4$(self, entry$2, idx$2);
      break;
    } else {
      const _Some = _bind$2;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        moonbitlang$core$set$$Set$set_entry$4$(self, entry$2, idx$2);
        _tmp$2 = _curr_entry.psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        _tmp$4 = _curr_entry;
        continue;
      } else {
        _tmp$2 = psl + 1 | 0;
        _tmp$3 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function moonbitlang$core$set$$Set$add_with_hash$4$(self, key, hash) {
  if (self.size >= self.grow_at) {
    moonbitlang$core$set$$Set$grow$4$(self);
  }
  let _bind$2;
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$3 = _tmp$4[idx];
    if (_bind$3 === undefined) {
      _bind$2 = { _0: idx, _1: psl };
      break;
    } else {
      const _Some = _bind$3;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        moonbitlang$core$set$$Set$push_away$4$(self, idx, _curr_entry);
        _bind$2 = { _0: idx, _1: psl };
        break;
      }
      _tmp$2 = psl + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
  const _idx = _bind$2._0;
  const _psl = _bind$2._1;
  const _bind$3 = self.tail;
  const _bind$4 = undefined;
  const entry = { prev: _bind$3, next: _bind$4, psl: _psl, hash: hash, key: key };
  moonbitlang$core$set$$Set$add_entry_to_tail$4$(self, _idx, entry);
}
function moonbitlang$core$set$$Set$grow$4$(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp$2 = old_head;
  while (true) {
    const _param = _tmp$2;
    if (_param === undefined) {
      return;
    } else {
      const _Some = _param;
      const _x = _Some;
      const _next = _x.next;
      const _key = _x.key;
      const _hash = _x.hash;
      moonbitlang$core$set$$Set$add_with_hash$4$(self, _key, _hash);
      _tmp$2 = _next;
      continue;
    }
  }
}
function moonbitlang$core$set$$Set$add$4$(self, key) {
  moonbitlang$core$set$$Set$add_with_hash$4$(self, key, moonbitlang$core$builtin$$Hash$hash$15$(key));
}
function moonbitlang$core$set$$Set$remove_entry$4$(self, entry) {
  const _bind$2 = entry.prev;
  if (_bind$2 === -1) {
    self.head = entry.next;
  } else {
    const _tmp$2 = self.entries;
    $bound_check(_tmp$2, _bind$2);
    const _p = _tmp$2[_bind$2];
    let _tmp$3;
    if (_p === undefined) {
      _tmp$3 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$3 = _p$2;
    }
    const _tmp$4 = _tmp$3;
    _tmp$4.next = entry.next;
  }
  const _bind$3 = entry.next;
  if (_bind$3 === undefined) {
    self.tail = entry.prev;
    return;
  } else {
    const _Some = _bind$3;
    const _next = _Some;
    _next.prev = entry.prev;
    return;
  }
}
function moonbitlang$core$set$$Set$shift_back$4$(self, idx) {
  let _tmp$2 = idx;
  while (true) {
    const idx$2 = _tmp$2;
    const next = idx$2 + 1 & self.capacity_mask;
    _L: {
      const _tmp$3 = self.entries;
      $bound_check(_tmp$3, next);
      const _bind$2 = _tmp$3[next];
      if (_bind$2 === undefined) {
        break _L;
      } else {
        const _Some = _bind$2;
        const _x = _Some;
        const _x$2 = _x.psl;
        if (_x$2 === 0) {
          break _L;
        } else {
          _x.psl = _x.psl - 1 | 0;
          moonbitlang$core$set$$Set$set_entry$4$(self, _x, idx$2);
          _tmp$2 = next;
          continue;
        }
      }
    }
    const _tmp$3 = self.entries;
    $bound_check(_tmp$3, idx$2);
    _tmp$3[idx$2] = undefined;
    return;
  }
}
function moonbitlang$core$set$$Set$remove$4$(self, key) {
  const hash = moonbitlang$core$builtin$$Hash$hash$15$(key);
  let _tmp$2 = 0;
  let _tmp$3 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp$2;
    const idx = _tmp$3;
    const _tmp$4 = self.entries;
    $bound_check(_tmp$4, idx);
    const _bind$2 = _tmp$4[idx];
    if (_bind$2 === undefined) {
      break;
    } else {
      const _Some = _bind$2;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        moonbitlang$core$set$$Set$remove_entry$4$(self, _entry);
        moonbitlang$core$set$$Set$shift_back$4$(self, idx);
        self.size = self.size - 1 | 0;
        break;
      }
      if (i > _entry.psl) {
        break;
      }
      _tmp$2 = i + 1 | 0;
      _tmp$3 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function moonbitlang$core$string$$StringView$at(self, index) {
  if (index >= 0 && index < (self.end - self.start | 0)) {
    const _tmp$2 = self.str;
    const _tmp$3 = self.start + index | 0;
    return _tmp$2.charCodeAt(_tmp$3);
  } else {
    return moonbitlang$core$abort$$abort$4$("Index out of bounds");
  }
}
function moonbitlang$core$string$$String$view$46$inner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length) ? { str: self, start: start_offset, end: end_offset$2 } : moonbitlang$core$abort$$abort$6$("Invalid index for View");
}
function moonbitlang$core$string$$StringView$view$46$inner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.end - self.start | 0;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= (self.end - self.start | 0)) ? { str: self.str, start: self.start + start_offset | 0, end: self.start + end_offset$2 | 0 } : moonbitlang$core$abort$$abort$6$("Invalid index for View");
}
function moonbitlang$core$string$$String$offset_of_nth_char_backward(self, n, start_offset, end_offset) {
  let char_count = 0;
  let utf16_offset = end_offset;
  while (true) {
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const _tmp$2 = utf16_offset - 1 | 0;
      const c = self.charCodeAt(_tmp$2);
      if (56320 <= c && c <= 57343) {
        utf16_offset = utf16_offset - 2 | 0;
      } else {
        utf16_offset = utf16_offset - 1 | 0;
      }
      char_count = char_count + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
}
function moonbitlang$core$string$$String$offset_of_nth_char_forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let utf16_offset = start_offset;
    let char_count = 0;
    while (true) {
      if (utf16_offset < end_offset && char_count < n) {
        const _tmp$2 = utf16_offset;
        const c = self.charCodeAt(_tmp$2);
        if (55296 <= c && c <= 56319) {
          utf16_offset = utf16_offset + 2 | 0;
        } else {
          utf16_offset = utf16_offset + 1 | 0;
        }
        char_count = char_count + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
  } else {
    return moonbitlang$core$abort$$abort$7$("Invalid start index");
  }
}
function moonbitlang$core$string$$String$offset_of_nth_char$46$inner(self, i, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return i >= 0 ? moonbitlang$core$string$$String$offset_of_nth_char_forward(self, i, start_offset, end_offset$2) : moonbitlang$core$string$$String$offset_of_nth_char_backward(self, -i | 0, start_offset, end_offset$2);
}
function moonbitlang$core$string$$String$char_length_eq$46$inner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp$2 = start_offset;
  let _tmp$3 = 0;
  while (true) {
    const index = _tmp$2;
    const count = _tmp$3;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (55296 <= c1 && c1 <= 56319 && (index + 1 | 0) < end_offset$2) {
        const _tmp$4 = index + 1 | 0;
        const c2 = self.charCodeAt(_tmp$4);
        if (56320 <= c2 && c2 <= 57343) {
          _tmp$2 = index + 2 | 0;
          _tmp$3 = count + 1 | 0;
          continue;
        } else {
          moonbitlang$core$abort$$abort$5$("invalid surrogate pair");
        }
      }
      _tmp$2 = index + 1 | 0;
      _tmp$3 = count + 1 | 0;
      continue;
    } else {
      return count === len && index === end_offset$2;
    }
  }
}
function moonbitlang$core$string$$String$char_length_ge$46$inner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp$2 = start_offset;
  let _tmp$3 = 0;
  while (true) {
    const index = _tmp$2;
    const count = _tmp$3;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (55296 <= c1 && c1 <= 56319 && (index + 1 | 0) < end_offset$2) {
        const _tmp$4 = index + 1 | 0;
        const c2 = self.charCodeAt(_tmp$4);
        if (56320 <= c2 && c2 <= 57343) {
          _tmp$2 = index + 2 | 0;
          _tmp$3 = count + 1 | 0;
          continue;
        } else {
          moonbitlang$core$abort$$abort$5$("invalid surrogate pair");
        }
      }
      _tmp$2 = index + 1 | 0;
      _tmp$3 = count + 1 | 0;
      continue;
    } else {
      return count >= len;
    }
  }
}
function moonbitlang$core$builtin$$Show$to_string$6$(self) {
  return self.str.substring(self.start, self.end);
}
function moonbitlang$core$string$$code_point_of_surrogate_pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function moonbitlang$core$string$$StringView$iter(self) {
  const _p = (yield_) => {
    const _start555 = self.start;
    const _end556 = self.end;
    let _tmp$2 = _start555;
    while (true) {
      const index = _tmp$2;
      if (index < _end556) {
        const _tmp$3 = self.str;
        const c1 = _tmp$3.charCodeAt(index);
        if (55296 <= c1 && c1 <= 56319 && (index + 1 | 0) < self.end) {
          const _tmp$4 = self.str;
          const _tmp$5 = index + 1 | 0;
          const c2 = _tmp$4.charCodeAt(_tmp$5);
          if (56320 <= c2 && c2 <= 57343) {
            const c = moonbitlang$core$string$$code_point_of_surrogate_pair(c1, c2);
            const _bind$2 = yield_(c);
            if (_bind$2 === 1) {
              _tmp$2 = index + 2 | 0;
              continue;
            } else {
              return 0;
            }
          }
        }
        const _bind$2 = yield_(c1);
        if (_bind$2 === 1) {
        } else {
          return 0;
        }
        _tmp$2 = index + 1 | 0;
        continue;
      } else {
        return 1;
      }
    }
  };
  return _p;
}
function moonbitlang$core$string$$String$from_array(chars) {
  const buf = moonbitlang$core$builtin$$StringBuilder$new$46$inner(Math.imul(chars.end - chars.start | 0, 4) | 0);
  const _len = chars.end - chars.start | 0;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const c = chars.buf[chars.start + _i | 0];
      moonbitlang$core$builtin$$Logger$write_char$9$(buf, c);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return buf.val;
}
function moonbitlang$core$string$$String$from_iter(iter) {
  const chars = moonbitlang$core$builtin$$Iter$collect$3$(iter);
  return moonbitlang$core$string$$String$from_array({ buf: chars, start: 0, end: chars.length });
}
function moonbitlang$core$string$$ToStringView$to_string_view$13$(self) {
  return { str: self, start: 0, end: self.length };
}
function moonbitlang$core$string$$String$iter(self) {
  const _p = (yield_) => {
    const len = self.length;
    let _tmp$2 = 0;
    while (true) {
      const index = _tmp$2;
      if (index < len) {
        const c1 = self.charCodeAt(index);
        if (55296 <= c1 && c1 <= 56319 && (index + 1 | 0) < len) {
          const _tmp$3 = index + 1 | 0;
          const c2 = self.charCodeAt(_tmp$3);
          if (56320 <= c2 && c2 <= 57343) {
            const c = moonbitlang$core$string$$code_point_of_surrogate_pair(c1, c2);
            const _bind$2 = yield_(c);
            if (_bind$2 === 1) {
              _tmp$2 = index + 2 | 0;
              continue;
            } else {
              return 0;
            }
          }
        }
        const _bind$2 = yield_(c1);
        if (_bind$2 === 1) {
        } else {
          return 0;
        }
        _tmp$2 = index + 1 | 0;
        continue;
      } else {
        return 1;
      }
    }
  };
  return _p;
}
function moonbitlang$core$string$$boyer_moore_horspool_find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const skip_table = $make_array_len_and_init(256, needle_len);
      const _end320 = needle_len - 1 | 0;
      let _tmp$2 = 0;
      while (true) {
        const i = _tmp$2;
        if (i < _end320) {
          const _tmp$3 = needle.str;
          const _tmp$4 = needle.start + i | 0;
          const _tmp$5 = _tmp$3.charCodeAt(_tmp$4) & 255;
          $bound_check(skip_table, _tmp$5);
          skip_table[_tmp$5] = (needle_len - 1 | 0) - i | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let _tmp$3 = 0;
      while (true) {
        const i = _tmp$3;
        if (i <= (haystack_len - needle_len | 0)) {
          const _end326 = needle_len - 1 | 0;
          let _tmp$4 = 0;
          while (true) {
            const j = _tmp$4;
            if (j <= _end326) {
              const _p = i + j | 0;
              const _tmp$5 = haystack.str;
              const _tmp$6 = haystack.start + _p | 0;
              const _tmp$7 = _tmp$5.charCodeAt(_tmp$6);
              const _tmp$8 = needle.str;
              const _tmp$9 = needle.start + j | 0;
              if (_tmp$7 !== _tmp$8.charCodeAt(_tmp$9)) {
                break;
              }
              _tmp$4 = j + 1 | 0;
              continue;
            } else {
              return i;
            }
          }
          const _p = (i + needle_len | 0) - 1 | 0;
          const _tmp$5 = haystack.str;
          const _tmp$6 = haystack.start + _p | 0;
          const _tmp$7 = _tmp$5.charCodeAt(_tmp$6) & 255;
          $bound_check(skip_table, _tmp$7);
          _tmp$3 = i + skip_table[_tmp$7] | 0;
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return moonbitlang$core$string$$boyer_moore_horspool_find$46$constr$47$888;
  }
}
function moonbitlang$core$string$$brute_force_find(haystack, needle) {
  const haystack_len = haystack.end - haystack.start | 0;
  const needle_len = needle.end - needle.start | 0;
  if (needle_len > 0) {
    if (haystack_len >= needle_len) {
      const _p = 0;
      const _tmp$2 = needle.str;
      const _tmp$3 = needle.start + _p | 0;
      const needle_first = _tmp$2.charCodeAt(_tmp$3);
      const forward_len = haystack_len - needle_len | 0;
      let i = 0;
      while (true) {
        if (i <= forward_len) {
          while (true) {
            let _tmp$4;
            if (i <= forward_len) {
              const _p$2 = i;
              const _tmp$5 = haystack.str;
              const _tmp$6 = haystack.start + _p$2 | 0;
              _tmp$4 = _tmp$5.charCodeAt(_tmp$6) !== needle_first;
            } else {
              _tmp$4 = false;
            }
            if (_tmp$4) {
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          if (i <= forward_len) {
            let _tmp$4 = 1;
            while (true) {
              const j = _tmp$4;
              if (j < needle_len) {
                const _p$2 = i + j | 0;
                const _tmp$5 = haystack.str;
                const _tmp$6 = haystack.start + _p$2 | 0;
                const _tmp$7 = _tmp$5.charCodeAt(_tmp$6);
                const _tmp$8 = needle.str;
                const _tmp$9 = needle.start + j | 0;
                if (_tmp$7 !== _tmp$8.charCodeAt(_tmp$9)) {
                  break;
                }
                _tmp$4 = j + 1 | 0;
                continue;
              } else {
                return i;
              }
            }
            i = i + 1 | 0;
          }
          continue;
        } else {
          break;
        }
      }
      return undefined;
    } else {
      return undefined;
    }
  } else {
    return moonbitlang$core$string$$brute_force_find$46$constr$47$902;
  }
}
function moonbitlang$core$string$$StringView$find(self, str) {
  return (str.end - str.start | 0) <= 4 ? moonbitlang$core$string$$brute_force_find(self, str) : moonbitlang$core$string$$boyer_moore_horspool_find(self, str);
}
function moonbitlang$core$string$$String$find(self, str) {
  return moonbitlang$core$string$$StringView$find({ str: self, start: 0, end: self.length }, str);
}
function moonbitlang$core$string$$StringView$contains(self, str) {
  const _bind$2 = moonbitlang$core$string$$StringView$find(self, str);
  return !(_bind$2 === undefined);
}
function moonbitlang$core$string$$StringView$split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    const _bind$2 = moonbitlang$core$string$$StringView$iter(self);
    return (_p) => _bind$2((_p$2) => _p(moonbitlang$core$string$$String$view$46$inner(moonbitlang$core$builtin$$Show$to_string$3$(_p$2), 0, undefined)));
  }
  const _p = (yield_) => {
    let view = self;
    while (true) {
      const _bind$2 = moonbitlang$core$string$$StringView$find(view, sep);
      if (_bind$2 === undefined) {
        return yield_(view);
      } else {
        const _Some = _bind$2;
        const _end = _Some;
        const _bind$3 = yield_(moonbitlang$core$string$$StringView$view$46$inner(view, 0, _end));
        if (_bind$3 === 1) {
          view = moonbitlang$core$string$$StringView$view$46$inner(view, _end + sep_len | 0, undefined);
        } else {
          return 0;
        }
        continue;
      }
    }
  };
  return _p;
}
function moonbitlang$core$string$$String$split(self, sep) {
  return moonbitlang$core$string$$StringView$split({ str: self, start: 0, end: self.length }, sep);
}
function moonbitlang$core$string$$String$replace(self, old, new_) {
  const _bind$2 = moonbitlang$core$string$$String$find(self, old);
  if (_bind$2 === undefined) {
    return self;
  } else {
    const _Some = _bind$2;
    const _end = _Some;
    const _self = moonbitlang$core$builtin$$StringBuilder$new$46$inner(0);
    moonbitlang$core$builtin$$StringBuilder$write_iter(_self, moonbitlang$core$string$$StringView$iter(moonbitlang$core$string$$String$view$46$inner(self, 0, _end)));
    moonbitlang$core$builtin$$StringBuilder$write_iter(_self, moonbitlang$core$string$$StringView$iter(new_));
    moonbitlang$core$builtin$$StringBuilder$write_iter(_self, moonbitlang$core$string$$StringView$iter(moonbitlang$core$string$$String$view$46$inner(self, _end + (old.end - old.start | 0) | 0, undefined)));
    const _p = _self;
    return _p.val;
  }
}
function moonbitlang$core$string$$StringView$get_char(self, idx) {
  if (idx >= 0 && idx < (self.end - self.start | 0)) {
    const _tmp$2 = self.str;
    const _tmp$3 = self.start + idx | 0;
    const c = _tmp$2.charCodeAt(_tmp$3);
    if (55296 <= c && c <= 56319) {
      if ((idx + 1 | 0) < (self.end - self.start | 0)) {
        const _p = idx + 1 | 0;
        const _tmp$4 = self.str;
        const _tmp$5 = self.start + _p | 0;
        const next = _tmp$4.charCodeAt(_tmp$5);
        return 56320 <= next && next <= 57343 ? moonbitlang$core$string$$code_point_of_surrogate_pair(c, next) : -1;
      } else {
        return -1;
      }
    } else {
      return 56320 <= c && c <= 57343 ? -1 : c;
    }
  } else {
    return -1;
  }
}
function moonbitlang$core$string$regex$$MatchResult$named_group(self, name) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$$Regexp$group_by_name(self._1, name);
  if (_bind$2 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$2;
    const _index = _Some;
    return moonbitlang$core$string$regex$internal$regexp$$MatchResult$get(self._0, _index);
  }
}
function moonbitlang$core$string$regex$$compile(pattern) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$$compile(pattern, undefined);
  let _tmp$2;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _tmp$2 = _ok._0;
  } else {
    return _bind$2;
  }
  return new Result$Ok$2$(_tmp$2);
}
function moonbitlang$core$string$regex$$Regex$execute(self, input) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$$Regexp$match_(self, input);
  if (_bind$2 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$2;
    const _result = _Some;
    return { _0: _result, _1: self };
  }
}
function $moonbitlang$core$string$regex$internal$regexp$$moonbitlang$core$string$regex$internal$regexp$internal$parse$$ParseResult$compile(self) {
  return { instructions: moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile(self.ast), map: self.capture_map, capture: self.captures };
}
function moonbitlang$core$string$regex$internal$regexp$$compile$46$inner(regexp, flags) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse$46$inner(regexp, { multiline: moonbitlang$core$string$$StringView$contains(flags, { str: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$70, start: 0, end: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$70.length }), singleline: moonbitlang$core$string$$StringView$contains(flags, { str: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$71, start: 0, end: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$71.length }), ignore_case: moonbitlang$core$string$$StringView$contains(flags, { str: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$72, start: 0, end: moonbitlang$core$string$regex$internal$regexp$$compile$46$inner$46$42$bind$124$72.length }) });
  let _tmp$2;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _tmp$2 = _ok._0;
  } else {
    return _bind$2;
  }
  return new Result$Ok$3$($moonbitlang$core$string$regex$internal$regexp$$moonbitlang$core$string$regex$internal$regexp$internal$parse$$ParseResult$compile(_tmp$2));
}
function moonbitlang$core$string$regex$internal$regexp$$compile(regexp, flags$46$opt) {
  let flags;
  if (flags$46$opt === undefined) {
    flags = { str: moonbitlang$core$string$regex$internal$regexp$$compile$46$42$bind$124$66, start: 0, end: moonbitlang$core$string$regex$internal$regexp$$compile$46$42$bind$124$66.length };
  } else {
    const _Some = flags$46$opt;
    flags = _Some;
  }
  return moonbitlang$core$string$regex$internal$regexp$$compile$46$inner(regexp, flags);
}
function moonbitlang$core$string$regex$internal$regexp$$Regexp$group_by_name(self, name) {
  return moonbitlang$core$builtin$$Map$get$17$(self.map, name);
}
function moonbitlang$core$string$regex$internal$regexp$$Regexp$match_(self, input) {
  const captures = moonbitlang$core$string$regex$internal$regexp$internal$vm$$vm(self.instructions, input, self.capture);
  _L: {
    if (captures.length >= 2) {
      const _x = captures[0];
      if (_x >= 0) {
        const _x$2 = captures[1];
        if (_x$2 >= 0) {
          const before = moonbitlang$core$string$$StringView$view$46$inner(input, 0, _x);
          const after = moonbitlang$core$string$$StringView$view$46$inner(input, _x$2, undefined);
          return { input: input, captures: captures, names: self.map, before: before, after: after };
        } else {
          break _L;
        }
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  return undefined;
}
function moonbitlang$core$string$regex$internal$regexp$$MatchResult$get(self, index) {
  let _tmp$2;
  const _p = self.captures;
  if (_p.length === 0) {
    _tmp$2 = true;
  } else {
    _tmp$2 = index < 0 || index >= (self.captures.length / 2 | 0);
  }
  if (_tmp$2) {
    return undefined;
  }
  const start = moonbitlang$core$array$$Array$at$4$(self.captures, Math.imul(index, 2) | 0);
  const end = moonbitlang$core$array$$Array$at$4$(self.captures, (Math.imul(index, 2) | 0) + 1 | 0);
  let _tmp$3;
  if (start < 0) {
    _tmp$3 = true;
  } else {
    let _tmp$4;
    if (end < start) {
      _tmp$4 = true;
    } else {
      const _p$2 = self.input;
      _tmp$4 = end > (_p$2.end - _p$2.start | 0);
    }
    _tmp$3 = _tmp$4;
  }
  if (_tmp$3) {
    return undefined;
  }
  return moonbitlang$core$string$$StringView$view$46$inner(self.input, start, end);
}
function moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(regex, instructions) {
  switch (regex.$tag) {
    case 0: {
      return;
    }
    case 1: {
      const _CharClass = regex;
      const _chars = _CharClass._0;
      const _neg = _CharClass._1;
      if (_neg) {
        const complement = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$compute_char_class_complement(_chars);
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Char(complement));
        return;
      } else {
        const simplified = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$simplify_char_ranges(_chars);
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Char(simplified));
        return;
      }
    }
    case 2: {
      const _Assertion = regex;
      const _pred = _Assertion._0;
      moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Assertion(_pred));
      return;
    }
    case 3: {
      const _Capture = regex;
      const _inner = _Capture._0;
      const _capture = _Capture._1;
      moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save(Math.imul(_capture, 2) | 0));
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner, instructions);
      moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Save((Math.imul(_capture, 2) | 0) + 1 | 0));
      return;
    }
    case 4: {
      const _ZeroOrMore = regex;
      const _inner$2 = _ZeroOrMore._0;
      const _greedy = _ZeroOrMore._1;
      const split_pos = instructions.length;
      moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$979);
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$2, instructions);
      const next_pos = instructions.length;
      if (!_greedy) {
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(next_pos + 1 | 0, split_pos + 1 | 0));
        moonbitlang$core$array$$Array$set$11$(instructions, split_pos, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(next_pos + 1 | 0, split_pos + 1 | 0));
        return;
      } else {
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(split_pos + 1 | 0, next_pos + 1 | 0));
        moonbitlang$core$array$$Array$set$11$(instructions, split_pos, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(split_pos + 1 | 0, next_pos + 1 | 0));
        return;
      }
    }
    case 5: {
      const _OneOrMore = regex;
      const _inner$3 = _OneOrMore._0;
      const _greedy$2 = _OneOrMore._1;
      const jmp_pos = instructions.length;
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$3, instructions);
      const next_pos$2 = instructions.length;
      if (!_greedy$2) {
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(next_pos$2 + 1 | 0, jmp_pos));
        return;
      } else {
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(jmp_pos, next_pos$2 + 1 | 0));
        return;
      }
    }
    case 6: {
      const _ZeroOrOne = regex;
      const _inner$4 = _ZeroOrOne._0;
      const _greedy$3 = _ZeroOrOne._1;
      const split_pos$2 = instructions.length;
      moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$980);
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$4, instructions);
      if (!_greedy$3) {
        moonbitlang$core$array$$Array$set$11$(instructions, split_pos$2, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(instructions.length, split_pos$2 + 1 | 0));
        return;
      } else {
        moonbitlang$core$array$$Array$set$11$(instructions, split_pos$2, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(split_pos$2 + 1 | 0, instructions.length));
        return;
      }
    }
    case 7: {
      const _Repeat = regex;
      const _greedy$4 = _Repeat._1;
      const _min = _Repeat._2;
      const _max = _Repeat._3;
      const _inner$5 = _Repeat._0;
      if (_max === undefined) {
        let _tmp$2 = 0;
        while (true) {
          const i = _tmp$2;
          if (i >>> 0 < _min >>> 0) {
            moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$5, instructions);
            _tmp$2 = (i >>> 0) + (1 >>> 0) | 0;
            continue;
          } else {
            break;
          }
        }
        const split_pos$3 = instructions.length;
        moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$982);
        moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$5, instructions);
        moonbitlang$core$array$$Array$push$11$(instructions, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump(split_pos$3));
        if (!_greedy$4) {
          moonbitlang$core$array$$Array$set$11$(instructions, split_pos$3, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(instructions.length, split_pos$3 + 1 | 0));
          return;
        } else {
          moonbitlang$core$array$$Array$set$11$(instructions, split_pos$3, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(split_pos$3 + 1 | 0, instructions.length));
          return;
        }
      } else {
        const _Some = _max;
        const _max$2 = _Some;
        let _tmp$2 = 0;
        while (true) {
          const i = _tmp$2;
          if (i >>> 0 < _min >>> 0) {
            moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$5, instructions);
            _tmp$2 = (i >>> 0) + (1 >>> 0) | 0;
            continue;
          } else {
            break;
          }
        }
        const split_pos$3 = [];
        const _end58 = (_max$2 >>> 0) - (_min >>> 0) | 0;
        let _tmp$3 = 0;
        while (true) {
          const i = _tmp$3;
          if (i >>> 0 < _end58 >>> 0) {
            moonbitlang$core$array$$Array$push$4$(split_pos$3, instructions.length);
            moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$981);
            moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_inner$5, instructions);
            _tmp$3 = (i >>> 0) + (1 >>> 0) | 0;
            continue;
          } else {
            break;
          }
        }
        const jmp_pos$2 = instructions.length;
        if (!_greedy$4) {
          const _len = split_pos$3.length;
          let _tmp$4 = 0;
          while (true) {
            const _i = _tmp$4;
            if (_i < _len) {
              const pos = split_pos$3[_i];
              moonbitlang$core$array$$Array$set$11$(instructions, pos, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(jmp_pos$2, pos + 1 | 0));
              _tmp$4 = _i + 1 | 0;
              continue;
            } else {
              return;
            }
          }
        } else {
          const _len = split_pos$3.length;
          let _tmp$4 = 0;
          while (true) {
            const _i = _tmp$4;
            if (_i < _len) {
              const pos = split_pos$3[_i];
              moonbitlang$core$array$$Array$set$11$(instructions, pos, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(pos + 1 | 0, jmp_pos$2));
              _tmp$4 = _i + 1 | 0;
              continue;
            } else {
              return;
            }
          }
        }
      }
    }
    case 8: {
      const _Concat = regex;
      const _regexs = _Concat._0;
      const _len = _regexs.length;
      let _tmp$2 = 0;
      while (true) {
        const _i = _tmp$2;
        if (_i < _len) {
          const regex$2 = _regexs[_i];
          moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(regex$2, instructions);
          _tmp$2 = _i + 1 | 0;
          continue;
        } else {
          return;
        }
      }
    }
    default: {
      const _Alternate = regex;
      const _left = _Alternate._0;
      const _right = _Alternate._1;
      const split_pos$3 = instructions.length;
      moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$983);
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_left, instructions);
      const jmp_pos$2 = instructions.length;
      moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile_aux$46$constr$47$984);
      moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(_right, instructions);
      moonbitlang$core$array$$Array$set$11$(instructions, split_pos$3, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Split(split_pos$3 + 1 | 0, jmp_pos$2 + 1 | 0));
      moonbitlang$core$array$$Array$set$11$(instructions, jmp_pos$2, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Jump(instructions.length));
      return;
    }
  }
}
function moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile(self) {
  const instructions = [moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1047, new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Char([0, 1114111]), moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1048];
  moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1049);
  moonbitlang$core$string$regex$internal$regexp$internal$ast$$Ast$compile_aux(self, instructions);
  moonbitlang$core$array$$Array$push$11$(instructions, moonbitlang$core$string$regex$internal$regexp$internal$ast$$compile$46$constr$47$1050);
  moonbitlang$core$array$$Array$push$11$(instructions, $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$vm$46$Instruction$Matched);
  return instructions;
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$new(input, flags) {
  const _bind$2 = moonbitlang$core$builtin$$Map$from_array$17$([]);
  const _bind$3 = moonbitlang$core$set$$Set$new$46$inner$4$(8);
  return { input: input, flags: flags, captures: 1, current_capture_scope: _bind$3, capture_map: _bind$2 };
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$is_special_char(c) {
  switch (c) {
    case 42: {
      return true;
    }
    case 43: {
      return true;
    }
    case 63: {
      return true;
    }
    case 124: {
      return true;
    }
    case 40: {
      return true;
    }
    case 41: {
      return true;
    }
    case 91: {
      return true;
    }
    case 93: {
      return true;
    }
    case 123: {
      return true;
    }
    case 46: {
      return true;
    }
    case 94: {
      return true;
    }
    case 36: {
      return true;
    }
    default: {
      return false;
    }
  }
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_general_category(self, property_name, neg) {
  const _bind$2 = moonbitlang$core$builtin$$Map$get$1$(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_property_value_alises, property_name);
  let normalized_name;
  if (_bind$2 === undefined) {
    return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(1, self.input));
  } else {
    const _Some = _bind$2;
    normalized_name = _Some;
  }
  const _bind$3 = moonbitlang$core$builtin$$Map$get$2$(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$general_category_ranges, normalized_name);
  if (_bind$3.$tag === 1) {
    const _Some = _bind$3;
    const _ranges = _Some._0;
    return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(_ranges, neg));
  } else {
    return new Result$Ok$4$($panic());
  }
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_escape(self) {
  _L: {
    const _bind$2 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
      if (_x === 123) {
        const _tmp$2 = _bind$2.str;
        const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
        let _tmp$3;
        if (_bind$3 === undefined) {
          _tmp$3 = _bind$2.end;
        } else {
          const _Some = _bind$3;
          _tmp$3 = _Some;
        }
        const _tmp$4 = _tmp$3;
        const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
        self.input = _x$2;
        let codepoint = 0;
        let len = 0;
        while (true) {
          const _bind$4 = self.input;
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end)) {
            const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$4.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 0, _bind$4.start, _bind$4.end));
            const _tmp$5 = _bind$4.str;
            const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end);
            let _tmp$6;
            if (_bind$5 === undefined) {
              _tmp$6 = _bind$4.end;
            } else {
              const _Some = _bind$5;
              _tmp$6 = _Some;
            }
            const _tmp$7 = _tmp$6;
            const _x$3 = { str: _tmp$5, start: _tmp$7, end: _bind$4.end };
            if (_ch !== 125) {
              if (_ch >= 48 && _ch <= 57) {
                codepoint = codepoint << 4 | (_ch - 48 | 0);
                self.input = _x$3;
              } else {
                if (_ch >= 97 && _ch <= 102) {
                  codepoint = codepoint << 4 | ((_ch - 97 | 0) + 10 | 0);
                  self.input = _x$3;
                } else {
                  if (_ch >= 65 && _ch <= 70) {
                    codepoint = codepoint << 4 | ((_ch - 65 | 0) + 10 | 0);
                    self.input = _x$3;
                  } else {
                    return new Result$Err$5$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, self.input));
                  }
                }
              }
              len = len + 1 | 0;
              if (len > 6) {
                return new Result$Err$5$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, _x$2));
              }
              continue;
            } else {
              break;
            }
          } else {
            break;
          }
        }
        if (len === 0) {
          return new Result$Err$5$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, _x$2));
        }
        _L$2: {
          const _bind$4 = self.input;
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end)) {
            const _x$3 = moonbitlang$core$string$$String$unsafe_char_at(_bind$4.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 0, _bind$4.start, _bind$4.end));
            if (_x$3 === 125) {
              const _tmp$5 = _bind$4.str;
              const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end);
              let _tmp$6;
              if (_bind$5 === undefined) {
                _tmp$6 = _bind$4.end;
              } else {
                const _Some = _bind$5;
                _tmp$6 = _Some;
              }
              const _tmp$7 = _tmp$6;
              const _x$4 = { str: _tmp$5, start: _tmp$7, end: _bind$4.end };
              self.input = _x$4;
              if (codepoint < 0 || codepoint > 1114111) {
                return new Result$Err$5$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, _x$2));
              }
              return new Result$Ok$5$(codepoint);
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
        }
        return new Result$Ok$5$($panic());
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  let codepoint = 0;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < 4) {
      _L$2: {
        _L$3: {
          const _bind$2 = self.input;
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
            const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
            if (_x >= 48 && _x <= 57) {
              const _tmp$3 = _bind$2.str;
              const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
              let _tmp$4;
              if (_bind$3 === undefined) {
                _tmp$4 = _bind$2.end;
              } else {
                const _Some = _bind$3;
                _tmp$4 = _Some;
              }
              const _tmp$5 = _tmp$4;
              const _x$2 = { str: _tmp$3, start: _tmp$5, end: _bind$2.end };
              codepoint = codepoint << 4 | (_x - 48 | 0);
              self.input = _x$2;
            } else {
              if (_x >= 97 && _x <= 102) {
                const _tmp$3 = _bind$2.str;
                const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                let _tmp$4;
                if (_bind$3 === undefined) {
                  _tmp$4 = _bind$2.end;
                } else {
                  const _Some = _bind$3;
                  _tmp$4 = _Some;
                }
                const _tmp$5 = _tmp$4;
                const _x$2 = { str: _tmp$3, start: _tmp$5, end: _bind$2.end };
                codepoint = codepoint << 4 | ((_x - 97 | 0) + 10 | 0);
                self.input = _x$2;
              } else {
                if (_x >= 65 && _x <= 70) {
                  const _tmp$3 = _bind$2.str;
                  const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                  let _tmp$4;
                  if (_bind$3 === undefined) {
                    _tmp$4 = _bind$2.end;
                  } else {
                    const _Some = _bind$3;
                    _tmp$4 = _Some;
                  }
                  const _tmp$5 = _tmp$4;
                  const _x$2 = { str: _tmp$3, start: _tmp$5, end: _bind$2.end };
                  codepoint = codepoint << 4 | ((_x - 65 | 0) + 10 | 0);
                  self.input = _x$2;
                } else {
                  break _L$3;
                }
              }
            }
          } else {
            break _L$3;
          }
          break _L$2;
        }
        return new Result$Err$5$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, self.input));
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new Result$Ok$5$(codepoint);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_property(self) {
  _L: {
    const _bind$2 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
      if (_x === 123) {
        const _tmp$2 = _bind$2.str;
        const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
        let _tmp$3;
        if (_bind$3 === undefined) {
          _tmp$3 = _bind$2.end;
        } else {
          const _Some = _bind$3;
          _tmp$3 = _Some;
        }
        const _tmp$4 = _tmp$3;
        const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
        self.input = _x$2;
        const chars = [];
        while (true) {
          const _bind$4 = self.input;
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end)) {
            const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$4.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 0, _bind$4.start, _bind$4.end));
            const _tmp$5 = _bind$4.str;
            const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end);
            let _tmp$6;
            if (_bind$5 === undefined) {
              _tmp$6 = _bind$4.end;
            } else {
              const _Some = _bind$5;
              _tmp$6 = _Some;
            }
            const _tmp$7 = _tmp$6;
            const _x$3 = { str: _tmp$5, start: _tmp$7, end: _bind$4.end };
            if (_ch !== 125) {
              moonbitlang$core$array$$Array$push$3$(chars, _ch);
              self.input = _x$3;
              continue;
            } else {
              break;
            }
          } else {
            break;
          }
        }
        _L$2: {
          const _bind$4 = self.input;
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end)) {
            const _x$3 = moonbitlang$core$string$$String$unsafe_char_at(_bind$4.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 0, _bind$4.start, _bind$4.end));
            if (_x$3 === 125) {
              const _tmp$5 = _bind$4.str;
              const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end);
              let _tmp$6;
              if (_bind$5 === undefined) {
                _tmp$6 = _bind$4.end;
              } else {
                const _Some = _bind$5;
                _tmp$6 = _Some;
              }
              const _tmp$7 = _tmp$6;
              const _x$4 = { str: _tmp$5, start: _tmp$7, end: _bind$4.end };
              self.input = _x$4;
              return new Result$Ok$6$(moonbitlang$core$string$$String$from_iter(moonbitlang$core$array$$Array$iter$3$(chars)));
            } else {
              break _L$2;
            }
          } else {
            break _L$2;
          }
        }
        return new Result$Err$6$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(1, self.input));
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  return new Result$Err$6$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(1, self.input));
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_char_class(self) {
  const _bind$2 = self.input;
  let neg;
  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
    const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
    if (_x === 94) {
      const _tmp$2 = _bind$2.str;
      const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
      let _tmp$3;
      if (_bind$3 === undefined) {
        _tmp$3 = _bind$2.end;
      } else {
        const _Some = _bind$3;
        _tmp$3 = _Some;
      }
      const _tmp$4 = _tmp$3;
      const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
      self.input = _x$2;
      neg = true;
    } else {
      neg = false;
    }
  } else {
    neg = false;
  }
  const chars = [];
  _L: while (true) {
    const _bind$3 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
      const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
      const _bind$4 = _bind$3.str;
      const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
      let _bind$6;
      if (_bind$5 === undefined) {
        _bind$6 = _bind$3.end;
      } else {
        const _Some = _bind$5;
        _bind$6 = _Some;
      }
      const _bind$7 = _bind$3.end;
      const _x = { str: _bind$4, start: _bind$6, end: _bind$7 };
      if (_ch !== 93) {
        let start_char;
        if (_ch === 92) {
          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4, 1, _bind$6, _bind$7)) {
            const _ch$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$4, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 0, _bind$6, _bind$7));
            const _bind$8 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _bind$6, _bind$7);
            let _tmp$2;
            if (_bind$8 === undefined) {
              _tmp$2 = _bind$7;
            } else {
              const _Some = _bind$8;
              _tmp$2 = _Some;
            }
            const _x$2 = { str: _bind$4, start: _tmp$2, end: _bind$7 };
            self.input = _x$2;
            _L$2: {
              _L$3: {
                let flag;
                _L$4: {
                  _L$5: {
                    switch (_ch$2) {
                      case 100: {
                        const _p = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_digit.length;
                        let _tmp$3 = 0;
                        while (true) {
                          const _p$2 = _tmp$3;
                          if (_p$2 < _p) {
                            const _p$3 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_digit[_p$2];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$3);
                            _tmp$3 = _p$2 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 68: {
                        const _p$2 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_digit.length;
                        let _tmp$4 = 0;
                        while (true) {
                          const _p$3 = _tmp$4;
                          if (_p$3 < _p$2) {
                            const _p$4 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_digit[_p$3];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$4);
                            _tmp$4 = _p$3 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 119: {
                        const _p$3 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_word.length;
                        let _tmp$5 = 0;
                        while (true) {
                          const _p$4 = _tmp$5;
                          if (_p$4 < _p$3) {
                            const _p$5 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_word[_p$4];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$5);
                            _tmp$5 = _p$4 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 87: {
                        const _p$4 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_word.length;
                        let _tmp$6 = 0;
                        while (true) {
                          const _p$5 = _tmp$6;
                          if (_p$5 < _p$4) {
                            const _p$6 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_word[_p$5];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$6);
                            _tmp$6 = _p$5 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 115: {
                        const _p$5 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_white_space_or_line_terminator.length;
                        let _tmp$7 = 0;
                        while (true) {
                          const _p$6 = _tmp$7;
                          if (_p$6 < _p$5) {
                            const _p$7 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_white_space_or_line_terminator[_p$6];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$7);
                            _tmp$7 = _p$6 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 83: {
                        const _p$6 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_white_space_or_line_terminator.length;
                        let _tmp$8 = 0;
                        while (true) {
                          const _p$7 = _tmp$8;
                          if (_p$7 < _p$6) {
                            const _p$8 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_white_space_or_line_terminator[_p$7];
                            moonbitlang$core$array$$Array$push$3$(chars, _p$8);
                            _tmp$8 = _p$7 + 1 | 0;
                            continue;
                          } else {
                            break;
                          }
                        }
                        continue _L;
                      }
                      case 112: {
                        flag = _ch$2;
                        break _L$5;
                      }
                      case 80: {
                        flag = _ch$2;
                        break _L$5;
                      }
                      case 116: {
                        start_char = 9;
                        break;
                      }
                      case 110: {
                        start_char = 10;
                        break;
                      }
                      case 118: {
                        start_char = 11;
                        break;
                      }
                      case 102: {
                        start_char = 12;
                        break;
                      }
                      case 114: {
                        start_char = 13;
                        break;
                      }
                      case 98: {
                        start_char = 8;
                        break;
                      }
                      case 117: {
                        const _bind$9 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_escape(self);
                        if (_bind$9.$tag === 1) {
                          const _ok = _bind$9;
                          start_char = _ok._0;
                        } else {
                          return _bind$9;
                        }
                        break;
                      }
                      case 99: {
                        break _L$3;
                      }
                      case 107: {
                        break _L$3;
                      }
                      default: {
                        start_char = _ch$2;
                      }
                    }
                    break _L$4;
                  }
                  const _bind$9 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_property(self);
                  let property_name;
                  if (_bind$9.$tag === 1) {
                    const _ok = _bind$9;
                    property_name = _ok._0;
                  } else {
                    return _bind$9;
                  }
                  const _bind$10 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_general_category(self, property_name, flag === 80);
                  let _bind$11;
                  if (_bind$10.$tag === 1) {
                    const _ok = _bind$10;
                    _bind$11 = _ok._0;
                  } else {
                    return _bind$10;
                  }
                  if (_bind$11.$tag === 1) {
                    const _CharClass = _bind$11;
                    const _class = _CharClass._0;
                    const _neg = _CharClass._1;
                    if (_neg) {
                      const _p = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$compute_char_class_complement(_class);
                      const _p$2 = _p.length;
                      let _tmp$3 = 0;
                      while (true) {
                        const _p$3 = _tmp$3;
                        if (_p$3 < _p$2) {
                          const _p$4 = _p[_p$3];
                          moonbitlang$core$array$$Array$push$3$(chars, _p$4);
                          _tmp$3 = _p$3 + 1 | 0;
                          continue;
                        } else {
                          break;
                        }
                      }
                    } else {
                      const _p = _class.length;
                      let _tmp$3 = 0;
                      while (true) {
                        const _p$2 = _tmp$3;
                        if (_p$2 < _p) {
                          const _p$3 = _class[_p$2];
                          moonbitlang$core$array$$Array$push$3$(chars, _p$3);
                          _tmp$3 = _p$2 + 1 | 0;
                          continue;
                        } else {
                          break;
                        }
                      }
                    }
                    continue;
                  } else {
                    start_char = $panic();
                  }
                }
                break _L$2;
              }
              return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, _x));
            }
          } else {
            return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(9, self.input));
          }
        } else {
          self.input = _x;
          start_char = _ch;
        }
        _L$2: {
          _L$3: {
            const _bind$8 = self.input;
            if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$8.str, 1, _bind$8.start, _bind$8.end)) {
              const _x$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$8.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$8.str, 0, _bind$8.start, _bind$8.end));
              if (_x$2 === 45) {
                const _tmp$2 = _bind$8.str;
                const _bind$9 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$8.str, 1, _bind$8.start, _bind$8.end);
                let _tmp$3;
                if (_bind$9 === undefined) {
                  _tmp$3 = _bind$8.end;
                } else {
                  const _Some = _bind$9;
                  _tmp$3 = _Some;
                }
                const _tmp$4 = _tmp$3;
                const _x$3 = { str: _tmp$2, start: _tmp$4, end: _bind$8.end };
                const input_copy = self.input;
                self.input = _x$3;
                _L$4: {
                  _L$5: {
                    const _bind$10 = self.input;
                    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$10.str, 1, _bind$10.start, _bind$10.end)) {
                      const _ch$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$10.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$10.str, 0, _bind$10.start, _bind$10.end));
                      const _bind$11 = _bind$10.str;
                      const _bind$12 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$10.str, 1, _bind$10.start, _bind$10.end);
                      let _bind$13;
                      if (_bind$12 === undefined) {
                        _bind$13 = _bind$10.end;
                      } else {
                        const _Some = _bind$12;
                        _bind$13 = _Some;
                      }
                      const _bind$14 = _bind$10.end;
                      const _x$4 = { str: _bind$11, start: _bind$13, end: _bind$14 };
                      if (_ch$2 !== 93) {
                        let end_char;
                        if (_ch$2 === 92) {
                          if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$11, 1, _bind$13, _bind$14)) {
                            const _ch$3 = moonbitlang$core$string$$String$unsafe_char_at(_bind$11, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$11, 0, _bind$13, _bind$14));
                            const _bind$15 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$11, 1, _bind$13, _bind$14);
                            let _tmp$5;
                            if (_bind$15 === undefined) {
                              _tmp$5 = _bind$14;
                            } else {
                              const _Some = _bind$15;
                              _tmp$5 = _Some;
                            }
                            const _x$5 = { str: _bind$11, start: _tmp$5, end: _bind$14 };
                            self.input = _x$5;
                            _L$6: {
                              _L$7: {
                                _L$8: {
                                  _L$9: {
                                    switch (_ch$3) {
                                      case 116: {
                                        end_char = 9;
                                        break;
                                      }
                                      case 110: {
                                        end_char = 10;
                                        break;
                                      }
                                      case 118: {
                                        end_char = 11;
                                        break;
                                      }
                                      case 102: {
                                        end_char = 12;
                                        break;
                                      }
                                      case 114: {
                                        end_char = 13;
                                        break;
                                      }
                                      case 98: {
                                        end_char = 8;
                                        break;
                                      }
                                      case 117: {
                                        const _bind$16 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_escape(self);
                                        if (_bind$16.$tag === 1) {
                                          const _ok = _bind$16;
                                          end_char = _ok._0;
                                        } else {
                                          return _bind$16;
                                        }
                                        break;
                                      }
                                      case 100: {
                                        break _L$9;
                                      }
                                      case 68: {
                                        break _L$9;
                                      }
                                      case 119: {
                                        break _L$9;
                                      }
                                      case 87: {
                                        break _L$9;
                                      }
                                      case 115: {
                                        break _L$9;
                                      }
                                      case 83: {
                                        break _L$9;
                                      }
                                      case 112: {
                                        break _L$9;
                                      }
                                      case 80: {
                                        break _L$9;
                                      }
                                      case 99: {
                                        break _L$7;
                                      }
                                      case 107: {
                                        break _L$7;
                                      }
                                      default: {
                                        end_char = _ch$3;
                                      }
                                    }
                                    break _L$8;
                                  }
                                  return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(1, _bind$8));
                                }
                                break _L$6;
                              }
                              return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, self.input));
                            }
                          } else {
                            return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(9, self.input));
                          }
                        } else {
                          self.input = _x$4;
                          end_char = _ch$2;
                        }
                        if (end_char < start_char) {
                          return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(1, self.input));
                        }
                        moonbitlang$core$array$$Array$push$3$(chars, start_char);
                        moonbitlang$core$array$$Array$push$3$(chars, end_char);
                      } else {
                        break _L$5;
                      }
                    } else {
                      break _L$5;
                    }
                    break _L$4;
                  }
                  self.input = input_copy;
                  moonbitlang$core$array$$Array$push$3$(chars, start_char);
                  moonbitlang$core$array$$Array$push$3$(chars, start_char);
                }
              } else {
                break _L$3;
              }
            } else {
              break _L$3;
            }
            break _L$2;
          }
          moonbitlang$core$array$$Array$push$3$(chars, start_char);
          moonbitlang$core$array$$Array$push$3$(chars, start_char);
        }
        continue;
      } else {
        break;
      }
    } else {
      break;
    }
  }
  _L$2: {
    const _bind$3 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
      if (_x === 93) {
        const _tmp$2 = _bind$3.str;
        const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
        let _tmp$3;
        if (_bind$4 === undefined) {
          _tmp$3 = _bind$3.end;
        } else {
          const _Some = _bind$4;
          _tmp$3 = _Some;
        }
        const _tmp$4 = _tmp$3;
        const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
        self.input = _x$2;
        return self.flags.ignore_case ? new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_insensitive_char_class(chars), neg)) : new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(chars, neg));
      } else {
        break _L$2;
      }
    } else {
      break _L$2;
    }
  }
  return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(6, self.input));
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_flags(self) {
  const _bind$2 = self.flags;
  let flag = { multiline: _bind$2.multiline, singleline: _bind$2.singleline, ignore_case: _bind$2.ignore_case };
  let positive = true;
  const _bind$3 = self.input;
  const _bind$4 = _bind$3.str;
  const _bind$5 = _bind$3.start;
  const _bind$6 = _bind$3.end;
  let _tmp$2;
  let _tmp$3 = _bind$5;
  _L: while (true) {
    const _param_start = _tmp$3;
    _L$2: {
      if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4, 1, _param_start, _bind$6)) {
        const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$4, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 0, _param_start, _bind$6));
        switch (_x) {
          case 58: {
            const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _param_start, _bind$6);
            let _tmp$4;
            if (_bind$7 === undefined) {
              _tmp$4 = _bind$6;
            } else {
              const _Some = _bind$7;
              _tmp$4 = _Some;
            }
            const _x$2 = { str: _bind$4, start: _tmp$4, end: _bind$6 };
            self.input = _x$2;
            return new Result$Ok$7$(flag);
          }
          case 109: {
            const _bind$8 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _param_start, _bind$6);
            let _bind$9;
            if (_bind$8 === undefined) {
              _bind$9 = _bind$6;
            } else {
              const _Some = _bind$8;
              _bind$9 = _Some;
            }
            const _bind$10 = flag;
            flag = { multiline: positive, singleline: _bind$10.singleline, ignore_case: _bind$10.ignore_case };
            _tmp$3 = _bind$9;
            continue _L;
          }
          case 115: {
            const _bind$11 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _param_start, _bind$6);
            let _bind$12;
            if (_bind$11 === undefined) {
              _bind$12 = _bind$6;
            } else {
              const _Some = _bind$11;
              _bind$12 = _Some;
            }
            const _bind$13 = flag;
            flag = { multiline: _bind$13.multiline, singleline: positive, ignore_case: _bind$13.ignore_case };
            _tmp$3 = _bind$12;
            continue _L;
          }
          case 105: {
            const _bind$14 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _param_start, _bind$6);
            let _bind$15;
            if (_bind$14 === undefined) {
              _bind$15 = _bind$6;
            } else {
              const _Some = _bind$14;
              _bind$15 = _Some;
            }
            const _bind$16 = flag;
            flag = { multiline: _bind$16.multiline, singleline: _bind$16.singleline, ignore_case: positive };
            _tmp$3 = _bind$15;
            continue _L;
          }
          case 45: {
            const _bind$17 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4, 1, _param_start, _bind$6);
            let _bind$18;
            if (_bind$17 === undefined) {
              _bind$18 = _bind$6;
            } else {
              const _Some = _bind$17;
              _bind$18 = _Some;
            }
            if (positive) {
              positive = false;
              _tmp$3 = _bind$18;
              continue _L;
            } else {
              break _L$2;
            }
          }
          default: {
            break _L$2;
          }
        }
      } else {
        break _L$2;
      }
    }
    return new Result$Err$7$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(4, self.input));
  }
  return new Result$Ok$7$(_tmp$2);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_group_name(self) {
  let name = "";
  let first = true;
  while (true) {
    const _bind$2 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
      const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
      const _tmp$2 = _bind$2.str;
      const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
      let _tmp$3;
      if (_bind$3 === undefined) {
        _tmp$3 = _bind$2.end;
      } else {
        const _Some = _bind$3;
        _tmp$3 = _Some;
      }
      const _tmp$4 = _tmp$3;
      const _x = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
      if (_ch !== 62) {
        if (first) {
          _L: {
            if (_ch >= 97 && _ch <= 122) {
              break _L;
            } else {
              if (_ch >= 65 && _ch <= 90) {
                break _L;
              } else {
                if (_ch === 95) {
                  break _L;
                } else {
                  return new Result$Err$6$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(3, self.input));
                }
              }
            }
          }
          name = `${name}${moonbitlang$core$builtin$$Show$to_string$3$(_ch)}`;
          self.input = _x;
          first = false;
        } else {
          _L: {
            if (_ch >= 97 && _ch <= 122) {
              break _L;
            } else {
              if (_ch >= 65 && _ch <= 90) {
                break _L;
              } else {
                if (_ch >= 48 && _ch <= 57) {
                  break _L;
                } else {
                  if (_ch === 95) {
                    break _L;
                  } else {
                    return new Result$Err$6$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(3, self.input));
                  }
                }
              }
            }
          }
          name = `${name}${moonbitlang$core$builtin$$Show$to_string$3$(_ch)}`;
          self.input = _x;
        }
        continue;
      } else {
        break;
      }
    } else {
      break;
    }
  }
  if (name === "") {
    return new Result$Err$6$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(3, self.input));
  }
  return new Result$Ok$6$(name);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_number(self) {
  let result = 0;
  let has_digits = false;
  while (true) {
    const _bind$2 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
      const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
      const _tmp$2 = _bind$2.str;
      const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
      let _tmp$3;
      if (_bind$3 === undefined) {
        _tmp$3 = _bind$2.end;
      } else {
        const _Some = _bind$3;
        _tmp$3 = _Some;
      }
      const _tmp$4 = _tmp$3;
      const _x = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
      if (_ch >= 48) {
        if (_ch <= 57) {
          has_digits = true;
          result = ((Math.imul(result, 10) | 0) >>> 0) + ((_ch - 48 | 0) >>> 0) | 0;
          self.input = _x;
          continue;
        } else {
          break;
        }
      } else {
        break;
      }
    } else {
      break;
    }
  }
  if (!has_digits) {
    return new Result$Err$8$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(8, self.input));
  }
  return new Result$Ok$8$(result);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_repeat(self) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_number(self);
  let min;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    min = _ok._0;
  } else {
    return _bind$2;
  }
  _L: {
    const _bind$3 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
      switch (_x) {
        case 125: {
          const _tmp$2 = _bind$3.str;
          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
          let _tmp$3;
          if (_bind$4 === undefined) {
            _tmp$3 = _bind$3.end;
          } else {
            const _Some = _bind$4;
            _tmp$3 = _Some;
          }
          const _tmp$4 = _tmp$3;
          const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
          self.input = _x$2;
          return new Result$Ok$9$({ _0: min, _1: min });
        }
        case 44: {
          const _tmp$5 = _bind$3.str;
          const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
          let _tmp$6;
          if (_bind$5 === undefined) {
            _tmp$6 = _bind$3.end;
          } else {
            const _Some = _bind$5;
            _tmp$6 = _Some;
          }
          const _tmp$7 = _tmp$6;
          const _x$3 = { str: _tmp$5, start: _tmp$7, end: _bind$3.end };
          self.input = _x$3;
          _L$2: {
            const _bind$6 = self.input;
            if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$6.str, 1, _bind$6.start, _bind$6.end)) {
              const _x$4 = moonbitlang$core$string$$String$unsafe_char_at(_bind$6.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$6.str, 0, _bind$6.start, _bind$6.end));
              if (_x$4 === 125) {
                const _tmp$8 = _bind$6.str;
                const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$6.str, 1, _bind$6.start, _bind$6.end);
                let _tmp$9;
                if (_bind$7 === undefined) {
                  _tmp$9 = _bind$6.end;
                } else {
                  const _Some = _bind$7;
                  _tmp$9 = _Some;
                }
                const _tmp$10 = _tmp$9;
                const _x$5 = { str: _tmp$8, start: _tmp$10, end: _bind$6.end };
                self.input = _x$5;
                return new Result$Ok$9$({ _0: min, _1: undefined });
              } else {
                break _L$2;
              }
            } else {
              break _L$2;
            }
          }
          const _bind$6 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_number(self);
          let max;
          if (_bind$6.$tag === 1) {
            const _ok = _bind$6;
            max = _ok._0;
          } else {
            return _bind$6;
          }
          _L$3: {
            const _bind$7 = self.input;
            if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$7.str, 1, _bind$7.start, _bind$7.end)) {
              const _x$4 = moonbitlang$core$string$$String$unsafe_char_at(_bind$7.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$7.str, 0, _bind$7.start, _bind$7.end));
              if (_x$4 === 125) {
                const _tmp$8 = _bind$7.str;
                const _bind$8 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$7.str, 1, _bind$7.start, _bind$7.end);
                let _tmp$9;
                if (_bind$8 === undefined) {
                  _tmp$9 = _bind$7.end;
                } else {
                  const _Some = _bind$8;
                  _tmp$9 = _Some;
                }
                const _tmp$10 = _tmp$9;
                const _x$5 = { str: _tmp$8, start: _tmp$10, end: _bind$7.end };
                self.input = _x$5;
                if (max >>> 0 < min >>> 0) {
                  return new Result$Err$9$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(5, self.input));
                }
                return new Result$Ok$9$({ _0: min, _1: max });
              } else {
                break _L$3;
              }
            } else {
              break _L$3;
            }
          }
          return new Result$Err$9$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(4, self.input));
        }
        default: {
          break _L;
        }
      }
    } else {
      break _L;
    }
  }
  return new Result$Err$9$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(4, self.input));
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_expression(self) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_sequence(self);
  let left;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    left = _ok._0;
  } else {
    return _bind$2;
  }
  while (true) {
    const _bind$3 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
      if (_x === 124) {
        const _tmp$2 = _bind$3.str;
        const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
        let _tmp$3;
        if (_bind$4 === undefined) {
          _tmp$3 = _bind$3.end;
        } else {
          const _Some = _bind$4;
          _tmp$3 = _Some;
        }
        const _tmp$4 = _tmp$3;
        const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
        self.input = _x$2;
        const _bind$5 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_sequence(self);
        let right;
        if (_bind$5.$tag === 1) {
          const _ok = _bind$5;
          right = _ok._0;
        } else {
          return _bind$5;
        }
        left = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Alternate(left, right);
        continue;
      } else {
        break;
      }
    } else {
      break;
    }
  }
  return new Result$Ok$4$(left);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_sequence(self) {
  const sequence = [];
  while (true) {
    const _bind$2 = self.input;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
      const _ch = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
      if (_ch !== 124) {
        if (_ch !== 41) {
          const _bind$3 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_term(self);
          let term;
          if (_bind$3.$tag === 1) {
            const _ok = _bind$3;
            term = _ok._0;
          } else {
            return _bind$3;
          }
          moonbitlang$core$array$$Array$push$19$(sequence, term);
          continue;
        } else {
          break;
        }
      } else {
        break;
      }
    } else {
      break;
    }
  }
  if (sequence.length === 0) {
    return new Result$Ok$4$($64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Empty);
  } else {
    if (sequence.length === 1) {
      const _regex = sequence[0];
      return new Result$Ok$4$(_regex);
    } else {
      return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Concat(sequence));
    }
  }
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_term(self) {
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_factor(self);
  let base;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    base = _ok._0;
  } else {
    return _bind$2;
  }
  let rest;
  _L: {
    _L$2: {
      let rest$2;
      _L$3: {
        _L$4: {
          let rest$3;
          _L$5: {
            _L$6: {
              let rest$4;
              _L$7: {
                _L$8: {
                  const _bind$3 = self.input;
                  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 2, _bind$3.start, _bind$3.end)) {
                    const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
                    switch (_x) {
                      case 42: {
                        const _x$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end));
                        if (_x$2 === 63) {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 2, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$3 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          self.input = _x$3;
                          base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrMore(base, false);
                        } else {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$3 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          rest$4 = _x$3;
                          break _L$8;
                        }
                        break;
                      }
                      case 43: {
                        const _x$3 = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end));
                        if (_x$3 === 63) {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 2, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$4 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          self.input = _x$4;
                          base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$OneOrMore(base, false);
                        } else {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$4 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          rest$3 = _x$4;
                          break _L$6;
                        }
                        break;
                      }
                      case 63: {
                        const _x$4 = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end));
                        if (_x$4 === 63) {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 2, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$5 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          self.input = _x$5;
                          base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrOne(base, false);
                        } else {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$5 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          rest$2 = _x$5;
                          break _L$4;
                        }
                        break;
                      }
                      case 123: {
                        const _tmp$2 = _bind$3.str;
                        const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                        let _tmp$3;
                        if (_bind$4 === undefined) {
                          _tmp$3 = _bind$3.end;
                        } else {
                          const _Some = _bind$4;
                          _tmp$3 = _Some;
                        }
                        const _tmp$4 = _tmp$3;
                        const _x$5 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                        rest = _x$5;
                        break _L$2;
                      }
                    }
                  } else {
                    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
                      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
                      switch (_x) {
                        case 42: {
                          const _tmp$2 = _bind$3.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$3;
                          if (_bind$4 === undefined) {
                            _tmp$3 = _bind$3.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                          rest$4 = _x$2;
                          break _L$8;
                        }
                        case 43: {
                          const _tmp$5 = _bind$3.str;
                          const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$6;
                          if (_bind$5 === undefined) {
                            _tmp$6 = _bind$3.end;
                          } else {
                            const _Some = _bind$5;
                            _tmp$6 = _Some;
                          }
                          const _tmp$7 = _tmp$6;
                          const _x$3 = { str: _tmp$5, start: _tmp$7, end: _bind$3.end };
                          rest$3 = _x$3;
                          break _L$6;
                        }
                        case 63: {
                          const _tmp$8 = _bind$3.str;
                          const _bind$6 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$9;
                          if (_bind$6 === undefined) {
                            _tmp$9 = _bind$3.end;
                          } else {
                            const _Some = _bind$6;
                            _tmp$9 = _Some;
                          }
                          const _tmp$10 = _tmp$9;
                          const _x$4 = { str: _tmp$8, start: _tmp$10, end: _bind$3.end };
                          rest$2 = _x$4;
                          break _L$4;
                        }
                        case 123: {
                          const _tmp$11 = _bind$3.str;
                          const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                          let _tmp$12;
                          if (_bind$7 === undefined) {
                            _tmp$12 = _bind$3.end;
                          } else {
                            const _Some = _bind$7;
                            _tmp$12 = _Some;
                          }
                          const _tmp$13 = _tmp$12;
                          const _x$5 = { str: _tmp$11, start: _tmp$13, end: _bind$3.end };
                          rest = _x$5;
                          break _L$2;
                        }
                      }
                    }
                  }
                  break _L$7;
                }
                self.input = rest$4;
                base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrMore(base, true);
              }
              break _L$5;
            }
            self.input = rest$3;
            base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$OneOrMore(base, true);
          }
          break _L$3;
        }
        self.input = rest$2;
        base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$ZeroOrOne(base, true);
      }
      break _L;
    }
    self.input = rest;
    const _bind$3 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_repeat(self);
    let repeat_result;
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      repeat_result = _ok._0;
    } else {
      return _bind$3;
    }
    const _bind$4 = self.input;
    let greedy;
    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end)) {
      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$4.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 0, _bind$4.start, _bind$4.end));
      if (_x === 63) {
        const _tmp$2 = _bind$4.str;
        const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$4.str, 1, _bind$4.start, _bind$4.end);
        let _tmp$3;
        if (_bind$5 === undefined) {
          _tmp$3 = _bind$4.end;
        } else {
          const _Some = _bind$5;
          _tmp$3 = _Some;
        }
        const _tmp$4 = _tmp$3;
        const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$4.end };
        self.input = _x$2;
        greedy = false;
      } else {
        greedy = true;
      }
    } else {
      greedy = true;
    }
    base = new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Repeat(base, greedy, repeat_result._0, repeat_result._1);
  }
  return new Result$Ok$4$(base);
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_factor(self) {
  let rest;
  let c;
  _L: {
    let c$2;
    _L$2: {
      let escape;
      let rest$2;
      _L$3: {
        let rest$3;
        _L$4: {
          let rest$4;
          _L$5: {
            let rest$5;
            _L$6: {
              let rest$6;
              _L$7: {
                let rest$7;
                _L$8: {
                  const _bind$2 = self.input;
                  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 2, _bind$2.start, _bind$2.end)) {
                    const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
                    switch (_x) {
                      case 40: {
                        const _x$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end));
                        if (_x$2 === 63) {
                          const _bind$3 = _bind$2.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 2, _bind$2.start, _bind$2.end);
                          let _bind$5;
                          if (_bind$4 === undefined) {
                            _bind$5 = _bind$2.end;
                          } else {
                            const _Some = _bind$4;
                            _bind$5 = _Some;
                          }
                          const _bind$6 = _bind$2.end;
                          const _x$3 = { str: _bind$3, start: _bind$5, end: _bind$6 };
                          _L$9: {
                            if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3, 1, _bind$5, _bind$6)) {
                              const _x$4 = moonbitlang$core$string$$String$unsafe_char_at(_bind$3, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3, 0, _bind$5, _bind$6));
                              if (_x$4 === 60) {
                                const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3, 1, _bind$5, _bind$6);
                                let _tmp$2;
                                if (_bind$7 === undefined) {
                                  _tmp$2 = _bind$6;
                                } else {
                                  const _Some = _bind$7;
                                  _tmp$2 = _Some;
                                }
                                const _x$5 = { str: _bind$3, start: _tmp$2, end: _bind$6 };
                                const captures = self.captures;
                                self.captures = self.captures + 1 | 0;
                                self.input = _x$5;
                                const _bind$8 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_group_name(self);
                                let name;
                                if (_bind$8.$tag === 1) {
                                  const _ok = _bind$8;
                                  name = _ok._0;
                                } else {
                                  return _bind$8;
                                }
                                _L$10: {
                                  const _bind$9 = self.input;
                                  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$9.str, 1, _bind$9.start, _bind$9.end)) {
                                    const _x$6 = moonbitlang$core$string$$String$unsafe_char_at(_bind$9.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$9.str, 0, _bind$9.start, _bind$9.end));
                                    if (_x$6 === 62) {
                                      const _tmp$3 = _bind$9.str;
                                      const _bind$10 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$9.str, 1, _bind$9.start, _bind$9.end);
                                      let _tmp$4;
                                      if (_bind$10 === undefined) {
                                        _tmp$4 = _bind$9.end;
                                      } else {
                                        const _Some = _bind$10;
                                        _tmp$4 = _Some;
                                      }
                                      const _tmp$5 = _tmp$4;
                                      const _x$7 = { str: _tmp$3, start: _tmp$5, end: _bind$9.end };
                                      self.input = _x$7;
                                      moonbitlang$core$set$$Set$add$4$(self.current_capture_scope, captures);
                                      const _bind$11 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_expression(self);
                                      let expr;
                                      if (_bind$11.$tag === 1) {
                                        const _ok = _bind$11;
                                        expr = _ok._0;
                                      } else {
                                        return _bind$11;
                                      }
                                      moonbitlang$core$set$$Set$remove$4$(self.current_capture_scope, captures);
                                      _L$11: {
                                        const _bind$12 = self.input;
                                        if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$12.str, 1, _bind$12.start, _bind$12.end)) {
                                          const _x$8 = moonbitlang$core$string$$String$unsafe_char_at(_bind$12.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$12.str, 0, _bind$12.start, _bind$12.end));
                                          if (_x$8 === 41) {
                                            const _tmp$6 = _bind$12.str;
                                            const _bind$13 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$12.str, 1, _bind$12.start, _bind$12.end);
                                            let _tmp$7;
                                            if (_bind$13 === undefined) {
                                              _tmp$7 = _bind$12.end;
                                            } else {
                                              const _Some = _bind$13;
                                              _tmp$7 = _Some;
                                            }
                                            const _tmp$8 = _tmp$7;
                                            const _x$9 = { str: _tmp$6, start: _tmp$8, end: _bind$12.end };
                                            self.input = _x$9;
                                            if (moonbitlang$core$builtin$$Map$contains$17$(self.capture_map, name)) {
                                              return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(3, _bind$2));
                                            }
                                            moonbitlang$core$builtin$$Map$set$17$(self.capture_map, name, captures);
                                            return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Capture(expr, captures));
                                          } else {
                                            break _L$11;
                                          }
                                        } else {
                                          break _L$11;
                                        }
                                      }
                                      return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(7, self.input));
                                    } else {
                                      break _L$10;
                                    }
                                  } else {
                                    break _L$10;
                                  }
                                }
                                return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(3, self.input));
                              } else {
                                break _L$9;
                              }
                            } else {
                              break _L$9;
                            }
                          }
                          self.input = _x$3;
                          const old_flags = self.flags;
                          const _bind$7 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_flags(self);
                          let new_flags;
                          if (_bind$7.$tag === 1) {
                            const _ok = _bind$7;
                            new_flags = _ok._0;
                          } else {
                            return _bind$7;
                          }
                          self.flags = new_flags;
                          const _bind$8 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_expression(self);
                          let expr;
                          if (_bind$8.$tag === 1) {
                            const _ok = _bind$8;
                            expr = _ok._0;
                          } else {
                            return _bind$8;
                          }
                          _L$10: {
                            const _bind$9 = self.input;
                            if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$9.str, 1, _bind$9.start, _bind$9.end)) {
                              const _x$4 = moonbitlang$core$string$$String$unsafe_char_at(_bind$9.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$9.str, 0, _bind$9.start, _bind$9.end));
                              if (_x$4 === 41) {
                                const _tmp$2 = _bind$9.str;
                                const _bind$10 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$9.str, 1, _bind$9.start, _bind$9.end);
                                let _tmp$3;
                                if (_bind$10 === undefined) {
                                  _tmp$3 = _bind$9.end;
                                } else {
                                  const _Some = _bind$10;
                                  _tmp$3 = _Some;
                                }
                                const _tmp$4 = _tmp$3;
                                const _x$5 = { str: _tmp$2, start: _tmp$4, end: _bind$9.end };
                                self.input = _x$5;
                                self.flags = old_flags;
                                return new Result$Ok$4$(expr);
                              } else {
                                break _L$10;
                              }
                            } else {
                              break _L$10;
                            }
                          }
                          return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(7, self.input));
                        } else {
                          const _tmp$2 = _bind$2.str;
                          const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$3;
                          if (_bind$3 === undefined) {
                            _tmp$3 = _bind$2.end;
                          } else {
                            const _Some = _bind$3;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$3 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
                          rest$7 = _x$3;
                          break _L$8;
                        }
                      }
                      case 91: {
                        const _tmp$2 = _bind$2.str;
                        const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                        let _tmp$3;
                        if (_bind$3 === undefined) {
                          _tmp$3 = _bind$2.end;
                        } else {
                          const _Some = _bind$3;
                          _tmp$3 = _Some;
                        }
                        const _tmp$4 = _tmp$3;
                        const _x$3 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
                        rest$6 = _x$3;
                        break _L$7;
                      }
                      case 46: {
                        const _tmp$5 = _bind$2.str;
                        const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                        let _tmp$6;
                        if (_bind$4 === undefined) {
                          _tmp$6 = _bind$2.end;
                        } else {
                          const _Some = _bind$4;
                          _tmp$6 = _Some;
                        }
                        const _tmp$7 = _tmp$6;
                        const _x$4 = { str: _tmp$5, start: _tmp$7, end: _bind$2.end };
                        rest$5 = _x$4;
                        break _L$6;
                      }
                      case 94: {
                        const _tmp$8 = _bind$2.str;
                        const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                        let _tmp$9;
                        if (_bind$5 === undefined) {
                          _tmp$9 = _bind$2.end;
                        } else {
                          const _Some = _bind$5;
                          _tmp$9 = _Some;
                        }
                        const _tmp$10 = _tmp$9;
                        const _x$5 = { str: _tmp$8, start: _tmp$10, end: _bind$2.end };
                        rest$4 = _x$5;
                        break _L$5;
                      }
                      case 36: {
                        const _tmp$11 = _bind$2.str;
                        const _bind$6 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                        let _tmp$12;
                        if (_bind$6 === undefined) {
                          _tmp$12 = _bind$2.end;
                        } else {
                          const _Some = _bind$6;
                          _tmp$12 = _Some;
                        }
                        const _tmp$13 = _tmp$12;
                        const _x$6 = { str: _tmp$11, start: _tmp$13, end: _bind$2.end };
                        rest$3 = _x$6;
                        break _L$4;
                      }
                      case 92: {
                        const _tmp$14 = _bind$2.str;
                        const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                        let _tmp$15;
                        if (_bind$7 === undefined) {
                          _tmp$15 = _bind$2.end;
                        } else {
                          const _Some = _bind$7;
                          _tmp$15 = _Some;
                        }
                        const _tmp$16 = _tmp$15;
                        const _x$7 = { str: _tmp$14, start: _tmp$16, end: _bind$2.end };
                        escape = _bind$2;
                        rest$2 = _x$7;
                        break _L$3;
                      }
                      default: {
                        if (moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$is_special_char(_x)) {
                          c$2 = _x;
                          break _L$2;
                        } else {
                          const _tmp$17 = _bind$2.str;
                          const _bind$8 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$18;
                          if (_bind$8 === undefined) {
                            _tmp$18 = _bind$2.end;
                          } else {
                            const _Some = _bind$8;
                            _tmp$18 = _Some;
                          }
                          const _tmp$19 = _tmp$18;
                          const _x$8 = { str: _tmp$17, start: _tmp$19, end: _bind$2.end };
                          rest = _x$8;
                          c = _x;
                          break _L;
                        }
                      }
                    }
                  } else {
                    if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end)) {
                      const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 0, _bind$2.start, _bind$2.end));
                      switch (_x) {
                        case 40: {
                          const _tmp$2 = _bind$2.str;
                          const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$3;
                          if (_bind$3 === undefined) {
                            _tmp$3 = _bind$2.end;
                          } else {
                            const _Some = _bind$3;
                            _tmp$3 = _Some;
                          }
                          const _tmp$4 = _tmp$3;
                          const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$2.end };
                          rest$7 = _x$2;
                          break _L$8;
                        }
                        case 91: {
                          const _tmp$5 = _bind$2.str;
                          const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$6;
                          if (_bind$4 === undefined) {
                            _tmp$6 = _bind$2.end;
                          } else {
                            const _Some = _bind$4;
                            _tmp$6 = _Some;
                          }
                          const _tmp$7 = _tmp$6;
                          const _x$3 = { str: _tmp$5, start: _tmp$7, end: _bind$2.end };
                          rest$6 = _x$3;
                          break _L$7;
                        }
                        case 46: {
                          const _tmp$8 = _bind$2.str;
                          const _bind$5 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$9;
                          if (_bind$5 === undefined) {
                            _tmp$9 = _bind$2.end;
                          } else {
                            const _Some = _bind$5;
                            _tmp$9 = _Some;
                          }
                          const _tmp$10 = _tmp$9;
                          const _x$4 = { str: _tmp$8, start: _tmp$10, end: _bind$2.end };
                          rest$5 = _x$4;
                          break _L$6;
                        }
                        case 94: {
                          const _tmp$11 = _bind$2.str;
                          const _bind$6 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$12;
                          if (_bind$6 === undefined) {
                            _tmp$12 = _bind$2.end;
                          } else {
                            const _Some = _bind$6;
                            _tmp$12 = _Some;
                          }
                          const _tmp$13 = _tmp$12;
                          const _x$5 = { str: _tmp$11, start: _tmp$13, end: _bind$2.end };
                          rest$4 = _x$5;
                          break _L$5;
                        }
                        case 36: {
                          const _tmp$14 = _bind$2.str;
                          const _bind$7 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$15;
                          if (_bind$7 === undefined) {
                            _tmp$15 = _bind$2.end;
                          } else {
                            const _Some = _bind$7;
                            _tmp$15 = _Some;
                          }
                          const _tmp$16 = _tmp$15;
                          const _x$6 = { str: _tmp$14, start: _tmp$16, end: _bind$2.end };
                          rest$3 = _x$6;
                          break _L$4;
                        }
                        case 92: {
                          const _tmp$17 = _bind$2.str;
                          const _bind$8 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                          let _tmp$18;
                          if (_bind$8 === undefined) {
                            _tmp$18 = _bind$2.end;
                          } else {
                            const _Some = _bind$8;
                            _tmp$18 = _Some;
                          }
                          const _tmp$19 = _tmp$18;
                          const _x$7 = { str: _tmp$17, start: _tmp$19, end: _bind$2.end };
                          escape = _bind$2;
                          rest$2 = _x$7;
                          break _L$3;
                        }
                        default: {
                          if (moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$is_special_char(_x)) {
                            c$2 = _x;
                            break _L$2;
                          } else {
                            const _tmp$20 = _bind$2.str;
                            const _bind$9 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2.str, 1, _bind$2.start, _bind$2.end);
                            let _tmp$21;
                            if (_bind$9 === undefined) {
                              _tmp$21 = _bind$2.end;
                            } else {
                              const _Some = _bind$9;
                              _tmp$21 = _Some;
                            }
                            const _tmp$22 = _tmp$21;
                            const _x$8 = { str: _tmp$20, start: _tmp$22, end: _bind$2.end };
                            rest = _x$8;
                            c = _x;
                            break _L;
                          }
                        }
                      }
                    } else {
                      return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(0, self.input));
                    }
                  }
                }
                const captures = self.captures;
                self.captures = self.captures + 1 | 0;
                self.input = rest$7;
                moonbitlang$core$set$$Set$add$4$(self.current_capture_scope, captures);
                const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_expression(self);
                let expr;
                if (_bind$2.$tag === 1) {
                  const _ok = _bind$2;
                  expr = _ok._0;
                } else {
                  return _bind$2;
                }
                moonbitlang$core$set$$Set$remove$4$(self.current_capture_scope, captures);
                _L$9: {
                  const _bind$3 = self.input;
                  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
                    const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
                    if (_x === 41) {
                      const _tmp$2 = _bind$3.str;
                      const _bind$4 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end);
                      let _tmp$3;
                      if (_bind$4 === undefined) {
                        _tmp$3 = _bind$3.end;
                      } else {
                        const _Some = _bind$4;
                        _tmp$3 = _Some;
                      }
                      const _tmp$4 = _tmp$3;
                      const _x$2 = { str: _tmp$2, start: _tmp$4, end: _bind$3.end };
                      self.input = _x$2;
                      return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$Capture(expr, captures));
                    } else {
                      break _L$9;
                    }
                  } else {
                    break _L$9;
                  }
                }
                return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(7, self.input));
              }
              self.input = rest$6;
              return moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_char_class(self);
            }
            self.input = rest$5;
            return self.flags.singleline ? new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_any, false)) : new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_any_not_new_line, false));
          }
          self.input = rest$4;
          return self.flags.multiline ? new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1300) : new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1301);
        }
        self.input = rest$3;
        return self.flags.multiline ? new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1298) : new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1299);
      }
      if (moonbitlang$core$string$$String$char_length_ge$46$inner(rest$2.str, 1, rest$2.start, rest$2.end)) {
        const _c = moonbitlang$core$string$$String$unsafe_char_at(rest$2.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(rest$2.str, 0, rest$2.start, rest$2.end));
        const _bind$2 = rest$2.str;
        const _bind$3 = moonbitlang$core$string$$String$offset_of_nth_char$46$inner(rest$2.str, 1, rest$2.start, rest$2.end);
        let _bind$4;
        if (_bind$3 === undefined) {
          _bind$4 = rest$2.end;
        } else {
          const _Some = _bind$3;
          _bind$4 = _Some;
        }
        const _bind$5 = rest$2.end;
        const _x = { str: _bind$2, start: _bind$4, end: _bind$5 };
        self.input = _x;
        _L$4: {
          let flag;
          _L$5: {
            if (_c === 98) {
              return new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1296);
            } else {
              if (_c === 66) {
                return new Result$Ok$4$(moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse_factor$46$constr$47$1297);
              } else {
                if (_c === 100) {
                  return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_digit, false));
                } else {
                  if (_c === 68) {
                    return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_digit, false));
                  } else {
                    if (_c === 119) {
                      return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_word, false));
                    } else {
                      if (_c === 87) {
                        return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_word, false));
                      } else {
                        if (_c === 115) {
                          return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_white_space_or_line_terminator, false));
                        } else {
                          if (_c === 83) {
                            return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$ranges_is_not_white_space_or_line_terminator, false));
                          } else {
                            if (_c === 116) {
                              return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([9, 9], false));
                            } else {
                              if (_c === 110) {
                                return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([10, 10], false));
                              } else {
                                if (_c === 118) {
                                  return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([11, 11], false));
                                } else {
                                  if (_c === 102) {
                                    return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([12, 12], false));
                                  } else {
                                    if (_c === 114) {
                                      return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([13, 13], false));
                                    } else {
                                      if (_c === 112) {
                                        flag = _c;
                                        break _L$5;
                                      } else {
                                        if (_c === 80) {
                                          flag = _c;
                                          break _L$5;
                                        } else {
                                          if (_c === 117) {
                                            const _bind$6 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_escape(self);
                                            let unicode_char;
                                            if (_bind$6.$tag === 1) {
                                              const _ok = _bind$6;
                                              unicode_char = _ok._0;
                                            } else {
                                              return _bind$6;
                                            }
                                            return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([unicode_char, unicode_char], false));
                                          } else {
                                            if (_c === 48) {
                                              _L$6: {
                                                if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$2, 1, _bind$4, _bind$5)) {
                                                  const _x$2 = moonbitlang$core$string$$String$unsafe_char_at(_bind$2, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$2, 0, _bind$4, _bind$5));
                                                  if (_x$2 >= 48 && _x$2 <= 57) {
                                                    return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, escape));
                                                  } else {
                                                    break _L$6;
                                                  }
                                                } else {
                                                  break _L$6;
                                                }
                                              }
                                              self.input = _x;
                                              return new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([0, 0], false));
                                            } else {
                                              if (_c === 99) {
                                                break _L$4;
                                              } else {
                                                if (_c === 107) {
                                                  break _L$4;
                                                } else {
                                                  if (_c >= 49 && _c <= 57) {
                                                    break _L$4;
                                                  } else {
                                                    return self.flags.ignore_case ? new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_insensitive_char_class([_c, _c]), false)) : new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([_c, _c], false));
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          const _bind$6 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_unicode_property(self);
          let property_name;
          if (_bind$6.$tag === 1) {
            const _ok = _bind$6;
            property_name = _ok._0;
          } else {
            return _bind$6;
          }
          return moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_general_category(self, property_name, flag === 80);
        }
        return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, escape));
      } else {
        return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(9, self.input));
      }
    }
    return new Result$Err$4$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(2, self.input));
  }
  self.input = rest;
  return self.flags.ignore_case ? new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_insensitive_char_class([c, c]), false)) : new Result$Ok$4$(new $64$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$ast$46$Ast$CharClass([c, c], false));
}
function moonbitlang$core$string$regex$internal$regexp$internal$parse$$parse$46$inner(regex, flags) {
  const parser = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$new(regex, flags);
  const _bind$2 = moonbitlang$core$string$regex$internal$regexp$internal$parse$$Parser$parse_expression(parser);
  let result;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    result = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = parser.input;
  if (moonbitlang$core$string$$String$char_length_ge$46$inner(_bind$3.str, 1, _bind$3.start, _bind$3.end)) {
    const _x = moonbitlang$core$string$$String$unsafe_char_at(_bind$3.str, moonbitlang$core$string$$String$offset_of_nth_char$46$inner(_bind$3.str, 0, _bind$3.start, _bind$3.end));
    if (_x === 41) {
      return new Result$Err$10$(new Error$moonbitlang$47$core$47$string$47$regex$47$internal$47$regexp$47$internal$47$parse$46$RegexpError$46$RegexpError(10, parser.input));
    }
  }
  const _bind$4 = parser.capture_map;
  const _bind$5 = parser.captures;
  return new Result$Ok$10$({ ast: result, captures: _bind$5, capture_map: _bind$4 });
}
function moonbitlang$core$string$regex$internal$regexp$internal$vm$$add_thread(content, instructions, inst_gen, thread, clist) {
  let _tmp$2 = thread;
  _L: while (true) {
    const thread$2 = _tmp$2;
    if (moonbitlang$core$array$$Array$at$4$(inst_gen, thread$2.pc) === thread$2.sp) {
      return undefined;
    }
    moonbitlang$core$array$$Array$set$4$(inst_gen, thread$2.pc, thread$2.sp);
    const _bind$2 = moonbitlang$core$array$$Array$at$11$(instructions, thread$2.pc);
    switch (_bind$2.$tag) {
      case 1: {
        const _Save = _bind$2;
        const _i = _Save._0;
        moonbitlang$core$array$$Array$set$4$(thread$2.captures, _i, thread$2.sp);
        _tmp$2 = { pc: thread$2.pc + 1 | 0, sp: thread$2.sp, captures: thread$2.captures };
        continue _L;
      }
      case 3: {
        const _Jump = _bind$2;
        const _i$2 = _Jump._0;
        _tmp$2 = { pc: _i$2, sp: thread$2.sp, captures: thread$2.captures };
        continue _L;
      }
      case 4: {
        const _Split = _bind$2;
        const _i1 = _Split._0;
        const _i2 = _Split._1;
        moonbitlang$core$string$regex$internal$regexp$internal$vm$$add_thread(content, instructions, inst_gen, { pc: _i1, sp: thread$2.sp, captures: moonbitlang$core$array$$Array$copy$4$(thread$2.captures) }, clist);
        _tmp$2 = { pc: _i2, sp: thread$2.sp, captures: thread$2.captures };
        continue _L;
      }
      case 5: {
        const _Assertion = _bind$2;
        const _pred = _Assertion._0;
        const sp = thread$2.sp;
        let assertion;
        switch (_pred) {
          case 0: {
            assertion = sp === 0;
            break;
          }
          case 1: {
            assertion = sp === (content.end - content.start | 0);
            break;
          }
          case 2: {
            assertion = sp === 0 || moonbitlang$core$string$$StringView$at(content, sp - 1 | 0) === 10;
            break;
          }
          case 3: {
            assertion = sp === (content.end - content.start | 0) || moonbitlang$core$string$$StringView$at(content, sp) === 10;
            break;
          }
          case 4: {
            const _p = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char_at(content, sp - 1 | 0);
            const _p$2 = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char_at(content, sp);
            assertion = !(_p === _p$2);
            break;
          }
          default: {
            assertion = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char_at(content, sp - 1 | 0) === moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char_at(content, sp);
          }
        }
        if (assertion) {
          _tmp$2 = { pc: thread$2.pc + 1 | 0, sp: thread$2.sp, captures: thread$2.captures };
          continue _L;
        } else {
          return;
        }
      }
      default: {
        moonbitlang$core$array$$Array$push$18$(clist, thread$2);
        return;
      }
    }
  }
}
function moonbitlang$core$string$regex$internal$regexp$internal$vm$$vm(instructions, input, captures) {
  _L: {
    if (instructions.length >= 2) {
      const _x = instructions[(instructions.length - 1 | 0) - 1 | 0];
      if (_x.$tag === 1) {
        const _Save = _x;
        const _x$2 = _Save._0;
        if (_x$2 === 1) {
          const _x$3 = instructions[instructions.length - 1 | 0];
          if (_x$3.$tag === 0) {
            const inst_gen = moonbitlang$core$array$$Array$make$4$(instructions.length, -1);
            let clist = moonbitlang$core$array$$Array$new$46$inner$18$(instructions.length);
            let nlist = moonbitlang$core$array$$Array$new$46$inner$18$(instructions.length);
            let matched = [];
            const _bind$2 = moonbitlang$core$array$$Array$make$4$(Math.imul(captures, 2) | 0, -1);
            moonbitlang$core$string$regex$internal$regexp$internal$vm$$add_thread(input, instructions, inst_gen, { pc: 0, sp: 0, captures: _bind$2 }, clist);
            let _tmp$2 = 0;
            while (true) {
              const sp = _tmp$2;
              if (sp <= (input.end - input.start | 0)) {
                const _p = clist;
                if (_p.length === 0) {
                  break;
                }
                let actual_char;
                if (sp === (input.end - input.start | 0)) {
                  actual_char = -1;
                } else {
                  const _p$2 = moonbitlang$core$string$$StringView$get_char(input, sp);
                  actual_char = _p$2 === -1 ? $panic() : _p$2;
                }
                const next_sp = actual_char > 65535 ? sp + 2 | 0 : sp + 1 | 0;
                const _arr = clist;
                const _len = _arr.length;
                let _tmp$3 = 0;
                while (true) {
                  const _i = _tmp$3;
                  if (_i < _len) {
                    _L$2: {
                      const thread = _arr[_i];
                      const _pc = thread.pc;
                      const _captures = thread.captures;
                      const _thread_sp = thread.sp;
                      if (_thread_sp > sp) {
                        moonbitlang$core$array$$Array$push$18$(nlist, thread);
                        break _L$2;
                      }
                      if (_thread_sp === sp) {
                        const _bind$3 = moonbitlang$core$array$$Array$at$11$(instructions, _pc);
                        if (_bind$3.$tag === 0) {
                          matched = _captures;
                          break;
                        }
                        const _bind$4 = moonbitlang$core$array$$Array$at$11$(instructions, _pc);
                        if (_bind$4.$tag === 2) {
                          const _Char = _bind$4;
                          const _chars = _Char._0;
                          if (moonbitlang$core$string$regex$internal$regexp$internal$unicode$$char_in_ranges(actual_char, _chars)) {
                            const _bind$5 = _pc + 1 | 0;
                            moonbitlang$core$string$regex$internal$regexp$internal$vm$$add_thread(input, instructions, inst_gen, { pc: _bind$5, sp: next_sp, captures: _captures }, nlist);
                          }
                        } else {
                          $panic();
                        }
                      } else {
                        $panic();
                      }
                      break _L$2;
                    }
                    _tmp$3 = _i + 1 | 0;
                    continue;
                  } else {
                    break;
                  }
                }
                const tmp = clist;
                clist = nlist;
                nlist = tmp;
                moonbitlang$core$array$$Array$clear$18$(nlist);
                _tmp$2 = next_sp;
                continue;
              } else {
                break;
              }
            }
            return matched;
          } else {
            break _L;
          }
        } else {
          break _L;
        }
      } else {
        break _L;
      }
    } else {
      break _L;
    }
  }
  return $panic();
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$simplify_char_ranges(chars) {
  if (chars.length === 0) {
    return [];
  }
  const ranges = [];
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < chars.length) {
      const start = moonbitlang$core$array$$Array$at$3$(chars, i);
      const end = moonbitlang$core$array$$Array$at$3$(chars, i + 1 | 0);
      moonbitlang$core$array$$Array$push$12$(ranges, { _0: start, _1: end });
      _tmp$2 = i + 2 | 0;
      continue;
    } else {
      break;
    }
  }
  moonbitlang$core$array$$Array$sort_by_key$21$(ranges, (range) => range._0);
  const simplified = [];
  let current_start = 0;
  let current_end = 0;
  if (ranges.length > 0) {
    current_start = moonbitlang$core$array$$Array$at$12$(ranges, 0)._0;
    current_end = moonbitlang$core$array$$Array$at$12$(ranges, 0)._1;
    const _arr = moonbitlang$core$array$$Array$sub$46$inner$12$(ranges, 1, undefined);
    const _len = _arr.end - _arr.start | 0;
    let _tmp$3 = 0;
    while (true) {
      const _i = _tmp$3;
      if (_i < _len) {
        const range = _arr.buf[_arr.start + _i | 0];
        const _next_start = range._0;
        const _next_end = range._1;
        if (_next_start <= (current_end + 1 | 0)) {
          current_end = current_end > _next_end ? current_end : _next_end;
        } else {
          moonbitlang$core$array$$Array$push$3$(simplified, current_start);
          moonbitlang$core$array$$Array$push$3$(simplified, current_end);
          current_start = _next_start;
          current_end = _next_end;
        }
        _tmp$3 = _i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    moonbitlang$core$array$$Array$push$3$(simplified, current_start);
    moonbitlang$core$array$$Array$push$3$(simplified, current_end);
  }
  return simplified;
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char(c) {
  return c >= 97 && c <= 122 ? true : c >= 65 && c <= 90 ? true : c >= 48 && c <= 57 ? true : c === 95;
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char_at(input, sp) {
  if (sp === -1 || sp === (input.end - input.start | 0)) {
    return false;
  }
  const _p = moonbitlang$core$string$$StringView$get_char(input, sp);
  const c = _p === -1 ? $panic() : _p;
  return moonbitlang$core$string$regex$internal$regexp$internal$unicode$$is_word_char(c);
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$char_in_ranges(ch, chars) {
  let left = 0;
  let right = (chars.length / 2 | 0) - 1 | 0;
  while (true) {
    if (left <= right) {
      const mid = (left + right | 0) / 2 | 0;
      const start = moonbitlang$core$array$$Array$at$3$(chars, Math.imul(mid, 2) | 0);
      const end = moonbitlang$core$array$$Array$at$3$(chars, (Math.imul(mid, 2) | 0) + 1 | 0);
      if (ch < start) {
        right = mid - 1 | 0;
      } else {
        if (ch > end) {
          left = mid + 1 | 0;
        } else {
          return true;
        }
      }
      continue;
    } else {
      break;
    }
  }
  return false;
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$compute_char_class_complement(chars) {
  const simplified = moonbitlang$core$string$regex$internal$regexp$internal$unicode$$simplify_char_ranges(chars);
  if (simplified.length === 0) {
    return [0, 1114111];
  }
  const complement = [];
  if (moonbitlang$core$array$$Array$at$3$(simplified, 0) > 0) {
    moonbitlang$core$array$$Array$push$3$(complement, 0);
    moonbitlang$core$array$$Array$push$3$(complement, moonbitlang$core$array$$Array$at$3$(simplified, 0) - 1 | 0);
  }
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < ((simplified.length / 2 | 0) - 1 | 0)) {
      const current_end = moonbitlang$core$array$$Array$at$3$(simplified, (Math.imul(i, 2) | 0) + 1 | 0);
      const next_start = moonbitlang$core$array$$Array$at$3$(simplified, Math.imul(i + 1 | 0, 2) | 0);
      const gap_start = current_end + 1 | 0;
      const gap_end = next_start - 1 | 0;
      if (gap_start <= gap_end) {
        moonbitlang$core$array$$Array$push$3$(complement, gap_start);
        moonbitlang$core$array$$Array$push$3$(complement, gap_end);
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const last_end = moonbitlang$core$array$$Array$at$3$(simplified, simplified.length - 1 | 0);
  if (last_end < 1114111) {
    moonbitlang$core$array$$Array$push$3$(complement, last_end + 1 | 0);
    moonbitlang$core$array$$Array$push$3$(complement, 1114111);
  }
  return complement;
}
function moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_insensitive_char_class(chars) {
  const result = [];
  const _end9 = chars.length / 2 | 0;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end9) {
      _L: {
        let start = moonbitlang$core$array$$Array$at$3$(chars, Math.imul(i, 2) | 0);
        let end = moonbitlang$core$array$$Array$at$3$(chars, (Math.imul(i, 2) | 0) + 1 | 0);
        if (start <= 65 && end >= 125251 || (end < 65 || start > 125251)) {
          moonbitlang$core$array$$Array$push$3$(result, start);
          moonbitlang$core$array$$Array$push$3$(result, end);
          break _L;
        }
        if (start < 65) {
          moonbitlang$core$array$$Array$push$3$(result, start);
          moonbitlang$core$array$$Array$push$3$(result, 65 - 1 | 0);
          start = 65;
        } else {
          if (end > 125251) {
            moonbitlang$core$array$$Array$push$3$(result, 125251 + 1 | 0);
            moonbitlang$core$array$$Array$push$3$(result, end);
            end = 125251;
          }
        }
        const _start15 = start;
        const _end16 = end;
        let _tmp$3 = _start15;
        while (true) {
          const c = _tmp$3;
          if (c <= _end16) {
            const char = c;
            let ch0 = char;
            moonbitlang$core$array$$Array$push$3$(result, char);
            moonbitlang$core$array$$Array$push$3$(result, char);
            while (true) {
              const _bind$2 = moonbitlang$core$builtin$$Map$get$0$(moonbitlang$core$string$regex$internal$regexp$internal$unicode$$case_folding, ch0);
              if (_bind$2 === -1) {
                break;
              } else {
                const _Some = _bind$2;
                const _ch = _Some;
                if (_ch !== char) {
                  moonbitlang$core$array$$Array$push$3$(result, _ch);
                  moonbitlang$core$array$$Array$push$3$(result, _ch);
                  ch0 = _ch;
                  continue;
                } else {
                  break;
                }
              }
            }
            _tmp$3 = c + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        break _L;
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$string$regex$internal$regexp$internal$unicode$$simplify_char_ranges(result);
}
function huangxl$md2mind$$parse_heading_line(line) {
  if ((line.end - line.start | 0) === 0 || moonbitlang$core$string$$StringView$at(line, 0) !== 35) {
    return undefined;
  }
  let _tmp$2;
  let _try_err;
  _L: {
    _L$2: {
      const _bind$2 = moonbitlang$core$string$regex$$compile({ str: "^(?:(?<hashes>(?:#)+) (?<title>(?:[\\u{0000}-\\u{d7ff}\\u{e000}-\\u{10ffff}])*)$)", start: 0, end: "^(?:(?<hashes>(?:#)+) (?<title>(?:[\\u{0000}-\\u{d7ff}\\u{e000}-\\u{10ffff}])*)$)".length });
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _tmp$2 = _ok._0;
      } else {
        const _err = _bind$2;
        const _tmp$3 = _err._0;
        _try_err = _tmp$3;
        break _L$2;
      }
      break _L;
    }
    _tmp$2 = $panic();
  }
  const _bind$2 = moonbitlang$core$string$regex$$Regex$execute(_tmp$2, line);
  if (_bind$2 === undefined) {
    return undefined;
  } else {
    const _Some = _bind$2;
    const _payload = _Some;
    const _bind$3 = moonbitlang$core$string$regex$$MatchResult$named_group(_payload, "title");
    let title;
    if (_bind$3 === undefined) {
      title = $panic();
    } else {
      const _Some$2 = _bind$3;
      title = _Some$2;
    }
    const _bind$4 = moonbitlang$core$string$regex$$MatchResult$named_group(_payload, "hashes");
    let hashes;
    if (_bind$4 === undefined) {
      hashes = $panic();
    } else {
      const _Some$2 = _bind$4;
      hashes = _Some$2;
    }
    return { _0: hashes.end - hashes.start | 0, _1: moonbitlang$core$builtin$$Show$to_string$6$(title) };
  }
}
function huangxl$md2mind$$parse_headings(markdown) {
  const headings = [];
  const lines = moonbitlang$core$builtin$$Iter$to_array$6$(moonbitlang$core$string$$String$split(markdown, { str: huangxl$md2mind$$parse_headings$46$42$bind$124$174, start: 0, end: huangxl$md2mind$$parse_headings$46$42$bind$124$174.length }));
  const _len = lines.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const line = lines[_i];
      const _bind$2 = huangxl$md2mind$$parse_heading_line(line);
      if (_bind$2 === undefined) {
      } else {
        const _Some = _bind$2;
        const _heading = _Some;
        moonbitlang$core$array$$Array$push$10$(headings, _heading);
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return headings;
}
function huangxl$md2mind$$make_indent(level) {
  const spaces = [];
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < level) {
      moonbitlang$core$array$$Array$push$13$(spaces, "  ");
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$join$13$(spaces, { str: huangxl$md2mind$$make_indent$46$42$bind$124$177, start: 0, end: huangxl$md2mind$$make_indent$46$42$bind$124$177.length });
}
function huangxl$md2mind$$render_heading(heading) {
  const _level = heading._0;
  const _title = heading._1;
  const indent = huangxl$md2mind$$make_indent(_level - 1 | 0);
  return `${indent}- ${_title}`;
}
function huangxl$md2mind$$render_ascii_mindmap(markdown) {
  const rendered = [];
  const _arr = huangxl$md2mind$$parse_headings(markdown);
  const _len = _arr.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const heading = _arr[_i];
      moonbitlang$core$array$$Array$push$13$(rendered, huangxl$md2mind$$render_heading(heading));
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$join$13$(rendered, { str: huangxl$md2mind$$render_ascii_mindmap$46$42$bind$124$184, start: 0, end: huangxl$md2mind$$render_ascii_mindmap$46$42$bind$124$184.length });
}
function huangxl$md2mind$$demo_output() {
  return huangxl$md2mind$$render_ascii_mindmap("# MindDown Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview");
}
function huangxl$md2mind$$json_field(name, value) {
  return `\"${name}\":${value}`;
}
function huangxl$md2mind$$json_string(source) {
  const escaped_backslash = moonbitlang$core$string$$String$replace(source, { str: huangxl$md2mind$$json_string$46$42$bind$124$189, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$189.length }, { str: huangxl$md2mind$$json_string$46$42$bind$124$190, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$190.length });
  const escaped_quote = moonbitlang$core$string$$String$replace(escaped_backslash, { str: huangxl$md2mind$$json_string$46$42$bind$124$187, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$187.length }, { str: huangxl$md2mind$$json_string$46$42$bind$124$188, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$188.length });
  const escaped_newline = moonbitlang$core$string$$String$replace(escaped_quote, { str: huangxl$md2mind$$json_string$46$42$bind$124$185, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$185.length }, { str: huangxl$md2mind$$json_string$46$42$bind$124$186, start: 0, end: huangxl$md2mind$$json_string$46$42$bind$124$186.length });
  return `\"${escaped_newline}\"`;
}
function huangxl$md2mind$$document_json(title, children_json) {
  const flat_index_field = huangxl$md2mind$$json_field("flat_index", "-1");
  const level_field = huangxl$md2mind$$json_field("level", "1");
  const title_field = huangxl$md2mind$$json_field("title", huangxl$md2mind$$json_string(title));
  const synthetic_field = huangxl$md2mind$$json_field("synthetic", "true");
  return `{${flat_index_field},${level_field},${title_field},${synthetic_field},\"children\":${children_json}}`;
}
function huangxl$md2mind$$subtree_end(headings, index) {
  const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, index);
  const _level = _bind$2._0;
  let cursor = index + 1 | 0;
  while (true) {
    if (cursor < headings.length && moonbitlang$core$array$$Array$at$10$(headings, cursor)._0 > _level) {
      cursor = cursor + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return cursor;
}
function huangxl$md2mind$$render_node_json(headings, index) {
  const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, index);
  const _level = _bind$2._0;
  const _title = _bind$2._1;
  const flat_index_field = huangxl$md2mind$$json_field("flat_index", moonbitlang$core$int$$Int$to_string$46$inner(index, 10));
  const level_field = huangxl$md2mind$$json_field("level", moonbitlang$core$int$$Int$to_string$46$inner(_level, 10));
  const title_field = huangxl$md2mind$$json_field("title", huangxl$md2mind$$json_string(_title));
  const synthetic_field = huangxl$md2mind$$json_field("synthetic", "false");
  const children_field = huangxl$md2mind$$children_json(headings, index);
  return { _0: `{${flat_index_field},${level_field},${title_field},${synthetic_field},\"children\":${children_field}}`, _1: huangxl$md2mind$$subtree_end(headings, index) };
}
function huangxl$md2mind$$children_json(headings, index) {
  const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, index);
  const _level = _bind$2._0;
  const children = [];
  let cursor = index + 1 | 0;
  while (true) {
    if (cursor < headings.length && moonbitlang$core$array$$Array$at$10$(headings, cursor)._0 > _level) {
      const _bind$3 = huangxl$md2mind$$render_node_json(headings, cursor);
      const _child_json = _bind$3._0;
      const _next_cursor = _bind$3._1;
      moonbitlang$core$array$$Array$push$13$(children, _child_json);
      cursor = _next_cursor;
      continue;
    } else {
      break;
    }
  }
  const joined = moonbitlang$core$array$$Array$join$13$(children, { str: huangxl$md2mind$$children_json$46$42$bind$124$207, start: 0, end: huangxl$md2mind$$children_json$46$42$bind$124$207.length });
  return `[${joined}]`;
}
function huangxl$md2mind$$render_roots_json(headings) {
  const nodes = [];
  let index = 0;
  while (true) {
    if (index < headings.length) {
      const _bind$2 = huangxl$md2mind$$render_node_json(headings, index);
      const _node = _bind$2._0;
      const _next_index = _bind$2._1;
      moonbitlang$core$array$$Array$push$13$(nodes, _node);
      index = _next_index;
      continue;
    } else {
      break;
    }
  }
  const joined = moonbitlang$core$array$$Array$join$13$(nodes, { str: huangxl$md2mind$$render_roots_json$46$42$bind$124$218, start: 0, end: huangxl$md2mind$$render_roots_json$46$42$bind$124$218.length });
  return `[${joined}]`;
}
function huangxl$md2mind$$top_level_count(headings) {
  let count = 0;
  const _len = headings.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const heading = headings[_i];
      if (heading._0 === 1) {
        count = count + 1 | 0;
      }
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return count;
}
function huangxl$md2mind$$outline_json(markdown) {
  const headings = huangxl$md2mind$$parse_headings(markdown);
  if (headings.length === 0) {
    return huangxl$md2mind$$document_json("Empty Document", "[]");
  }
  if (huangxl$md2mind$$top_level_count(headings) === 1) {
    const _bind$2 = huangxl$md2mind$$render_node_json(headings, 0);
    const _root_json = _bind$2._0;
    return _root_json;
  }
  return huangxl$md2mind$$document_json("Document", huangxl$md2mind$$render_roots_json(headings));
}
function huangxl$md2mind$$repeat_hashes(level) {
  const hashes = [];
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < level) {
      moonbitlang$core$array$$Array$push$13$(hashes, "#");
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$join$13$(hashes, { str: huangxl$md2mind$$repeat_hashes$46$42$bind$124$227, start: 0, end: huangxl$md2mind$$repeat_hashes$46$42$bind$124$227.length });
}
function huangxl$md2mind$$render_markdown(headings) {
  const lines = [];
  const _len = headings.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const heading = headings[_i];
      const _level = heading._0;
      const _title = heading._1;
      moonbitlang$core$array$$Array$push$13$(lines, `${huangxl$md2mind$$repeat_hashes(_level)} ${_title}`);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return moonbitlang$core$array$$Array$join$13$(lines, { str: huangxl$md2mind$$render_markdown$46$42$bind$124$234, start: 0, end: huangxl$md2mind$$render_markdown$46$42$bind$124$234.length });
}
function huangxl$md2mind$$rename_heading(markdown, flat_index, title) {
  const headings = huangxl$md2mind$$parse_headings(markdown);
  if (flat_index < 0 || flat_index >= headings.length) {
    return markdown;
  }
  const next_title = title;
  if (next_title.length === 0) {
    return markdown;
  }
  const updated = [];
  const _end143 = headings.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _end143) {
      const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, i);
      const _level = _bind$2._0;
      const _old_title = _bind$2._1;
      if (i === flat_index) {
        moonbitlang$core$array$$Array$push$10$(updated, { _0: _level, _1: next_title });
      } else {
        moonbitlang$core$array$$Array$push$10$(updated, { _0: _level, _1: _old_title });
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return huangxl$md2mind$$render_markdown(updated);
}
function huangxl$md2mind$$parent_index(headings, index) {
  const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, index);
  const _level = _bind$2._0;
  let cursor = index - 1 | 0;
  while (true) {
    if (cursor >= 0) {
      if (moonbitlang$core$array$$Array$at$10$(headings, cursor)._0 < _level) {
        return cursor;
      }
      cursor = cursor - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return -1;
}
function huangxl$md2mind$$can_move_heading(headings, from_flat_index, to_flat_index) {
  if (from_flat_index < 0 || to_flat_index < 0) {
    return false;
  }
  if (from_flat_index >= headings.length || to_flat_index >= headings.length) {
    return false;
  }
  if (from_flat_index === to_flat_index) {
    return false;
  }
  return huangxl$md2mind$$parent_index(headings, from_flat_index) === huangxl$md2mind$$parent_index(headings, to_flat_index);
}
function huangxl$md2mind$$concat_headings(left, right) {
  const merged = [];
  const _len = left.length;
  let _tmp$2 = 0;
  while (true) {
    const _i = _tmp$2;
    if (_i < _len) {
      const item = left[_i];
      moonbitlang$core$array$$Array$push$10$(merged, item);
      _tmp$2 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _len$2 = right.length;
  let _tmp$3 = 0;
  while (true) {
    const _i = _tmp$3;
    if (_i < _len$2) {
      const item = right[_i];
      moonbitlang$core$array$$Array$push$10$(merged, item);
      _tmp$3 = _i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return merged;
}
function huangxl$md2mind$$slice_headings(headings, start, end_) {
  const sliced = [];
  let _tmp$2 = start;
  while (true) {
    const i = _tmp$2;
    if (i < end_) {
      moonbitlang$core$array$$Array$push$10$(sliced, moonbitlang$core$array$$Array$at$10$(headings, i));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return sliced;
}
function huangxl$md2mind$$move_heading(markdown, from_flat_index, to_flat_index, place_after) {
  const headings = huangxl$md2mind$$parse_headings(markdown);
  if (!huangxl$md2mind$$can_move_heading(headings, from_flat_index, to_flat_index)) {
    return markdown;
  }
  const from_end = huangxl$md2mind$$subtree_end(headings, from_flat_index);
  const to_end = huangxl$md2mind$$subtree_end(headings, to_flat_index);
  const moved = huangxl$md2mind$$slice_headings(headings, from_flat_index, from_end);
  const remaining = huangxl$md2mind$$concat_headings(huangxl$md2mind$$slice_headings(headings, 0, from_flat_index), huangxl$md2mind$$slice_headings(headings, from_end, headings.length));
  const raw_insert_at = place_after ? to_end : to_flat_index;
  const insert_at = from_flat_index < raw_insert_at ? raw_insert_at - (from_end - from_flat_index | 0) | 0 : raw_insert_at;
  const rebuilt = huangxl$md2mind$$concat_headings(huangxl$md2mind$$concat_headings(huangxl$md2mind$$slice_headings(remaining, 0, insert_at), moved), huangxl$md2mind$$slice_headings(remaining, insert_at, remaining.length));
  return huangxl$md2mind$$render_markdown(rebuilt);
}
function huangxl$md2mind$$add_child_heading(markdown, parent_flat_index, title) {
  const headings = huangxl$md2mind$$parse_headings(markdown);
  const next_title = title;
  if (next_title.length === 0) {
    return markdown;
  }
  if (parent_flat_index === -1) {
    const rebuilt = huangxl$md2mind$$concat_headings(headings, [{ _0: 1, _1: next_title }]);
    return huangxl$md2mind$$render_markdown(rebuilt);
  }
  if (parent_flat_index < 0 || parent_flat_index >= headings.length) {
    return markdown;
  }
  const _bind$2 = moonbitlang$core$array$$Array$at$10$(headings, parent_flat_index);
  const _level = _bind$2._0;
  const insert_at = huangxl$md2mind$$subtree_end(headings, parent_flat_index);
  const rebuilt = huangxl$md2mind$$concat_headings(huangxl$md2mind$$concat_headings(huangxl$md2mind$$slice_headings(headings, 0, insert_at), [{ _0: _level + 1 | 0, _1: next_title }]), huangxl$md2mind$$slice_headings(headings, insert_at, headings.length));
  return huangxl$md2mind$$render_markdown(rebuilt);
}
function huangxl$md2mind$$delete_heading(markdown, flat_index) {
  const headings = huangxl$md2mind$$parse_headings(markdown);
  if (flat_index < 0 || flat_index >= headings.length) {
    return markdown;
  }
  const end_index = huangxl$md2mind$$subtree_end(headings, flat_index);
  const rebuilt = huangxl$md2mind$$concat_headings(huangxl$md2mind$$slice_headings(headings, 0, flat_index), huangxl$md2mind$$slice_headings(headings, end_index, headings.length));
  return huangxl$md2mind$$render_markdown(rebuilt);
}
function huangxl$md2mind$cmd$main$$keep_web_api() {
  const markdown = "# MindDown Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview";
  huangxl$md2mind$$outline_json(markdown);
  huangxl$md2mind$$rename_heading(markdown, 0, "MindDown Demo");
  huangxl$md2mind$$move_heading(markdown, 1, 4, true);
  huangxl$md2mind$$add_child_heading(markdown, 4, "Export");
  huangxl$md2mind$$delete_heading(markdown, 1);
}
(() => {
  huangxl$md2mind$cmd$main$$keep_web_api();
  moonbitlang$core$builtin$$println$13$("Markdown input:");
  moonbitlang$core$builtin$$println$13$("# MindDown Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview");
  moonbitlang$core$builtin$$println$13$("");
  moonbitlang$core$builtin$$println$13$("ASCII mindmap:");
  moonbitlang$core$builtin$$println$13$(huangxl$md2mind$$demo_output());
})();

const __md2mind_sample = "# MindDown Demo\n## Parser\n### Heading extraction\n### Level mapping\n## Renderer\n### ASCII mindmap\n### Round-trip preview";

globalThis.md2mind = {
  sampleMarkdown() {
    return __md2mind_sample;
  },
  outlineJson(markdown) {
    return huangxl$md2mind$$outline_json(markdown);
  },
  renameHeading(markdown, flatIndex, title) {
    return huangxl$md2mind$$rename_heading(markdown, flatIndex, title);
  },
  moveHeading(markdown, fromFlatIndex, toFlatIndex, placeAfter) {
    return huangxl$md2mind$$move_heading(markdown, fromFlatIndex, toFlatIndex, placeAfter);
  },
  addChildHeading(markdown, parentFlatIndex, title) {
    return huangxl$md2mind$$add_child_heading(markdown, parentFlatIndex, title);
  },
  deleteHeading(markdown, flatIndex) {
    return huangxl$md2mind$$delete_heading(markdown, flatIndex);
  },
  renderAsciiMindmap(markdown) {
    return huangxl$md2mind$$render_ascii_mindmap(markdown);
  },
  demoOutput() {
    return huangxl$md2mind$$demo_output();
  },
};

export const md2mind = globalThis.md2mind;
