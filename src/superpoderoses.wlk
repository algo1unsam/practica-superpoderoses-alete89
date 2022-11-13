class Personaje {

	var property estrategia
	var property espiritualidad
	const property poderes = []

	method capacidadBatalla() {
		return poderes.sum({ poder => poder.capacidadBatalla(self) })
	}

	method mejorPoder() {
		return poderes.max({ poder => poder.capacidadBatalla(self) })
	}

	method esRadioinmune() {
		return poderes.any({ poder => poder.otorgaRadioInmunidad() })
	}

	method superaPeligro(peligro) {
		return not peligro.superaPersonaje(self)
	}

	method validaSuperaPeligro(peligro) {
		if (not self.superaPeligro(peligro)) {
			self.error("no puede superar el peligro")
		}
	}

	method enfrentarPeligro(peligro) {
		self.validaSuperaPeligro(peligro)
		estrategia += peligro.complejidad()
	}

}

class MetaHumano inherits Personaje {

	override method capacidadBatalla() {
		return super() * 2
	}

	override method esRadioinmune() {
		return true
	}

	override method enfrentarPeligro(peligro) {
		super(peligro)
		espiritualidad += peligro.complejidad()
	}

}

class Mago inherits MetaHumano {

	var property poderAcumulado

	override method capacidadBatalla() {
		return super() + poderAcumulado
	}

	override method enfrentarPeligro(peligro) {
		if (poderAcumulado > 10) {
			super(peligro)
		}
		poderAcumulado = 0.max(poderAcumulado - 5)
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

	method otorgaRadioInmunidad()

}

class Velocidad inherits Poder {

	const property rapidez

	override method agilidad(personaje) {
		return personaje.estrategia() * rapidez
	}

	override method fuerza(personaje) {
		return personaje.espiritualidad() * rapidez
	}

	override method otorgaRadioInmunidad() {
		return false
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

	override method otorgaRadioInmunidad() {
		return alturaMaxima > 200
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

	override method otorgaRadioInmunidad() {
		return true
	}

}

class Equipo {

	const property personajes = []

	method miembroMasVulnerable() {
		return personajes.min({ personaje => personaje.capacidadBatalla() })
	}

	method sumaDeCapacidades() {
		return personajes.sum({ personaje => personaje.capacidadBatalla() })
	}

	method calidad() {
		return (self.sumaDeCapacidades() / personajes.size()).truncate(2)
	}

	method mejoresPoderes() {
		return personajes.map({ personaje => personaje.mejorPoder() })
	}

	method peligroSensato(peligro) {
		return personajes.all({ personaje => personaje.superaPeligro(peligro) })
	}

	method personajesQueSuperanPeligro(peligro) {
		return personajes.filter({ personaje => personaje.superaPeligro(peligro) })
	}

	method validarPuedenPelear(peligro) {
		if (self.personajesQueSuperanPeligro(peligro).size() < peligro.cantidadDePersonajesQueSeBanca()) {
			self.error("no deben enfrentar")
		}
	}

	method enfrentarPeligro(peligro) {
		self.validarPuedenPelear(peligro)
		self.personajesQueSuperanPeligro(peligro).forEach({ personaje => personaje.enfrentarPeligro(peligro)})
	}

}

class Peligro {

	const property capacidadBatalla
	const property complejidad
	const property cantidadDePersonajesQueSeBanca

	method superaPersonaje(personaje) {
		return capacidadBatalla > personaje.capacidadBatalla()
	}

}

class Radiactivo inherits Peligro {

	override method superaPersonaje(personaje) {
		return super(personaje) or not personaje.esRadioinmune()
	}

}

