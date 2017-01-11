package com.brunobergamo.cobranca.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.brunobergamo.cobranca.model.Titulo;

public interface Titulos extends JpaRepository<Titulo, Long> {

}
