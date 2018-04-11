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
      console.log(this.state.locations);
    });
  }
  handleSearchFormChange = (event) =>{
    const target = event.target;
    const value = target.value;
    this.setState({
      searchQuery: target.value
    });
    console.log(this.state.searchQuery);
  };
  render () {
    console.log(this.state.locations);
    let filtered = this.state.locations.filter(
      (location) => {
        return location.address.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1 || location.title.toLowerCase().indexOf(this.state.searchQuery.toLowerCase()) !== -1;
      }
    );
    if (filtered.length > 7) filtered.length = 7;
    let results = filtered.map((location) =>
      <div className="location-search-result">
        <h3><a href={this.props.rootUrl+"location/"+location.id} data-turbolinks="false">{location.title}</a></h3>
        <p>{location.address}</p>
      </div>
    );
    return (
      <div className="location-search">
        <input type="text" value={this.state.searchQuery} onChange={this.handleSearchFormChange} placeholder="&#xF002; Search" style={{fontFamily: "Helvetica ,FontAwesome"}}/>
        { this.state.searchQuery != "" && results }
      </div>
    );
  }
}
LocationSearch.propTypes = {
  rootUrl: PropTypes.string
};
export default LocationSearch;
