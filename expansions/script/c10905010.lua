--梦幻之星
local m=10905010
local cm=_G["c"..m]
function cm.initial_effect(c)   
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1,m)
    e1:SetCost(cm.cost)
    e1:SetCondition(cm.con)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(11548522,0))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetTarget(cm.bantg)
    e5:SetOperation(cm.banop)
    c:RegisterEffect(e5)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x238)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,99,99,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
        local dc=Duel.GetOperatedGroup():GetFirst()
        if dc:IsSetCard(0x238) and dc:IsType(TYPE_MONSTER) and Duel.IsPlayerCanDraw(tp,1)
            and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.BreakEffect()
            Duel.ConfirmCards(1-tp,dc)
            Duel.Draw(tp,1,REASON_EFFECT)
            Duel.ShuffleHand(tp)
        end
    end
function cm.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.banop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
    end
end
