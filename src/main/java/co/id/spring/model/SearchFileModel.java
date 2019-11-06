package co.id.spring.model;

public class SearchFileModel {
	private String fileName;
	private String folderPath;
	private String proyekName;
	private String projectDate;
	private String filePath;
	private String fileType;
	private String noSurat;
	private String perihal;
	private String sektor;
	private String jenisDok;
	private String uploadBy;
		
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getFolderPath() {
		return folderPath;
	}
	
	public void setFolderPath(String folderPath) {
		this.folderPath = folderPath;
	}
	
	public String getProyekName() {
		return proyekName;
	}
	
	public void setProyekName(String proyekName) {
		this.proyekName = proyekName;
	}

	public String getProjectDate() {
		return projectDate;
	}

	public void setProjectDate(String projectDate) {
		this.projectDate = projectDate;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
	public String getFileType(){
		return fileType;
	}
	
	public void setFileType(String fileType){
		this.fileType = fileType;
	}

	public String getNoSurat() {
		return noSurat;
	}

	public void setNoSurat(String noSurat) {
		this.noSurat = noSurat;
	}

	public String getPerihal() {
		return perihal;
	}

	public void setPerihal(String perihal) {
		this.perihal = perihal;
	}

	public String getSektor() {
		return sektor;
	}

	public void setSektor(String sektor) {
		this.sektor = sektor;
	}

	public String getJenisDok() {
		return jenisDok;
	}

	public void setJenisDok(String jenisDok) {
		this.jenisDok = jenisDok;
	}

	public String getUploadBy() {
		return uploadBy;
	}

	public void setUploadBy(String uploadBy) {
		this.uploadBy = uploadBy;
	}
	
}

