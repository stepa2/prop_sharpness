
local IsValid = IsValid
local math = math

do
    local cvarMeta = FindMetaTable( "ConVar" )

    local blockProppushVar = CreateConVar( "sharpness_sv_proppushdamage", "1", FCVAR_ARCHIVE, "Do sharpness damage on stuff held/thrown by the physics gun?", 0, 1 )
    hook.Add( "prop_sharpness_blocksharpdamage", "sharpness_noplyproppushdamage", function( sharpEnt, damaged )
        if cvarMeta.GetBool( blockProppushVar ) then return end
        if not damaged:IsPlayer() then return end
        if IsValid( sharpEnt.sharpness_PhysgunHolder ) then return true end
        if sharpEnt.sharpness_Thrower and sharpEnt.sharpness_ThrowType == "physgun" then return true end

    end )

    local damageMulVar = CreateConVar( "sharpness_sv_sharpdamagemul", "1", FCVAR_ARCHIVE, "Multiply 'sharp' damage by this amount", 0, 9999 )
    hook.Add( "prop_sharpness_predamage", "sharpness_damagemul", function( _sharpEnt, _takingDamage, hookDat, _sharpData )
        local dmgMul = cvarMeta.GetFloat( damageMulVar )
        if dmgMul == 1 then return end
        hookDat.damage = hookDat.damage * dmgMul

    end )

    local crushMagicNum = 1.035

    local damageLogVar = CreateConVar( "sharpness_sv_nobigdamage", "0", FCVAR_ARCHIVE, "Stops 'sharp' damage from blowing up. Damage will clamp out at around ~200", 0, 1 )
    hook.Add( "prop_sharpness_predamage", "sharpness_damagemath.log", function( _sharpEnt, _takingDamage, hookDat, _sharpData )
        if not cvarMeta.GetBool( damageLogVar ) then return end
        hookDat.damage = math.log( hookDat.damage, crushMagicNum )

    end )
end

local debugVar = CreateConVar( "sharpness_sv_debug", "0", FCVAR_NONE, "enable developer 1 visualizers to help add sharp props" )

local entsMeta = FindMetaTable( "Entity" )

local function dirToPos( startPos, endPos )
    if not startPos then return end
    if not endPos then return end

    return ( endPos - startPos ):GetNormalized()

end


local string_lower = string.lower
local string_find = string.find

local materialAliases = {
    ["antlion"] = "flesh",
    ["plaster"] = "generic",
    ["concrete"] = "generic",

}

local potentialMaterials = {
    "wood",
    "flesh",
    "antlion",
    "plastic",
    "plaster",
    "concrete",
}

local function getMaterialForEnt( ent )
    if not IsValid( ent ) then return end

    local cached = ent.sharpness_CachedSoundMaterial
    if cached then return cached end

    local theMat
    local stringToCheck = ent:GetMaterial()

    if stringToCheck ~= "" then
        local loweredStr = string_lower( stringToCheck )

        for _, currMat in ipairs( potentialMaterials ) do
            if string_find( loweredStr, currMat ) then
                --print( loweredStr, currMat, ent:GetModel() )
                theMat = currMat
                break

            end
        end
    end

    if not theMat then
        local entsObj = ent:GetPhysicsObject()
        if IsValid( entsObj ) then
            stringToCheck = entsObj:GetMaterial()

        end
        local loweredStr = string_lower( stringToCheck )

        for _, currMat in ipairs( potentialMaterials ) do
            if string_find( loweredStr, currMat ) then
                --print( loweredStr, currMat, ent:GetModel() )
                theMat = currMat
                break

            end
        end
    end

    if not theMat then
        theMat = "generic"

    end

    local alias = materialAliases[theMat]
    if alias then
        theMat = alias

    end

    ent.sharpness_CachedSoundMaterial = theMat

    timer.Simple( 5, function() -- props WILL get their material changed
        if not IsValid( ent ) then return end
        ent.sharpness_CachedSoundMaterial = nil

    end )
    return theMat

end


local damageScales = {
    ["wood"] = 0.75,
    ["flesh"] = 1,
    ["antlion"] = 1,
    ["plastic"] = 0.8,
    ["generic"] = 0.25,

}

local function scaleDamageForEntsMaterial( ent, dmg )
    local mat = getMaterialForEnt( ent )
    return dmg * damageScales[ mat ], mat

end


PROP_SHARPNESS = PROP_SHARPNESS or {}

function PROP_SHARPNESS.CanBleed( ent )
    local color = ent:GetBloodColor()
    if not color then return end
    return color >= 0

end

function PROP_SHARPNESS.SHARP_POINTY( _, dirRef, collisonNormal ) -- one end is pointy
    local product = dirRef:Dot( collisonNormal )
    if product > -0.75 then return 0 end
    return -product, dirRef

end
function PROP_SHARPNESS.SHARP_DUALPOINTY( _, dirRef, collisonNormal ) -- both ends are pointy
    local product = math.abs( dirRef:Dot( collisonNormal ) )
    if product < 0.75 then return 0 end
    return product, dirRef -- WRONG

end
function PROP_SHARPNESS.SHARP_PLANAR( sharpEnt, dirRef, collisonNormal ) -- flat plane of pointy ( eg sawblade )
    local product = math.abs( dirRef:Dot( collisonNormal ) )
    if product > 0.5 then
        return 0

    else
        local sharpsPos = sharpEnt:GetPos()
        local sharpDir = sharpEnt:WorldToLocal( -collisonNormal + sharpsPos )
        sharpDir.z = 0
        sharpDir:Normalize()
        sharpDir = sharpEnt:LocalToWorld( sharpDir ) - sharpsPos

        return math.min( ( 1 - product ) * 1.5, 1 ), sharpDir

    end
end

PROP_SHARPNESS.skewerSnd = {
    "ambient/machines/slicer1.wav",
    "ambient/machines/slicer2.wav",
    "ambient/machines/slicer3.wav",
    "ambient/machines/slicer4.wav",

}
PROP_SHARPNESS.skewerSndNonMetallic = {
    "ambient/machines/slicer2.wav",
    "ambient/machines/slicer3.wav",

}

PROP_SHARPNESS.sawbladeSliceSound = {
    "d1_town.Slicer"

}

PROP_SHARPNESS.bashingSound = {
    "physics/body/body_medium_break2.wav",
    "physics/body/body_medium_break3.wav",
    "physics/body/body_medium_break4.wav",

}

PROP_SHARPNESS.metalstickSounds = {
    "physics/metal/sawblade_stick1.wav",
    "physics/metal/sawblade_stick2.wav",
    "physics/metal/sawblade_stick3.wav",

}

PROP_SHARPNESS.woodStickSounds = {
    "physics/wood/wood_solid_impact_bullet2.wav",
    "physics/wood/wood_solid_impact_bullet3.wav",
    "physics/wood/wood_box_impact_bullet1.wav",
    "physics/wood/wood_box_impact_bullet4.wav",

}


PROP_SHARPNESS.IMPALE_STRONG = 25000
PROP_SHARPNESS.IMPALE_MEDIUM = 8000
PROP_SHARPNESS.IMPALE_WEAK = 2500


PROP_SHARPNESS.SPEED_SUPERSHARP = 5
PROP_SHARPNESS.SHARPNESS_SUPERSHARP = 0.9

PROP_SHARPNESS.SPEED_ALWAYSDMG = 75
PROP_SHARPNESS.SHARPNESS_SHARP = 0.75

PROP_SHARPNESS.SPEED_DULL = 100
PROP_SHARPNESS.SHARPNESS_DULL = 0.5

PROP_SHARPNESS.SPEED_BLUNT = 125
PROP_SHARPNESS.SHARPNESS_BLUNT = 0.05

PROP_SHARPNESS.SPEED_CRUSH = 200
PROP_SHARPNESS.SHARPNESS_CRUSH = 0.5


PROP_SHARPNESS.generic_SHARP_UPWARD_SPIKE = {
    typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
    sharpness = PROP_SHARPNESS.SHARPNESS_SHARP,
    dmgSounds = PROP_SHARPNESS.skewerSnd,
    impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,

}

PROP_SHARPNESS.generic_SHARP_DOWNWARD_SPIKE = table.Copy( PROP_SHARPNESS.generic_SHARP_UPWARD_SPIKE )
PROP_SHARPNESS.generic_SHARP_DOWNWARD_SPIKE.invertDir = true

PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE = {
    typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = PROP_SHARPNESS.SPEED_BLUNT,
    sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
    dmgSounds = PROP_SHARPNESS.skewerSnd,
    impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

}

PROP_SHARPNESS.generic_DULL_UPWARD_SPIKE = {
    typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = PROP_SHARPNESS.SPEED_BLUNT, -- intentional
    sharpness = PROP_SHARPNESS.SHARPNESS_DULL,
    dmgSounds = PROP_SHARPNESS.skewerSnd,
    impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

}

PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE = {
    typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    invertDir = true,
    startSpeed = PROP_SHARPNESS.SPEED_BLUNT, -- intentional
    sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
    dmgSounds = PROP_SHARPNESS.skewerSnd,
    impaleStrength = PROP_SHARPNESS.IMPALE_MEDIUM,

}

PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD = {
    typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    invertDir = true,
    localPos = Vector( 0, 0, 0 ),
    localPosDist = 50,
    startSpeed = PROP_SHARPNESS.SPEED_CRUSH,
    sharpness = PROP_SHARPNESS.SHARPNESS_CRUSH,
    dmgType = DMG_CRUSH,
    dmgSounds = PROP_SHARPNESS.bashingSound,
    impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

}

PROP_SHARPNESS.generic_DUALBASH_IBEAM = { -- takes alot of speed to make this deal damage, but its an instakill
    typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
    dirFunc = entsMeta.GetForward,
    startSpeed = PROP_SHARPNESS.SPEED_CRUSH,
    sharpness = PROP_SHARPNESS.SHARPNESS_CRUSH,
    dmgType = DMG_CRUSH,
    dmgSounds = PROP_SHARPNESS.bashingSound,
    impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,
    sticks = true,
    stickSounds = {
        "d1_town.CarHit",

    },

}
PROP_SHARPNESS.generic_DUALSHARP_IBEAM = table.Copy( PROP_SHARPNESS.generic_DUALBASH_IBEAM )
PROP_SHARPNESS.generic_DUALSHARP_IBEAM.sharpness = PROP_SHARPNESS.SHARPNESS_DULL

PROP_SHARPNESS.generic_DUALSHARP_REBAR = { -- same as ibeam, but less intense sounds, and stronger impaling
    typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = PROP_SHARPNESS.SPEED_CRUSH,
    sharpness = PROP_SHARPNESS.SHARPNESS_DULL,
    dmgSounds = PROP_SHARPNESS.skewerSnd,
    impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,
    sticks = true,

}
PROP_SHARPNESS.generic_DUALSHARPFORWARD_REBAR = table.Copy( PROP_SHARPNESS.generic_DUALSHARP_REBAR )
PROP_SHARPNESS.generic_DUALSHARPFORWARD_REBAR.dirFunc = entsMeta.GetForward


PROP_SHARPNESS.generic_DUALSHARP_WOODSPLINTERS = { -- takes little speed, and does little damage
    typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = PROP_SHARPNESS.SPEED_DULL,
    sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
    dmgSounds = PROP_SHARPNESS.skewerSndNonMetallic,
    maxDamage = 25,
    impaleStrength = PROP_SHARPNESS.IMPALE_MEDIUM,
    sticks = true,
    sticksIntoOnly = { flesh = true },
    stickSounds = PROP_SHARPNESS.woodStickSounds,

}

PROP_SHARPNESS.generic_UPSHARP_WOODSPLINTERS = table.Copy( PROP_SHARPNESS.generic_DUALSHARP_WOODSPLINTERS )
PROP_SHARPNESS.generic_UPSHARP_WOODSPLINTERS.typeTransformer = PROP_SHARPNESS.SHARP_POINTY

PROP_SHARPNESS.generic_DOWNSHARP_WOODSPLINTERS = table.Copy( PROP_SHARPNESS.generic_DUALSHARP_WOODSPLINTERS )
PROP_SHARPNESS.generic_DOWNSHARP_WOODSPLINTERS.typeTransformer = PROP_SHARPNESS.SHARP_POINTY
PROP_SHARPNESS.generic_DOWNSHARP_WOODSPLINTERS.invertDir = true

function PROP_SHARPNESS.AddModels( models )
    local mdlData = PROP_SHARPNESS.ModelData
    for mdl, data in pairs( models ) do
        if not data.typeTransformer or not isfunction( data.typeTransformer ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .typeTransformer" )

        end
        if not data.dirFunc or not isfunction( data.typeTransformer ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .dirFunc" )

        end
        if not data.startSpeed or not isnumber( data.startSpeed ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .startSpeed" )

        end
        if not data.sharpness or not isnumber( data.sharpness ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .sharpness" )

        end
        if not data.dmgSounds or not istable( data.dmgSounds ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .dmgSounds" )

        end
        if data.localPosDist and not isnumber( data.localPosDist ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .localPosDist" )

        end
        if data.localPos and not isvector( data.localPos ) then
            error( "SHARPNESS: Can't add " .. mdl .. ", invalid .localPos" )

        end
        mdlData[mdl] = data

    end
end

local refreshed = true

local function gobble()
    refreshed = nil
    PROP_SHARPNESS.ModelData = {}

    local count = 0

    local dataFiles = file.Find( "prop_sharpness_sharpdata/*.lua", "LUA" )
    for _, name in ipairs( dataFiles ) do
        local success = ProtectedCall( function( nameProtected ) include( "prop_sharpness_sharpdata/" .. nameProtected ) end, name )
        if success then
            count = count + 1

        end
    end
    print( "prop_sharpness: Gobbled " .. count .. " sharp data files..." )

end

hook.Add( "PostCleanupMap", "prop_sharpness_gobble", function()
    if not refreshed then return end
    gobble()

end )

hook.Add( "InitPostEntity", "prop_sharpness_gobble", function()
    gobble()

end )

function PROP_SHARPNESS.DoSharpPoke( sharpData, currSharpDat, sharpEnt, takingDamage )
    if not IsValid( takingDamage ) then
        if takingDamage and takingDamage:IsWorld() then
            isWorld = true-- we stick into the world...

        else
            return

        end
    end

    if hook.Run( "prop_sharpness_blocksharpdamage", sharpEnt, takingDamage ) then return end

    local dirRef = sharpData.dirFunc( sharpEnt )
    if sharpData.invertDir then
        dirRef = -dirRef

    end

    local forCollide, pointyDir = sharpData.typeTransformer( sharpEnt, dirRef, currSharpDat.collisonNormal )
    local sharpness = sharpData.sharpness * forCollide
    if sharpness <= 0 then return end

    if debugVar:GetBool() then
        local oldPos = sharpEnt:GetPos()
        debugoverlay.Line( oldPos, oldPos + pointyDir * 250, 10, color_white, true )

    end

    local takingsCenter = takingDamage:WorldSpaceCenter()
    local nearest = sharpEnt:NearestPoint( takingsCenter )

    local localPos = sharpData.localPos -- some specific part of the ent is sharp
    local localPosDist = sharpData.localPosDist
    local sharpPoint
    if localPos and localPosDist then
        sharpPoint = sharpEnt:LocalToWorld( localPos )
        local takersNearest = takingDamage:NearestPoint( sharpPoint )

        if debugVar:GetBool() then
            debugoverlay.Cross( sharpPoint, 5, 5, color_white, true )
            debugoverlay.Line( takersNearest, sharpPoint, 5, color_white, true )
            debugoverlay.Text( takersNearest, takersNearest:Distance( sharpPoint ), 5, false )

        end

        local hitSomewhereDull = takersNearest:Distance( sharpPoint ) > localPosDist
        if hitSomewhereDull then return end

    end

    local isRagdoll = takingDamage:IsRagdoll()
    local alive = takingDamage:IsPlayer() or takingDamage:IsNPC() or takingDamage:IsNextBot()
    local minSharpSpeed = sharpData.startSpeed
    local dmgVel = currSharpDat.oldVel
    local speed = currSharpDat.speed or currSharpDat.oldVel:Length()

    local overMin = speed - minSharpSpeed
    local damage = overMin * sharpness

    damage = scaleDamageForEntsMaterial( sharpEnt, damage )
    local takingDamagesMat

    if not isWorld then
        damage, takingDamagesMat = scaleDamageForEntsMaterial( takingDamage, damage ) -- so we dont instakill glide cars, etc

    end

    if sharpData.maxDamage then
        damage = math.min( damage, sharpData.maxDamage )

    end

    local hookDat = { damage = damage }
    hook.Run( "prop_sharpness_predamage", sharpEnt, takingDamage, hookDat, sharpData )

    damage = hookDat.damage

    damage = math.floor( damage )
    if damage <= 0 then return end

    if sharpData.impaleStrength then
        local color = takingDamage:GetBloodColor()

        if isRagdoll then
            PROP_SHARPNESS.skewerRagdoll( takingDamage, sharpEnt, sharpData.impaleStrength, sharpData.localPos, color )

        elseif alive then
            takingDamage:SetNW2Float( "prop_sharpness_laststabtime", CurTime() )
            takingDamage:SetNW2Entity( "prop_sharpness_laststabber", sharpEnt )
            takingDamage:SetNW2Int( "prop_sharpness_impalestrength", sharpData.impaleStrength )

            if color then
                takingDamage:SetNW2Int( "prop_sharpness_bloodcolor", color )

            end

            takingDamage:SetNW2Bool( "prop_sharpness_hasauthedpoint", isvector( sharpPoint ) )

            if sharpPoint then
                takingDamage:SetNW2Vector( "prop_sharpness_authedpoint", sharpData.localPos )

            end
        end
    end

    local dmgType = sharpData.dmgType
    if not dmgType then
        if sharpData.canSlice and speed > math.random( 450, 550 ) then -- slice zombies!
            dmgType = bit.bor( DMG_SLASH, DMG_CRUSH )

        else
            dmgType = DMG_SLASH

        end
    end

    local sharpEntsTbl = entsMeta.GetTable( sharpEnt )

    local attacker = sharpEnt
    if sharpEntsTbl.sharpness_Holder then
        attacker = sharpEntsTbl.sharpness_Holder

    elseif sharpEntsTbl.sharpness_Thrower then
        attacker = sharpEntsTbl.sharpness_Thrower

    end

    local dmgInfo = DamageInfo()
    dmgInfo:SetAttacker( attacker )
    dmgInfo:SetInflictor( sharpEnt )
    dmgInfo:SetDamage( damage )
    dmgInfo:SetDamageType( dmgType )
    dmgInfo:SetDamagePosition( nearest )
    dmgInfo:SetDamageForce( dmgVel )

    if debugVar:GetBool() then
        print( "SHARPNESS: " .. sharpEnt:GetModel() .. " dealt " .. math.Round( damage ) .. " damage to", takingDamage )

    end

    takingDamage:TakeDamageInfo( dmgInfo )

    local bloodRef = sharpPoint or sharpEnt:WorldSpaceCenter()
    local scale = math.Clamp( damage / math.random( 8, math.max( 10, damage ) ), 8, 12 )
    PROP_SHARPNESS.BloodSpray( takingDamage, nearest, dirToPos( bloodRef, takingsCenter ), scale )

    if alive or isRagdoll then
        sharpEntsTbl.sharpness_NextDealDamage = CurTime() + 0.15
        local paths = sharpData.dmgSounds
        local path = paths[math.random( 1, #paths )]
        local pitch = math.Clamp( 120 - ( damage / 2 ), 50, 120 )
        if pitch < 65 then
            sharpEnt:EmitSound( paths[math.random( 1, #paths )], 85, 90, 1, CHAN_STATIC )

        end
        sharpEnt:EmitSound( path, 80, pitch, 1 )

        timer.Simple( 0, function()
            local dir = dirToPos( bloodRef, takingsCenter )
            PROP_SHARPNESS.BloodSpray( takingDamage, nearest, dir + VectorRand(), math.Clamp( damage / math.random( 1, 10 ), 4, 10 ) )

        end )
    elseif sharpData.sticks and sharpness >= 0.75 and speed > minSharpSpeed * 4 and damage > 25 then -- STICKING
        if sharpData.sticksIntoOnly and ( not takingDamagesMat or not sharpData.sticksIntoOnly[takingDamagesMat] ) then return end
        if currSharpDat.preCollideAng then
            sharpEnt:SetAngles( currSharpDat.preCollideAng )

        end
        PROP_SHARPNESS.HandlePropSticking( sharpEnt, takingDamage, sharpData, pointyDir )

    end
end

do
    local function handleSharpCollide( sharpEnt, colData, sharpData )
        local minSharpSpeed = sharpData.startSpeed
        local speed = colData.Speed
        if speed < minSharpSpeed then return end

        if sharpEnt.sharpness_NextDealDamage > CurTime() then return end
        local preCollideAng = sharpEnt:GetAngles()

        timer.Simple( 0, function() -- dont break default zombie slicing!
            if not IsValid( sharpEnt ) then return end

            local takingDamage = colData.HitEntity

            local oldVel = colData.TheirOldVelocity - colData.OurOldVelocity
            local velDir = oldVel:GetNormalized()

            local collisonNormal = ( -colData.HitNormal * 0.30 ) + ( velDir * 0.60 )
            collisonNormal:Normalize()

            local currSharpDat = {
                speed = speed,
                oldVel = oldVel,
                preCollideAng = preCollideAng,
                collisonNormal = collisonNormal,

            }

            PROP_SHARPNESS.DoSharpPoke( sharpData, currSharpDat, sharpEnt, takingDamage )

        end )
    end
    local string_lowerCreated = string.lower
    local getModel = entsMeta.GetModel

    hook.Add( "OnEntityCreated", "prop_sharpness_findsharp", function( ent )
        timer.Simple( 0, function() -- another use for PostEntityCreated
            if not IsValid( ent ) then return end

            local model = getModel( ent )
            if not model then return end -- someone reported this as a bug once and now im paranoid

            model = string_lowerCreated( model )
            local sharpData = PROP_SHARPNESS.ModelData[model]
            if not sharpData then return end

            ent.sharpness_NextDealDamage = 0
            ent.IsSharp = true

            if ent:IsScripted() then
                ent.sharpness_OldPhysicsCollide = ent.PhysicsCollide -- kinda hacky
                function ent:PhysicsCollide( colData, collider )
                    self.sharpness_OldPhysicsCollide( colData, collider )
                    handleSharpCollide( self, colData, sharpData )

                end
            else
                ent:AddCallback( "PhysicsCollide", function( sharpEnt, colData )
                    handleSharpCollide( sharpEnt, colData, sharpData )

                end )
            end
        end )
    end )
end

hook.Add( "GetFallDamage", "prop_sharpness_sharplanding", function( ply, speed )
    local landEnt = ply:GetGroundEntity()

    if not IsValid( landEnt ) then return end
    if not landEnt.IsSharp then return end

    local model = landEnt:GetModel()
    if not model then return end

    local sharpData = PROP_SHARPNESS.ModelData[model]
    if not sharpData then return end

    local plyVel = ply:GetVelocity()

    local currSharpDat = {
        speed = speed,
        oldVel = plyVel,
        collisonNormal = plyVel:GetNormalized(),

    }

    PROP_SHARPNESS.DoSharpPoke( sharpData, currSharpDat, landEnt, ply )

end )


function PROP_SHARPNESS.HandlePropSticking( thing, into, sharpData, dir )
    local freeze
    local weld
    local nudgeThem
    local nudgeUs

    local thingsObj = thing:GetPhysicsObject()
    local intoObj

    if into:IsWorld() then
        freeze = true
        nudgeUs = thingsObj:IsMotionEnabled()

    else
        intoObj = into:GetPhysicsObject()
        if IsValid( intoObj ) then
            local intosFrozen = not intoObj:IsMotionEnabled()
            local thingsFrozen = not thingsObj:IsMotionEnabled()
            if not intosFrozen and not thingsFrozen then
                weld = true
                nudgeUs = true

            elseif thingsFrozen and not intosFrozen then
                weld = true
                nudgeThem = true

            else
                freeze = true

            end
        else
            intoObj = nil

        end
    end

    if nudgeUs then
        thing:SetPos( thing:GetPos() + dir * math.random( 10, 15 ) )

    end
    if nudgeThem then
        into:SetPos( into:GetPos() + -dir * math.random( 10, 15 ) )

    end

    if freeze or weld then
        local paths = sharpData.stickSounds
        local path = paths[math.random( 1, #paths )]
        local pitch = math.random( 95, 105 )
        thing:EmitSound( path, 80, pitch, 1 )

    end

    if freeze then
        thingsObj:EnableMotion( false )
        thing.sharpness_FrozenStuck = true

    end

    if weld then
        local block = hook.Run( "prop_sharpness_blockweld", thing, into )
        if block then
            weld = nil

        end
    end

    if weld then
        thing:ForcePlayerDrop()
        into:ForcePlayerDrop()
        local strength = math.min( thingsObj:GetMass() * 100, intoObj and intoObj:GetMass() * 100 or math.huge )

        local newWeld = constraint.Weld( thing, into, 0, 0, strength, false )
        if not IsValid( newWeld ) then return end

        local noCollide = constraint.NoCollide( thing, into, 0, 0, true )
        newWeld:DeleteOnRemove( noCollide )

        hook.Run( "prop_sharpness_createweld", newWeld, "prop" )
        timer.Simple( 0, function()
            if not IsValid( thingsObj ) then return end
            if not IsValid( intoObj ) then return end

            thingsObj:SetVelocity( intoObj:GetVelocity() )

        end )
    end
end

hook.Add( "GravGunPickupAllowed", "sharpness_unfreezestuck", function( ply, ent )
    if not ent.sharpness_FrozenStuck then return end
    local entsObj = ent:GetPhysicsObject()
    if not IsValid( entsObj ) then return end
    if entsObj:IsMotionEnabled() then ent.sharpness_FrozenStuck = nil return end

    if not ply:KeyPressed( IN_ATTACK2 ) then return end
    entsObj:EnableMotion( true )
    ent.sharpness_FrozenStuck = nil
    ent.sharpness_NextDealDamage = CurTime() + 0.25

end )

hook.Add( "OnPhysgunPickup", "sharpness_clearstuck", function( ply, ent )
    if not ent.sharpness_FrozenStuck then return end
    ent.sharpness_FrozenStuck = nil
    ent.sharpness_NextDealDamage = CurTime() + 0.25

end )


local function manageThrownSharpThing( thrower, thrown, throwType ) -- GIVE CORRECT INFLICTOR
    local thrownsObj = thrown:GetPhysicsObject()
    if not IsValid( thrownsObj ) then return end
    if not thrownsObj:IsMotionEnabled() then return end

    thrown.sharpness_ThrowType = throwType
    thrown.sharpness_Thrower = thrower

    local timerName  = "prop_sharpness_thrownattacker_" .. thrown:GetCreationID()

    local function stopThrow()
        timer.Remove( timerName )
        if not IsValid( thrown ) then return end

        thrown.sharpness_Thrower = nil
        thrown.sharpness_ThrowType = nil

    end

    timer.Remove( timerName )
    timer.Create( timerName, 1, 0, function()
        if not IsValid( thrown ) then stopThrow() return end
        if not IsValid( thrownsObj ) then stopThrow() return end
        if not thrownsObj:IsMotionEnabled() then stopThrow() return end
        if thrownsObj:GetVelocity():Length() <= 5 then stopThrow() return end

    end )
end

hook.Add( "PhysgunPickup", "prop_sharpness", function( picker, picked )
    if not picked.IsSharp then return end
    picked.sharpness_PhysgunHolder = picker
    picked.sharpness_Holder = picker

end )
hook.Add( "PhysgunDrop", "prop_sharpness", function( picker, picked )
    if not picked.IsSharp then return end
    picked.sharpness_PhysgunHolder = nil
    picked.sharpness_Holder = nil
    manageThrownSharpThing( picker, picked, "physgun" )

end )

hook.Add( "GravGunOnPickedUp", "prop_sharpness", function( picker, picked )
    if not picked.IsSharp then return end
    picked.sharpness_Holder = picker

end )
hook.Add( "GravGunOnDropped", "prop_sharpness", function( _, picked )
    if not picked.IsSharp then return end
    picked.sharpness_Holder = nil
    manageThrownSharpThing( picker, picked )

end )
hook.Add( "GravGunPunt", "prop_sharpness", function( punter, punted )
    if not punted.IsSharp then return end
    manageThrownSharpThing( punter, punted, "gravgun" )

end )

hook.Add( "OnPlayerPhysicsPickup", "prop_sharpness", function( _, picked )
    if not picked.IsSharp then return end
    picked.sharpness_Holder = picker

end )
hook.Add( "OnPlayerPhysicsDrop", "prop_sharpness", function( dropper, dropped, thrown )
    if not dropped.IsSharp then return end
    dropped.sharpness_Holder = nil
    manageThrownSharpThing( dropper, dropped, "use" )

end )