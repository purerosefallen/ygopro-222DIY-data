--那无名的意中人
local m=22260169
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c22260169.mfilter,3)
    c:EnableReviveLimit()
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTarget(c22260169.atktg)
    e1:SetValue(c22260169.atkval)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260169,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c22260169.drcon)
    e2:SetTarget(c22260169.drtg)
    e2:SetOperation(c22260169.drop)
    c:RegisterEffect(e2)
    --index
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260169,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c22260169.ixcon)
    e3:SetTarget(c22260169.ixtg)
    e3:SetOperation(c22260169.ixop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(22260169,3))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c22260169.spcon)
    e4:SetTarget(c22260169.sptg)
    e4:SetOperation(c22260169.spop)
    c:RegisterEffect(e4)

end

--
function c22260169.mfilter(c)
    return c:IsRace(RACE_PLANT)
end
--
function c22260169.atktg(e,c)
    return c:IsRace(RACE_PLANT)
end
function c22260169.atkfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c22260169.atkval(e,c)
    return Duel.GetMatchingGroupCount(c22260169.filter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end
----
function c22260169.filter1(c)
    return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_PLANT)
end
--
function c22260169.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c22260169.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22260169.drop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,1,nil) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
--
function c22260169.ixcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,2,nil)
end
function c22260169.ixfilter(c)
    return c:IsCode(22261503)
end
function c22260169.ixtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22260169.ixfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22260169.ixop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,2,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22260169.ixfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--
function c22260169.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,3,nil)
end
function c22260169.spfilter(c)
    return c:IsCode(22260020) or c:IsCode(22260021)
end
function c22260169.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c22260169.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22260169.spop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c22260169.filter1,tp,LOCATION_MZONE,0,3,nil) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c22260169.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end