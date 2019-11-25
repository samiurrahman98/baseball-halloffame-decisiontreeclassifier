SELECT
    distinct hof.playerID,
    hof.category            AS feature1, -- role,

    b.G                                                             AS feature2, -- gamesBatted,
    b.H / b.AB                                                      AS feature3, -- battingAverage,
    b.HR                                                            AS feature4, -- homeRuns,
    b.RBI                                                           AS feature5, -- runsBattedIn,
    b.R                                                             AS feature6, -- runs,
    b.H                                                             AS feature7, -- hits,
    b.H - (b.2B + b.3B + b.HR)                                      AS feature8, -- singles,
    b.2B                                                            AS feature9, -- doubles,
    b.3B                                                            AS feature10, -- triples,
    b.SB                                                            AS feature11, -- stolenBases,
    (b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF)             AS feature12, -- onBasePercentage,
    (b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB  AS feature13, -- sluggingPercentage,

    p.G                 AS feature14, -- gamesPitched,
    p.W                 AS feature15, -- wins,
    p.L                 AS feature16, -- losses,
    p.W / (p.W + p.L)   AS feature17, -- winLossPercentage,
    9*p.ER / p.IP       AS feature18, -- earnedRunAverage,
    p.CG                AS feature19, -- completeGames,
    p.SHO               AS feature20, -- shutouts,
    p.SV                AS feature21, -- saves,
    p.IP                AS feature22, -- inningsPitched,
    p.SO                AS feature23, -- strikeouts,

    f.G     AS feature24, -- gamesFielded,
    f.PO    AS feature25, -- putouts,
    f.A     AS feature26, -- assists,
    f.DP    AS feature27, -- doublePlays,

    m.G     AS feature28, -- gamesManaged,
    m.W     AS feature29, -- managedWins,
    m.L     AS feature30, -- managedLosses,
    m.R     AS feature31, -- managedRank,

    a.S     AS feature32, -- allStarSelections,

    ap.A    AS feature33, -- playerAwards,

    am.A    AS feature34, -- managerAwards,

    hof.inducted    AS classification
FROM HallOfFame hof
LEFT JOIN (
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
LEFT JOIN (
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
LEFT JOIN (
    SELECT
        playerID,
        SUM(G)      AS G,
        SUM(PO)     AS PO,
        SUM(A)      AS A,
        SUM(DP)     AS DP
    FROM Fielding
    GROUP BY playerID
) f USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        COUNT(playerID)     AS S
    FROM AllstarFull
    GROUP BY playerID
) a USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(G)          AS G,
        SUM(W)          AS W,
        SUM(L)          AS L,
        AVG(`rank`)     AS R
    FROM Managers
    GROUP BY playerID
) m USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        COUNT(awardID)  AS A
    FROM AwardsPlayers
    GROUP BY playerID
) ap USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        COUNT(awardID)  AS A
    FROM AwardsManagers
    GROUP BY playerID
) am USING(playerID)