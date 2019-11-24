SELECT
    hof.playerID, 

    b.G + p.G   AS feature1, -- gamesPlayedPitched,

    b.H / b.AB                                                      AS feature2, -- battingAverage,
    b.HR                                                            AS feature3, -- homeRuns,
    b.RBI                                                           AS feature4, -- runsBattedIn,
    b.R                                                             AS feature5, -- runs,
    b.H                                                             AS feature6, -- hits,
    b.H - (b.2B + b.3B + b.HR)                                      AS feature7, -- singles,
    b.2B                                                            AS feature8, -- doubles,
    b.3B                                                            AS feature9, -- triples,
    b.SB                                                            AS feature10, -- stolenBases,
    (b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF)             AS feature11, -- onBasePercentage,
    (b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB  AS feature12, -- sluggingPercentage,

    p.W                 AS feature13, -- wins,
    p.L                 AS feature14, -- losses,
    p.W / (p.W + p.L)   AS feature15, -- winLossPercentage,
    9*p.ER / p.IP       AS feature16, -- earnedRunAverage,
    p.CG                AS feature17, -- completeGames,
    p.SHO               AS feature18, -- shutouts,
    p.SV                AS feature19, -- saves,
    p.IP                AS feature20, -- inningsPitched,
    p.SO                AS feature21, -- strikeouts,

    f.PO    AS feature22, -- putouts,
    f.A     AS feature23, -- assists,
    f.DP    AS feature24, -- doublePlays,

    a.S     AS feature25, -- allStarSelections,

    ap.A    AS feature26, -- playerAwards,

    am.A    AS feature27, -- managerAwards,

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
        SUM(SB)  AS SB,
        SUM(BB)  AS BB,
        SUM(HBP) AS HBP,
        SUM(SF)  AS SF
    FROM Batting
    GROUP BY playerID
) b USING(playerID)
JOIN (
    SELECT
        playerID,
        SUM(W)      AS W,
        SUM(L)      AS L,
        SUM(G)      AS G,
        SUM(CG)     AS CG,
        SUM(SHO)    AS SHO,
        SUM(SV)     AS SV,
        SUM(IPOuts / 3) AS IP,
        SUM(H)      AS H,
        SUM(ER)     AS ER,
        SUM(HR)     AS HR,
        SUM(BB)     AS BB,
        SUM(SO)     AS SO
    FROM Pitching
    GROUP BY playerID
) p USING(playerID)
JOIN (
    SELECT
        playerID,
        SUM(PO)     AS PO,
        SUM(A)      AS A,
        SUM(DP)     AS DP
    FROM Fielding
    GROUP BY playerID
) f USING(playerID)
JOIN (
    SELECT
        playerID,
        COUNT(playerID)     AS S
    FROM AllstarFull
    GROUP BY playerID
) a USING(playerID)
JOIN (
    SELECT
        playerID,
        SUM(G)          AS G,
        SUM(W)          AS W,
        SUM(L)          AS L,
        AVG(rank)   AS R
    FROM Managers
    GROUP BY playerID
) m USING(playerID)
JOIN (
    SELECT
        playerID,
        COUNT(awardID)  AS A
    FROM AwardsPlayers
    GROUP BY playerID
) ap USING(playerID)
JOIN (
    SELECT
        playerID,
        COUNT(awardID)  AS A
    FROM AwardsManagers
    GROUP BY playerID
) am USING(playerID)