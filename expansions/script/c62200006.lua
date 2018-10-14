--玻离之物 无言之花
local m=62200006
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_FragileArticles=true
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c62200006.matfilter,1,1)
    c:EnableReviveLimit()
    --changelp
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(62200006,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetOperation(c62200006.activate)
    c:RegisterEffect(e2)
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e3:SetTarget(c62200006.distarget)
    c:RegisterEffect(e3)
    --disable effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetOperation(c62200006.disoperation)
    c:RegisterEffect(e4)    
    --xyzlimit
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE)
    e10:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e10:SetValue(c62200006.mlimit)
    c:RegisterEffect(e10)
    local e11=e10:Clone()
    e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e11)
    local e12=e10:Clone()
    e12:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e12)
    local e13=e10:Clone()
    e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e13)
end
--
function c62200006.matfilter(c)
    return c:GetBaseAttack()==0
end
--
function c62200006.mlimit(e,c)
    if not c then return false end
    return c:GetAttack()~=0
end
--
function c62200006.splimcon(e)
    return e:GetTurnCount()~=1
end
--
function c62200006.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,1000)
end
--
function c62200006.distarget(e,c)
    return c~=e:GetHandler() and c:IsType(TYPE_SPELL)
end
function c62200006.disoperation(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL) then
        Duel.NegateEffect(ev)
    end
end