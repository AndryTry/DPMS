package co.id.spring.model; 

public class JenisDokumenModel {
	private int idJenisDokumen;
	private String namaJenisDokumen;
	
	public int getIdJenisDokumen(){
		return idJenisDokumen;
	}
	public void setIdJenisDokumen(int idJenisDokumen){
		this.idJenisDokumen = idJenisDokumen;
	}
	
	public String getNamaJenisDokumen(){
		return namaJenisDokumen;
	}
	public void setNamaJenisDokumen(String namaJenisDokumen){
		this.namaJenisDokumen = namaJenisDokumen;
	}
}
