package co.id.spring.model;

public class PmeEksportModel {
	String proyek_name, nilai_investasi, pjpk, tahapan;
	int id_proyek_pme = 0;
	String Area;

	public String getArea() {
		return Area;
	}

	public void setArea(String area) {
		Area = area;
	}

	public int getId_proyek_pme() {
		return id_proyek_pme;
	}

	public void setId_proyek_pme(int id_proyek_pme) {
		this.id_proyek_pme = id_proyek_pme;
	}

	public String getProyek_name() {
		return proyek_name;
	}

	public void setProyek_name(String proyek_name) {
		this.proyek_name = proyek_name;
	}

	public String getNilai_investasi() {
		return nilai_investasi;
	}

	public void setNilai_investasi(String nilai_investasi) {
		this.nilai_investasi = nilai_investasi;
	}

	public String getPjpk() {
		return pjpk;
	}

	public void setPjpk(String pjpk) {
		this.pjpk = pjpk;
	}

	public String getTahapan() {
		return tahapan;
	}

	public void setTahapan(String tahapan) {
		this.tahapan = tahapan;
	}
	
}
