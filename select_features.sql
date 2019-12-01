SELECT
    DISTINCT hof.playerID,
    hof.category                                                                AS feature1, -- role,
    hof.votedBy                                                                 AS feature2, -- committee,

    IFNULL((b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB, ' ') AS feature3, -- sluggingPercentage,

    IFNULL(9*p.ER / p.IP, ' ')                                                  AS feature4, -- earnedRunAverage,
    IFNULL((p.BB + p.H / p.IP), ' ')                                            AS feature5, -- walksAndHitsPerInningPitched,

    IFNULL((f.PO + f.A) / (f.PO + f.A + f.E), ' ')                              AS feature6, -- fieldingPercentage

    IFNULL(m.W / (m.W + m.L), ' ')                                              AS feature7, -- managedWinLossPercentage

    hof.inducted                                                                AS classification
FROM HallOfFame hof
LEFT JOIN (
    SELECT
        playerID,
        SUM(AB)  AS AB,
        SUM(H)   AS H,
        SUM(2B)  AS 2B,
        SUM(3B)  AS 3B,
        SUM(HR)  AS HR
    FROM Batting
    GROUP BY playerID
) b USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(IPOuts / 3) AS IP,
        SUM(H)      AS H,
        SUM(ER)     AS ER,
        SUM(BB)     AS BB
    FROM Pitching
    GROUP BY playerID
) p USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(PO)     AS PO,
        SUM(A)      AS A,
        SUM(E)      AS E
    FROM Fielding
    GROUP BY playerID
) f USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(W)          AS W,
        SUM(L)          AS L
    FROM Managers
    GROUP BY playerID
) m USING(playerID);