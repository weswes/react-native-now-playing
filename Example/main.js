import React, { Component } from 'react';
import { View, NativeAppEventEmitter} from 'react-native';
import RNNowPlaying from 'react-native-now-playing';

export default class Example extends Component {
  
  componentDidMount(){
    NativeAppEventEmitter.addListener('nowPlayingEvent', function(e: Event) {
        console.log("Musique detectée:" + e.title);
        console.log(e);
    });
  }
  
  render() {
    return (
      <View>
      </View>
    );
  }
}