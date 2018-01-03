//Parte A
class Ninio
{
	var caramelos
	var elementosPuestos
	var actitud
	var estado = sano  //Parte E
	constructor(_caramelos, _elementosPuestos, _actitud) 
	{	caramelos=_caramelos	elementosPuestos=_elementosPuestos  actitud=_actitud}
	method caramelos() = caramelos
	
	//parte A
	method capacidadDeAsustar() = elementosPuestos.sum({elemento => elemento.sustoQueGenera()}) * actitud
	method asustarA(alguien){	self.agregarCaramelos(alguien.asustarse(self))	}
	method agregarCaramelos(caramelosAAgregar) { caramelos+=caramelosAAgregar } 
	//parte D
	method alimentarse(caramelosAComer)//modificado por parte E
	{
		estado.comerCaramelos(self, caramelosAComer)
	}
	method cambiarEstado(nuevoEstado) {estado = nuevoEstado} 	 //Parte E
	method cambiarActitud(nuevaActitud) {actitud =nuevaActitud}  //Parte E
	method cambiarCantCaramelos(nuevaCant) {caramelos = nuevaCant}  //Parte E
	method actitud()=actitud //Parte E
}

class Persona
{
	method noSeAsusto() = 0
}

object adultoComun inherits Persona
{
	var intentaronAsustarlo = 0
	method asustarse(ninio)
	{
		if(ninio.caramelos()>15) {intentaronAsustarlo+=1}
		
		if(self.tolerancia() < ninio.capacidadDeAsustar()) { return self.tolerancia()/2	}
		else {return self.noSeAsusto()}
	}
	method tolerancia() = 10*intentaronAsustarlo
}

class Abuelo inherits Persona
{
	var caramelos
	constructor (_caramelos) {caramelos =_caramelos}
	method asustarse(_) = caramelos/2
}

object adultoNecio inherits Persona
{
	method asustarse(_) = self.noSeAsusto()
}

class Maquillaje
{
	var  susto = 3
	method modificarSusto(nuevoSusto) {	susto=nuevoSusto }
	method sustoQueGenera() = susto
}

class TrajeTerrorifico
{
	method sustoQueGenera() = 3
}

class TrajeTierno
{
	method sustoQueGenera() = 5
}

	
//parte B
class Legion
{
	var ninios
	constructor(_ninios)
	{
		if(_ninios.size() >= 2){ninios = _ninios}
		else {	throw new NoHaySuficientesNinios()	}
	}

	

	method caramelos() = ninios.sum({ninio=>ninio.caramelos()})
	method lider() = ninios.max({ninio=>ninio.capacidadDeAsustar()})
	method capacidadDeAsustar() = ninios.sum({ninio=>ninio.capacidadDeAsustar()})
	method asustarA(alguien) {	self.lider().agregarCaramelos(alguien.asustarse(self))}
}

class NoHaySuficientesNinios
{}

//parte C
class Barrio
{
	var niniosQueHabitan
	constructor(_niniosQueHabitan) { niniosQueHabitan=_niniosQueHabitan }
	method losQueMasCaramelosTienen()
	=	niniosQueHabitan.sortedBy({ninio, otroNinio => ninio.caramelos()>otroNinio.caramelos()}).take(3)
	method elementosUsados() = niniosQueHabitan.filter({ninio=> ninio.caramelos()>10}).asSet()
}

//parte D
class NoHaySuficientesCaramelos
{}

//parte E
class Estado
{
	method comerCaramelos(ninio, caramelosAComer)
	{ if(ninio.caramelos() >= caramelosAComer) 
	{	ninio.cambiarCantCaramelos(ninio.caramelos()-caramelosAComer) 	}
	else {	throw new NoHaySuficientesCaramelos()	}   }
}

class EstadoSanoYEmpachado inherits Estado
{
	constructor(nuevoEstado) 
	override method comerCaramelos(ninio, caramelosAComer)
	{	if(caramelosAComer>10) { ninio.cambiarEstado(nuevoEstado) } 	
		super(ninio, caramelosAComer)	}
}

object sano inherits EstadoSanoYEmpachado(empachado)
{}

object empachado inherits EstadoSanoYEmpachado(enCama)
{
	override method comerCaramelos(ninio, caramelosAComer)
	{	ninio.cambiarActitud(ninio.actitud()/2)
		super(ninio, caramelosAComer)	}
}

object enCama inherits Estado
{
	override method comerCaramelos(ninio, _) 
	{ 	ninio.cambiarActitud(0) 
		super(ninio, 0) 	} 
}