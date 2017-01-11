package com.brunobergamo.cobranca.model;

public enum StatusTitulo {

	PENDENTE("Pendente"),
	CANCELADO("Cancelado"),
	RECEBIDO("Recebido");
	
	private String descricao;
	
	StatusTitulo(String pDescricao) {
		descricao = pDescricao;
	}
	
	public String getDescricao()
	{
		return descricao;
	}
}
