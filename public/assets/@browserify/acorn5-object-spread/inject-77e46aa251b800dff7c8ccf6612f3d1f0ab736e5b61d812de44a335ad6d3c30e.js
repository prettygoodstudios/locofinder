!function(){function t(e,r,n){function i(s,a){if(!r[s]){if(!e[s]){var p="function"==typeof require&&require;if(!a&&p)return p(s,!0);if(o)return o(s,!0);var c=new Error("Cannot find module '"+s+"'");throw c.code="MODULE_NOT_FOUND",c}var u=r[s]={exports:{}};e[s][0].call(u.exports,function(t){var r=e[s][1][t];return i(r||t)},u,u.exports,t,e,r,n)}return r[s].exports}for(var o="function"==typeof require&&require,s=0;s<n.length;s++)i(n[s]);return i}return t}()({1:[function(t,e){"use strict";e.exports=function(t){var e=t.version.match(/^5\.(\d+)\./);if(!e||Number(e[1])<2)throw new Error("Unsupported acorn version "+t.version+", please use acorn 5 >= 5.2");var r=t.tokTypes,n=function(t){return function(e,r,n){var i=this;if("ObjectPattern"!=e.type)return"Property"===e.type?this.checkLVal(e.value,r,n):t.apply(this,arguments);e.properties.forEach(function(t){i.checkLVal(t,r,n)})}};return t.plugins.objectSpread=function(t){t.extend("parseProperty",function(t){return function(e,n){var i;return this.options.ecmaVersion>=6&&this.type===r.ellipsis?(e?(i=this.startNode(),this.next(),i.argument=this.parseIdent(),this.finishNode(i,"RestElement")):i=this.parseSpread(n),this.type===r.comma&&(e?this.raise(this.start,"Comma is not permitted after the rest element"):n&&n.trailingComma<0&&(n.trailingComma=this.start)),i):t.apply(this,arguments)}}),t.extend("checkPropClash",function(t){return function(e){if("SpreadElement"!=e.type&&"RestElement"!=e.type)return t.apply(this,arguments)}}),t.extend("checkLVal",n),t.extend("toAssignable",function(t){return function(e,r){var n=this;if(this.options.ecmaVersion>=6&&e){if("ObjectExpression"==e.type)return e.type="ObjectPattern",e.properties.forEach(function(t){n.toAssignable(t,r)}),e;if("Property"===e.type)return"init"!==e.kind&&this.raise(e.key.start,"Object pattern can't contain getter or setter"),this.toAssignable(e.value,r);if("SpreadElement"===e.type)return e.type="RestElement",this.toAssignable(e.argument,r)}return t.apply(this,arguments)}}),t.extend("checkPatternExport",function(t){return function(e,r){var n=this;if("ObjectPattern"!=r.type)return"Property"===r.type?this.checkPatternExport(e,r.value):"RestElement"===r.type?this.checkPatternExport(e,r.argument):void t.apply(this,arguments);r.properties.forEach(function(t){n.checkPatternExport(e,t)})}})},t}},{}]},{},[1]);