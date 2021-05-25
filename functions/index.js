/* eslint-disable no-mixed-spaces-and-tabs */
/* eslint-disable no-tabs */
/* eslint-disable prefer-const */
const functions = require("firebase-functions");
const distance = require("google-distance-matrix");
// const bounds = new google.maps.LatLngBounds();
const HashMap = require("hashmap");
distance.key("AIzaSyBC-3s8CcMfSKWMoU96Bkb3c3gQ34QVdHM");
distance.units("imperial");

let station = new HashMap;
// let metersFromStation = new HashMap;
// eslint-disable-next-line max-len
station.set("Nørreport St.", {latitude: 55.68372763388621, longitude: 12.57157366748944});
exports.getNearestStation = functions.https.onCall((data, context) => {
  let currentMarkerLat = data.currentMarkerLat;
  let currentMarkerLot = data.currentMarkerLot;
  let destination = [`${currentMarkerLat}, ${currentMarkerLot}`];
  let origin = ["55.68372763388621, 12.57157366748944"];
  // station.forEach((key, value) => {
  // let lat = value.latitude;
  // let lot = value.longitude;
  // eslint-disable-next-line max-len
  // distance1(currentMarkerLat, currentMarkerLot, value.latitude, value.longitude, key);
  // eslint-disable-next-line require-jsdoc
  distance.matrix(origin, destination, function(distances) {
    for (let i=0; i < origin.length; i++) {
      for (let j=0; i < destination.length; j++) {
        let origin = distances.origin_addresses[i];
        let destination = distances.destination_addresses[j];
        // if (distances.rows[0].elements[j].status == "OK") {
        let distance = distances.rows[i].elements[j].distance.text;
        // eslint-disable-next-line max-len
        return {response: {"Distance From": origin, "to": destination, "Is": distance}};
        // } else {
        // return {response: {"Hitting else": "Shiat"}};
        // }
      }
    }
  });


  // eslint-disable-next-line max-len
  // return {response: "hitting bottom Return"};
  // eslint-disable-next-line max-len
  // return {response: {"valueOne": value.latitude, "valueTwo": value.longitude, "currentMarkerLat": currentMarkerLat, "currentMarkerLot": currentMarkerLot}};
  return {"fuckAll": "Steffen"};
  // eslint-disable-next-line max-len
  // });
  // eslint-disable-next-line valid-jsdoc
/**
 * @param {latitude currentmarker} lat1
 * @param {longitude currentmarker} lot1
 * @param {latitude trainstation} lat2
 * @param {longitude trainstation} lot2
 * @return{stations}
 */
// function distance1(lat1, lot1, lat2, lot2, key) {
//   if ((lat1 == lat2) && (lot1 == lot2)) {
//     return {response: "empty"};
//   } else {
//     let radlat1 = Math.PI * lat1/180;
//     let radlat2 = Math.PI * lat2/180;
//     let theta = lot1-lot2;
//     let radtheta = Math.PI * theta/180;
//     // eslint-disable-next-line max-len
// eslint-disable-next-line max-len
//     let dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
//     if (dist > 1) {
//       dist = 1;
//     }
//     dist = Math.acos(dist);
//     dist = dist * 180/Math.PI;
//     dist = dist * 60 * 1.1515;
//     if (key=="K") {
//       dist = dist * 1.609344;
//     }
// 	    // eslint-disable-next-line no-mixed-spaces-and-tabs
// 	    if (key=="N") {
//       dist = dist * 0.8684;
//     }
//     metersFromStation.set(key, dist);
//     return {reponse: "hejsan"};
//   }
// }
// eslint-disable-next-line max-len
// "currentlat": currentMarkerLat, "currenLot": currentMarkerLot};
// "${value.latitude},${value.longitude}",
//   return {
//     response: {"value": distance.latitude, "value1": distance.longitude},
//   };
});
