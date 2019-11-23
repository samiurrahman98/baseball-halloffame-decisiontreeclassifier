SELECT
    hof.playerID, 

    b.G + p.G   AS gamesPlayedPitched,

    b.H / b.AB                                                      AS battingAverage,
    b.HR                                                            AS homeRuns,
    b.RBI                                                           AS runsBattedIn,
    b.R                                                             AS runs,
    b.H                                                             AS hits,
    b.H - (b.2B + b.3B + b.HR)                                      AS singles,
    b.2B                                                            AS doubles,
    b.3B                                                            AS triples,
    b.SB                                                            AS stolenBases,
    (b.H + b.BB + b.HBP) / (b.AB + b.BB + b.HBP + b.SF)             AS onBasePercentage,
    (b.H - (b.2B + b.3B + b.HR) + 2*b.2B + 3*b.3B + 4*b.HR) / b.AB  AS sluggingPercentage,

    p.W                 AS wins,
    p.L                 AS losses,
    p.W / (p.W + p.L)   AS winLossPercentage,
    9*p.ER / p.IP       AS earnedRunAverage,
    p.CG                AS completeGames,
    p.SHO               AS shutouts,
    p.SV                AS saves,
    p.IP                AS inningsPitched,
    p.SO                AS strikeouts,

    f.PO    AS putouts,
    f.A     AS assists,
    f.DP    AS doublePlays,

    a.S     AS allStarSelections,

    ap.A    AS playerAwards,

    am.A    AS managerAwards,

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