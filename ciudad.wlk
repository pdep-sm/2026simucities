import bloques.*
class Ciudad {
  const bloques
  const trimestres = []

  //Pto 2
  method esVerde() = bloques.all{ b => b.tienePlazas() }

  //Pto 3
  method parquizar() {
    bloques.forEach{ b => b.parquizar() }
  } 

  //Pto 5
  method pbiPerCapita() = self.pbi() / self.poblacionTotal()

  method pbi() = bloques.sum{ b => b.economia() }

  method poblacionTotal() = bloques.sum{ b => b.cantidadHabitantes() }

  //Pto 6
  method hayCrecimientoEconomico() {
    const ultimosTrimestres = self.ultimosTrimestres(2)
    return 
      ultimosTrimestres.first().pbiPerCapita() < ultimosTrimestres.last().pbiPerCapita() 
      and ultimosTrimestres.last().pbiPerCapita() < self.pbiPerCapita()
  }

  method ultimosTrimestres(cantidad) = 
    trimestres.reverse().take(cantidad).reverse()

  method aplicarEvento(evento) {
    self.registrarTrimestre(evento)
    evento.aplicarA(self)
  }

  method registrarTrimestre(evento) {
    trimestres.add(
        new Trimestre(pbiPerCapita = self.pbiPerCapita(), evento = evento)
        )
  }

  method modificarPoblacion(porcentaje) {
    bloques.forEach{ b => b.modificarPoblacion(porcentaje) }
    self.bloquesSobrepoblados().forEach{ b => b.reorganizar() }
  }

  method bloquesSobrepoblados() = bloques.filter{ b => b.estaSobrepoblado() }

  method nuevoBloqueResidencial(cantidadHabitantes) {
    const nuevoBloque = 
      new BloqueResidencial(
          vecinos = self.ultimosBloques(3),
          ciudad = self,
          cantidadHabitantes = cantidadHabitantes)
    bloques.add(nuevoBloque)
  }

  method incrementarEconomia(porcentaje) {
    bloques.forEach{ b => b.incrementarEconomia(porcentaje)}
    if (self.pbiPerCapita() > 1000)
      self.nuevoBloqueIndustrial()
  }

  method ultimosBloques(cantidad) = bloques.reverse().take(cantidad)

  method nuevoBloqueIndustrial() {
    const bloquesVecinos = self.ultimosBloques(3)
    if (bloquesVecinos.any{b => b.tienePlazas()}) {
      const nuevoBloque = new BloqueIndustrial(
          vecinos = bloquesVecinos,
          ciudad = self,
          produccion = self.promedioEconomico())
      bloques.add(nuevoBloque)
    }
  }

  method promedioEconomico() = self.pbi() / bloques.size()

  method eliminarBloquesViejos(cantidad) {
    const bloquesViejos = bloques.take(cantidad)
    bloques.removeAll(bloquesViejos)
    bloques.forEach{ b => b.eliminarVecinos(bloquesViejos) }
  }

  method puedeSerFeliz() = trimestres.last().permiteFelicidad()

}

class Trimestre {
  const property pbiPerCapita
  const property evento 

  method permiteFelicidad() = evento.permiteFelicidad()
}