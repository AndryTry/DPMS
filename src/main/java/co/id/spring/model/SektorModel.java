package co.id.spring.model;

import java.util.Map;

public class SektorModel {
	private int idSektor;
	private String namaSektor;
	private Map<String, Object> sectorMap;
	
	public Map<String, Object> getSectorMap() {
		return sectorMap;
	}

	public void setSectorMap(Map<String, Object> sectorMap) {
		this.sectorMap = sectorMap;
	}

	public int getIdSektor(){
		return idSektor;
	}
	
	public void setIdSektor(int idSektor){
		this.idSektor = idSektor;
	}
	
	public String getNamaSektor(){
		return namaSektor;
	}
	
	public void setNamaSektor(String namaSektor){
		this.namaSektor = namaSektor;
	}
	
}
