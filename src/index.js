import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import registerServiceWorker from './registerServiceWorker';
import firebase from 'firebase';

//better content scaling for mobile devices, if the screen width is less than 600 then we scale as if it was 600
if (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)) {
	let ww = (window.innerWidth < window.screen.width) ? window.innerWidth : window.screen.width; //get proper width
	let mw = 600; // min width of site
	let ratio =  ww / mw; //calculate ratio
	if (ww < mw) { //smaller than minimum size
		document.getElementById('viewport').setAttribute('content', 'initial-scale=' + ratio + ', user-scalable=yes, width=' + ww);
	} else { //regular size
		document.getElementById('viewport').setAttribute('content', 'initial-scale=1.0, user-scalable=yes, width=' + ww);
	}
}

const config = {
    apiKey: "AIzaSyCyKa7eT6YNjw4ASlSOTUFddcM6qsMQqbg",
	authDomain: "wlscoreboard.firebaseapp.com",
	databaseURL: "https://wlscoreboard.firebaseio.com",
	projectId: "wlscoreboard",
	storageBucket: "",
	messagingSenderId: "336497861566"
};

firebase.initializeApp(config);

ReactDOM.render(<App />, document.getElementById('root'));
registerServiceWorker();
