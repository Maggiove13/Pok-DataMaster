-- Crar las tablas--

--TABLA DE POKEMONES
CREATE TABLE Pokemon(
	id INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR (10),
	Tipo_1 VARCHAR(10),
	Tipo_2 VARCHAR(10),
	Total SMALLINT NOT NULL,
	Hp TINYINT NOT NULL,
	Attack TINYINT NOT NULL,
	Defense TINYINT NOT NULL,
	Speed TINYINT NOT NULL
);


--TABLA DE Entrenadores
CREATE TABLE Trainer(
	id INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(10),
	Apellido VARCHAR(10)
);


--Tabla de relacion entrenador pokemon
CREATE TABLE Trainer_Pokemon (
    id_Pokemon INT NOT NULL,
    id_Trainer INT NOT NULL, 
    PRIMARY KEY (id_Pokemon, id_Trainer), -- Clave primaria compuesta
    FOREIGN KEY (id_Pokemon) REFERENCES Pokemon(id),
    FOREIGN KEY (id_Trainer) REFERENCES Trainer(id)
);


--TABLA DE BATALLAS
CREATE TABLE Battle (
    id_Battle INT IDENTITY(1,1) PRIMARY KEY,
	id_Pokemon1 INT NOT NULL,
    id_Trainer1 INT NOT NULL,
    id_Pokemon2 INT NOT NULL,
    id_Trainer2 INT NOT NULL,
	winner_Pokemon INT NOT NULL,
    winner_Trainer INT NOT NULL,
	Battle_date DATE NOT NULL,
    FOREIGN KEY (id_Pokemon1, id_Trainer1) REFERENCES Trainer_Pokemon(id_Pokemon, id_Trainer),
    FOREIGN KEY (id_Pokemon2, id_Trainer2) REFERENCES Trainer_Pokemon(id_Pokemon, id_Trainer),
    FOREIGN KEY (winner_Pokemon, winner_Trainer) REFERENCES Trainer_Pokemon(id_Pokemon, id_Trainer)
);



-- CONSULTAS

-- Insertar los datos a la tabla Trainer
INSERT INTO Pokemon (Name, Tipo_1, Tipo_2, Total, Hp, Attack, Defense, Speed)
Values 
	('Bulbasaur', 'Grass', 'Poison', 318, 45, 49, 49, 45),
	('Charizard', 'Fire', 'Flying', 534, 78, 84, 78, 100),
	('Pikachu', 'Electric', NULL, 320, 35, 55, 40, 90),
	('Rapidash', 'Fire', NULL, 500, 65, 100, 70, 105),
	('Tauros', 'Fire', NULL, 500, 65, 100, 70, 105),
	('Magnezone', 'Electric', 'Steel', 535, 70, 70, 115, 60),
	('Starmie', 'Water', 'Psychic', 520, 60, 75, 85, 115),
	('Rydon', 'Ground', 'Rock', 485, 105, 130, 120, 40),
	('Kingler', 'Water', NULL, 475, 55, 130, 115, 75),
	('Gengar', 'Ghost', 'Poison', 500, 60, 65, 60, 110),
	('Kakuna', 'Bug', 'Poison', 205, 45, 25, 50, 35),
	('Jigglypuff', 'Normal', 'Fairy', 270, 115, 45, 20, 35),
	('Machamp', 'Fighting', NULL, 505, 90, 130, 80, 55);
	

--Ver la tabla completa de Pokemon
SELECT * FROM Pokemon --VEr la tabla de Pokemones

--Para eliminar un registro duplicado en la tabla Pokemon
DELETE FROM Pokemon 
WHERE id = 12;


-- Insertar los datos a la tabla Trainer
INSERT INTO Trainer (Name, Apellido) 
VALUES
	('Ash', 'Ketchum'),
	('Gary', Null),
	('Steven', 'Son'),
	('Lionel', NULL);


--Verificar la tabla Trainer
SELECT * FROM Trainer  --Ver la tabla de Entrenadores

--Actualizar un nombre de uno de los entrenadores Pokemon
UPDATE Trainer
SET
	Name = 'Brock',
    Apellido = 'Harrison'
WHERE 
	Name = 'Lionel';

--Insertar datos a la tabla Trainer_Pokemon
INSERT INTO Trainer_Pokemon (id_Pokemon, id_Trainer)
VALUES 
	(2,1),
	(6,1),
	(1,1),
	(11,1),
	(10,1),
	(3,1),
	(9,2),
	(5,3),
	(8,4),
	(15,4),
	(14,3),
	(13,2);

--Verificar la tabla Trainer
SELECT * FROM Trainer_Pokemon 

--Insertar datos a la tabla Battle.
INSERT INTO Battle (id_Trainer1, id_Pokemon1, id_Trainer2, id_Pokemon2, winner_Trainer, winner_Pokemon, Battle_date)
VALUES 
	(1,2,2,9,1,2,'2024-06-20'),
	(3,5,2,9,3,5,'2024-05-18'),
	(1,10,4,8,1,10,'2024-06-22'),
	(1,11,3,5,1,11,'2024-06-25'),
	(3,14,4,15,4,15,'2024-06-27'),
	(3,14,4,15,4,15,'2024-06-27'),
	(4,8,3,14,3,14,'2024-06-18');

--Ver la tabla de Batallas
SELECT * FROM Battle

--OPERACIONES MULTITABLA--
-- Unir las tablas de Pokemon, con entrenador para ver los nombres
SELECT
    Pokemon.Name AS PokemonName,
    Trainer.Name AS TrainerName
FROM
    Trainer_Pokemon
INNER JOIN Pokemon ON Trainer_Pokemon.id_Pokemon = Pokemon.id
INNER JOIN Trainer ON Trainer_Pokemon.id_Trainer = Trainer.id;


--Eliminar un Pokemon de la lista
--Primero saber cual es el id del nombre que busco eliminar
DECLARE @pokemon_id INT; --Esta es una variable que va a almacenar el id del Pokemon que queremos eliminar

-- Obtener el ID del Pokémon
SELECT @pokemon_id = id
FROM Pokemon
WHERE Name = 'Bulbasaur';

-- Eliminar en la tabla Battle donde el Pokémon es el id_Pokemon1
DELETE FROM Battle
WHERE 
	id_Pokemon1 = @pokemon_id
	OR id_Pokemon2 = @pokemon_id
	OR winner_Pokemon = @pokemon_id

-- Eliminar en la tabla Trainer_Pokemon
DELETE FROM Trainer_Pokemon
WHERE id_Pokemon = @pokemon_id;

-- Eliminar el Pokémon de la tabla principal
DELETE FROM Pokemon
WHERE id = @pokemon_id;


--Para ver la tabla de batallas y saber cuales son los nombres de los entrenadoresy los de sus pokemones asociados a sus ids
SELECT 
    B.id_Battle,
    T1.Name AS Trainer1_Name, 
    P1.Name AS Pokemon1_Name,
    T2.Name AS Trainer2_Name, 
    P2.Name AS Pokemon2_Name,
    WT.Name AS WinnerName, 
    WP.Name AS WinnerPokemon,
    B.Battle_date
FROM 
    Battle B
INNER JOIN 
    Trainer_Pokemon TP1 ON B.id_Trainer1 = TP1.id_Trainer AND B.id_Pokemon1 = TP1.id_Pokemon
INNER JOIN 
    Trainer_Pokemon TP2 ON B.id_Trainer2 = TP2.id_Trainer AND B.id_Pokemon2 = TP2.id_Pokemon
INNER JOIN 
    Trainer_Pokemon TPW ON B.winner_Trainer = TPW.id_Trainer AND B.winner_Pokemon = TPW.id_Pokemon
INNER JOIN 
    Trainer T1 ON TP1.id_Trainer = T1.id
INNER JOIN 
    Pokemon P1 ON TP1.id_Pokemon = P1.id
INNER JOIN 
    Trainer T2 ON TP2.id_Trainer = T2.id
INNER JOIN 
    Pokemon P2 ON TP2.id_Pokemon = P2.id
INNER JOIN 
    Trainer WT ON TPW.id_Trainer = WT.id
INNER JOIN 
    Pokemon WP ON TPW.id_Pokemon = WP.id;


--Contar cuantos Pokemones tiene cada entrenador, y ver el nombre de cada entrenador
SELECT 
    Trainer.Name,
    COUNT(Trainer_Pokemon.id_Pokemon) AS TotalPokemon
FROM 
    Trainer_Pokemon
INNER JOIN 
    Trainer ON Trainer_Pokemon.id_Trainer = Trainer.id
GROUP BY 
    Trainer.Name;
