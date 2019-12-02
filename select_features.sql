SELECT
    DISTINCT hof.playerID,
    hof.category                                                                AS feature1, -- role,
    hof.votedBy                                                                 AS feature2, -- committee,

    IFNULL((b.H / b.AB), ' ')                                                   AS feature3, -- battingAverage,
    IFNULL(b.HR, ' ')                                                           AS feature4, -- homeRuns,
    IFNULL(b.RBI, ' ')                                                          AS feature5, -- runsBattedIn,
    IFNULL(b.H, ' ')                                                            AS feature6, -- hits,
    IFNULL((b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB, ' ') AS feature7, -- sluggingPercentage,

    IFNULL(p.W / (p.W + p.L), ' ')                                              AS feature8, -- winLossPercentage,
    IFNULL(9*p.ER / p.IP, ' ')                                                  AS feature9, -- earnedRunAverage,
    IFNULL(p.S, ' ')                                                            AS feature10, -- saves,
    IFNULL(p.IP, ' ')                                                           AS feature11, -- inningPitched,
    IFNULL(p.SO, ' ')                                                           AS feature12, -- strikeouts,

    IFNULL(f.P, ' ')    AS feature13, -- putouts
    IFNULL(f.A, ' ')    AS feature14, -- assists

    IFNULL(m.W, ' ')    AS feature15, -- managedWins,
    IFNULL(m.L, ' ')    AS feature16, -- managedLosses,
    IFNULL(m.R, ' ')    AS feature17, -- rank,

    IFNULL(a.S, ' ')    AS feature18, -- allStarSelections,
    
    IFNULL(ap.A, ' ')   AS feature19, -- playerAwards,

    IFNULL(am.A, ' ')   AS feature20, -- managerAwards,

    hof.inducted                                                                AS classification
FROM HallOfFame hof
LEFT JOIN (
    SELECT
        playerID,
        SUM(AB)  AS AB,
        SUM(H)   AS H,
        SUM(2B)  AS 2B,
        SUM(3B)  AS 3B,
        SUM(HR)  AS HR,
        SUM(RBI) AS RBI
    FROM Batting
    GROUP BY playerID
) b USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(W)      AS W,
        SUM(L)      AS L,
        SUM(IPOuts / 3) AS IP,
        SUM(H)      AS H,
        SUM(ER)     AS ER,
        SUM(BB)     AS BB,
        SUM(SV)      AS S,
        SUM(SO)     AS SO
    FROM Pitching
    GROUP BY playerID
) p USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(PO)     AS P,
        SUM(A)      AS A
    FROM Fielding
    GROUP BY playerID
) f USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        SUM(W)          AS W,
        SUM(L)          AS L,
        SUM(`rank`)     AS R
    FROM Managers
    GROUP BY playerID
) m USING(playerID)
LEFT JOIN (
    SELECT
        playerID,
        COUNT(playerID) AS S
    FROM AllstarFull
    GROUP BY playerID
) a USING(playerID)
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
) am USING(playerID);