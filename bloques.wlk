class Bloque {
  const vecinos
  const ciudad

  //Pto 1
  method estaCeloso() = vecinos.all{ vecino => vecino.estaMejorQue(self) }

  method estaMejorQue(otroBloque) = 
    self.tieneMejorEconomiaQue(otroBloque) or 
      self.tieneMasPlazasQue(otroBloque)

  method tieneMejorEconomiaQue(otroBloque) = 
    self.economia() > otroBloque.economia()

  method tieneMasPlazasQue(otroBloque) =
    self.cantidadPlazas() > otroBloque.cantidadPlazas()

  method tienePlazas() = self.cantidadPlazas() > 0

  //Pto 4 :D 
  method esFeliz() = self.tienePlazas() and not self.estaCeloso() 
    and self.menosPoblacionQueVecinos() and ciudad.puedeSerFeliz()

  method menosPoblacionQueVecinos() = 
    self.poblacionTotalVecinos() > self.cantidadHabitantes()

  method poblacionTotalVecinos() =  
    vecinos.sum{ b => b.cantidadHabitantes() }

  method estaSobrepoblado() = self.cantidadHabitantes() > 100000

  method eliminarVecinos(bloquesViejos) {
    vecinos.removeAll(bloquesViejos)
  }

  method modificarPoblacion(porcentaje)
  method economia()
  method cantidadHabitantes()
  method cantidadPlazas()
  method parquizar()
  method incrementarEconomia(porcentaje)

}

class BloqueResidencial inherits Bloque {
  const comercios = []
  var property cantidadPlazas = 0
  var property cantidadHabitantes

  override method economia() = comercios.sum{c => c.aporteEconomico() }

  override method parquizar() { 
    cantidadPlazas += cantidadHabitantes / 10000
  }

  override method modificarPoblacion(porcentaje) { 
    cantidadHabitantes += cantidadHabitantes * porcentaje / 100
  }

  override method incrementarEconomia(porcentaje) {
    comercios.forEach{ c => c.incrementarEconomia(porcentaje)}
  }

  method reorganizar() {
    cantidadHabitantes = cantidadHabitantes / 2
    ciudad.nuevoBloqueResidencial(cantidadHabitantes)
  }

}

class Comercio {
  var property aporteEconomico

  method incrementarEconomia(porcentaje) {
    aporteEconomico += aporteEconomico * porcentaje / 100
  }
}

class BloqueIndustrial inherits Bloque {
  const property cantidadPlazas = 0
  var produccion
  
  override method economia() = produccion * 1000

  override method parquizar() { }

  override method cantidadHabitantes() = 0 // Otra solución distinta a la cantidad de Plazas

  override method modificarPoblacion(porcentaje) { } //No pasa nah'

  override method incrementarEconomia(porcentaje) {
    produccion += produccion * porcentaje / 100
  }
}



