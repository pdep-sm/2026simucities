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
    self.registrarTrimestre()
    evento.aplicarA(self)
  }

  method registrarTrimestre() {
    trimestres.add(new Trimestre(pbiPerCapita = self.pbiPerCapita()))
  }

  method modificarPoblacion(porcentaje) {
    bloques.forEach{ b => b.modificarPoblacion(porcentaje) }
    self.bloquesSobrepoblados().forEach{ b => b.reorganizarEn(self) }
  }

  method bloquesSobrepoblados() = bloques.filter{ b => b.estaSobrepoblado() }

  method nuevoBloqueResidencial(cantidadHabitantes) {
    const nuevoBloque = 
      new BloqueResidencial(
          cantidadHabitantes=cantidadHabitantes, 
          vecinos = bloques.reverse().take(3))
    bloques.add(nuevoBloque)
  }

}

class Trimestre {
  const property pbiPerCapita
}