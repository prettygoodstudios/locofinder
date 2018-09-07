import React from "react";
import PropTypes from "prop-types";
class LocationSearch extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      locations: [],
      searchQuery: ""
    }
  }
  componentDidMount(){
    $.get(this.props.rootUrl+"geo_json_api").then(data =>{
      var locos = [];
      for(var i = 0; i < data.length; i++){
        locos.push(data[i]);
      }
      this.setState({
        locations: locos
      });
    });
  }
  handleSearchFormChange = (event) =>{
    const target = event.target;
    const value = target.value;
    this.setState({
      searchQuery: target.value
    });
  };
  sortByPoints = (arr, sQ) =>{
    let retVal = arr.sort(function(a,b){
      let pointsB = 0;
      let pointsA = 0;
      sQ.split(" ").forEach((searchQuery) => {
        var titleA = a.title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
        var addressA = a.address.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
        if(titleA){
          pointsA += 2;
        }
        if(addressA){
          pointsA++;
        }
        var titleB = b.title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
        var addressB = b.address.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
        if(titleB){
          pointsB += 2;
        }
        if(addressB){
          pointsB++;
        }
      });
      if (pointsA > pointsB) {
        return -1;
      }
      if (pointsA < pointsB) {
        return 1;
      }
    });
    return retVal;
  }

  subQuery = (sQ, location) => {
    return location.address.toLowerCase().indexOf(sQ.toLowerCase()) !== -1 || location.title.toLowerCase().indexOf(sQ.toLowerCase()) !== -1;
  }

  render () {
    const {locations, searchQuery} = this.state;

    let filtered = locations.filter(
      (location) => {
        const searchTerms = searchQuery.split(" ");
        let found = false;
        searchTerms.forEach((t) => {
          if(this.subQuery(t, location)){
            found = true;
          }
        });
        return found;
      }
    );
    filtered = this.sortByPoints(filtered, searchQuery);
    if (filtered.length > 7) filtered.length = 7;
    let results = filtered.map((location) =>
      <div className="location-search-result">
        <h3><a href={this.props.rootUrl+"location/"+location.id} data-turbolinks="false">{location.title}</a></h3>
        <p>{location.address}</p>
      </div>
    );
    return (
      <div className="location-search">
        <input type="text" value={searchQuery} onChange={this.handleSearchFormChange} placeholder="&#xF002; Search" style={{fontFamily: "Helvetica ,FontAwesome"}}/>
        { searchQuery != "" && results }
      </div>
    );
  }
}
LocationSearch.propTypes = {
  rootUrl: PropTypes.string
};
export default LocationSearch;
