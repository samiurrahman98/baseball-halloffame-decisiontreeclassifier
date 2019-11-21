SELECT
    hof.playerID,

    b.AB / b.G      AS feature1,
    b.R / b.G       AS feature2,

    hof.inducted    AS classification
FROM HallOfFame hof
JOIN (
    SELECT
        playerID,
        SUM(G)   AS G,
        SUM(AB)  AS AB,
        SUM(R)   AS R,
        SUM(H)   AS H,
        SUM(2B)  AS 2B,
        SUM(3B)  AS 3B,
        SUM(HR)  AS HR,
        SUM(RBI) AS RBI,
        SUM(CS)  AS CS,
        SUM(BB)  AS BB,
        SUM(SO)  AS SO
    FROM Batting
    GROUP BY playerID
) b USING(playerID)
JOIN (
    SELECT
        playerID,
        SUM(W)      AS W,
        SUM(L)      AS L,
        SUM(G)      AS G,
        SUM(GS)     AS GS,
        SUM(CG)     AS CG,
        SUM(SHO)    AS SHO,
        SUM(SV)     AS SV,
        SUM(IPOuts) AS IPOuts,
        SUM(H)      AS H,
        SUM(ER)     AS ER,
        SUM(HR)     AS HR,
        SUM(BB)     AS BB,
        SUM(SO)     AS SO
    FROM Pitching
    GROUP BY playerID
) p USING(playerID)