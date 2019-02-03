--ReLive-Karen
require("expansions/script/c20100002")
local m=20100060
local cm=_G["c"..m]
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.ap1)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1) 
    --special summon from deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)   
    --special summon from hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.sptg2)
    e3:SetOperation(cm.spop2)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.filter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT) then
            Duel.ConfirmCards(1-tp,g)
            if c:IsRelateToEffect(e) then
                Duel.BreakEffect()
                c:AddCounter(0xc99,1)
            end
        end  
    end
end
function cm.spfilter(c,e,tp)
    return c:IsLevel(4) and c:IsSetCard(0xc99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e) then
            Duel.BreakEffect()
            e:GetHandler():AddCounter(0xc99,1)
        end
    end
end
function cm.ffilter(c,tp)
    return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsSetCard(0xc99)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    if not fc and not Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) then return false end
    return true
end
function cm.clcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xc99,3,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xc99,3,REASON_COST)
end
function cm.clfilter(c,e,tp)
    return c:IsSetCard(0xc99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_HAND,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
    local bgm=fc:GetCode()
    if not Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_HAND,0,2,nil,e,tp) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.clfilter,tp,LOCATION_HAND,0,2,2,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end