package com.brunobergamo.cobranca.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.brunobergamo.cobranca.model.StatusTitulo;
import com.brunobergamo.cobranca.model.Titulo;
import com.brunobergamo.cobranca.repository.Titulos;

@Controller
@RequestMapping("/titulos")
public class TituloController {

	@Autowired
	private Titulos titulos;

	@RequestMapping("/novo")
	public ModelAndView novo()
	{
		ModelAndView modelAndView = new ModelAndView("CadastroTitulo");
		return modelAndView;
	}

	@ModelAttribute("todosStatusTitulos")
	private List<StatusTitulo> addStatusCombo() 
	{
		return Arrays.asList(StatusTitulo.values());
	}

	@RequestMapping(method= RequestMethod.POST)
	public ModelAndView salvar(Titulo pTitulo)
	{
		titulos.save(pTitulo);
		System.out.println(pTitulo.getDescricao());
		ModelAndView modelAndView = new ModelAndView("CadastroTitulo");
		modelAndView.addObject("mensagem", "Título salvo com sucesso");
		return modelAndView;
	}
}
