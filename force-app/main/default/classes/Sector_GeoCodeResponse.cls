public class Sector_GeoCodeResponse {
  public class Address_components {
    public String long_name;
    public String short_name;
    public List<String> types;
  }

  public List<Results> results;
  public String status;
  public String error_message;
  //public String response;

  public class Location {
    public Double lat;
    public Double lng;
  }

  public class Geometry {
    public Location location;
    public String location_type;
    public Viewport viewport;
  }
    public class Results {
    public List<Address_components> address_components;
    public String formatted_address;
    public Geometry geometry;
    public List<String> types;
  }

  public class Viewport {
    public Location northeast;
    public Location southwest;
  }
        
  public static Sector_GeoCodeResponse parse(String json) {
    return (Sector_GeoCodeResponse) System.JSON.deserialize(json, Sector_GeoCodeResponse.class);
  }
}