import React, {Component} from 'react';

export default class Photo extends Component{
    constructor(props){
      super(props);
      this.state = {
        finalWidth: 0,
        finalHeight: 0,
        finalOffsetX: 0,
        finalOffsetY: 0
      }
    }
  
    componentDidMount(){
      this.updateDimensions();
      window.addEventListener("resize", () =>  this.updateDimensions());
    }
  
    updateDimensions = () => {
      const props = this.props;
      const colls = 12/props.colls;
      var scaleRatio = 0.625;
      var finalWidth = props.width*props.zoom*scaleRatio;
      var finalHeight = props.height*props.zoom*scaleRatio;
      var finalOffsetX = props.offsetX*scaleRatio;
      var finalOffsetY = props.offsetY*scaleRatio;
      let totWidth = window.innerWidth - 40;
      console.log("My Colls", colls);
      if(window.innerWidth > 550 && colls != 1){
        totWidth = (window.innerWidth*0.8-window.innerWidth*0.04)/2;
        if(window.innerWidth > 800 &&  colls != 2){
          totWidth = (window.innerWidth*0.8-window.innerWidth*0.08)/3;
        }
      }
      let diff = totWidth - (finalWidth - Math.abs(finalOffsetX));
      if(diff > 0){
        //finalOffsetX +=  totWidth - (finalWidth - finalOffsetX);
        const scaleY = 250/(finalHeight-Math.abs(finalOffsetY));
        const scaleX = totWidth/(finalWidth-Math.abs(finalOffsetX));
        const scaleUp =  scaleY > scaleX ? scaleY : scaleX;
        finalOffsetX *= scaleUp;
        finalOffsetY *= scaleUp;
        finalWidth *= scaleUp;
        finalHeight *= scaleUp;
      }
      this.setState({
        finalWidth,
        finalHeight,
        finalOffsetX,
        finalOffsetY
      });
    }
  
    render(){
      const {finalWidth, finalHeight, finalOffsetX, finalOffsetY} = this.state;
      const {props} = this;
      return(
        <img style={{width: finalWidth,height: finalHeight,marginLeft: finalOffsetX,marginTop: finalOffsetY}} src={props.url}/>
      );
    }
  }