--十狼的雄叫
local m=47591010
local cm=_G["c"..m]
function c47591010.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47591010+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(c47591010.cost)
    e1:SetCondition(c47591010.cod)
    e1:SetTarget(c47591010.drtg)
    e1:SetOperation(c47591010.drat)
    c:RegisterEffect(e1)
end
function c47591010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x105d,9,REASON_COST) 
    end
    Duel.RemoveCounter(tp,1,1,0x105d,9,REASON_COST)
    local g=Duel.GetDecktopGroup(tp,10)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==10
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c47591010.cfilter(c,tp)
    return c:IsCode(47591200) 
end
function c47591010.cod(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47591010.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c47591010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local gc=g:GetCount()
    if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(1,gc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1,gc)
end
function c47591010.drat(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local gc=g:GetCount()
    if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
        local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if oc>0 then
            Duel.Draw(1,oc,REASON_EFFECT)
        end
    end
end
