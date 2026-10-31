import ciudad.*

class Evento {
  method aplicarA(ciudad) 
  method permiteFelicidad() = true
}
object crecimientoPoblacional inherits Evento {

  override method aplicarA(ciudad) {
    if (ciudad.hayCrecimientoEconomico())
      ciudad.modificarPoblacion(5)
    else
      ciudad.modificarPoblacion(-1)
  }

}

class CrecimientoEconomico inherits Evento {
  const porcentaje

  override method aplicarA(ciudad) {
    if (self.puedeCrecer(ciudad)) {
      ciudad.incrementarEconomia(porcentaje)
    }
  }

  method puedeCrecer(ciudad) =
    ciudad.hayCrecimientoEconomico() and 
      ciudad.pbiPerCapita() > crecimientoEconomico.pbiMinimoPerCapita()


}

object crecimientoEconomico {
  var property pbiMinimoPerCapita = 600
}

class CrecimientoMixto inherits Evento {
  const porcentaje
  // o directamente => const eventoEconomico
  
  override method aplicarA(ciudad) {
    crecimientoPoblacional.aplicarA(ciudad)
    const eventoEconomico = new CrecimientoEconomico(porcentaje = porcentaje)
    eventoEconomico.aplicarA(ciudad)
  }

}


object desastreNatural inherits Evento {

  override method aplicarA(ciudad) {
     ciudad.modificarPoblacion(-10)
     ciudad.eliminarBloquesViejos(2)
  }

  override method permiteFelicidad() = false

}