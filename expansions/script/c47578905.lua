--黑暗天司 奥利维尔
local m=47578905
local cm=_G["c"..m]
function c47578905.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47578905.ffilter,2,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47578905.spcon)
    e0:SetOperation(c47578905.spop)
    c:RegisterEffect(e0)
    --spssummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47578905,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(c47578905.con)
    e3:SetOperation(c47578905.atkop)
    c:RegisterEffect(e3) 
    --activate limit
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47578905,2))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47578906)
    e4:SetCondition(c47578905.actcon)
    e4:SetOperation(c47578905.actop)
    c:RegisterEffect(e4)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47578905,3))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47578905.pencon)
    e8:SetTarget(c47578905.pentg)
    e8:SetOperation(c47578905.penop)
    c:RegisterEffect(e8)
end
function c47578905.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47578905.ffilter(c)
    return c:IsSetCard(0x5de)
end
function c47578905.spfilter(c,fc)
    return c47578905.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47578905.spfilter1(c,tp,g)
    return g:IsExists(c47578905.spfilter2,1,c,tp,c)
end
function c47578905.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47578905.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47578905.spfilter,nil,c)
    return g:IsExists(c47578905.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47578905.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47578905.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47578905.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47578905.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c47578905.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x5de) end
    local g=Duel.SelectReleaseGroup(tp,Card.SetCardData,1,1,nil,0x5de)
    Duel.Destroy(g,REASON_COST)
end
function c47578905.pcfilter(c)
    return c:IsSetCard(0x5de) and c:IsType(TYPE_PENDULUM) 
end
function c47578905.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c47578905.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47578905.pcop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47578905.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47578905.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47578905.atkfilter(c,e,tp,dam)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToGrave(e,0,tp,false,false)
end
function c47578905.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47578905.atkfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c47578905.actcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47578905.actop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(aux.TRUE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47578905.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47578905.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47578905.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
