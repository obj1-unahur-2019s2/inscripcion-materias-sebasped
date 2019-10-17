class Estudiante{
	
	//var property aprobaciones = []
	//var property carreras = []
	//var property materiasInscripto = []


	var aprobaciones = []
	var carreras = []

	
	method registrarAprobacion(materia,nota){
		//registra una aprovacion y tira error si esta duplicada.
		//if( aprobaciones.all({aprob => aprob.materia() != materia}) ){
		if( not aprobaciones.any({aprob => aprob.materia() == materia}) ){
			aprobaciones.add(new Aprobacion(nota = nota,materia = materia))
			}
		else {self.error("Ya está aprobada")}
	}
	
	method materiasDeLasCarrerasInscripto(){
		return carreras.flatMap({car=>car.materias()})
		//return carreras.map({car=>car.materias()}).flatten()
	}
	
	
	method inscribirseACarrera(carrera){
		carreras.add(carrera)
	}
	
	
	method estaAprobada(materia){
		 return aprobaciones.any({aprob => aprob.materia() == materia})
	}
	method cantMateriasAprobadas(){
		return aprobaciones.size()
	}
	
	method promedio(){
		return aprobaciones.sum( {aprob=>aprob.nota()} ) / self.cantMateriasAprobadas()		
	}
	
	method puedeInscribirse(materia){
		//condiciones para poder inscribirse
		return self.materiasDeLasCarrerasInscripto().contains(materia)
			and not self.estaAprobada(materia)
			//not materiasInscripto.contains(materia)
			and not materia.estudiantesInscriptos().contains(self)
			and not materia.listaDeEspera().contains(self)
			and materia.requisitos().all({mat => self.estaAprobada(mat)})
	}
	
	method inscribirseA(materia){
		if (self.puedeInscribirse(materia)){
			//materiasInscripto.add(materia)
			materia.inscribirEstudiante(self)
		}	 
		else {self.error("No se pudo inscribir")}
	}
	
	method materiasInscripto() {
		return self.materiasDeLasCarrerasInscripto().filter({ materia => materia.estudiantesInscriptos().contains(self)} )
	}
		
}

class Materia{
	var property requisitos = []
	var property estudiantesInscriptos = []
	var property listaDeEspera = []
	var property cantidadMaximaDeEstudiantes
	
	method correlativa(materia){
		requisitos.add(materia)
	}
	
	method inscribirEstudiante(estudiante){
		if(estudiantesInscriptos.size()<=cantidadMaximaDeEstudiantes){
			estudiantesInscriptos.add(estudiante)
		}
		else{
			listaDeEspera.add(estudiante)
		}
	}
	method darDeBaja(estudiante){
		estudiantesInscriptos.remove(estudiante)
		if (not listaDeEspera.isEmpty()){
			estudiantesInscriptos.add(listaDeEspera.head())
			listaDeEspera.remove(listaDeEspera.head())			
			}
	}
	
	
	
}


// esta clase la necesitamos para registrar materia+nota cuando un estudiante aprueba.
class Aprobacion{
	var property nota
	var property materia
}


class Carrera {
	var property materias = []
	method registrar(materia){
		materias.add(materia)
	}
}


// Las carreras pueden ser objetos
//object medicina{}
