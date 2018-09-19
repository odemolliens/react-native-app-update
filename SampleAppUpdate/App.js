/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View
} from 'react-native';

import { NativeModules } from 'react-native';
const { ODAppUpdate } = NativeModules;



const instructions = Platform.select({
  ios: 'Hello world',
  android: 'Hello world',
});

type Props = {};
export default class App extends Component<Props> {

  constructor(){
    super();
    ODAppUpdate.appVersion()
      .then(response => {
        // New version installed
        console.warn('good')
        console.log(response)
      })
        .catch(error => {
            // No update installed (or error occured)
          console.warn(error.message)
        });
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
