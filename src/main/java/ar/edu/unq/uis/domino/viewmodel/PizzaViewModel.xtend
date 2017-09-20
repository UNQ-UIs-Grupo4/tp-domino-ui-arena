package ar.edu.unq.uis.domino.viewmodel

import org.uqbar.commons.model.annotations.TransactionalAndObservable
import org.uqbar.commons.applicationContext.ApplicationContext
import org.uqbar.commons.model.utils.ObservableUtils
import ar.edu.unq.uis.domino.repo.RepoIngredientes
import ar.edu.unq.uis.domino.model.Ingrediente
import ar.edu.unq.uis.domino.model.Pizza
import org.eclipse.xtend.lib.annotations.Accessors
import ar.edu.unq.uis.domino.model.Distribucion
import ar.edu.unq.uis.domino.repo.RepoDistribucion
import ar.edu.unq.uis.domino.model.IngredienteDistribuido
import org.uqbar.commons.model.annotations.Dependencies
import ar.edu.unq.uis.domino.repo.Repositories

@Accessors
@TransactionalAndObservable
class PizzaViewModel {
	
	Pizza pizza = new Pizza()
	Ingrediente ingredienteSeleccionado
	Distribucion distribucionSeleccionada
	
	
	def getIngredientes(){
		Repositories.getIngredientes().allInstances
	}
	
	def eliminarSeleccionado() {
		if (ingredienteSeleccionado == null){
			return
		}
		Repositories.getIngredientes().delete(ingredienteSeleccionado)
		ingredienteSeleccionado = null
		refresh
	}
	
	def refresh(){
		ObservableUtils.firePropertyChanged(this, "ingredientes", getIngredientes)
	}
	
	def getDistribuciones(){
		Repositories.getDistribuciones.allInstances
	}
	
	def agregarIngrediente() {
		val nuevo = new IngredienteDistribuido(ingredienteSeleccionado, distribucionSeleccionada)
		pizza.agregarIngrediente(nuevo)
		ObservableUtils.firePropertyChanged(pizza, "ingredientes", pizza.ingredientes)		
	}
	
	@Dependencies("ingredienteSeleccionado", "distribucionSeleccionada")
	def isPuedeAgregarIngrediente(){
		ingredienteSeleccionado != null && distribucionSeleccionada != null
	}
	
	def guardar(){
		if (pizza.isNew) {
			Repositories.getPizzas.create(pizza)
		} else {
			Repositories.getPizzas.update(pizza)	
		}	
	}
	
}