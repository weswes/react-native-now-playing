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
		// Tester si token existe
		const APP_ID = "215504"; // 
		const REDIRECT_URI = "";
		const authUrl = "https://connect.deezer.com/oauth/auth.php?app_id="+APP_ID+"&redirect_uri="+REDIRECT_URI+"&perms=basic_access,offline_access&response_type=token";
		// Fetch will open browser and then redirect user to the app
		fetch(authUrl)
			.then(response => {

			})
			.catch(error => {
				console.log("Auth Deezer error:" + error);
			});
		

		this.deezerUserId = "";
		this.deezerInterval = setInterval(fetchDeezerData, 60000);
	}
	
	
	authDeezerCallback(){
		//save token
		console.log(response);
		token = ""; // save token as it never expire
		fetch("https://api.deezer.com/user/me?token"+token)
			.then(response => {
				console.log(response);
				user = "";
			})
	}
	
	fetchDeezerData(){
		console.log("NowPlaying fetchDeezerData");
		var deezerNowPlaying = fetchDeezerData(this.deezerUserId);
		this.eventCallback(deezerNowPlaying.title, deezerNowPlaying.albumTitle, deezerNowPlaying.artist, "iOS", "Deezer");
	}
	
}

export default new NowPlaying();
