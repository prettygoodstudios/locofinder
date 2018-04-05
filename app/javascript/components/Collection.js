import React from "react"
import PropTypes from "prop-types"
class Collection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      users: [],
      locations: [],
      photos: [],
      filteredArray: [],
      colls: (12/this.props.collumns),
      searchQuery: ''
    }
  }
  componentDidMount(){
    console.log("Hello Components!");
    console.log(this.props);
    var queryString = "";
    if (this.props.location != ""){
      queryString = "location="+this.props.location;
    }else{
      queryString = "user="+this.props.user;
    }
    $.get(this.props.rootUrl+"collection_api?"+queryString).then(data => {
      console.log(data);
      var users = [];
      var photos = [];
      var locations = [];
      var filteredArray = [];
      for(var i = 0;i < data.length;i++){
        photos.push(data[i][0]);
        users.push(data[i][1]);
        locations.push(data[i][2]);
        filteredArray.push(data[i]);
      }
      console.log(filteredArray);
      this.setState({
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
  render () {
    let filtered = this.state.filteredArray.filter(
      (photo) => {
        return photo[0].caption.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || photo[1].email.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || photo[2].title.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1;
      }
    );
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
        { this.props.search && <SearchBar val={this.state.searchQuery} newSearch={this.newSearch} update={this.handleSearchFormChange}/>}
        <div>
          {this.state.users.length > 0 && !this.props.search && <Grid photos={this.state.photos} users={this.state.users} locations={this.state.locations} rootUrl={this.props.rootUrl} currentUser={this.props.currentUser} colls={this.state.colls} limit={this.props.limit}></Grid>}
          {this.props.search && filtered.length > 0 && <Grid photos={fPhotos} users={fUsers} locations={fLocations} rootUrl={this.props.rootUrl} currentUser={this.props.currentUser} colls={this.state.colls} limit={this.props.limit}></Grid>}
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
  console.log(photoArray);
  const photoGrid = photoArray.map((photo,i) =>
    <div key={photo.id} className={parseDigitToString(props.colls)+" columns img-card img-card-"+(12/props.colls)}>
      <div className={"img-holder img-holder-"+(12/props.colls)}>
        <img src={photo.img_url.url} />
      </div>
      <br/>
      <p>
        <UserTag profile_img={props.users[i].profile_img} width={props.users[i].width} height={props.users[i].height} zoom={props.users[i].zoom} offsetX={props.users[i].offsetX} offsetY={props.users[i].offsetY} rootUrl={props.rootUrl} id={props.users[i].id} email={props.users[i].email} /> "{photo.caption}" <a href={props.rootUrl+"location/"+props.locations[i].id} className="img-card-link"><img src="https://s3-us-west-2.amazonaws.com/staticgeofocus/70+by+70.png" style={{width: 20, height: 20, display: 'inline'}} />{props.locations[i].title}</a> { props.currentUser != null && props.currentUser.verified && <a href={props.rootUrl+"report/new?photo"+photo.id} className="img-card-link">Report Content</a> }
      </p>
      { (props.currentUser != null ) &&  (props.currentUser.id == props.users[i].id || props.currentUser.role == 'admin') && <a href={props.rootUrl+"photo/"+photo.id} method="delete" className="button delete-button">Delete</a>}
      <a href={props.rootUrl+"photo/"+photo.id} className="button">View - {photo.views} Views</a>
    </div>
  );
  console.log(photoArray);
  return(
    <div className="row">
      {photoGrid}
    </div>
  );
}
const UserTag = (props) => {
  return(
      <a href={props.rootUrl+"user/show/"+props.id} className="img-card-link">
        <ProfileImg scaleRatio={0.0625} profile_img={props.profile_img} userWidth={props.width} userHeight={props.height} zoom={props.zoom} offsetX={props.offsetX} offsetY={props.offsetY}/>
        {props.email}
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
