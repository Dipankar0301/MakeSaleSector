public class Sector_EFLApiResponse {
    
    public cls_well_to_tank well_to_tank;
	public cls_tank_to_wheel tank_to_wheel;
	public cls_well_to_wheel well_to_wheel;
	class cls_well_to_tank {
		public Double value;	//0.06119768
		public String uom;	//tonne of CO₂ equivalent
		public cls_sources[] sources;
	}
	class cls_sources {
		public Integer id;	//6
		public String name;	//DEFRA 2021
		public String description;	//A set of emission conversion factors for use by UK and international organisations to report greenhouse gas emissions.
		public String publication_date;	//2021-06-02T00:00:00Z
		public String source_url;	//https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021
		public cls_publisher publisher;
		public cls_parts[] parts;
		public boolean show_disclaimer_info;
	}
	class cls_publisher {
		public Integer id;	//5
		public String name;	//UK Department for Environment, Food and Rural Affairs
		public String short_name;	//DEFRA
		public String description;	//The UK Government Department for Environment, Food and Rural Affairs is responsible for environmental protection, food production and standards, agriculture, fisheries and rural communities.
	}
	class cls_parts {
	}
	class cls_tank_to_wheel {
		public Double value;	//0.25024876
		public String uom;	//tonne of CO₂ equivalent
		public cls_sources[] sources;
	}
	class cls_well_to_wheel {
		public Double value;	//0.31144644
		public String uom;	//tonne of CO₂ equivalent
		public cls_sources[] sources;
	}
	public static Sector_EFLApiResponse parse(String json){
		return (Sector_EFLApiResponse) System.JSON.deserialize(json, Sector_EFLApiResponse.class);
	}

	
    
    
    
    
  
}