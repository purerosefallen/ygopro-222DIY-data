--觉醒十天众 索恩
local m=47591822
local cm=_G["c"..m]
function c47591822.initial_effect(c)
    c:SetSPSummonOnce(47591822)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c47591822.lcheck)
    c:EnableReviveLimit()
    --serch
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)  
    e1:SetCountLimit(1,47591822)
    e1:SetCondition(c47591822.poscon)
    e1:SetTarget(c47591822.thtg)
    e1:SetOperation(c47591822.thop)
    c:RegisterEffect(e1)
    --atk down
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetTarget(c47591822.atktg)
    e3:SetOperation(c47591822.atkop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,47591823)
    e4:SetTarget(c47591822.sptg)
    e4:SetOperation(c47591822.spop)
    c:RegisterEffect(e4)    
end
function c47591822.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end
function c47591822.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47591822.filter(c)
    return c:IsCode(47591002) and c:IsAbleToHand()
end
function c47591822.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591822.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591822.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591822.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c47591822.splimit)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c47591822.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47591822.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-1000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47591822.filter2(c,e,tp,dam)
    return c:IsLevelBelow(2) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47591822.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47591822.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47591822.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47591822.filter2,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>=1 then
        local fid=e:GetHandler():GetFieldID()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c47591822.splimit)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c47591822.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)
end