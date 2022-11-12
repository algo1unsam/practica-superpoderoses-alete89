class Personaje {

	const property estrategia
	const property espiritualidad
	const property poderes = []

	method capacidadBatalla() {
		poderes.sum({ poder => poder.capacidadBatalla(self)})
	}

}

class Poder {

	method capacidadBatalla(personaje) {
		return (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje)
	}

	method agilidad(personaje)

	method fuerza(personaje)

	method habilidadEspecial(personaje) {
		return personaje.espiritualidad() + personaje.estrategia()
	}

}

class Velocidad inherits Poder {

	const property rapidez

	override method agilidad(personaje) {
		return personaje.estrategia() * rapidez
	}

	override method fuerza(personaje) {
		return personaje.espiritualidad() * rapidez
	}

}

class Vuelo inherits Poder {

	const property alturaMaxima
	const property energiaParaDespegue

	override method agilidad(personaje) {
		return personaje.estrategia() * alturaMaxima / energiaParaDespegue
	}

	override method fuerza(personaje) {
		return personaje.espiritualidad() + alturaMaxima - energiaParaDespegue
	}

}

class PoderAmplificador inherits Poder {

	const property poderBase
	const property amplificador

	override method agilidad(personaje) {
		return poderBase.agilidad(personaje)
	}

	override method fuerza(personaje) {
		return poderBase.fuerza(personaje)
	}

	override method habilidadEspecial(personaje) {
		return poderBase.habilidadEspecial(personaje) * amplificador
	}

}

