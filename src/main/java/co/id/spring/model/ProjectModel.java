package co.id.spring.model;

public class ProjectModel {
	private int projectID;
	private String projectName;
	private String area; //==project_region
	private String progress;
	private String sector;
	private String projectDate;
	private String noDataQuery;
	private String valueFileName;
	private String valueProjectName;
	private String valueTahunFrom;
	private String valueTahunTo;
	private int sectorID;
	private int areaID;
	private int userID;
	private String pjpk;
	private String nilaiProyek;
	private String sektor;
	private String nilaiInvestasi;
	private String mapTitle;
	
	
	public String getProjectDate() {
		return projectDate;
	}

	public void setProjectDate(String projectDate) {
		this.projectDate = projectDate;
	}

	public String getSector() {
		return sector;
	}

	public void setSector(String sector) {
		this.sector = sector;
	}

	public String getNoDataQuery() {
		return noDataQuery;
	}

	public void setNoDataQuery(String noDataQuery) {
		this.noDataQuery = noDataQuery;
	}

	public String getValueFileName() {
		return valueFileName;
	}

	public void setValueFileName(String valueFileName) {
		this.valueFileName = valueFileName;
	}

	public String getValueProjectName() {
		return valueProjectName;
	}

	public void setValueProjectName(String valueProjectName) {
		this.valueProjectName = valueProjectName;
	}

	public String getValueTahunFrom() {
		return valueTahunFrom;
	}

	public void setValueTahunFrom(String valueTahunFrom) {
		this.valueTahunFrom = valueTahunFrom;
	}

	public String getValueTahunTo() {
		return valueTahunTo;
	}

	public void setValueTahunTo(String valueTahunTo) {
		this.valueTahunTo = valueTahunTo;
	}

	public int getProjectID() {
		return projectID;
	}
	
	public void setProjectID(int projectID) {
		this.projectID = projectID;
	}
	
	public String getProjectName() {
		return projectName;
	}
	
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	public String getArea() {
		return area;
	}
	
	public void setArea(String area) {
		this.area = area;
	}
	
	public String getProgress() {
		return progress;
	}
	
	public void setProgress(String progress) {
		this.progress = progress;
	}
	
	public int getSectorID() {
		return sectorID;
	}

	public void setSectorID(int sectorID) {
		this.sectorID = sectorID;
	}
	
	public int getAreaID() {
		return areaID;
	}

	public void setAreaID(int areaID) {
		this.areaID = areaID;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getPjpk() {
		return pjpk;
	}

	public void setPjpk(String pjpk) {
		this.pjpk = pjpk;
	}

	public String getNilaiProyek() {
		return nilaiProyek;
	}

	public void setNilaiProyek(String nilaiProyek) {
		this.nilaiProyek = nilaiProyek;
	}
	
	public String getSektor() {
		return sektor;
	}

	public void setSektor(String sektor) {
		this.sektor = sektor;
	}
	
	public String getNilaiInvestasi() {
		return nilaiInvestasi;
	}

	public void setNilaiInvestasi(String nilaiInvestasi) {
		this.nilaiInvestasi = nilaiInvestasi;
	}

	public String getMapTitle() {
		return mapTitle;
	}

	public void setMapTitle(String mapTitle) {
		this.mapTitle = mapTitle;
	}
	
		
}