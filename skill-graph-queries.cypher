
// sample task-linked job paths
MATCH p = (o:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(r:Occupation)
WHERE r.ANZSCO_Title = "Policy and Planning Managers"
RETURN *

// sample task-cluster-linked job paths
MATCH q = (o2:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(c:Cluster)-[]-(tr:Task)-[]-(r2:Occupation)
WHERE r2.ANZSCO_Title = 'Corporate Treasurer'
RETURN *


// sample task-family-linked job paths
MATCH l = (o3:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(c:Cluster)-[]-(f:Family)-[]-(cd:Cluster)-[]-(tr:Task)-[]-(r3:Occupation)
WHERE r3.ANZSCO_Title = 'Advertising Manager'
RETURN *

// next best job recommendation ranked - starting at 'General Manager'

CALL {
MATCH p = (o:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(r:Occupation)
RETURN o,count(p) as paths_count,r
UNION
MATCH q = (o2:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(c:Cluster)-[]-(tr:Task)-[]-(r2:Occupation)
RETURN o2 as o,count(q) as paths_count, r2 as r
UNION
MATCH l = (o3:Occupation{ANZSCO_Title:'General Managers'})-[]-(t:Task)-[]-(c:Cluster)-[]-(f:Family)-[]-(cd:Cluster)-[]-(tr:Task)-[]-(r3:Occupation)
RETURN o3 as o,count(l) as paths_count, r3 as r
}
RETURN  o.ANZSCO_Title as source_job, r.ANZSCO_Title as target_job, sum(paths_count) as total_score
ORDER BY total_score desc
LIMIT 20

