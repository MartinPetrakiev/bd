CREATE VIEW LargerBattlesByShips AS
SELECT B1.NAME AS BattleName
FROM BATTLES AS B1
WHERE (
    SELECT COUNT(DISTINCT O1.SHIP)
    FROM OUTCOMES AS O1
    WHERE O1.BATTLE = B1.NAME
) > (
    SELECT COUNT(DISTINCT O2.SHIP)
    FROM OUTCOMES AS O2
    WHERE O2.BATTLE = 'Guadalcanal'
);

CREATE VIEW LargerBattlesByCountry AS
SELECT B1.NAME AS BattleName
FROM BATTLES AS B1
WHERE (
    SELECT COUNT(DISTINCT CLASSES.COUNTRY)
    FROM OUTCOMES AS O1
	INNER JOIN SHIPS ON SHIPS.NAME = O1.SHIP
	INNER JOIN CLASSES ON CLASSES.CLASS = SHIPS.CLASS
    WHERE O1.BATTLE = B1.NAME
) > (
    SELECT COUNT(DISTINCT CLASSES.COUNTRY)
    FROM OUTCOMES AS O2
	INNER JOIN SHIPS ON SHIPS.NAME = O2.SHIP
	INNER JOIN CLASSES ON CLASSES.CLASS = SHIPS.CLASS
    WHERE O2.BATTLE = 'Guadalcanal'
);

SELECT * FROM LargerBattlesByCountry;






