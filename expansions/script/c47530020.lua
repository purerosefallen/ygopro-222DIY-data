--精神感应扎古
local m=47530020
local cm=_G["c"..m]
function c47530020.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47530020.ffilter,2,true)
    aux.EnablePendulumAttribute(c,false)    
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47530020.spcon)
    e0:SetOperation(c47530020.spop)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BECOME_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c47530020.ftg)
    e1:SetOperation(c47530020.fop2)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)    
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)   
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530020,2))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCountLimit(2)
    e4:SetCondition(c47530020.actcon)
    e4:SetOperation(c47530020.actop)
    c:RegisterEffect(e4)
end
function c47530020.actcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47530020.actop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end
function c47530020.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47530020.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateEffect(ev)
end
function c47530020.ffilter(c,fc,sub,mg,sg)
    return c:IsRace(RACE_MACHINE) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c47530020.spfilter(c,fc)
    return c47530020.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47530020.spfilter1(c,tp,g)
    return g:IsExists(c47530020.spfilter2,1,c,tp,c)
end
function c47530020.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47530020.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47530020.spfilter,nil,c)
    return g:IsExists(c47530020.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47530020.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47530020.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47530020.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47530020.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end