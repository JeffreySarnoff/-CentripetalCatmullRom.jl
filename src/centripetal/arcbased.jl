#=
    Given 4 ND points along a centripetal Catmull-Rom span,
    roughly approximate the arclength of the curvilinear segment
    that would be determined by the two bounding points
    and the tangents they determine [the arc between p1 and p2].
    
    This well-behaved approximation was developed by Jens Gravesen

    (2*corddist + (n-1)*bezdist)/(n+1), n is degree of the curve
    deg=2 --> (2*corddist + bezdist)/(3)
    deg=3 --> (2*corddist + 2*bezdist)/(4) --> (corddist + bezdist)/2
    deg=4 --> (2*corddsit + 3*bezdist)/(5)
=#

function catmullrom_approx_arclen(p0, p1, p2, p3)
    b0, b1, b2, b3 = catmullrom2bezier(p0, p1, p2, p3)
    corddist = norm(b3 .- b0)
    bezdist = norm(b1 .- b0) + norm(b2 .- b1) + norm(b3 .- b2)
    return (corddist + bezdist) * 0.5
end

function catmullrom2bezier(p0, p1, p2, p3)
    b0 = p1
    b3 = p2
    d1 = norm(p1 .- p0); d1a = sqrt(d1)
    d2 = norm(p2 .- p1); d2a = sqrt(d2)
    d3 = norm(p3 .- p2); d3a = sqrt(d3)
    b1n = @. (d1 * p2) - (d2 * p0) + ((2*d1 + 3*d1a*d2a+d2) * p1)
    b1d = 3*d1a*(d1a+d2a)
    b1 = b1n ./ b1d
    b2n = @. (d3 * p1) - (d2 * p3) + ((2*d3 + 3*d3a*d2a+d2) * p2)
    b2d = 3*d3a*(d3a+d2a)
    b2 = b2n ./ b2d
    return b0, b1, b2, b3
end



# relatively fast determination of angular separation
#    UNCHECKED PRECONDITION:
#       both points are given relative to the same origin
#
#  >>>  for a numerically rigourous approach to angular separation
#  >>>  use AngleBetweenVectors.jl
#

function anglesep(pointa::P1, pointb::P1) where {P1}
    dota = dot(pointa, pointa)
    dotb = dot(pointb, pointb)
    (iszero(dota) || iszero(dotb)) && return zero(T)

    dotb = sqrt(dota * dotb)
    dota = dot(pointa, pointb)
    acos( dota / dotb )
end

