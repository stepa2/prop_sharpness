
local entsMeta = FindMetaTable( "Entity" )

local models = {
    ["models/props_junk/sawblade001a.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
        sharpness = PROP_SHARPNESS.SHARPNESS_SHARP,
        dmgSounds = PROP_SHARPNESS.sawbladeSliceSound,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,
        sticks = true,
        stickSounds = PROP_SHARPNESS.metalstickSounds,

    },
    ["models/props_c17/trappropeller_blade.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        localPos = Vector( 9.5, -40, 4 ),
        localPosDist = 55,
        startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
        sharpness = PROP_SHARPNESS.SHARPNESS_DULL,
        dmgSounds = PROP_SHARPNESS.sawbladeSliceSound,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },
    ["models/props_junk/meathook001a.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        localPos = Vector( 0, -7.8, -12.2 ),
        localPosDist = 15,
        startSpeed = PROP_SHARPNESS.SPEED_SUPERSHARP,
        sharpness = PROP_SHARPNESS.SHARPNESS_SUPERSHARP,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,

    },
    ["models/props_c17/pulleyhook01.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        localPos = Vector( -0.3, -13.1, 10.7 ),
        localPosDist = 15,
        startSpeed = PROP_SHARPNESS.SPEED_BLUNT,
        sharpness = PROP_SHARPNESS.SHARPNESS_DULL,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_MEDIUM,

    },
    ["models/weapons/w_crowbar.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_SUPERSHARP,
        sharpness = PROP_SHARPNESS.SHARPNESS_SHARP,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,
        sticks = true,
        stickSounds = PROP_SHARPNESS.metalstickSounds,

    },
    ["models/weapons/w_spade.mdl"] = { -- spade'n
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = true,
        startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
        sharpness = PROP_SHARPNESS.SHARPNESS_SHARP,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,
        sticks = true,
        stickSounds = PROP_SHARPNESS.metalstickSounds,

    },
    ["models/props_junk/harpoon002a.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetForward,
        invertDir = nil,
        localPos = Vector( 50, 0, 0 ),
        localPosDist = 25,
        startSpeed = PROP_SHARPNESS.SPEED_SUPERSHARP,
        sharpness = PROP_SHARPNESS.SHARPNESS_SUPERSHARP,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,
        sticks = true,
        stickSounds = PROP_SHARPNESS.metalstickSounds,

    },

    ["models/mechanics/wheels/wheel_spike_24.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },
    ["models/mechanics/wheels/wheel_spike_48.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_PLANAR,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_ALWAYSDMG,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },

    ["models/props_c17/signpole001.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_BLUNT,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_STRONG,
        sticks = true,
        stickSounds = PROP_SHARPNESS.metalstickSounds,

    },

    ["models/props_c17/metalladder001.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_CRUSH,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.bashingSound,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },
    ["models/props_c17/metalladder002.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_CRUSH,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.bashingSound,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },

    ["models/props_c17/chair02a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/nova/chair_plastic01.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/props_interiors/furniture_chair03a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/props_interiors/furniture_chair01a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/nova/chair_wood01.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,

    ["models/props_c17/furnituretable001a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/props_c17/furnituretable002a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/props_c17/furnituretable003a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,
    ["models/props_c17/furnituredrawer002a.mdl"] = PROP_SHARPNESS.generic_IMPALING_DULL_DOWNWARD_SPIKE,

    ["models/props_c17/trappropeller_lever.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_POINTY,
        dirFunc = entsMeta.GetRight,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_BLUNT,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },

    ["models/hunter/misc/cone1x1.mdl"] = PROP_SHARPNESS.generic_DULL_UPWARD_SPIKE,
    ["models/hunter/misc/cone2x2.mdl"] = PROP_SHARPNESS.generic_DULL_UPWARD_SPIKE,

    ["models/hunter/misc/squarecap1x1x1.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x1x1.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x1x2.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/squarecap2x2x2.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone1x05.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone2x1.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone4x2.mdl"] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    ["models/hunter/misc/cone4x2mirrored.mdl"] = {
        typeTransformer = PROP_SHARPNESS.SHARP_DUALPOINTY,
        dirFunc = entsMeta.GetUp,
        invertDir = nil,
        startSpeed = PROP_SHARPNESS.SPEED_BLUNT,
        sharpness = PROP_SHARPNESS.SHARPNESS_BLUNT,
        dmgSounds = PROP_SHARPNESS.skewerSnd,
        impaleStrength = PROP_SHARPNESS.IMPALE_WEAK,

    },

    ["models/props_c17/utilitypole01a.mdl"] = PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD,
    ["models/props_c17/utilitypole01b.mdl"] = PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD,
    ["models/props_c17/utilitypole01d.mdl"] = PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD,
    ["models/props_c17/utilitypole02b.mdl"] = PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD,
    ["models/props_c17/utilitypole03a.mdl"] = PROP_SHARPNESS.generic_IMPALING_BASHING_DOWNWARD,

    ["models/props_junk/ibeam01a.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/props_junk/ibeam01a_cluster01.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/box_beam_16.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/box_beam_24.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/box_beam_32.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/box_beam_48.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_16.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_24.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_32.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_48.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_64.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_96.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_16_2d.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam2_16.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam2_32.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam2_48.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam2_60.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam2_96.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/i_beam_8.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/l-beam__24.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/l-beam__32.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/l-beam__48.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/u_beam_16.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/u_beam_24.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/u_beam_32.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    ["models/mechanics/solid_steel/u_beam_48.mdl"] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,

    --[[
    [""] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    [""] = PROP_SHARPNESS.generic_DUALBASH_IBEAM,
    [""] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    [""] = PROP_SHARPNESS.generic_BLUNT_UPWARD_SPIKE,
    --]]

}

PROP_SHARPNESS.AddModels( models )
