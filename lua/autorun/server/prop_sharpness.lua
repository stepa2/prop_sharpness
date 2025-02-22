local IsValid = IsValid
local math = math

local function SHARP_POINTY( dirRef, collisonNormal ) -- one end is pointy
    local product = dirRef:Dot( collisonNormal )
    if product > -0.75 then return 0 end
    return -product

end
local function SHARP_DUALPOINTY( dirRef, collisonNormal ) -- both ends are pointy
    local product = math.abs( dirRef:Dot( collisonNormal ) )
    if product < 0.75 then return 0 end
    return product

end
local function SHARP_PLANAR( dirRef, collisonNormal ) -- flat plane of pointy ( eg sawblade )
    local product = math.abs( dirRef:Dot( collisonNormal ) )
    if product > 0.5 then
        return 0

    else
        return math.min( ( 1 - product ) * 1.5, 1 )

    end

end

local entsMeta = FindMetaTable( "Entity" )

local skewerSnd = {
    "ambient/machines/slicer3.wav"

}

local sawbladeSliceSound = {
    "d1_town.Slicer"

}

local SPEED_ALWAYSDMG = 75
local SHARPNESS_SHARP = 0.9

local SPEED_DULL = 100
local SHARPNESS_DULL = 0.5

local SPEED_BLUNT = 125
local SHARPNESS_BLUNT = 0.15

local data_BLUNT_UPWARD_SPIKE = {
    typeTransformer = SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = SPEED_BLUNT,
    sharpness = SHARPNESS_BLUNT,
    dmgSounds = skewerSnd,

}

local data_DULL_UPWARD_SPIKE = {
    typeTransformer = SHARP_POINTY,
    dirFunc = entsMeta.GetUp,
    startSpeed = SPEED_BLUNT, -- intentional
    sharpness = SHARPNESS_DULL,
    dmgSounds = skewerSnd,

}


local sharpModels = {
    ["models/props_junk/sawblade001a.mdl"] = {
        typeTransformer = SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = SPEED_ALWAYSDMG,
        sharpness = SHARPNESS_SHARP,
        dmgSounds = sawbladeSliceSound,

    },
    ["models/props_c17/trappropeller_blade.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        localPos = Vector( 9.5, -39, 4 ),
        localPosDist = 40,
        startSpeed = SPEED_ALWAYSDMG,
        sharpness = SHARPNESS_DULL,
        dmgSounds = sawbladeSliceSound,

    },
    ["models/props_junk/harpoon002a.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        startSpeed = 50,
        sharpness = 1,
        dmgSounds = skewerSnd,

    },
    ["models/props_mining/railroad_spike01.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        startSpeed = SPEED_ALWAYSDMG,
        sharpness = SHARPNESS_DULL,
        dmgSounds = skewerSnd,

    },

    ["models/mechanics/wheels/wheel_spike_24.mdl"] = {
        typeTransformer = SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = SPEED_ALWAYSDMG,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },
    ["models/mechanics/wheels/wheel_spike_48.mdl"] = {
        typeTransformer = SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = SPEED_ALWAYSDMG,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },

    ["models/props_c17/signpole001.mdl"] = {
        typeTransformer = SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = SPEED_BLUNT,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },
    ["models/props_c17/chair02a.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = true,
        startSpeed = SPEED_BLUNT,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },
    ["models/props_interiors/furniture_chair03a.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = true,
        startSpeed = SPEED_BLUNT,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },
    ["models/props_c17/trappropeller_lever.mdl"] = {
        typeTransformer = SHARP_POINTY,
        dirFunc = entsMeta.GetRight,
        invertDir = nil,
        startSpeed = SPEED_BLUNT,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },

    ["models/hunter/misc/cone1x1.mdl"] = data_DULL_UPWARD_SPIKE,
    ["models/hunter/misc/cone2x2.mdl"] = data_DULL_UPWARD_SPIKE,

    ["models/hunter/misc/squarecap1x1x1.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x1x1.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x1x2.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x2x2.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone1x05.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone2x1.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone4x2.mdl"] = data_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone4x2mirrored.mdl"] = {
        typeTransformer = SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = SPEED_BLUNT,
        sharpness = SHARPNESS_BLUNT,
        dmgSounds = skewerSnd,

    },
    [""] = data_BLUNT_UPWARD_SPIKE,
    [""] = data_BLUNT_UPWARD_SPIKE,
    [""] = data_BLUNT_UPWARD_SPIKE,

}

local function handleSharpCollide( sharpEnt, colData, sharpData )

    local min = sharpData.startSpeed
    local speed = colData.Speed
    if speed < min then return end

    if sharpEnt.sharpness_NextDealDamage > CurTime() then return end
    local oldPos = sharpEnt:GetPos()

    timer.Simple( 0, function() -- dont break zombie slicing!
        if not IsValid( sharpEnt ) then return end

        local takingDamage = colData.HitEntity
        if not IsValid( takingDamage ) then return end -- WORLD 

        local dirRef = sharpData.dirFunc( sharpEnt )
        if sharpData.invertDir then
            dirRef = -dirRef

        end

        debugoverlay.Line( oldPos, oldPos + dirRef * 25, 10, color_white, true )

        local oldVel = colData.TheirOldVelocity - colData.OurOldVelocity
        local velDir = oldVel:GetNormalized()

        local collisonNormal = ( -colData.HitNormal * 0.25 ) + ( velDir * 0.75 )
        collisonNormal:Normalize()

        local sharpness = sharpData.sharpness * sharpData.typeTransformer( dirRef, collisonNormal )
        if sharpness <= 0 then return end

        local nearest = sharpEnt:NearestPoint( takingDamage:WorldSpaceCenter() )

        local localPos = sharpData.localPos -- some specific part of the ent is sharp
        local localPosDist = sharpData.localPosDist
        if localPos and localPosDist then
            local takersNearest = takingDamage:NearestPoint( nearest )
            local sharpPoint = sharpEnt:LocalToWorld( localPos )

            local hitSomewhereDull = takersNearest:Distance( sharpPoint ) > localPosDist
            if hitSomewhereDull then return end

        end

        local overMin = speed - min
        local damage = overMin * sharpness

        local dmgVel = oldVel

        if takingDamage:IsPlayer() then
            dmgVel = dmgVel * damage

        end

        local dmgInfo = DamageInfo()
        dmgInfo:SetAttacker( sharpEnt )
        dmgInfo:SetInflictor( sharpEnt )
        dmgInfo:SetDamage( damage )
        dmgInfo:SetDamageType( DMG_SLASH )
        dmgInfo:SetDamagePosition( nearest )
        dmgInfo:SetDamageForce( dmgVel )

        takingDamage:TakeDamageInfo( dmgInfo )

        if takingDamage:IsPlayer() or takingDamage:IsNPC() or takingDamage:IsNextBot() then
            sharpEnt.sharpness_NextDealDamage = CurTime() + 0.15
            local paths = sharpData.dmgSounds
            local path = paths[math.random( 1, #paths )]
            local pitch = math.Clamp( 120 - ( damage / 2 ), 50, 120 )
            sharpEnt:EmitSound( path, 80, pitch, 1 )

        elseif speed > min * 4 then -- STICKING
            local ourObj = sharpEnt:GetPhysicsObject()
            local theirObj = takingDamage:GetPhysicsObject()
            local goodStick = IsValid( theirObj ) and IsValid( ourObj ) and not theirObj:IsMotionEnabled() and ourObj:IsMotionEnabled()

            goodStick = goodStick and theirObj:GetMass() > ourObj:GetMass() * 2
            goodStick = goodStick and theirObj:GetVolume() > ourObj:GetVolume() * 2

            if goodStick then
                ourObj:EnableMotion( false )

            end
        end
    end )
end

do
    local string_lower = string.lower
    local getModel = entsMeta.GetModel

    hook.Add( "OnEntityCreated", "prop_sharpness_findsharp", function( ent )
        timer.Simple( 0, function()
            if not IsValid( ent ) then return end

            local model = getModel( ent )
            if not model then return end

            model = string_lower( model )
            local sharpData = sharpModels[model]
            if not sharpData then return end
            ent.sharpness_NextDealDamage = 0
            ent:AddCallback( "PhysicsCollide", function( sharpEnt, colData )
                handleSharpCollide( sharpEnt, colData, sharpData )

            end )
        end )
    end )
end