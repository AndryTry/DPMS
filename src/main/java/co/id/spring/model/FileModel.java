package co.id.spring.model;

public class FileModel {

	private int id_file;
	private String file_name;
	private String file_path;
	private String folder_path;
	private String file_type;
	private String date;
	private String perihal;
	private String nomor_surat;
	private int id_jenis_dokumen;
	private String nama_jenis_dokumen;
	private String uploadBy;
	private String editBy;
	private String editDate;
	private String date_surat;
	private int id_user;
	private String proyek_name;
	
	public String getProyek_name() {
		return proyek_name;
	}

	public void setProyek_name(String proyek_name) {
		this.proyek_name = proyek_name;
	}

	public int getId_user() {
		return id_user;
	}

	public void setId_user(int id_user) {
		this.id_user = id_user;
	}

	public String getDate_surat() {
		return date_surat;
	}

	public void setDate_surat(String date_surat) {
		this.date_surat = date_surat;
	}

	public int getId_file() {
		return id_file;
	}
	
	public void setId_file(int id_file) {
		this.id_file = id_file;
	}
	
	public String getFile_name() {
		return file_name;
	}
	
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}
	
	public String getFile_path() {
		return file_path;
	}
	
	public void setFile_path(String file_path) {
		this.file_path = file_path;
	}
	
	public String getFolder_path() {
		return folder_path;
	}
	
	public void setFolder_path(String folder_path) {
		this.folder_path = folder_path;
	}
	
	public String getFile_type() {
		return file_type;
	}
	
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	
	public String getDate() {
		return date;
	}
	
	public void setDate(String date) {
		this.date = date;
	}

	public String getPerihal() {
		return perihal;
	}

	public void setPerihal(String perihal) {
		this.perihal = perihal;
	}

	public String getNomor_surat() {
		return nomor_surat;
	}

	public void setNomor_surat(String nomor_surat) {
		this.nomor_surat = nomor_surat;
	}

	public String getNama_jenis_dokumen() {
		return nama_jenis_dokumen;
	}

	public void setNama_jenis_dokumen(String nama_jenis_dokumen) {
		this.nama_jenis_dokumen = nama_jenis_dokumen;
	}

	public String getUploadBy() {
		return uploadBy;
	}

	public void setUploadBy(String uploadBy) {
		this.uploadBy = uploadBy;
	}

	public String getEditBy() {
		return editBy;
	}

	public void setEditBy(String editBy) {
		this.editBy = editBy;
	}

	public int getId_jenis_dokumen() {
		return id_jenis_dokumen;
	}

	public void setId_jenis_dokumen(int id_jenis_dokumen) {
		this.id_jenis_dokumen = id_jenis_dokumen;
	}

	public String getEditDate() {
		return editDate;
	}

	public void setEditDate(String editDate) {
		this.editDate = editDate;
	}
	
	
	
	
}
