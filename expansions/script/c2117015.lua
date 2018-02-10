--狱卒阎魔-乌莉丝
local m=2117015
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c2117015.lcheck)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(2117015,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,21170151)
    e1:SetCondition(c2117015.thcon)
    e1:SetTarget(c2117015.thtg)
    e1:SetOperation(c2117015.thop)
    c:RegisterEffect(e1)
    --instant
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(2117015,1))
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,21170152)
    e3:SetCost(c2117015.lvcost)
    e3:SetTarget(c2117015.sumtg)
    e3:SetOperation(c2117015.sumop)
    c:RegisterEffect(e3)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(2117015,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,21170153)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c2117015.condition)
    e1:SetTarget(c2117015.sptg)
    e1:SetOperation(c2117015.spop)
    c:RegisterEffect(e1)
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c2117015.atkval)
    c:RegisterEffect(e1)
end
function c2117015.atkval(e,c)
    return c:GetLinkedGroupCount()*500
end
function c2117015.indcon(e)
    return e:GetHandler():GetLinkedGroupCount()>0
end
function c2117015.hspfilter(c)
    return c:IsSetCard(0x21c) 
end
function c2117015.lcheck(g,lc)
    return g:IsExists(c2117015.hspfilter,1,nil)
end
function c2117015.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c2117015.thfilter(c)
    return c:IsSetCard(0x21c) and c:IsAbleToHand()
end
function c2117015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2117015.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2117015.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c2117015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c2117015.costfilter(c,lv)
    return c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function c2117015.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2117015.costfilter,tp,LOCATION_DECK,0,1,nil,lv) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c2117015.costfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
    Duel.SendtoGrave(g,REASON_COST)
end
function c2117015.filter1(c)
    return c:IsSetCard(0x21c) and not c:IsCode(2117015) and c:IsSummonable(true,nil)
end
function c2117015.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2117015.filter1,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c2117015.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c2117015.filter1,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
end
function c2117015.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil,RACE_FIEND):GetClassCount(Card.GetCode)>=4
end
function c2117015.filter(c,e,tp)
    return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2117015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c2117015.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c2117015.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c2117015.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c2117015.spop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsRace(RACE_FIEND) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end