import React from "react";
import LazyLoad from 'react-lazyload';
import PropTypes from "prop-types";
class Collection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      users: [],
      locations: [],
      photos: [],
      filteredArray: [],
      loading: true,
      colls: (12/this.props.collumns),
      searchQuery: ''
    }
  }
  componentDidMount(){
    var queryString = "";
    if (this.props.location != ""){
      queryString = "location="+this.props.location;
    }else{
      queryString = "user="+this.props.user;
    }
    $.get(this.props.rootUrl+"collection_api?"+queryString).then(data => {
      var users = [];
      var photos = [];
      var locations = [];
      var filteredArray = [];
      var collectionLength = data.length;
      if(this.props.limit != undefined && this.props.limit < data.length){
        collectionLength = this.props.limit;
      }
      for(var i = 0;i < collectionLength ;i++){
        photos.push(data[i][0]);
        users.push(data[i][1]);
        locations.push(data[i][2]);
        filteredArray.push(data[i]);
      }
      this.setState({
        loading: false,
        users: users,
        photos: photos,
        locations: locations,
        filteredArray: filteredArray
      });
    });
  }
  newSearch = () => {

  }
  handleSearchFormChange = (event) =>{
    const target = event.target;
    const value = target.value;
    this.setState({
      searchQuery: target.value
    });
    this.newSearch();
  };
  sortByPoints = (arr,searchQuery) =>{
    let retVal = arr.sort(function(a,b){
      var captionA = a[0].caption.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var emailA = a[1].email.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var addressA = (a[2].city+" "+a[2].state+" "+a[2].country).toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var titleA = a[2].title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var pointsA = 0;
      if(captionA){
        pointsA += 3;
      }
      if(emailA){
        pointsA += 2;
      }
      if(titleA){
        pointsA += 1;
      }
      if(addressA){
        pointsA += 1;
      }
      var captionB = b[0].caption.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var emailB = b[1].email.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var addressB = (b[2].city+" "+b[2].state+" "+b[2].country).toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var titleB = b[2].title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
      var pointsB = 0;
      if(captionB){
        pointsB += 3;
      }
      if(emailB){
        pointsB += 2;
      }
      if(titleB){
        pointsB += 1;
      }
      if(addressB){
        pointsB += 1;
      }
      if(pointsA == pointsB){
        if(a[0].views > b[0].views){
          return -1;
        }else{
          return 1;
        }
      }else if (pointsA > pointsB) {
        return -1;
      }else if (pointsA < pointsB) {
        return 1;
      }
    });
    return retVal;
  }
  render () {
    let filtered = this.state.filteredArray.filter(
      (photo) => {
        return photo[0].caption.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || photo[1].email.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || photo[2].title.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || (photo[2].city+" "+photo[2].state+" "+photo[2].country+" ").toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1;
      }
    );
    filtered = this.sortByPoints(filtered,this.state.searchQuery);
    let fUsers = [];
    let fPhotos = [];
    let fLocations = [];
    for(var i = 0; i < filtered.length; i++){
      fUsers.push(filtered[i][1]);
      fPhotos.push(filtered[i][0]);
      fLocations.push(filtered[i][2]);
    }
    return (
      <div>
        { this.props.title != "" &&
        <h1>
          {this.props.title}
        </h1>
        }
        { this.props.search && this.state.users.length > 0 && <SearchBar val={this.state.searchQuery} newSearch={this.newSearch} update={this.handleSearchFormChange}/>}
        { this.state.users.length == 0 && !this.state.loading && <p>There are no photos available.</p>}
        <div>
          {this.state.loading && <center><div className="loader"></div><br /></center> }
          {this.state.users.length > 0 && !this.props.search && <Grid photos={this.state.photos} users={this.state.users} locations={this.state.locations} rootUrl={this.props.rootUrl} currentUser={this.props.currentUser} colls={this.state.colls} limit={this.props.limit}></Grid>}
          {this.props.search && filtered.length > 0 && <Grid photos={fPhotos} users={fUsers} locations={fLocations} rootUrl={this.props.rootUrl} currentUser={this.props.currentUser} colls={this.state.colls} limit={this.props.limit} style={{marginTop: this.state.loading ? "700px" : "0px"}}></Grid>}
        </div>
      </div>
    );
  }
}
const Grid = (props) => {
  var photoArray = props.photos;
  if (props.limit != undefined && props.limit != null){
    photoArray.slice(0,props.limit);
  }
  
  const photoGrid = photoArray.map((photo,i) =>
      <LazyLoad offset={100} height={700}>
        <div key={photo.id} className={parseDigitToString(props.colls)+" columns img-card img-card-"+(12/props.colls)}>
          <div className={"img-holder img-holder-"+(12/props.colls)}>
            {photo.zoom == null && <img src={photo.img_url.url} />}
            {photo.zoom != null && <Photo url={photo.img_url.url} width={photo.width} height={photo.height} zoom={photo.zoom} offsetX={photo.offsetX} offsetY={photo.offsetY}/>}
          </div>
          <br/>
          <p>
            <UserTag profileImg={props.users[i].profile_img} width={props.users[i].width} height={props.users[i].height} zoom={props.users[i].zoom} offsetX={props.users[i].offsetX} offsetY={props.users[i].offsetY} rootUrl={props.rootUrl} id={props.users[i].id} display={props.users[i].display} /> "{photo.caption}" <a href={props.rootUrl+"location/"+props.locations[i].id} className="img-card-link" data-turbolinks="false"><img src="https://s3-us-west-2.amazonaws.com/staticgeofocus/70+by+70.png" style={{width: 20, height: 20, display: 'inline'}} />{props.locations[i].title}</a> { props.currentUser != null && props.currentUser.verified && <a href={props.rootUrl+"report/new?photo"+photo.id} className="img-card-link">Report Content</a> }
          </p>
          { (props.currentUser != null ) &&  (props.currentUser.id == props.users[i].id || props.currentUser.role == 'admin') && <a href={props.rootUrl+"photo/"+photo.id} data-method="delete" data-turbolinks="true" className="button delete-button">Delete</a>}
          <a href={props.rootUrl+"photo/"+photo.id} className="button">View - {photo.views} Views</a>
        </div>
      </LazyLoad>
  );

  return(
    <LazyLoad offset={100}>
      <div className="row" style={props.style}>
        {photoGrid}
      </div>
    </LazyLoad>
  );
}
class Photo extends React.Component{
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
    console.log("My props",props);
    var scaleRatio = 0.625;
    var finalWidth = props.width*props.zoom*scaleRatio;
    var finalHeight = props.height*props.zoom*scaleRatio;
    var finalOffsetX = props.offsetX*scaleRatio;
    var finalOffsetY = props.offsetY*scaleRatio;
    let totWidth = window.innerWidth * 0.85;
    if(window.innerWidth > 550){
      totWidth = (window.innerWidth*0.8-window.innerWidth*0.04)/2;
      if(window.innerWidth > 800){
        totWidth = (window.innerWidth*0.8-window.innerWidth*0.08)/3;
      }
    }
    let diff = totWidth - (finalWidth - Math.abs(finalOffsetX));
    console.log("Total Width",totWidth);
    console.log("Real Width", finalWidth - finalOffsetX);
    console.log(diff);
    if(diff > 0){
      //finalOffsetX +=  totWidth - (finalWidth - finalOffsetX);
      const scaleY = 250/(finalHeight-Math.abs(finalOffsetY));
      const scaleX = totWidth/(finalWidth-Math.abs(finalOffsetX));
      const scaleUp =  scaleY > scaleX ? scaleY : scaleX;
      finalOffsetX *= scaleUp;
      finalOffsetY *= scaleUp;
      finalWidth *= scaleUp;
      finalHeight *= scaleUp;
      console.log("Final Width", finalWidth - finalOffsetX);
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
const UserTag = ({rootUrl, id, profileImg, display, width, height, zoom, offsetX, offsetY}) => {
  return(
      <a href={rootUrl+"user/show/"+id} className="img-card-link" data-turbolinks="false">
        <ProfileImg scaleRatio={0.0625} profile_img={profileImg} userWidth={width} userHeight={height} zoom={zoom} offsetX={offsetX} offsetY={offsetY}/>
        <span className="profile-email">{display}</span>
      </a>
  );
}
const ProfileImg = (props) => {
  const displayWidth = props.scaleRatio*400;
  var image = "";
  if(props.profile_img.url != undefined){
    console.log(props);
    const finalWidth = props.scaleRatio * props.userWidth * parseFloat(props.zoom);
    const finalHeight = props.scaleRatio * props.userHeight * parseFloat(props.zoom);
    const finalOffsetX = props.offsetX * props.scaleRatio;
    const finalOffsetY = props.offsetY * props.scaleRatio;
    image = <img src={props.profile_img.url} style={{width: finalWidth,height: finalHeight,marginLeft: finalOffsetX,marginTop: finalOffsetY}}/>;
  }
  return(
    <span className="profile-img" style={{background: "black",width: displayWidth,height: displayWidth}}>
      {image}
    </span>
  );
}
const SearchBar = (props) => {
  return(
    <div className="search-bar">
      <input type="text" value={props.val} onChange={props.update} placeholder="&#xF002; Search" style={{fontFamily: "Helvetica ,FontAwesome"}}/>
    </div>
  );
}
function parseDigitToString(num){
  var retVal = "";
  switch(num){
    case 0:
      retVal = "zero";
      break;
    case 1:
      retVal = "one";
      break;
    case 2:
      retVal = "two";
      break;
    case 3:
      retVal = "three";
      break;
    case 4:
      retVal = "four";
      break;
    case 5:
      retVal = "five";
      break;
    case 6:
      retVal = "six";
      break;
    case 7:
      retVal = "seven";
      break;
    case 8:
      retVal = "eight";
      break;
    case 9:
      retVal = "nine";
      break;
  }
  return retVal;
}
Collection.propTypes = {
  title: PropTypes.string,
  user: PropTypes.string,
  location: PropTypes.string,
  rootUrl: PropTypes.string,
  currentUser: PropTypes.object,
  limit: PropTypes.number,
  collumns: PropTypes.number,
  search: PropTypes.bool
};
export default Collection;
