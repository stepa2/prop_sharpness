
PROP_SHARPNESS = PROP_SHARPNESS or {}

function PROP_SHARPNESS.BloodSpray( ent, pos, dir, scale, color )
    color = color or ent:GetBloodColor() or ent.sharpness_BloodColor
    if not color then return end
    if color < 0 then return end

    local effData = EffectData()
    effData:SetOrigin( pos )
    effData:SetColor( color )
    effData:SetScale( scale )
    effData:SetFlags( 1 )
    effData:SetNormal( dir )
    util.Effect( "bloodspray", effData )

end