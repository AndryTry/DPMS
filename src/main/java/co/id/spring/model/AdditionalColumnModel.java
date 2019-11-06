package co.id.spring.model;

public class AdditionalColumnModel {
	private int id;
	private String namaKolom;
	private String deskripsi;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public String getNamaKolom() {
		return namaKolom;
	}
	
	public void setNamaKolom(String namaKolom) {
		this.namaKolom = namaKolom;
	}
	
	public String getDeskripsi() {
		return deskripsi;
	}
	
	public void setDeskripsi(String deskripsi) {
		this.deskripsi = deskripsi;
	}
	
}
