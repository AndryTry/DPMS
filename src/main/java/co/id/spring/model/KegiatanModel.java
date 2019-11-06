package co.id.spring.model;

public class KegiatanModel {

	private int idKegiatan;
	private String namaKegiatan;
	private String target;
	private String realisasi;
	private String keterangan;
	private String status;
	private int id_user;
	private String username;
	
	public int getId_user() {
		return id_user;
	}

	public void setId_user(int id_user) {
		this.id_user = id_user;
	}

	public int getIdKegiatan() {
		return idKegiatan;
	}
	
	public void setIdKegiatan(int idKegiatan) {
		this.idKegiatan = idKegiatan;
	}
	
	public String getNamaKegiatan() {
		return namaKegiatan;
	}
	
	public void setNamaKegiatan(String namaKegiatan) {
		this.namaKegiatan = namaKegiatan;
	}
	
	public String getTarget() {
		return target;
	}
	
	public void setTarget(String target) {
		this.target = target;
	}
	
	public String getRealisasi() {
		return realisasi;
	}
	
	public void setRealisasi(String realisasi) {
		this.realisasi = realisasi;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}

	public String getKeterangan() {
		return keterangan;
	}

	public void setKeterangan(String keterangan) {
		this.keterangan = keterangan;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
}