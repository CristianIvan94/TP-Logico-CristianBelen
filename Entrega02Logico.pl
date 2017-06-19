% personaje(Nombre, Ocupacion)
personaje(pumkin, ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).
personaje(bernardo, mafioso(cerebro)).
personaje(bianca, actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie, vender([auto])).

% encargo(Solicitante, Encargado, Tarea). 
% las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).




trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

%Ejercicio01
% Ver si esPeligroso le podemos dar comportamiento,
% sino 'chau, chau, adios'
% Recuperar la abstraccion, actividadPeligrosa/1
esPeligroso(Personaje) :-
	personajePeligroso(Personaje).

personajePeligroso(Personaje) :-
	personaje(Personaje, mafioso(maton)).
personajePeligroso(Personaje) :-
	personaje(Personaje, ladron(Lista)), % Expresividad en la variable lista
	member(licorerias,Lista).
personajePeligroso(Personaje) :-
	encargo(Jefe,Personaje,_),
	personajePeligroso(Jefe).

%Ejercicio02
sonAmigos(Personaje,OtroPersonaje):-
	amigo(Personaje,OtroPersonaje).	
sonAmigos(Personaje,OtroPersonaje):-
	amigo(OtroPersonaje,Personaje).
	
trabajanJuntos(Personaje,OtroPersonaje):-
	trabajaPara(Personaje,OtroPersonaje).	
trabajanJuntos(Personaje,OtroPersonaje):-
	trabajaPara(OtroPersonaje,Personaje).	
	
estanCerca(Personaje,OtroPersonaje):-
	sonAmigos(Personaje,OtroPersonaje).
estanCerca(Personaje,OtroPersonaje):-
	trabajanJuntos(Personaje,OtroPersonaje).

% Corregir el forall/2
sanCayetano(Personaje):-
	estanCerca(Personaje,OtroPersonaje),
	forall(estanCerca(Personaje,OtroPersonaje),encargo(Personaje,OtroPersonaje,_)).
	

%Ejercicio03
% Quitar la repeticion de logica de generar la actividad
% Quitar el maldito 'is' :( 
% donde no es necesario
nivelRespeto(Personaje,Nivel) :-
	nivel(Personaje,Nivel).
	
nivel(Personaje,Nivel) :-
	personaje(Personaje, actriz(Lista)),
	length(Lista,Cantidad),
	Nivel is Cantidad * 0.1.
nivel(Personaje,Nivel) :-
	personaje(Personaje, mafioso(resuelveProblemas)),
	Nivel is 10.
nivel(Personaje,Nivel) :-
	personaje(Personaje, mafioso(capo)),
	Nivel is 20.
nivel(vincent,15).

%Ejercicio04
% respetables/1 por cantidadRespetables/1, asi se entiende que trabaja sobre una cantidad. Tmb para no respetables
% Quitar el is...

respetabilidad(Respetables,NoRespetables) :-
	respetable(Respetables),
	noRespetable(NoRespetables).
	
respetable(Respetables) :-
	findall(Personaje, esRespetable(Personaje), RespetablesAux ),
	length(RespetablesAux,CantidadRespetables),
	Respetables is CantidadRespetables.
	
noRespetable(NoRespetables) :-
	findall(Personaje, noEsRespetable(Personaje), NoRespetablesAux),
	length(NoRespetablesAux,CantidadNoRespetables),
	NoRespetables is CantidadNoRespetables.
	
esRespetable(Personaje) :-
	nivelRespeto(Personaje,Nivel),
	Nivel > 9.
	
noEsRespetable(Personaje) :-
	personaje(Personaje,_),
	not(esRespetable(Personaje)).

%Ejercicio05

cantidadEncargos(Personaje,Cantidad) :-
	encargo(_,Personaje,_),
	findall(Encargo,encargo(_,Personaje,Encargo),ListaEncargos),
	length(ListaEncargos,Cantidad).

mayorCantEncargosQue(Personaje,OtroPersonaje):-
	cantidadEncargos(Personaje,Cantidad1),
	cantidadEncargos(OtroPersonaje,Cantidad2),
	Personaje\=OtroPersonaje,
	Cantidad1>Cantidad2.

masTareas(Personaje):-
	encargo(_,Personaje,_),
	forall(
		(cantidadEncargos(OtroPersonaje,_),Personaje\=OtroPersonaje),
		mayorCantEncargosQue(Personaje,OtroPersonaje)
	).
	
