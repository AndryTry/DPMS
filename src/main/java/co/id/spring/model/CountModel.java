package co.id.spring.model;

public class CountModel {
	private String totalproyek;
	private String totaldokumen;
	private String totaluser;
	
	public String getTotalproyek(){
		return totalproyek;
	}
	public void setTotalproyek(String totalproyek){
		this.totalproyek = totalproyek;
	}
	
	public String getTotaldokumen(){
		return totaldokumen;
	}
	public void setTotaldokumen(String totaldokumen){
		this.totaldokumen = totaldokumen;
	}
	
	public String getTotaluser(){
		return totaluser;
	}
	public void setTotaluser(String totaluser){
		this.totaluser = totaluser;
	}

}
