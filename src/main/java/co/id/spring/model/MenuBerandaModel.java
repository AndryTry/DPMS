package co.id.spring.model; 

public class MenuBerandaModel {
	private int idMenu;
	private String namaMenu;
	private String url;
	private String jenis;
	private String content;
	
	public int getIdMenu(){
		return idMenu;
	}
	public void setIdMenu(int idMenu){
		this.idMenu = idMenu;
	}
	
	public String getNamaMenu(){
		return namaMenu;
	}
	public void setNamaMenu(String namaMenu){
		this.namaMenu = namaMenu;
	}
	
	public String getUrl(){
		return url;
	}
	public void setUrl(String url){
		this.url = url;
	}
	
	public String getJenis(){
		return jenis;
	}
	public void setJenis(String jenis){
		this.jenis = jenis;
	}
	
	public String getContent(){
		return content;
	}
	public void setContent(String content){
		this.content = content;
	}
}
