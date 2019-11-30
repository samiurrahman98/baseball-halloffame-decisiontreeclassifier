SELECT
    distinct hof.playerID,
    hof.category            AS feature1, -- role,
    hof.votedBy             AS feature2, -- committee,

    -- b.G                                                             AS feature2, -- gamesBatted,
    -- IFNULL(b.H / b.AB, ' ')                                                      AS feature3, -- battingAverage,
    -- b.HR                                                            AS feature4, -- homeRuns,
    -- b.RBI                                                           AS feature5, -- runsBattedIn,
    -- b.H                                                             AS feature6, -- hits,
    -- IFNULL((b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF), ' ')             AS feature4, -- onBasePercentage,
    IFNULL((b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB, ' ')  AS feature3, -- sluggingPercentage,

    -- p.G                 AS feature14, -- gamesPitched,
    -- p.W                 AS feature6, -- wins,
    -- p.L                 AS feature7, -- losses,
    -- p.W / (p.W + p.L)   AS feature5, -- winLossPercentage,
    -- IFNULL(9*p.ER / p.IP, ' ')       AS feature6, -- earnedRunAverage,
    IFNULL((p.BB + p.H / p.IP), ' ') AS feature4, -- walksAndHitsPerInningPitched,
    -- p.CG                AS feature19, -- completeGames,
    -- p.SHO               AS feature20, -- shutouts,
    -- p.SV                AS feature9, -- saves,
    -- p.IP                AS feature13, -- inningsPitched,
    -- p.SO                AS feature8, -- strikeouts,

    IFNULL((f.PO + f.A) / (f.PO + f.A + f.E), ' ')   AS feature5, -- fieldingPercentage

    -- m.G     AS feature15, -- gamesManaged,
    -- IFNULL(m.W / (m.W + m.L), ' ')    AS feature6, -- managedWinLossPercentage
    IFNULL(m.R, ' ')     AS feature6, -- managedRank,

    IFNULL(a.S, ' ')     AS feature7, -- allStarSelections,

    -- IFNULL(ap.A, ' ')    AS feature8, -- playerAwards,

    -- IFNULL(am.A, ' ')    AS feature9, -- managerAwards,

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
        SUM(E)      AS E
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