--阿卡鲁姆的转世 塔
local m=47510217
local cm=_G["c"..m]
function c47510217.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510217,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510217)
    e1:SetCost(c47510217.mcost)
    e1:SetTarget(c47510217.mtg)
    e1:SetOperation(c47510217.mop)
    c:RegisterEffect(e1)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47510217.splimit)
    c:RegisterEffect(e2)  
    --Summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetDescription(aux.Stringid(47510217,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510200)
    e3:SetCost(c47510217.scost)
    e3:SetTarget(c47510217.stg)
    e3:SetOperation(c47510217.sop)
    c:RegisterEffect(e3)  
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510217,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510217.sumop)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47510217.indtg)
    e5:SetValue(c47510217.indct)
    c:RegisterEffect(e5)
end
function c47510217.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510217.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
end
function c47510217.atkfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510217.clfilter(c)
    return c:GetSequence()>=5
end
function c47510217.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47510217.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510217.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47510217.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
    if Duel.IsExistingMatchingCard(c47510217.clfilter,tp,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(c47510217.clfilter,tp,LOCATION_MZONE,0,1,nil) then
       Duel.SetChainLimit(aux.FALSE)
    end
end
function c47510217.tdfilter(c)
    return c:GetSequence()>=5 and c:IsAbleToDeck()
end
function c47510217.mop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(2000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
    local g=Duel.GetMatchingGroup(c47510217.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c47510217.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_EARTH)
    Duel.Release(g,REASON_COST)
end
function c47510217.ttcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510217.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
        e1:SetCondition(c47510217.ttcon)
        c:RegisterEffect(e1)
        local res=c:IsSummonable(true,nil) or c:IsAbleToGrave()
        e1:Reset()
        return res
    end
end
function c47510217.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47510217.ttcon)
    c:RegisterEffect(e1)
    if c:IsSummonable(true,nil) then
    Duel.Summon(tp,c,true,nil)
    end
end
function c47510217.ffilter(c)
    return c:GetAttribute()~=ATTRIBUTE_EARTH
end
function c47510217.thfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToHand()
end
function c47510217.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510217.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510217.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
    if Duel.SendtoHand(g,nil,1,REASON_EFFECT) then 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g1=Duel.SelectMatchingCard(tp,c47510217.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47510217.indtg(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510217.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end