import { NativeEventEmitter, NativeModules, Platform } from 'react-native';

const RNNowPlaying = NativeModules.RNNowPlaying;
const NowPlayingEventEmitter = new NativeEventEmitter(RNNowPlaying);

const fetchDeezerData = (deezerUserId) =>
	fetch("http://www.deezer.com/profile/" + deezerUserId)
		.then(response => {
			var html = response.text()["_55"];
			var regexp = new RegExp(/{("online":{).*?(?=,"ALB_PICTURE")/g);
			let res = regexp.exec(html)[0] + "}}";
			res = JSON.parse(res);
			return {
				title: res.online.SNG_TITLE,
				artist: res.online.ART_NAME,
				albumTitle: res.online.ALB_TITLE
			};
		})
		.catch(error => {
			console.log("API getDeezer error:" + error);
		});
		
class NowPlaying {
	/**
	Begin observing for music events
	Android: 
	- Register to 'all' music players intent in Native Module
	iOS:  
	- Register to Apple music events in Native Module
	- Auth and register Spotify events in Native Module if installed
	- Auth and fetch every 60sec Deezer now playing song
	**/
	startObserving(eventCallback) {
		console.log("NowPlaying startObserving");
		this.eventCallback = eventCallback;
		RNNowPlaying.startObserving();
		// Suscribe to Native Module events
		this.listener = NowPlayingEventEmitter.addListener(
			"NowPlayingEvent",
			this.eventCallback
		);
		if (Platform.OS == "ios")
			this.authDeezer();
	}
	
	stopObserving() {
		console.log("NowPlaying stopObserving");
		this.listener.remove();
		//TODO RNNowPlaying.stopObserving();
		if (Platform.OS == "ios")
			clearInterval(this.deezerInterval);
	}
	
	//////////////////////////////////////////////////////////
	// DEEZER: for iOS only									//
	//////////////////////////////////////////////////////////
	
	/**
	Auth with deezer and retrieve deezer User Id
	Then call fetchDeezerData every 60sec
	**/
	authDeezer(){
		console.log("NowPlaying authDeezer");
		this.deezerUserId = "";
		this.deezerInterval = setInterval(fetchDeezerData, 60000);
	}
	
	fetchDeezerData(){
		console.log("NowPlaying fetchDeezerData");
		var deezerNowPlaying = fetchDeezerData(this.deezerUserId);
		this.eventCallback(deezerNowPlaying.title, deezerNowPlaying.albumTitle, deezerNowPlaying.artist, "iOS", "Deezer");
	}
	
}

export default new NowPlaying();
