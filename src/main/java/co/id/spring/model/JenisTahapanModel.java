package co.id.spring.model;

public class JenisTahapanModel {
	
	private int idJenisTahapan;
	private String namaJenisTahapan;
	private String subName;
	private int status;
	private String disableEnabled;
	private int id_user;
	
	public int getId_user() {
		return id_user;
	}

	public void setId_user(int id_user) {
		this.id_user = id_user;
	}

	public int getIdJenisTahapan() {
		return idJenisTahapan;
	}
	
	public void setIdJenisTahapan(int idJenisTahapan) {
		this.idJenisTahapan = idJenisTahapan;
	}
	
	public String getNamaJenisTahapan() {
		return namaJenisTahapan;
	}
	
	public void setNamaJenisTahapan(String namaJenisTahapan) {
		this.namaJenisTahapan = namaJenisTahapan;
	}
	
	
	public int getStatus() {
		return status;
	}
	
	public void setStatus(int status) {
		this.status = status;
	}

	public String getSubName() {
		return subName;
	}

	public void setSubName(String subName) {
		this.subName = subName;
	}

	public String getDisableEnabled() {
		return disableEnabled;
	}

	public void setDisableEnabled(String disableEnabled) {
		this.disableEnabled = disableEnabled;
	}
	
}