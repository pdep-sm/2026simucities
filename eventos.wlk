object crecimientoPoblacional {

  method aplicarA(ciudad) {
    if (ciudad.hayCrecimientoEconomico())
      ciudad.modificarPoblacion(5)
    else
      ciudad.modificarPoblacion(-1)
  }

}