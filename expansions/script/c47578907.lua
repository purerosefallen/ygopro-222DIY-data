--火之天司 米迦勒
local m=47578907
local cm=_G["c"..m]
function c47578907.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47578907.ffilter,2,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47578907.spcon)
    e0:SetOperation(c47578907.spop)
    c:RegisterEffect(e0)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47578907.psplimit)
    c:RegisterEffect(e1) 
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47578907.indtg)
    e2:SetValue(c47578907.indval)
    c:RegisterEffect(e2)
    --spssummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47578907)
    e3:SetCondition(c47578907.con)
    e3:SetTarget(c47578907.sptg2)
    e3:SetOperation(c47578907.spop2)
    c:RegisterEffect(e3) 
    --atk
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47578908)
    e4:SetCondition(c47578907.atkcon)
    e4:SetCost(c47578907.atkcost)
    e4:SetOperation(c47578907.atkop)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47578907.indtg)
    e5:SetValue(c47578907.indval)
    c:RegisterEffect(e5)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47578907.pencon)
    e8:SetTarget(c47578907.pentg)
    e8:SetOperation(c47578907.penop)
    c:RegisterEffect(e8)
end
function c47578907.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47578907.ffilter(c)
    return c:IsSetCard(0x5de)
end
function c47578907.spfilter(c,fc)
    return c47578907.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c47578907.spfilter1(c,tp,g)
    return g:IsExists(c47578907.spfilter2,1,c,tp,c)
end
function c47578907.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47578907.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c47578907.spfilter,nil,c)
    return g:IsExists(c47578907.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47578907.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c47578907.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47578907.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47578907.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c47578907.indtg(e,c)
    return c:IsRace(RACE_FAIRY)
end
function c47578907.indval(e,re,r,rp)
    return rp==1-e:GetHandlerPlayer()
end
function c47578907.ffilter2(c,e,tp,dam)
    return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c47578907.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47578907.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47578907.ffilter2,tp,LOCATION_DECK,0,1,nil,e,tp,ev) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47578907.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47578907.ffilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,ev)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47578907.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsAbleToGraveAsCost()
end
function c47578907.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578907.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47578907.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47578907.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:IsControler(tp)
end
function c47578907.atkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local at=Duel.GetAttacker()
    if at:IsFaceup() and at:IsRelateToBattle() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(at:GetAttack()*2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        at:RegisterEffect(e1)
    end
end
function c47578907.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47578907.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47578907.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end