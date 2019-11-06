package co.id.spring.model;

public class FolderModel {

	private int idFolderDms;
	private String folderName;
	private int folderSub;
	private int folderParent;
	private int idProyekDms;
	
	public int getIdFolderDms() {
		return idFolderDms;
	}
	
	public void setIdFolderDms(int idFolderDms) {
		this.idFolderDms = idFolderDms;
	}
	
	public String getFolderName() {
		return folderName;
	}
	
	public void setFolderName(String folderName) {
		this.folderName = folderName;
	}
	
	public int getFolderSub() {
		return folderSub;
	}
	
	public void setFolderSub(int folderSub) {
		this.folderSub = folderSub;
	}
	
	public int getFolderParent() {
		return folderParent;
	}
	
	public void setFolderParent(int folderParent) {
		this.folderParent = folderParent;
	}
	
	public int getIdProyekDms() {
		return idProyekDms;
	}
	
	public void setIdProyekDms(int idProyekDms) {
		this.idProyekDms = idProyekDms;
	}
	
}
