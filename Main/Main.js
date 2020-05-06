import React, { Component } from 'react';
import Title from './Title';
import Photo from './Photo';
import './Main.css';

class Main extends Component {
  render(){
    return(
      <div>     
        <Title />
        <Photo />
      </div>
    );
  }
}

export default Main